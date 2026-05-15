# frozen_string_literal: true

module Decor
  module Suite
    # Suite skin of ClickToCopy. Preserves Confinus' two-variant API
    # (:chip with bordered styling, :inline bare). Confinus brand tokens
    # are replaced with generic Tailwind utilities.
    class ClickToCopy < ::Decor::Components::ClickToCopy
      prop :variant, _Union(:chip, :inline), default: :chip
      prop :tag_name, Symbol, default: :span

      def view_template(&)
        @content = capture(&) if block_given?
        root_element do
          child_element(:span, stimulus_target: :content) do
            raw safe(@content) if @content.present?
          end
          render ::Decor::Icon.new(
            name: "copy", width: 12, height: 12,
            classes: icon_classes
          )
        end
      end

      private

      def root_element_attributes
        { element_tag: @tag_name }
      end

      def root_element_classes
        case @variant
        when :inline
          "decor:group decor:inline-flex decor:items-center decor:gap-1.5 " \
            "decor:cursor-pointer decor:suite-description decor:font-tabular-nums " \
            "decor:hover:text-suite-primary-700 decor:transition-colors " \
            "decor:duration-suite-fast decor:ease-out"
        else
          "decor:group decor:inline-flex decor:items-center decor:gap-2 " \
            "decor:pl-3 decor:pr-2.5 decor:py-[5px] decor:bg-suite-gray-25 " \
            "decor:border decor:border-suite-hairline-strong decor:rounded-suite-control " \
            "decor:suite-dense-body decor:font-mono decor:font-medium " \
            "decor:cursor-pointer decor:transition-all decor:duration-suite-fast decor:ease-out " \
            "decor:hover:bg-white decor:hover:border-gray-400 decor:hover:text-gray-900"
        end
      end

      def icon_classes
        case @variant
        when :inline
          "decor:w-3 decor:h-3 decor:opacity-50 decor:transition-opacity " \
            "decor:duration-suite-fast decor:ease-out decor:group-hover:opacity-100 " \
            "decor:group-hover:text-suite-primary-600"
        else
          "decor:w-3 decor:h-3 decor:text-gray-400 decor:transition-colors " \
            "decor:duration-suite-fast decor:ease-out decor:group-hover:text-suite-primary-600"
        end
      end
    end
  end
end
