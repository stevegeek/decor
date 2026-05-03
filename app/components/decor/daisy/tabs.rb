# frozen_string_literal: true

module Decor
  module Daisy
    # A navigation component that displays a horizontal list of tabs.
    # Tabs allow users to switch between different views or sections of content.
    # Supports various styles, sizes, colors, and can include icons and badges.
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
            div(class: "ml-auto hidden md:flex items-center") do
              p(class: "text-sm text-base-content/70") { @status }
            end
          end
        end

        if @tab_content.present?
          div(class: "tab-content bg-base-100 border-base-300 p-6") do
            result = @tab_content.call
            raw result.html_safe if result.is_a?(String)
          end
        end
      end

      def render_mobile_tabs
        nav(class: "sm:hidden border-y border-base-300 p-4") do
          label(for: "#{id}-select", class: "block text-sm text-base-content/70 mb-2") { "Navigate to a tab:" }
          select(
            id: "#{id}-select",
            name: "#{id}-select",
            class: "select select-bordered w-full"
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
            p(class: "text-sm text-base-content/70 mt-2") { @status }
          end
        end
      end

      def render_tab_link(link)
        if link.disabled?
          span(class: "tab tab-disabled", aria_disabled: "true") do
            render_tab_content(link)
          end
        else
          a(
            href: link.href,
            role: "tab",
            class: "tab #{link.active? ? "tab-active" : ""}",
            **tab_link_attributes(link)
          ) do
            render_tab_content(link)
          end
        end
      end

      def render_tab_content(link)
        if link.icon.present? && link.icon_position == :before
          render ::Decor::Daisy::Icon.new(name: link.icon, size: @size, html_options: {class: "mr-2"})
        end

        unless link.icon.present? && link.icon_position == :only
          span { link.title }
        end

        if link.icon.present? && link.icon_position == :after
          render ::Decor::Daisy::Icon.new(name: link.icon, size: @size, html_options: {class: "ml-2"})
        end

        if link.icon.present? && link.icon_position == :only
          render ::Decor::Daisy::Icon.new(name: link.icon, size: @size)
        end

        if link.badge_text.present?
          render ::Decor::Daisy::Badge.new(
            label: link.badge_text,
            style: :filled,
            size: :sm,
            html_options: {class: "ml-2"}
          )
        end
      end

      def tabs_container_classes
        "tabs #{select_on_mobile? ? "hidden sm:block" : ""} #{style_classes} #{size_classes} #{color_classes}".strip
      end

      def component_style_classes(style)
        case style
        when :bordered then "tabs-border"
        when :lifted then "tabs-lift"
        when :boxed then "tabs-box"
        else "hover:tabs-lift" # ghost style
        end
      end

      def component_size_classes(size)
        case size
        when :xs then "tabs-xs"
        when :sm then "tabs-sm"
        when :lg then "tabs-lg"
        when :xl then "tabs-xl"
        else "" # md is default, no class needed
        end
      end

      def component_color_classes(color)
        case color
        when :primary then "text-primary"
        when :secondary then "text-secondary"
        when :accent then "text-accent"
        when :success then "text-success"
        when :error then "text-error"
        when :warning then "text-warning"
        when :info then "text-info"
        when :neutral then "text-neutral"
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
