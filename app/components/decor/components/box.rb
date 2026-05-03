# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Box. Owns the prop API + defaults + slot helpers.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus class-builder overrides for their visual language.
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
