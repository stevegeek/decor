# frozen_string_literal: true

module Decor
  class Dropdown < PhlexComponent
    # Modern attributes with DaisyUI integration
    attribute :size, Symbol, default: :md, in: [:xs, :sm, :md, :lg, :xl]
    attribute :color, Symbol, default: :base, in: [:base, :primary, :secondary, :accent, :success, :error, :warning, :info, :neutral]
    attribute :variant, Symbol, default: :default, in: [:default, :bordered, :filled]
    attribute :position, Symbol, default: :left, in: [:left, :right, :top, :bottom, :end, :center, :start]
    attribute :trigger, Symbol, default: :click, in: [:click, :hover, :focus]
    attribute :force_open, Symbol, default: :auto, in: [:auto, :open, :closed]

    attribute :button_classes, Array, default: []
    attribute :button_active_classes, Array, default: []

    def trigger_button(&block)
      @trigger_button = block
    end

    def trigger_button_content(&block)
      @trigger_button_content = block
    end

    def menu_header(&block)
      @menu_header = block
    end

    def menu_content(&block)
      @menu_content = block
    end

    def menu_item(item)
      @menu_items ||= []
      @menu_items << item
    end

    def card_content(&block)
      @card_content = block
    end

    def custom_content(&block)
      @custom_content = block
    end

    def view_template(&)
      @content = capture(&) if block_given?

      render parent_element do |s|
        if @trigger_button.present?
          instance_eval(&@trigger_button)
        else
          s.target_tag(
            :button,
            :button,
            type: "button",
            tabindex: "0",
            role: "button",
            aria_haspopup: "true",
            aria_expanded: "false",
            class: dropdown_button_classes
          ) do
            if @trigger_button_content.present?
              instance_eval(&@trigger_button_content)
            else
              plain "Menu"
            end
          end
        end

        if @card_content.present? || @custom_content.present?
          # Non-menu content (cards, custom elements)
          s.target_tag(
            :div,
            :content,
            class: dropdown_content_classes_non_menu,
            role: "dialog",
            aria_labelledby: "#{id}-menu-button",
            tabindex: "-1"
          ) do
            render instance_eval(&@card_content) if @card_content.present?
            render instance_eval(&@custom_content) if @custom_content.present?
          end
        else
          # Traditional menu content
          s.target_tag(
            :ul,
            :menu,
            tabindex: "0",
            class: dropdown_content_classes
          ) do
            render instance_eval(&@menu_header) if @menu_header.present?

            if @menu_items&.any?
              @menu_items.each do |item|
                render item
              end
            end

            render instance_eval(&@menu_content) if @menu_content.present?
          end
        end

        render @content if @content
      end
    end

    private

    def root_element_attributes
      {
        named_classes: {
          active: @button_active_classes
        },
        values: [{
          active_target: "##{id}-menu-button",
          enter_timeout: "100",
          leave_timeout: "75"
        }],
        actions: [[:click, :toggle], [:"click@window", :hide_on_click_outside]]
      }
    end

    def element_classes
      [
        "dropdown",
        position_classes,
        trigger_classes,
        force_open_classes
      ].compact.join(" ")
    end

    def dropdown_button_classes
      [
        "btn",
        size_classes,
        color_classes,
        variant_classes,
        @button_classes
      ].compact.join(" ")
    end

    def dropdown_content_classes
      [
        "dropdown-content",
        "menu",
        "bg-base-100",
        "rounded-box",
        "z-[1]",
        size_content_classes,
        "p-2",
        "shadow-sm",
        color_content_classes,
        variant_content_classes
      ].compact.join(" ")
    end

    def position_classes
      case @position
      when :right, :end
        "dropdown-end"
      when :top
        "dropdown-top"
      when :bottom
        "dropdown-bottom"
      when :center
        "dropdown-center"
      when :start
        "dropdown-start"
      else
        nil # :left is default and does not add a specific class
      end
    end

    def trigger_classes
      case @trigger
      when :hover then "dropdown-hover"
      when :focus then nil # default CSS focus behavior
      else nil # default click behavior
      end
    end

    def force_open_classes
      case @force_open
      when :open then "dropdown-open"
      when :closed then nil # forces closed state
      else nil # auto behavior
      end
    end

    def dropdown_content_classes_non_menu
      [
        "dropdown-content",
        "bg-base-100",
        "rounded-box",
        "z-[1]",
        size_content_classes,
        "p-2",
        "shadow-sm",
        color_content_classes,
        variant_content_classes
      ].compact.join(" ")
    end

    def size_classes
      case @size
      when :xs then "btn-xs"
      when :sm then "btn-sm"
      when :lg then "btn-lg"
      when :xl then "btn-lg" # xl maps to lg for buttons
      else nil # md is default
      end
    end

    def color_classes
      case @color
      when :primary then "btn-primary"
      when :secondary then "btn-secondary"
      when :accent then "btn-accent"
      when :success then "btn-success"
      when :error then "btn-error"
      when :warning then "btn-warning"
      when :info then "btn-info"
      when :neutral then "btn-neutral"
      else nil # base is default
      end
    end

    def variant_classes
      case @variant
      when :bordered then "btn-outline"
      when :filled then nil # default filled style
      else nil # default
      end
    end

    def size_content_classes
      case @size
      when :xs then "w-32"
      when :sm then "w-40"
      when :lg then "w-64"
      when :xl then "w-80"
      else "w-52" # md is default
      end
    end

    def color_content_classes
      case @color
      when :primary then "bg-primary text-primary-content"
      when :secondary then "bg-secondary text-secondary-content"
      when :accent then "bg-accent text-accent-content"
      when :success then "bg-success text-success-content"
      when :error then "bg-error text-error-content"
      when :warning then "bg-warning text-warning-content"
      when :info then "bg-info text-info-content"
      when :neutral then "bg-neutral text-neutral-content"
      else nil # base is default
      end
    end

    def variant_content_classes
      case @variant
      when :bordered then "border border-base-300"
      when :filled then "bg-base-200"
      else nil # default
      end
    end
  end
end
