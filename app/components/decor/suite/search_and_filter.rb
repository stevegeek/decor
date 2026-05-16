# frozen_string_literal: true

module Decor
  module Suite
    # Suite SearchAndFilter — combined search input + filter chip pill, with a
    # popover filter panel anchored to the pill, an optional CSV download
    # button, and an optional trailing actions slot.
    #
    # Visual identity:
    #   - Single rounded-suite-control pill containing the search input and
    #     the filter toggle button. Hairline-strong border, white surface.
    #   - Filter toggle: gray-25 fill, hairline divider on the left, optional
    #     active-count badge in suite-primary tones.
    #   - Filter panel: rendered via Suite::Dropdown, anchored to the filter
    #     button via CSS anchor-positioning. The panel itself has compact
    #     padding, individual form rows, and a footer row with Apply /
    #     Clear actions on a suite-gray-25 surface.
    #   - Optional download button mirrors the pill chrome (white, hairline
    #     border, suite-control radius).
    #
    # Stimulus contract is inherited from the abstract base. The matching JS
    # shim at javascript/controllers/decor/suite/search_and_filter_controller.js
    # exposes toggle / handle_apply / handle_clear_filters /
    # handle_search_input_keydown / handle_range_picker.
    class SearchAndFilter < ::Decor::Components::SearchAndFilter
      def view_template(&block)
        @block_content = capture(&block) if block

        root_element do
          render_top_row

          if @filters.present?
            render_filter_panel
          end
        end
      end

      private

      def root_element_classes
        "decor:flex decor:items-center decor:gap-2"
      end

      def render_top_row
        div(class: "decor:flex decor:items-center decor:gap-2") do
          # Combined search + filter pill
          div(class: pill_classes) do
            render_search_input if @search.present?
            render_filter_toggle if @filters.present?
          end

          render_download_button if @download_path.present?

          if @actions.present?
            div(class: "decor:shrink-0", &@actions)
          end
        end
      end

      def pill_classes
        "decor:flex decor:items-stretch decor:bg-white decor:border decor:border-suite-hairline-strong decor:rounded-suite-control decor:overflow-hidden decor:max-w-[480px] decor:flex-1 decor:min-w-0"
      end

      def render_search_input
        div(class: "decor:relative decor:flex-1 decor:min-w-0") do
          render_search_icon
          input(
            type: "text",
            name: @search.name,
            value: @search.value,
            placeholder: @search.placeholder || @search.label,
            class: "decor:w-full decor:border-0 decor:outline-hidden decor:py-[5px] decor:pl-[28px] decor:pr-3 decor:suite-description decor:text-gray-800 decor:bg-transparent decor:placeholder:text-gray-400",
            data: {
              **stimulus_target(:search_input),
              **stimulus_action(:keydown, :handle_search_input_keydown)
            }
          )
        end
      end

      def render_search_icon
        raw safe(<<~SVG)
          <svg class="decor:absolute decor:left-[10px] decor:top-1/2 decor:-translate-y-1/2 decor:w-[13px] decor:h-[13px] decor:text-gray-400 decor:pointer-events-none" fill="none" viewBox="0 0 16 16" stroke="currentColor" stroke-width="1.75" aria-hidden="true">
            <circle cx="7" cy="7" r="5"/>
            <path d="M11 11l3 3" stroke-linecap="round"/>
          </svg>
        SVG
      end

      def render_filter_toggle
        button(
          type: "button",
          class: filter_toggle_classes,
          style: "anchor-name: --decor-suite-saf-filter-#{id};",
          data: {**stimulus_action(:click, :toggle)}
        ) do
          render_filter_icon
          span { "Filter" }
          if active_filters_count > 0
            span(class: filter_badge_classes) { plain active_filters_count.to_s }
          end
          render_chevron_down
        end
      end

      def filter_toggle_classes
        "decor:inline-flex decor:items-center decor:gap-[6px] decor:px-3 decor:py-[5px] decor:bg-suite-gray-25 decor:border-l decor:border-suite-hairline decor:text-gray-700 decor:suite-description decor:font-medium decor:cursor-pointer decor:hover:bg-gray-100 decor:transition-colors decor:duration-suite-fast decor:whitespace-nowrap decor:shrink-0"
      end

      def filter_badge_classes
        "decor:inline-flex decor:items-center decor:justify-center decor:min-w-[15px] decor:h-[14px] decor:px-[4px] decor:bg-suite-primary-100 decor:text-suite-primary-700 decor:rounded-full decor:text-[10px] decor:font-semibold decor:ml-[2px]"
      end

      def render_filter_icon
        raw safe(<<~SVG)
          <svg class="decor:w-[12px] decor:h-[12px] decor:text-gray-500 decor:shrink-0" fill="none" viewBox="0 0 16 16" stroke="currentColor" stroke-width="1.75" aria-hidden="true">
            <path d="M2 4h12l-4 6v4l-4 1V10z" stroke-linejoin="round"/>
          </svg>
        SVG
      end

      def render_chevron_down
        raw safe(<<~SVG)
          <svg class="decor:w-[10px] decor:h-[10px] decor:text-gray-400 decor:shrink-0" fill="none" viewBox="0 0 10 10" stroke="currentColor" stroke-width="1.75" aria-hidden="true">
            <path d="M2 4l3 3 3-3" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        SVG
      end

      def render_download_button
        link_to(
          @download_path,
          method: :post,
          class: download_classes,
          data: {confirm: "Download the data currently shown in the table?", turbo_confirm: "Download the data currently shown in the table?", "confirm-yes": "Yes, download", turbo_method: :post}
        ) do
          render_download_icon
          span { "Download CSV" }
        end
      end

      def download_classes
        "decor:inline-flex decor:items-center decor:gap-1.5 decor:px-3 decor:h-[28px] decor:bg-white decor:border decor:border-suite-hairline-strong decor:rounded-suite-control decor:text-gray-700 decor:suite-description decor:font-medium decor:cursor-pointer decor:transition-all decor:duration-suite-fast decor:hover:bg-gray-50 decor:hover:text-suite-primary-700 decor:shrink-0"
      end

      def render_download_icon
        raw safe(<<~SVG)
          <svg class="decor:w-[14px] decor:h-[14px]" fill="none" viewBox="0 0 16 16" stroke="currentColor" stroke-width="1.75" aria-hidden="true">
            <path d="M8 3v8M5 8l3 3 3-3" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M3 13h10" stroke-linecap="round"/>
          </svg>
        SVG
      end

      def render_filter_panel
        render ::Decor::Suite::Dropdown.new(
          menu_position: :aligned_to_right,
          menu_classes: ["decor:p-0!", "decor:min-w-0!", "decor:rounded-suite-control!", "decor:overflow-hidden!"],
          dropdown_size_classes: ["decor:w-[280px]"],
          button_classes: ["decor:hidden"],
          anchor_name: "--decor-suite-saf-filter-#{id}",
          stimulus_outlet_host: self
        ) do |dropdown|
          dropdown.trigger_button_content {}

          dropdown.menu_content do
            div(class: "decor:p-[14px] decor:flex decor:flex-col decor:gap-3") do
              @filters.each { |filter| render_filter(filter) }
            end

            div(class: "decor:p-[11px] decor:bg-suite-gray-25 decor:border-t decor:border-suite-hairline decor:flex decor:gap-2") do
              if filters_on?
                render ::Decor::Daisy::Button.new(
                  label: "Clear filters",
                  stimulus_targets: [stimulus_target(:clear_filters_button)],
                  stimulus_actions: [stimulus_action(:click, :handle_clear_filters)],
                  icon: "x",
                  size: :sm,
                  color: :error,
                  style: :outlined,
                  full_width: true
                )
              end
              render ::Decor::Daisy::Button.new(
                label: "Apply",
                stimulus_targets: [stimulus_target(:apply_button)],
                stimulus_actions: [stimulus_action(:click, :handle_apply)],
                size: :sm,
                color: :primary,
                full_width: true
              )
            end
          end
        end
      end

      def render_filter(filter)
        case filter.type
        when :select
          render ::Decor::Daisy::Forms::Select.new(
            name: filter.name,
            label: filter.label,
            value: filter.value,
            options_array: filter.options,
            selected_option: filter.value,
            disabled: filter.disabled,
            disabled_options: filter.disabled_options,
            disable_blank_option: false,
            label_position: :inside,
            collapsing_helper_text: true,
            classes: "decor:w-full",
            stimulus_outlet_host: self
          )
        when :checkbox
          render ::Decor::Daisy::Forms::Checkbox.new(
            name: filter.name,
            label: filter.label,
            checked: filter.value == "true",
            disabled: filter.disabled,
            collapsing_helper_text: true,
            classes: "decor:w-full",
            stimulus_outlet_host: self
          )
        when :date_range
          render ::Decor::Daisy::Forms::TextField.new(
            label_position: :inside,
            name: filter.name,
            label: filter.label,
            value: filter.value,
            disabled: filter.disabled,
            collapsing_helper_text: true,
            control_actions: [stimulus_action(:focus, :handle_range_picker)],
            classes: "decor:w-full",
            stimulus_outlet_host: self
          )
        end
      end

      def active_filters_count
        @filters.count { |s| s.value.present? }
      end
    end
  end
end
