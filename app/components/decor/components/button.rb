# frozen_string_literal: true

module Decor
  module Components
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

      # Render the button in a loading state. Concrete skins decide how to
      # visualise it (e.g. spinner overlay + transparent label text).
      prop :loading, _Boolean, default: false

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
