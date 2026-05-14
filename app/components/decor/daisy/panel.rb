# frozen_string_literal: true

module Decor
  module Daisy
    # Panel A simple panel component for displaying titled content sections,
    # typically used within details boxes or cards. Panels provide a clean way
    # to organize related content with an optional icon and title.
    class Panel < ::Decor::Components::Panel
      def view_template(&)
        root_element do
          render ::Decor::Daisy::Title.new(
            title: @title,
            icon: @icon,
            size: :sm
          )

          div(class: "decor:mt-1.5 decor:text-sm", &)
        end
      end

      private

      def root_element_classes
        classes = ["decor:space-y-2"]
        classes << size_classes
        classes << style_classes
        classes.compact.join(" ")
      end

      def component_size_classes(size)
        case size
        when :xs then "decor:p-2 decor:text-xs"
        when :sm then "decor:p-3 decor:text-sm"
        when :md then "decor:p-4 decor:text-base"
        when :lg then "decor:p-6 decor:text-lg"
        when :xl then "decor:p-8 decor:text-xl"
        else
          ""
        end
      end

      def component_style_classes(style)
        case style
        when :filled
          # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
          "#{filled_color_classes(@color)} decor:rounded-box decor:border decor:border-base-300"
        when :outlined
          # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
          "#{outline_color_classes(@color)} decor:bg-base-100 decor:rounded-box"
        when :ghost
          # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
          "#{ghost_color_classes(@color)} decor:rounded-box"
        else
          ""
        end
      end
    end
  end
end
