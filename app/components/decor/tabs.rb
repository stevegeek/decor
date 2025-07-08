# frozen_string_literal: true

module Decor
  class Tabs < PhlexComponent
    class TabInfo < ::Literal::Data
      # When active link gets visual indicator representing its state
      prop :active, _Boolean, default: false, predicate: :public
      prop :disabled, _Boolean, default: false, predicate: :public

      # Title used as `title` attr in HTML and as content of `a` tag
      prop :title, _Nilable(String)
      prop :href, _Nilable(String)

      # Icon configuration
      prop :icon, _Nilable(String)
      prop :icon_position, _Union(:before, :after, :only), default: :before

      # Badge configuration
      prop :badge_text, _Nilable(String)
      prop :badge_color, _Union(:standard, :warning, :info, :error, :success, :primary, :secondary, :accent), default: :standard
    end

    # Array of links in navigation. Each link must have a `title` and `href` specified
    prop :links, _Nilable(_Array(TabInfo)), default: -> { [] } do |attrs|
      attrs.map { |link| link.is_a?(TabInfo) ? link : TabInfo.new(link) }
    end

    # Status text is displayed to the right of the tabs
    prop :status, _Nilable(String)

    # Size of the tabs
    prop :size, _Union(:xs, :sm, :md, :lg, :xl), default: :md

    # Color scheme using DaisyUI semantic colors
    prop :color, _Union(:base, :primary, :secondary, :accent, :success, :error, :warning, :info, :neutral), default: :base

    # Visual variant
    prop :variant, _Union(:ghost, :bordered, :lifted, :boxed), default: :bordered

    def tab_buttons(&block)
      @tab_buttons = block
    end

    def with_tab_buttons(&block)
      @tab_buttons = block
      self
    end

    def with_tab_content(&block)
      @tab_content = block
      self
    end

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
        # Tab buttons
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

      # Tab content (render outside nav for proper DOM structure)
      if @tab_content.present?
        div(class: "tab-content bg-base-100 border-base-300 p-6") do
          result = @tab_content.call
          raw result.html_safe if result.is_a?(String)
        end
      end
    end

    def render_mobile_tabs
      # Mobile select dropdown
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
      # Icon before text
      if link.icon.present? && link.icon_position == :before
        render ::Decor::Icon.new(name: link.icon, size: @size, html_options: {class: "mr-2"})
      end

      # Title text (unless icon-only)
      unless link.icon.present? && link.icon_position == :only
        span { link.title }
      end

      # Icon after text
      if link.icon.present? && link.icon_position == :after
        render ::Decor::Icon.new(name: link.icon, size: @size, html_options: {class: "ml-2"})
      end

      # Icon only (with aria-label)
      if link.icon.present? && link.icon_position == :only
        render ::Decor::Icon.new(name: link.icon, size: @size)
      end

      # Badge indicator
      if link.badge_text.present?
        render ::Decor::Badge.new(
          label: link.badge_text,
          style: map_badge_color_to_style(link.badge_color),
          size: :small,
          html_options: {class: "ml-2"}
        )
      end
    end

    def tabs_container_classes
      "tabs #{select_on_mobile? ? "hidden sm:block" : ""} #{variant_classes} #{size_classes} #{color_classes}".strip
    end

    def variant_classes
      case @variant
      when :bordered then "tabs-border"
      when :lifted then "tabs-lift"
      when :boxed then "tabs-box"
      else "hover:tabs-lift" # ghost variant
      end
    end

    def size_classes
      case @size
      when :xs then "tabs-xs"
      when :sm then "tabs-sm"
      when :lg then "tabs-lg"
      when :xl then "tabs-xl"
      else "" # md is default, no class needed
      end
    end

    def color_classes
      # DaisyUI tabs use standard color classes
      case @color
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

      # Enhanced ARIA attributes
      attrs[:role] = "tablist"
      attrs[:aria_label] = "Tabs"

      # Keyboard navigation support
      attrs[:tabindex] = "0"

      attrs
    end

    def tab_link_attributes(link)
      attrs = {}

      # ARIA attributes for accessibility
      attrs[:aria_selected] = link.active? ? "true" : "false"
      attrs[:tabindex] = link.active? ? "0" : "-1"

      # Enhanced accessibility for icon-only tabs
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

    def select_on_mobile?
      @links&.size.to_i > 3
    end

    def use_slot_api?
      @tab_buttons.present? || @tab_content.present? || @links.blank?
    end

    def map_badge_color_to_style(color)
      case color
      when :primary, :secondary, :accent then :standard
      when :warning, :info, :error, :success then color
      else :standard
      end
    end
  end
end
