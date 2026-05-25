# frozen_string_literal: true

module Decor
  module Daisy
    class Avatar < ::Decor::Components::Avatar
      def view_template
        root_element do
          classes = "#{color_classes} #{style_classes} #{size_classes} #{shape_class} #{avatar_border_classes}"
          if @url
            div(class: "decor:d-avatar") do
              div(class: classes) do
                image_tag @url, alt: @alt.presence || @initials.presence || t(".image")
              end
            end
          else
            div(class: "decor:d-avatar decor:d-avatar-placeholder") do
              div(class: classes) do
                span(class: text_size_class.to_s) { @initials }
              end
            end
          end

          status_dot if @status

          yield if block_given?
        end
      end

      private

      def root_element_classes
        shape_class
      end

      def shape_class
        case @shape
        when :circle, nil then "decor:rounded-full"
        when :square then "decor:rounded"
        else "decor:rounded-full"
        end
      end

      def component_size_classes(size)
        case size
        when :xs then "decor:w-4"
        when :sm then "decor:w-6"
        when :md then "decor:w-8"
        when :lg then "decor:w-16"
        when :xl then "decor:w-24"
        else "decor:w-10"
        end
      end

      def text_size_class(size = @size)
        text_size = super
        if text_size == "decor:text-xs"
          "decor:text-2xs"
        else
          text_size
        end
      end

      def avatar_border_classes
        return "" unless @border
        return "decor:ring-offset-base-100 decor:ring-2 decor:ring-offset-2" unless @color

        ring_color = case @color
        when :base then "decor:ring-base-300"
        when :primary then "decor:ring-primary"
        when :secondary then "decor:ring-secondary"
        when :accent then "decor:ring-accent"
        when :success then "decor:ring-success"
        when :error then "decor:ring-error"
        when :warning then "decor:ring-warning"
        when :info then "decor:ring-info"
        when :neutral then "decor:ring-neutral"
        else ""
        end

        "#{ring_color} decor:ring-offset-base-100 decor:ring-2 decor:ring-offset-2"
      end

      def status_dot
        span(
          class: "decor:absolute decor:-bottom-px decor:-right-px decor:w-[10px] decor:h-[10px] " \
                 "decor:rounded-full decor:border-2 decor:border-white #{status_dot_color}",
          aria: {label: @status.to_s}
        )
      end

      def status_dot_color
        case @status
        when :online then "decor:bg-success"
        when :away then "decor:bg-warning"
        when :offline then "decor:bg-base-300"
        end
      end
    end
  end
end
