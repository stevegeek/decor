# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for CardHeader. Owns the prop API + slot helpers.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus class-builder overrides for their visual language.
    class CardHeader < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :title, _Nilable(String)
      prop :subtitle, _Nilable(String)
      prop :icon, _Nilable(String)

      default_size :md

      def with_actions(&block)
        @actions_content = block
      end

      def with_meta(&block)
        @meta_content = block
      end
    end
  end
end
