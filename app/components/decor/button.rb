# frozen_string_literal: true

module Decor
  class Button < PhlexComponent
    attribute :label, String

    # An icon name to render before the label
    attribute :icon, String
    attribute :icon_variant, Symbol
    attribute :icon_only_on_mobile, :boolean, default: false

    attribute :variant, Symbol, default: :contained, in: %i[contained outlined text]
    attribute :theme, Symbol, default: :primary, in: %i[primary secondary danger warning neutral]
    attribute :size, Symbol, default: :medium, in: %i[large medium wide small micro xs lg md sm]

    attribute :disabled, :boolean, default: false

    # Whether button should span the entire width of the container or not
    attribute :full_width, :boolean, default: false

    def before_label(&block)
      @before_label = block
    end

    def after_label(&block)
      @after_label = block
    end

    private

    def view_template(&)
      @content = block_given? ? capture(&) : @label
      render parent_element do
        span(class: "text-center") do
          render @before_label if @before_label.present?
          if @icon
            render ::Decor::Icon.new(name: @icon, variant: @icon_variant, html_options: {class: icon_classes})
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
        *theme_classes,
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

    def theme_classes
      case @theme
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
