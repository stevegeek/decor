# frozen_string_literal: true

module Decor
  module Modals
    class ModalLayout < PhlexComponent
      attribute :title, String
      attribute :description, String
      attribute :icon, String

      # Standard attributes following Button/Notification patterns
      attribute :color, Symbol, default: :base, in: [:base, :primary, :secondary, :accent, :info, :success, :warning, :error, :neutral]
      attribute :variant, Symbol, default: :filled, in: [:filled, :outlined, :ghost]
      attribute :size, Symbol, default: :medium, in: [:small, :medium, :large, :extra_large]

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
        render parent_element do
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

      def element_classes
        classes = ["modal-box", "relative"]
        classes << size_classes
        classes << color_classes
        classes << variant_classes
        classes.compact.join(" ")
      end

      def size_classes
        case @size
        when :small
          "max-w-md"
        when :large
          "max-w-5xl"
        when :extra_large
          "max-w-7xl"
        else # :medium
          "max-w-2xl"
        end
      end

      def color_classes
        return "" if @variant == :ghost

        case @color
        when :primary
          (@variant == :outlined) ? "border-primary" : "bg-primary/10"
        when :secondary
          (@variant == :outlined) ? "border-secondary" : "bg-secondary/10"
        when :accent
          (@variant == :outlined) ? "border-accent" : "bg-accent/10"
        when :info
          (@variant == :outlined) ? "border-info" : "bg-info/10"
        when :success
          (@variant == :outlined) ? "border-success" : "bg-success/10"
        when :warning
          (@variant == :outlined) ? "border-warning" : "bg-warning/10"
        when :error
          (@variant == :outlined) ? "border-error" : "bg-error/10"
        when :neutral
          (@variant == :outlined) ? "border-neutral" : "bg-neutral/10"
        else # :base
          ""
        end
      end

      def variant_classes
        case @variant
        when :outlined
          "border-2"
        when :ghost
          "bg-transparent border-0 shadow-none"
        else # :filled
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
