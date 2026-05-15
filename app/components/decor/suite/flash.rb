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
              div(class: "decor:w-9 decor:h-9 decor:flex decor:items-center decor:justify-center decor:rounded-md decor:shrink-0 #{icon_wrap_classes}") do
                render ::Decor::Icon.new(name: icon, html_options: {class: "decor:w-[18px] decor:h-[18px]"})
              end
              div(class: "decor:flex-1 decor:min-w-0") do
                h4(class: "decor:font-semibold decor:text-sm decor:m-0 decor:mb-0.5") { title_with_defaults }
                p(class: "decor:text-sm decor:m-0 decor:leading-6") { text_with_default }
              end
              child_element(
                :button,
                type: "button",
                stimulus_actions: [[:click, :hide]],
                class: "decor:w-[22px] decor:h-[22px] decor:flex decor:items-center decor:justify-center decor:rounded-md decor:cursor-pointer decor:opacity-60 decor:hover:opacity-100 decor:hover:bg-black/5 decor:shrink-0"
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
          "decor:flex decor:items-start decor:gap-3 decor:px-4 decor:py-4 decor:border decor:rounded-md",
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
        when :success then "decor:bg-success/10 decor:border-success/30 decor:text-success"
        when :error then "decor:bg-error/10 decor:border-error/30 decor:text-error"
        when :warning then "decor:bg-warning/10 decor:border-warning/30 decor:text-warning"
        when :info, :primary then "decor:bg-info/10 decor:border-info/30 decor:text-info"
        else "decor:bg-base-200 decor:border-black/15 decor:text-base-content"
        end
      end

      def icon_wrap_classes
        case resolved_color
        when :success then "decor:bg-success/15 decor:text-success"
        when :error then "decor:bg-error/15 decor:text-error"
        when :warning then "decor:bg-warning/15 decor:text-warning"
        when :info, :primary then "decor:bg-info/15 decor:text-info"
        else "decor:bg-base-300 decor:text-base-content"
        end
      end
    end
  end
end
