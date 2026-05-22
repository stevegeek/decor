# frozen_string_literal: true

module Decor
  module Components
    class Box < ::Decor::PhlexComponent
      include Decor::Concerns::StyleColorClasses

      no_stimulus_controller

      prop :title, _Nilable(String)
      prop :description, _Nilable(String)

      default_size :md
      default_color :base
      default_style :outlined

      def html_title(&block)
        @html_title = block
      end

      def left(&block)
        @left = block
      end

      def right(&block)
        @right = block
      end

      def right?
        @right.present?
      end
    end
  end
end
