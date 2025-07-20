# frozen_string_literal: true

module Decor
  module Forms
    class FormChild < PhlexComponent
      # Labels are either on top, or off to the left of the input on anything wider than a phone. The
      # label can sometimes be 'inside' too, on textfields and select boxes. Checkbox and radios can also have
      # the label on the right.
      prop :label_position, _Union(:top, :left, :right, :inline, :inside), default: :top

      # The layout of the form field, if in a grid (eg FormSection/Container)
      prop :grid_span, _Nilable(_Union(:span_1, :span_2, :span_half, :span_4, :span_5, :span_full))

      private

      def grid_span_class
        case @grid_span
        when :span_1
          ["sm:col-span-2 lg:col-span-1"]
        when :span_2
          ["sm:col-span-4 lg:col-span-2"]
        when :span_half
          ["sm:col-span-6 lg:col-span-3"]
        when :span_4
          ["sm:col-span-6 lg:col-span-4"]
        when :span_5
          ["sm:col-span-6 lg:col-span-5"]
        when :span_full
          ["sm:col-span-6 lg:col-span-6"]
        else
          []
        end
      end

      def label_left?
        @label_position == :left
      end

      def label_right?
        @label_position == :right
      end

      def label_inline?
        @label_position == :inline
      end

      def label_inside?
        @label_position == :inside
      end

      def label_top?
        @label_position == :top
      end
    end
  end
end
