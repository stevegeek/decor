# frozen_string_literal: true

module Decor
  module Modals
    class ModalLayout < PhlexComponent
      prop :title, _Nilable(String)
      prop :description, _Nilable(String)
      prop :icon, _Nilable(String)

      # Use unified prop system
      default_size :md  # medium maps to md
      default_color :base
      default_style :filled

      # Modal uses custom size mapping for width classes
      redefine_sizes :sm, :md, :lg, :xl  # small->sm, medium->md, large->lg, extra_large->xl

      # Slot definitions
      def with_header(&block)
        @header = block
      end

      def with_body(&block)
        @body = block
      end

      def with_footer(&block)
        @footer = block
      end

      def view_template
        root_element do
          # Header slot
          if @header
            div(class: "modal-header") do
              render @header
            end
          end

          # Body slot with icon/title/description support
          div(class: "modal-body") do
            if @body
              render @body
            elsif @title || @description
              # Icon/title/description layout
              div(class: "sm:flex sm:items-start") do
                if show_icon?
                  div(class: "mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full #{icon_background_classes} sm:mx-0 sm:h-10 sm:w-10") do
                    render ::Decor::Icon.new(name: @icon, html_options: {class: "h-6 w-6 #{icon_text_classes}"})
                  end
                end
                div(class: "#{show_icon? ? "mt-3 sm:mt-0 sm:ml-4" : ""} text-center sm:text-left") do
                  if @title
                    h3(class: "text-lg leading-6 font-medium") { @title }
                  end
                  if @description.present?
                    div(class: "mt-2") do
                      p(class: "text-sm opacity-70") { @description }
                    end
                  end
                end
              end
            end
            # Content from yield
            yield if block_given? && !@body
          end

          # Footer slot
          if @footer
            div(class: "modal-action") do
              render @footer
            end
          end
        end
      end

      private

      def root_element_classes
        classes = ["modal-box", "relative"]
        classes << size_classes
        classes << style_classes
        classes.compact.join(" ")
      end

      def component_size_classes(size)
        case size
        when :xs then "max-w-sm"   # extra small - new
        when :sm then "max-w-md"   # small -> sm
        when :md then "max-w-2xl"  # medium -> md (default)
        when :lg then "max-w-5xl"  # large -> lg
        when :xl then "max-w-7xl"  # extra_large -> xl
        else "max-w-2xl"
        end
      end

      def component_color_classes(color)
        return "" if @style == :ghost

        case color
        when :primary
          (@style == :outlined) ? "border-primary" : "bg-primary/10"
        when :secondary
          (@style == :outlined) ? "border-secondary" : "bg-secondary/10"
        when :accent
          (@style == :outlined) ? "border-accent" : "bg-accent/10"
        when :info
          (@style == :outlined) ? "border-info" : "bg-info/10"
        when :success
          (@style == :outlined) ? "border-success" : "bg-success/10"
        when :warning
          (@style == :outlined) ? "border-warning" : "bg-warning/10"
        when :error
          (@style == :outlined) ? "border-error" : "bg-error/10"
        when :neutral
          (@style == :outlined) ? "border-neutral" : "bg-neutral/10"
        when :base
          ""
        else
          ""
        end
      end

      def component_style_classes(style)
        case style
        when :outlined
          "border-2"
        when :ghost
          "bg-transparent border-0 shadow-none"
        when :filled
          ""  # Default filled style
        else
          ""
        end
      end

      def show_icon?
        @icon.present?
      end

      def icon_text_classes
        case @color
        when :primary
          "text-primary"
        when :secondary
          "text-secondary"
        when :accent
          "text-accent"
        when :info
          "text-info"
        when :success
          "text-success"
        when :warning
          "text-warning"
        when :error
          "text-error"
        when :neutral
          "text-neutral"
        else
          "text-base-content"
        end
      end

      def icon_background_classes
        case @color
        when :primary
          "bg-primary/20"
        when :secondary
          "bg-secondary/20"
        when :accent
          "bg-accent/20"
        when :info
          "bg-info/20"
        when :success
          "bg-success/20"
        when :warning
          "bg-warning/20"
        when :error
          "bg-error/20"
        when :neutral
          "bg-neutral/20"
        else
          "bg-base-300"
        end
      end
    end
  end
end
