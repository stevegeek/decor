# frozen_string_literal: true

module Decor
  module Daisy
    class Tabs < ::Decor::Components::Tabs
      def view_template(&)
        @content = capture(&) if block_given?

        root_element do
          render_tabs
        end
      end

      private

      def render_tabs
        if select_on_mobile?
          render_mobile_tabs
        end

        nav(class: tabs_container_classes, **tabs_container_attributes) do
          if @tab_buttons.present?
            result = @tab_buttons.call
            raw result.html_safe if result.is_a?(String)
          else
            (@links || []).each do |link|
              render_tab_link(link)
            end
          end

          if @status.present?
            div(class: "decor:ml-auto decor:hidden decor:md:flex decor:items-center") do
              p(class: "decor:text-sm decor:text-base-content/70") { @status }
            end
          end
        end

        if @tab_content.present?
          div(class: "decor:d-tab-content decor:bg-base-100 decor:border-base-300 decor:p-6") do
            result = @tab_content.call
            raw result.html_safe if result.is_a?(String)
          end
        end
      end

      def render_mobile_tabs
        nav(class: "decor:sm:hidden decor:border-y decor:border-base-300 decor:p-4") do
          label(for: "#{id}-select", class: "decor:block decor:text-sm decor:text-base-content/70 decor:mb-2") { "Navigate to a tab:" }
          select(
            id: "#{id}-select",
            name: "#{id}-select",
            class: "decor:d-select decor:d-select-bordered decor:w-full"
          ) do
            @links.each do |link|
              option(
                value: link.title,
                data_href: link.href,
                **option_html_attributes(link)
              ) { link.title }
            end
          end
          if @status.present?
            p(class: "decor:text-sm decor:text-base-content/70 decor:mt-2") { @status }
          end
        end
      end

      def render_tab_link(link)
        if link.disabled?
          span(class: "decor:d-tab decor:d-tab-disabled", aria_disabled: "true") do
            render_tab_content(link)
          end
        else
          a(
            href: link.href,
            role: "tab",
            class: "decor:d-tab #{"decor:d-tab-active" if link.active?}",
            **tab_link_attributes(link)
          ) do
            render_tab_content(link)
          end
        end
      end

      def render_tab_content(link)
        if link.icon.present? && link.icon_position == :before
          render ::Decor::Icon.new(name: link.icon, size: @size, html_options: {class: "decor:mr-2"})
        end

        unless link.icon.present? && link.icon_position == :only
          span { link.title }
        end

        if link.icon.present? && link.icon_position == :after
          render ::Decor::Icon.new(name: link.icon, size: @size, html_options: {class: "decor:ml-2"})
        end

        if link.icon.present? && link.icon_position == :only
          render ::Decor::Icon.new(name: link.icon, size: @size)
        end

        if link.badge_text.present?
          render ::Decor::Daisy::Badge.new(
            label: link.badge_text,
            style: :filled,
            size: :sm,
            html_options: {class: "decor:ml-2"}
          )
        end
      end

      def tabs_container_classes
        "decor:d-tabs #{"decor:hidden decor:sm:block" if select_on_mobile?} #{style_classes} #{size_classes} #{color_classes}".strip
      end

      def component_style_classes(style)
        case style
        when :bordered then "decor:d-tabs-border"
        when :lifted then "decor:d-tabs-lift"
        when :boxed then "decor:d-tabs-box"
        else "decor:hover:d-tabs-lift" # ghost style
        end
      end

      def component_size_classes(size)
        case size
        when :xs then "decor:d-tabs-xs"
        when :sm then "decor:d-tabs-sm"
        when :lg then "decor:d-tabs-lg"
        when :xl then "decor:d-tabs-xl"
        else "" # md is default, no class needed
        end
      end

      def component_color_classes(color)
        case color
        when :primary then "decor:text-primary"
        when :secondary then "decor:text-secondary"
        when :accent then "decor:text-accent"
        when :success then "decor:text-success"
        when :error then "decor:text-error"
        when :warning then "decor:text-warning"
        when :info then "decor:text-info"
        when :neutral then "decor:text-neutral"
        else "" # base is default
        end
      end

      def tabs_container_attributes
        attrs = {}
        attrs[:role] = "tablist"
        attrs[:aria_label] = "Tabs"
        attrs[:tabindex] = "0"
        attrs
      end

      def tab_link_attributes(link)
        attrs = {}
        attrs[:aria_selected] = link.active? ? "true" : "false"
        attrs[:tabindex] = link.active? ? "0" : "-1"

        if link.icon.present? && link.icon_position == :only
          attrs[:aria_label] = link.title
        end

        attrs
      end

      def option_html_attributes(link)
        attrs = {}
        attrs[:selected] = nil if link.active?
        attrs[:disabled] = nil if link.disabled?
        attrs
      end
    end
  end
end
