# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for PropertyStrip — an inline horizontal strip of
    # label/value pairs in a responsive auto-fit grid. Compact admin
    # presentation for record summaries / header metadata.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus class-builder overrides for their visual language.
    class PropertyStrip < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :title, _Nilable(String)
      prop :subtitle, _Nilable(String)
      prop :min_column_width, Integer, default: 140

      def after_component_initialize
        @properties = []
      end

      # Append a property pair to the strip. Accepts either a `value:` kwarg
      # for plain text or a block whose rendered output is treated as the
      # property value (so callers can embed links, badges, etc.).
      def with_property(label:, value: nil, meta: nil, icon: nil, &block)
        @properties << {label: label, value: value, meta: meta, icon: icon, block: block}
        self
      end
    end
  end
end
