# frozen_string_literal: true

module Decor
  module Daisy
    class Avatar < ::Decor::Components::Avatar
      def view_template
        root_element do
          # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
          classes = "#{color_classes} #{style_classes} #{size_classes} #{shape_class} #{avatar_ring_classes}"
          if @url
            div(class: "decor:d-avatar") do
              div(class: classes) do
                image_tag @url, alt: t(".image")
              end
            end
          else
            div(class: "decor:d-avatar decor:d-avatar-placeholder") do
              div(class: classes) do
                span(class: text_size_class.to_s) { @initials }
              end
            end
          end

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
        if text_size == "text-xs"
          "decor:text-2xs"
        else
          text_size
        end
      end

      def avatar_ring_classes
        return "" unless @ring
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

        # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
        "#{ring_color} decor:ring-offset-base-100 decor:ring-2 decor:ring-offset-2"
      end
    end
  end
end
