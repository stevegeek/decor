# frozen_string_literal: true

module Decor
  class CodeSnippet < PhlexComponent
    prop :variant, _Union(:default, :primary, :secondary, :accent), default: :default
    prop :size, _Union(:xs, :sm, :normal, :lg), default: :normal

    private

    def view_template(&)
      code(class: element_classes) do
        yield if block_given?
      end
    end

    def element_classes
      [
        # Base styles
        "px-2 py-1 rounded font-mono",
        # Size classes
        size_classes,
        # Variant classes
        variant_classes
      ].compact.join(" ")
    end

    def size_classes
      case @size
      when :xs
        "text-xs"
      when :sm
        "text-sm"
      when :lg
        "text-lg"
      else
        "text-base"
      end
    end

    def variant_classes
      case @variant
      when :primary
        "bg-primary/20 text-primary"
      when :secondary
        "bg-secondary/20 text-secondary"
      when :accent
        "bg-accent/20 text-accent"
      else
        "bg-base-200 text-base-content"
      end
    end
  end
end
