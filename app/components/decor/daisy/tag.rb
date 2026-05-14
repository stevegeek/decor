# frozen_string_literal: true

module Decor
  module Daisy
    # A modern rounded tag/badge component with DaisyUI semantic colors.
    class Tag < ::Decor::Components::Tag
      private

      def root_element_attributes
        {
          element_tag: :span
        }
      end

      def view_template
        root_element do
          # Icon (if present)
          if @icon.present?
            render ::Decor::Daisy::Icon.new(
              name: @icon,
              style: :outline,
              html_options: {
                class: icon_classes
              }
            )
          end

          # Label content
          if block_given?
            yield
          else
            span(class: "decor:whitespace-nowrap") { plain(@label) }
          end

          # Remove button (if removable)
          if @removable
            render_remove_button
          end
        end
      end

      def root_element_classes
        classes = ["decor:inline-flex", "decor:items-center", "decor:justify-center", "decor:rounded-full", "decor:whitespace-nowrap"]
        classes << size_classes
        classes << style_classes
        classes << "decor:gap-2" if @icon.present? || @removable
        classes.compact.join(" ")
      end

      def component_size_classes(size)
        case size
        when :xs then "decor:px-2 decor:py-0.5 decor:text-xs"
        when :sm then "decor:px-2.5 decor:py-0.5 decor:text-sm"
        when :md then "decor:px-3 decor:py-1 decor:text-sm"
        when :lg then "decor:px-4 decor:py-1.5 decor:text-base"
        when :xl then "decor:px-5 decor:py-2 decor:text-lg"
        end
      end

      def icon_classes
        case @size
        when :xs then "decor:w-3 decor:h-3"
        when :sm then "decor:w-3 decor:h-3"
        when :md then "decor:w-4 decor:h-4"
        when :lg then "decor:w-5 decor:h-5"
        when :xl then "decor:w-6 decor:h-6"
        end
      end

      def render_remove_button
        button(
          class: remove_button_classes,
          type: "button"
        ) do
          span(class: "decor:sr-only") { "Remove tag" }
          render ::Decor::Daisy::Icon.new(
            name: "x-mark",
            style: :outline,
            html_options: {
              class: remove_icon_classes
            }
          )
        end
      end

      def remove_button_classes
        # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
        "decor:ml-1 decor:d-btn decor:d-btn-xs decor:d-btn-circle decor:d-btn-ghost #{remove_button_size_classes}"
      end

      def remove_button_size_classes
        case @size
        when :xs then "decor:w-3 decor:h-3"
        else "decor:w-4 decor:h-4"
        end
      end

      def remove_icon_classes
        case @size
        when :xs then "decor:w-2 decor:h-2"
        when :sm then "decor:w-3 decor:h-3"
        when :md then "decor:w-3 decor:h-3"
        when :lg then "decor:w-4 decor:h-4"
        when :xl then "decor:w-5 decor:h-5"
        end
      end
    end
  end
end
