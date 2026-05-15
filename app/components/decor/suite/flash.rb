# frozen_string_literal: true

module Decor
  module Suite
    # Suite Flash — muted card with avatar-style icon wrap and close-X button.
    # Pure component: relies on flash_data/controller_path/action_name being
    # passed explicitly. Use `decor_flash` view helper for Rails-aware rendering.
    class Flash < ::Decor::Components::Flash
      def view_template(&block)
        if block && !show_initial?
          yield
        else
          root_element do
            if show_initial?
              div(class: "decor:w-9 decor:h-9 decor:flex decor:items-center decor:justify-center decor:rounded-suite-card decor:shrink-0 #{icon_wrap_classes}") do
                render ::Decor::Icon.new(name: icon, html_options: {class: "decor:w-[18px] decor:h-[18px]"})
              end
              div(class: "decor:flex-1 decor:min-w-0") do
                h4(class: "decor:suite-section-title decor:m-0 decor:mb-[2px]") { title_with_defaults }
                p(class: "decor:suite-description decor:m-0 decor:leading-6") { text_with_default }
              end
              child_element(
                :button,
                type: "button",
                stimulus_action: [:click, :hide],
                class: "decor:w-[22px] decor:h-[22px] decor:flex decor:items-center decor:justify-center decor:rounded-suite-control decor:cursor-pointer decor:opacity-60 decor:hover:opacity-100 decor:hover:bg-black/5 decor:shrink-0"
              ) do
                render ::Decor::Icon.new(name: "x", html_options: {class: "decor:w-3 decor:h-3"})
              end
            end
          end
        end
      end

      private

      def root_element_classes
        [
          "decor:flex decor:items-start decor:gap-3 decor:px-4 decor:py-4 decor:border decor:rounded-suite-card",
          variant_classes,
          ("decor:invisible decor:opacity-0" unless show_initial?),
          ("decor:hidden" if @collapse_if_empty && !show_initial?)
        ].compact.join(" ")
      end

      def root_element_attributes
        {html_options: show_initial? ? {} : {hidden: true}}
      end

      def variant_classes
        case resolved_color
        when :success then "decor:bg-suite-success-50 decor:border-suite-success-100 decor:text-suite-success-700"
        when :error then "decor:bg-suite-danger-50 decor:border-suite-danger-100 decor:text-suite-danger-700"
        when :warning then "decor:bg-suite-warning-50 decor:border-suite-warning-100 decor:text-suite-warning-700"
        when :info, :primary then "decor:bg-suite-primary-50 decor:border-suite-primary-100 decor:text-suite-primary-700"
        else "decor:bg-gray-50 decor:border-suite-hairline decor:text-gray-800"
        end
      end

      def icon_wrap_classes
        case resolved_color
        when :success then "decor:bg-suite-success-100 decor:text-suite-success-600"
        when :error then "decor:bg-suite-danger-100 decor:text-suite-danger-600"
        when :warning then "decor:bg-suite-warning-100 decor:text-suite-warning-600"
        when :info, :primary then "decor:bg-suite-primary-100 decor:text-suite-primary-600"
        else "decor:bg-gray-100 decor:text-gray-600"
        end
      end
    end
  end
end
