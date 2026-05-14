# frozen_string_literal: true

module Decor
  module Daisy
    class Badge < ::Decor::Components::Badge
      private

      def root_element_attributes
        {
          element_tag: :span
        }
      end

      def root_element_classes
        [
          "decor:d-badge",
          component_color_classes(@color),
          component_size_classes(@size),
          component_style_classes(@style),
          dashed_classes
        ].compact.join(" ")
      end

      def view_template(&block)
        root_element do
          if @icon.present?
            render(
              ::Decor::Icon.new(
                name: @icon,
                style: :solid,
                # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
                html_options: {class: "decor:-ml-1 decor:mr-1.5 #{icon_size_classes}"}
              )
            )
          end
          if @url || @initials
            render(
              ::Decor::Daisy::Avatar.new(
                size: avatar_size,
                initials: @initials,
                url: @url,
                html_options: {style: "left: -11px", class: "decor:mr-1 decor:-mt-0.5"}
              )
            )
          end
          if @label
            plain(@label)
          elsif block_given?
            yield
          end
        end
      end

      def component_size_classes(size)
        case size
        when :xs then "decor:d-badge-xs"
        when :sm then "decor:d-badge-sm"
        when :md then [] # default size, no class needed
        when :lg then "decor:d-badge-lg"
        when :xl then "decor:d-badge-xl"
        else []
        end
      end

      def component_color_classes(color)
        case color
        when :base then "decor:d-badge-base"
        when :primary then "decor:d-badge-primary"
        when :secondary then "decor:d-badge-secondary"
        when :accent then "decor:d-badge-accent"
        when :success then "decor:d-badge-success"
        when :error then "decor:d-badge-error"
        when :warning then "decor:d-badge-warning"
        when :info then "decor:d-badge-info"
        when :neutral then "decor:d-badge-neutral"
        else []
        end
      end

      def component_style_classes(style)
        case style
        when :outlined then "decor:d-badge-outline"
        when :filled then [] # default filled, no class needed
        when :ghost then "decor:d-badge-ghost"
        else []
        end
      end

      def dashed_classes
        @dashed ? "decor:border-dashed" : nil
      end

      def icon_size_classes
        case @size
        when :xs
          "decor:h-2.5 decor:w-2.5"
        when :sm
          "decor:h-3 decor:w-3"
        when :md
          "decor:h-3.5 decor:w-3.5"
        when :lg
          "decor:h-4.5 decor:w-4.5"
        when :xl
          "decor:h-5 decor:w-5"
        end
      end

      def avatar_size
        case @size
        when :sm, :xs
          :xs
        when :md, :lg
          :sm
        else
          :md
        end
      end
    end
  end
end
