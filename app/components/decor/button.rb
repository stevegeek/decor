# frozen_string_literal: true

module Decor
  class Button < PhlexComponent
    prop :label, _Nilable(String)

    # An icon name to render before the label
    prop :icon, _Nilable(String)
    prop :icon_variant, _Nilable(Symbol)
    prop :icon_only_on_mobile, _Boolean, default: false

    prop :variant, _Union(:contained, :outlined, :text), default: :contained
    prop :color, _Union(:primary, :secondary, :danger, :warning, :neutral), default: :primary
    prop :size, _Union(:large, :medium, :wide, :small, :micro, :xs, :lg, :md, :sm), default: :medium

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
      @content = block_given? ? capture(&) : @label
      root_element do
        span(class: "text-center") do
          render @before_label if @before_label.present?
          if @icon
            icon_options = {name: @icon, html_options: {class: icon_classes}}
            icon_options[:variant] = @icon_variant if @icon_variant
            render ::Decor::Icon.new(**icon_options)
          end
          span(class: @icon_only_on_mobile ? "hidden md:inline" : "") do
            render @content
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
        *variant_classes,
        *size_classes,
        *modifier_classes
      ].compact.join(" ")
    end

    def icon_classes
      sized =
        case @size
        when :large, :lg
          "size-8 pr-2"
        when :medium, :wide, :md
          "size-6 pr-1"
        when :small, :sm
          "size-5.5 pr-1"
        when :micro, :xs
          "size-4.5 pr-1"
        end
      "inline #{@icon_only_on_mobile ? "mr-0 md:mr-1" : "mr-1"} #{sized}"
    end

    def color_classes
      case @color
      when :primary
        ["btn-primary"]
      when :secondary
        ["btn-secondary"]
      when :danger
        ["btn-error"]
      when :warning
        ["btn-warning"]
      when :neutral
        ["btn-neutral"]
      else
        ["btn-neutral"]
      end
    end

    def variant_classes
      case @variant
      when :outlined
        ["btn-outline bg-base-100"]
      when :text
        ["btn-ghost"]
      else
        []
      end
    end

    def size_classes
      case @size
      when :large, :lg
        ["btn-lg"]
      when :small, :sm
        ["btn-sm"]
      when :micro, :xs
        ["btn-xs"]
      when :wide
        ["btn-wide"]
      else
        []
      end
    end

    def modifier_classes
      classes = []
      classes << "btn-block" if @full_width
      classes
    end
  end
end
