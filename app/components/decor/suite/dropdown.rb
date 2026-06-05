# frozen_string_literal: true

module Decor
  module Suite
    class Dropdown < ::Decor::Components::Dropdown
      MENU_POSITION_OPTIONS = [:aligned_to_left, :aligned_to_right].freeze
      prop :menu_position, _Union(*MENU_POSITION_OPTIONS), default: :aligned_to_left

      stimulus do
        targets :button, :menu
        values_from_props :content_href, :placeholder
      end

      def trigger_attributes
        {
          popovertarget: "#{id}-menu",
          id: "#{id}-menu-button",
          style: "anchor-name: #{resolved_anchor_name};",
          data: {**stimulus_target(:button)}
        }
      end

      def with_menu_item(**attrs, &block)
        if attrs.any?
          item = ::Decor::Suite::DropdownItem.new(**attrs)
          @menu_items ||= []
          @menu_items << (block ? [item, block] : item)
          item
        else
          super(&block)
        end
      end

      def with_button(&block) = trigger_button(&block)
      def with_button_content(&block) = trigger_button_content(&block)
      def with_menu_header(&block) = menu_header(&block)
      def with_menu_content(&block) = menu_content(&block)

      def resolved_anchor_name
        @anchor_name || "--decor-suite-dropdown-anchor-#{id}"
      end

      def view_template(&)
        capture(&) if block_given?

        root_element do
          if @trigger_button.present?
            render @trigger_button
          else
            button(
              type: "button",
              id: "#{id}-menu-button",
              popovertarget: "#{id}-menu",
              style: "anchor-name: #{resolved_anchor_name};",
              class: button_class_string,
              data: {**stimulus_target(:button)}
            ) do
              span(class: "decor:sr-only") { "Open menu" }
              render @trigger_button_content if @trigger_button_content.present?
            end
          end

          div(
            id: "#{id}-menu",
            popover: "auto",
            class: menu_class_string,
            style: "--decor-suite-dropdown-anchor: #{resolved_anchor_name};",
            role: "menu",
            aria: {orientation: "vertical", labelledby: "#{id}-menu-button"},
            tabindex: "-1",
            data: {
              **stimulus_target(:menu),
              position: @menu_position.to_s,
              **stimulus_actions([:beforetoggle, :handle_before_toggle]).to_h
            }
          ) do
            render @menu_header if @menu_header.present?

            if @menu_items&.any?
              @menu_items.each do |item|
                if item.is_a?(Array)
                  component, block = item
                  block ? render(component, &block) : render(component)
                else
                  render item
                end
              end
            end

            render @menu_content if @menu_content.present?
          end
        end
      end

      private

      def root_element_classes
        "decor:relative"
      end

      def button_class_string
        active = @button_active_classes.map { |c| "aria-expanded:#{c}" }
        (@button_classes + active).join(" ")
      end

      def menu_class_string
        [
          "decor--suite--dropdown-menu",
          "decor:overflow-auto decor:focus:outline-hidden",
          size_class_string,
          base_menu_classes,
          @menu_classes&.join(" ")
        ].compact.join(" ")
      end

      # Merge (not replace) the default size classes with any consumer-supplied
      # ones, so passing e.g. a width can't silently drop the default `max-h`
      # cap. Without that cap a tall menu grows past the viewport and the
      # CSS-anchor `flip-block` fallback re-anchors it off-screen. tailwind_merge
      # resolves conflicts last-wins, so a consumer's own width/`max-h` still
      # overrides the defaults.
      def size_class_string
        tailwind_merger.merge(
          ["decor:w-auto decor:max-h-80", @dropdown_size_classes&.join(" ")].compact.join(" ")
        )
      end

      def base_menu_classes
        "decor:bg-white decor:border decor:border-suite-hairline-strong " \
          "decor:rounded-suite-control decor:shadow-suite-popover decor:p-1 decor:min-w-[180px]"
      end
    end
  end
end
