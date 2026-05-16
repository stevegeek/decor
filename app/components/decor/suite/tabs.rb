# frozen_string_literal: true

module Decor
  module Suite
    # Suite Tabs — segmented horizontal nav strip.
    #
    # Visual identity:
    #   - Gray-100 segmented container with 3px inner padding + control radius
    #   - Active tab: white pill with subtle 0/1px shadow + suite-primary-700 text
    #   - Inactive tab: gray-600 text, gray-200/60 hover fill
    #   - Disabled tab: gray-400, not interactive
    #   - Optional status caption right-aligned on >= sm
    #   - Horizontal overflow scrolls; leading/trailing fades reveal overflow
    #
    # Stimulus controls the scroll-shadow fades by toggling
    # `inset-scroll-shadow-not-at-{left,right}` classes on the strip wrapper.
    class Tabs < ::Decor::Components::Tabs
      stimulus do
        targets :wrapper, :scroll
        actions [:scroll, :scrolled]
      end

      def view_template
        root_element do
          div(
            class: strip_wrapper_classes,
            data: {**stimulus_target(:wrapper)}
          ) do
            div(
              class: "decor:overflow-x-auto decor:[scrollbar-width:none] decor:[&::-webkit-scrollbar]:hidden",
              data: {
                **stimulus_target(:scroll),
                **stimulus_action(:scroll, :scrolled)
              }
            ) do
              nav(
                aria_label: "Tabs",
                class: "decor:inline-flex decor:items-center decor:gap-[2px] decor:min-w-max"
              ) do
                (@links || []).each { |link| render_tab(link) }
              end
            end
          end

          if @status.present?
            p(class: "decor:suite-dense-body decor:text-gray-500 decor:sm:ml-4 decor:mt-2 decor:sm:mt-0 decor:shrink-0") do
              plain @status.to_s
            end
          end
        end
      end

      private

      def root_element_attributes
        {element_tag: :div}
      end

      def root_element_classes
        "decor:flex decor:flex-col decor:sm:flex-row decor:sm:items-center decor:w-full"
      end

      def strip_wrapper_classes
        "decor--suite--tabs__strip-wrapper decor:flex-1 decor:min-w-0 decor:relative decor:bg-gray-100 decor:rounded-suite-control decor:p-[3px] decor:overflow-hidden"
      end

      def render_tab(link)
        if link.disabled?
          span(class: disabled_tab_classes, aria_disabled: "true") do
            plain link.title.to_s
            render_badge(link) if link.badge_text.present?
          end
        elsif link.href.blank?
          # No href: non-interactive span (e.g. coming-soon tab).
          span(class: inactive_tab_classes) do
            plain link.title.to_s
            render_badge(link) if link.badge_text.present?
          end
        elsif link.active?
          a(href: link.href, aria_current: "page", class: active_tab_classes) do
            plain link.title.to_s
            render_badge(link, active: true) if link.badge_text.present?
          end
        else
          a(href: link.href, class: inactive_tab_classes) do
            plain link.title.to_s
            render_badge(link) if link.badge_text.present?
          end
        end
      end

      def render_badge(link, active: false)
        span(class: badge_classes(active: active)) { plain link.badge_text.to_s }
      end

      def tab_base_classes
        "decor:inline-flex decor:items-center decor:gap-2 decor:whitespace-nowrap " \
          "decor:px-3 decor:py-[6px] decor:text-[13px] decor:font-medium " \
          "decor:rounded-[5px] " \
          "decor:transition-colors decor:duration-suite-fast decor:ease-out " \
          "decor:focus-visible:outline-hidden decor:focus-visible:ring-2 " \
          "decor:focus-visible:ring-offset-1 decor:focus-visible:ring-suite-primary-500 " \
          "decor:no-underline decor:hover:no-underline"
      end

      def active_tab_classes
        "#{tab_base_classes} decor:bg-white decor:text-suite-primary-700 " \
          "decor:shadow-[0_1px_2px_rgba(0,0,0,0.06),0_0_0_1px_rgba(0,0,0,0.04)]"
      end

      def inactive_tab_classes
        "#{tab_base_classes} decor:text-gray-600 decor:hover:text-gray-900 decor:hover:bg-gray-200/60"
      end

      def disabled_tab_classes
        "#{tab_base_classes} decor:text-gray-400 decor:cursor-not-allowed decor:select-none"
      end

      def badge_classes(active:)
        base = "decor:inline-flex decor:items-center decor:justify-center " \
          "decor:min-w-[18px] decor:h-[18px] decor:px-[6px] " \
          "decor:text-[10.5px] decor:font-semibold decor:leading-none decor:tabular-nums " \
          "decor:rounded-full"
        if active
          "#{base} decor:bg-suite-primary-100 decor:text-suite-primary-700"
        else
          "#{base} decor:bg-gray-200 decor:text-gray-600"
        end
      end
    end
  end
end
