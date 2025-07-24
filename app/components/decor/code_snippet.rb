# frozen_string_literal: true

module Decor
  class CodeSnippet < PhlexComponent
    default_size :md
    default_color :base
    default_style :filled

    private

    def view_template(&)
      code(class: root_element_classes) do
        yield if block_given?
      end
    end

    def root_element_classes
      [
        # Base styles
        "px-2 py-1 rounded font-mono",
        # Use unified system
        size_classes,
        # Apply color classes if color is specified, otherwise use style classes
        (@color && @color != :base) ? component_color_classes(@color) : style_classes
      ].compact.join(" ")
    end

    def component_size_classes(size)
      case size
      when :xs then "text-xs"
      when :sm then "text-sm"
      when :md then "text-base"
      when :lg then "text-lg"
      when :xl then "text-xl"
      else "text-base"
      end
    end

    def component_style_classes(style)
      case style
      when :filled then "bg-base-200 text-base-content"  # Default filled style
      when :outlined then "border border-base-300 text-base-content bg-transparent"
      when :ghost then "text-base-content bg-transparent"
      else "bg-base-200 text-base-content"
      end
    end

    def component_color_classes(color)
      # Color affects the background/text combination for code snippets
      case color
      when :primary then "bg-primary/20 text-primary"
      when :secondary then "bg-secondary/20 text-secondary"
      when :accent then "bg-accent/20 text-accent"
      when :success then "bg-success/20 text-success"
      when :error then "bg-error/20 text-error"
      when :warning then "bg-warning/20 text-warning"
      when :info then "bg-info/20 text-info"
      else ""  # Base color handled by style
      end
    end
  end
end
