# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Button. Owns the prop API + defaults + slot helpers.
    # Concrete skins (Daisy, Suite) inherit and provide their `view_template`
    # plus `root_element_classes` / `component_*_classes` overrides for their
    # visual language.
    #
    # The view_template body is shared with Link and ButtonLink, so it lives
    # in the Decor::Daisy::ButtonTemplate mixin rather than on Daisy::Button
    # directly.
    class Button < ::Decor::PhlexComponent
      redefine_styles :filled, :outlined, :ghost, :soft

      default_size :md
      default_color :base
      default_style :filled

      prop :label, _Nilable(String)

      # An icon name to render before the label
      prop :icon, _Nilable(String)
      prop :icon_variant, _Nilable(Symbol)
      prop :icon_only_on_mobile, _Boolean, default: false

      prop :disabled, _Boolean, default: false

      # Whether button should span the entire width of the container or not
      prop :full_width, _Boolean, default: false

      def before_label(&block)
        @before_label = block
      end

      def with_before_label(&block)
        @before_label = block
        self
      end

      def after_label(&block)
        @after_label = block
      end

      def with_after_label(&block)
        @after_label = block
        self
      end
    end
  end
end
