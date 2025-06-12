# frozen_string_literal: true

module Decor
  class Tabs < PhlexComponent
    class TabInfo < PhlexComponent
      # When active link gets visual indicator representing its state
      attribute :active, :boolean, default: false
      attribute :disabled, :boolean, default: false

      # Title used as `title` attr in HTML and as content of `a` tag
      attribute :title, String, allow_blank: false
      attribute :href, String, allow_blank: false
      
      # Icon configuration
      attribute :icon, String
      attribute :icon_position, Symbol, default: :before, in: [:before, :after, :only]
      
      # Badge configuration
      attribute :badge_text, String
      attribute :badge_color, Symbol, default: :standard, in: [:standard, :warning, :info, :error, :success, :primary, :secondary, :accent]

      attr_reader :href, :title, :icon, :icon_position, :badge_text, :badge_color

      def active?
        @active
      end

      def disabled?
        @disabled
      end
    end
    
    # Array of links in navigation. Each link must have a `title` and `href` specified
    attribute :links, Array, sub_type: TabInfo, convert: true, allow_nil: true
    
    # Status text is displayed to the right of the tabs
    attribute :status, String
    
    # Size of the tabs
    attribute :size, Symbol, default: :md, in: [:xs, :sm, :md, :lg, :xl]
    
    # Color scheme using DaisyUI semantic colors
    attribute :color, Symbol, default: :base, in: [:base, :primary, :secondary, :accent, :success, :error, :warning, :info, :neutral]
    
    # Visual variant
    attribute :variant, Symbol, default: :bordered, in: [:ghost, :bordered, :lifted, :boxed]

    def tab_buttons(&block)
      @tab_buttons = block
    end

    def view_template(&)
      @content = capture(&) if block_given?

      render parent_element do
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
          div(role: "tablist", class: tabs_list_classes) do
            # result = instance_eval(&@tab_buttons)
            # raw result.html_safe if result.is_a?(String)
            render @tab_buttons
          end
        else
          @links.each do |link|
            render_tab_link(link)
          end
        end

        if @status.present?
          div(class: "ml-auto hidden md:flex items-center") do
            p(class: "text-sm text-base-content/70") { @status }
          end
        end

        # Tab content
        if @content.present?
          div(class: "tab-content bg-base-100 border-base-300 p-6") do
            render @content
          end
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
          class: "tab #{link.active? ? 'tab-active' : ''}",
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
      "tabs #{select_on_mobile? ? 'hidden sm:block' : ''} #{variant_classes} #{size_classes} #{color_classes}".strip
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

    def map_badge_color_to_style(color)
      case color
      when :primary, :secondary, :accent then :standard
      when :warning, :info, :error, :success then color
      else :standard
      end
    end
  end
end
