# frozen_string_literal: true

module Decor
  module Components
    class CodeBlock < ::Decor::PhlexComponent
      prop :language, _Nilable(String)
      prop :highlight, _Boolean, default: false
      prop :show_line_numbers, _Boolean, default: false
      prop :highlight_lines, _Nilable(Array), default: [].freeze
      prop :filename, _Nilable(String)
      prop :copy_button, _Boolean, default: false

      # CodeBlock uses domain-specific styles for presentation modes
      default_style :default
      redefine_styles :default, :terminal

      stimulus do
        values_from_props :language, :highlight
      end

      private

      def highlight_line?(line_number)
        @highlight_lines.include?(line_number)
      end
    end
  end
end
