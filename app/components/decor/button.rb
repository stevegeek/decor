# frozen_string_literal: true

module Decor
  class Button < PhlexComponent
    prop :label, _Nilable(String)

    # An icon name to render before the label
    prop :icon, _Nilable(String)
    prop :icon_variant, _Nilable(Symbol)
    prop :icon_only_on_mobile, _Boolean, default: false

    prop :disabled, _Boolean, default: false

    # Whether button should span the entire width of the container or not
    prop :full_width, _Boolean, default: false

    def before_label(&block)
      @before_label = block
    end

    def with_before_label(&block)
      @before_label = block
      self
    end

    def after_label(&block)
      @after_label = block
    end

    def with_after_label(&block)
      @after_label = block
      self
    end

    private

    def view_template(&)
      @content = capture(&) if block_given?
      root_element do
        span(class: "text-center") do
          render @before_label if @before_label.present?
          if @icon
            icon_options = {name: @icon, html_options: {class: icon_classes}}
            icon_options[:variant] = @icon_variant if @icon_variant
            render ::Decor::Icon.new(**icon_options)
          end
          span(class: @icon_only_on_mobile ? "hidden md:inline" : "") do
            if @content
              raw @content
            elsif @label.present?
              plain @label
            end
          end
          render @after_label if @after_label.present?
        end
      end
    end

    def root_element_attributes
      {
        element_tag: :button,
        html_options: {
          disabled: @disabled ? "disabled" : nil
        }
      }
    end

    def element_classes
      [
        "btn",
        *color_classes,
        *style_classes,
        *size_classes,
        *modifier_classes
      ].compact.join(" ")
    end

    def icon_classes
      normalized_size = normalize_size(@size)
      sized =
        case normalized_size
        when :xl
          "size-10 pr-2"
        when :lg
          "size-8 pr-2"
        when :md, nil
          "size-6 pr-1"
        when :sm
          "size-5.5 pr-1"
        when :xs
          "size-4.5 pr-1"
        else
          "size-6 pr-1"
        end
      "inline #{@icon_only_on_mobile ? "mr-0 md:mr-1" : "mr-1"} #{sized}"
    end

    def component_color_classes(color)
      return [] unless color
      
      case color
      when :base
        [] # Base color has no specific btn- class in DaisyUI
      when :primary
        ["btn-primary"]
      when :secondary
        ["btn-secondary"]
      when :error
        ["btn-error"]
      when :warning
        ["btn-warning"]
      when :neutral
        ["btn-neutral"]
      when :success
        ["btn-success"]
      when :info
        ["btn-info"]
      when :accent
        ["btn-accent"]
      else
        []
      end
    end

    def style_classes
      classes = component_style_classes(@style) || []
      classes << "bg-base-100" if @style == :outlined
      classes
    end

    def component_style_classes(style)
      case style
      when :filled
        [] # Default for buttons, no special class needed
      when :outlined
        ["btn-outline"]
      when :ghost
        ["btn-ghost"]
      else
        []
      end
    end

    def component_size_classes(size)
      case size
      when :xs
        ["btn-xs"]
      when :sm
        ["btn-sm"]
      when :lg
        ["btn-lg"]
      when :xl
        ["btn-xl"]
      else
        [] # medium is default, no class needed
      end
    end

    def modifier_classes
      classes = []
      classes << "btn-block" if @full_width
      classes
    end
  end
end
