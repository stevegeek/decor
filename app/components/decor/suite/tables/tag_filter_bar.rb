# frozen_string_literal: true

module Decor
  module Suite
    module Tables
      # Suite TagFilterBar — tag-chip filter row that sits below the table
      # header (or beside SearchAndFilter). Each tag renders as a clickable
      # chip; selected chips repaint in the tag's own color palette.
      #
      # Mode toggle (OR / AND) chooses match semantics: OR returns rows tagged
      # with any selected tag, AND returns rows tagged with all of them.
      #
      # No abstract Decor::Components base exists for this component; the
      # historical implementation lived only in Confinus' Suite skin.
      #
      # Tags are duck-typed — each item passed to `tags:` must respond to:
      #   - `encoded_id` (String) — opaque identifier used in the query string
      #   - `name` (String) — chip label
      #   - `color` (String) — one of: red, orange, yellow, green, teal, blue,
      #     purple, pink, gray. Unknown values fall through to gray.
      #
      # The Apply button stays hidden until the user diverges from the initial
      # selection / mode; then a full-page navigation rewrites the query
      # string. Clear and "+N more" similarly navigate.
      class TagFilterBar < ::Decor::PhlexComponent
        prop :tags, _Array(_Any), default: -> { [] }
        prop :selected_tag_ids, _Array(String), default: -> { [] }
        prop :tag_mode, String, default: "or"
        prop :max_visible, Integer, default: 15
        prop :param_name, String, default: "entity_tag_ids"
        prop :mode_param_name, String, default: "entity_tag_mode"

        stimulus do
          actions [:click, :toggle_tag], [:click, :set_mode],
            [:click, :apply], [:click, :clear_all], [:click, :show_all]
          targets :chip, :apply_button, :mode_toggle, :overflow_button, :tags_container
          values selected_ids: -> { @selected_tag_ids.to_json },
            tag_mode: -> { @tag_mode },
            param_name: -> { @param_name },
            mode_param_name: -> { @mode_param_name }
        end

        # Color palette for tag chips. Tailwind classes are emitted with the
        # `decor:` prefix so they survive the gem's namespaced extraction.
        CHIP_COLOR_CLASSES = {
          "red" => {bg: "decor:bg-red-100", text: "decor:text-red-800", border: "decor:border-red-300", dot: "decor:bg-red-500"},
          "orange" => {bg: "decor:bg-orange-100", text: "decor:text-orange-800", border: "decor:border-orange-300", dot: "decor:bg-orange-500"},
          "yellow" => {bg: "decor:bg-yellow-100", text: "decor:text-yellow-800", border: "decor:border-yellow-300", dot: "decor:bg-yellow-500"},
          "green" => {bg: "decor:bg-green-100", text: "decor:text-green-800", border: "decor:border-green-300", dot: "decor:bg-green-500"},
          "teal" => {bg: "decor:bg-teal-100", text: "decor:text-teal-800", border: "decor:border-teal-300", dot: "decor:bg-teal-500"},
          "blue" => {bg: "decor:bg-suite-primary-100", text: "decor:text-suite-primary-700", border: "decor:border-suite-primary-500", dot: "decor:bg-suite-primary-500"},
          "purple" => {bg: "decor:bg-purple-100", text: "decor:text-purple-800", border: "decor:border-purple-300", dot: "decor:bg-purple-500"},
          "pink" => {bg: "decor:bg-pink-100", text: "decor:text-pink-800", border: "decor:border-pink-300", dot: "decor:bg-pink-500"},
          "gray" => {bg: "decor:bg-gray-100", text: "decor:text-gray-800", border: "decor:border-gray-300", dot: "decor:bg-gray-500"}
        }.freeze
        DEFAULT_CHIP_COLOR = "gray"

        def view_template
          root_element do |s|
            # OR / AND mode toggle
            div(
              class: "decor:inline-flex decor:items-center decor:rounded-suite-control decor:border decor:border-suite-hairline-strong decor:text-xs decor:font-medium decor:overflow-hidden decor:shrink-0",
              data: {**s.stimulus_target(:mode_toggle)}
            ) do
              button(
                type: "button",
                class: mode_button_classes(active: @tag_mode == "or"),
                data: {mode: "or", **s.stimulus_action(:click, :set_mode)}
              ) { plain "OR" }
              button(
                type: "button",
                class: mode_button_classes(active: @tag_mode == "and"),
                data: {mode: "and", **s.stimulus_action(:click, :set_mode)}
              ) { plain "AND" }
            end

            # Tag chips
            div(class: "decor:flex decor:flex-wrap decor:gap-1.5", data: {**s.stimulus_target(:tags_container)}) do
              visible_tags.each do |chip_tag|
                colors = chip_color_for(chip_tag.color)
                button(
                  type: "button",
                  class: chip_classes(chip_tag, colors),
                  data: {
                    tag_id: chip_tag.encoded_id,
                    selected_classes: chip_selected_classes(colors),
                    unselected_classes: chip_unselected_classes,
                    **s.stimulus_action(:click, :toggle_tag),
                    **s.stimulus_target(:chip)
                  }
                ) do
                  span(class: "decor:inline-block decor:w-2 decor:h-2 decor:rounded-full decor:shrink-0 #{colors[:dot]}")
                  plain chip_tag.name
                end
              end
            end

            if overflow_count > 0
              button(
                type: "button",
                class: "decor:inline-flex decor:items-center decor:px-2.5 decor:py-1 decor:rounded-suite-control decor:text-xs decor:font-medium decor:border decor:border-suite-hairline-strong decor:bg-white decor:text-gray-500 decor:cursor-pointer decor:hover:border-gray-400 decor:hover:bg-suite-gray-25 decor:transition-all decor:duration-suite-fast decor:ease-out decor:leading-none",
                data: {**s.stimulus_action(:click, :show_all), **s.stimulus_target(:overflow_button)}
              ) { plain "+#{overflow_count} more" }
            end

            # Right-side metadata + actions
            div(class: "decor:ml-auto decor:flex decor:gap-2 decor:items-center") do
              button(
                type: "button",
                class: "decor:hidden decor:px-2.5 decor:py-1 decor:text-xs decor:font-medium decor:text-white decor:bg-suite-primary-500 decor:rounded-suite-control decor:hover:bg-suite-primary-700 decor:transition-all decor:duration-suite-fast decor:ease-out decor:leading-none",
                data: {**s.stimulus_action(:click, :apply), **s.stimulus_target(:apply_button)}
              ) { plain "Apply" }

              if @selected_tag_ids.any?
                button(
                  type: "button",
                  class: "decor:suite-description decor:text-gray-500 decor:font-tabular-nums decor:hover:text-gray-700 decor:underline decor:leading-none",
                  data: {**s.stimulus_action(:click, :clear_all)}
                ) { plain "Clear" }
              end
            end
          end
        end

        private

        def root_element_classes
          "decor:w-full decor:flex decor:items-center decor:gap-1.5 decor:pl-5 decor:pr-4 decor:py-[9px] decor:border-b decor:border-suite-hairline decor:bg-suite-gray-25"
        end

        def visible_tags
          @tags.first(@max_visible)
        end

        def overflow_count
          [@tags.size - @max_visible, 0].max
        end

        def tag_selected?(tag)
          @selected_tag_ids.include?(tag.encoded_id)
        end

        def chip_color_for(color)
          CHIP_COLOR_CLASSES.fetch(color.to_s, CHIP_COLOR_CLASSES.fetch(DEFAULT_CHIP_COLOR))
        end

        def chip_base_classes
          "decor:inline-flex decor:items-center decor:gap-1.5 decor:px-2.5 decor:py-1 decor:rounded-suite-control decor:text-xs decor:font-medium decor:border decor:cursor-pointer decor:transition-all decor:duration-suite-fast decor:ease-out decor:leading-none decor:select-none"
        end

        def chip_classes(tag, colors)
          if tag_selected?(tag)
            "#{chip_base_classes} #{colors[:bg]} #{colors[:text]} #{colors[:border]}"
          else
            "#{chip_base_classes} #{chip_unselected_classes}"
          end
        end

        def chip_selected_classes(colors)
          "#{colors[:bg]} #{colors[:text]} #{colors[:border]}"
        end

        def chip_unselected_classes
          "decor:bg-white decor:border-suite-hairline-strong decor:text-gray-700 decor:hover:border-gray-400 decor:hover:bg-suite-gray-25"
        end

        def mode_button_classes(active:)
          base = "decor:px-2.5 decor:py-1 decor:leading-none"
          if active
            "#{base} decor:bg-gray-800 decor:text-white"
          else
            "#{base} decor:bg-white decor:text-gray-600 decor:hover:bg-gray-50"
          end
        end
      end
    end
  end
end
