# frozen_string_literal: true

module Decor
  class Button < PhlexComponent
    # Eg to render an icon before
    slot :before_label

    # Eg to render an icon after the label
    slot :after_label

    attribute :label, String

    # An icon name to render before the label
    attribute :icon, String
    attribute :icon_variant, Symbol
    attribute :icon_only_on_mobile, :boolean, default: false

    # Button variant.
    attribute :variant, Symbol, default: :contained, in: %i[contained outlined text]

    # Theme
    attribute :theme, Symbol, default: :primary, in: %i[primary secondary danger warning neutral]

    # Size
    attribute :size, Symbol, default: :medium, in: %i[large medium wide small micro]

    # Whether button is disabled or not
    attribute :disabled, :boolean, default: false

    # Whether button should span the entire width of the container or not
    attribute :full_width, :boolean, default: false

    private

    def view_template
      render parent_element do
        span(class: "text-center") do
          render before_label_slot if before_label_slot.present?
          if @icon
            render ::Decor::Icon.new(name: @icon, variant: @icon_variant, html_options: {class: icon_classes})
          end
          span(class: @icon_only_on_mobile ? "hidden md:inline" : "") do
            block_given? ? yield : @label
          end
          render after_label_slot if after_label_slot.present?
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
        when :large
          "size-8 pr-2"
        when :medium, :wide
          "size-6 pr-1"
        when :small
          "size-5.5 pr-1"
        when :micro
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
      when :large
        ["btn-lg"]
      when :small
        ["btn-sm"]
      when :micro
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
