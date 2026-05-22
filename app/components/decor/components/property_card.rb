# frozen_string_literal: true

module Decor
  module Components
    class PropertyCard < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :title, String, reader: :public
      prop :accent, _Union(:primary, :success, :warning, :danger, :neutral),
        default: :primary, reader: :public
      prop :layout, _Union(:rows, :grid), default: :grid, reader: :public
      prop :columns, _Union(2, 3, 4), default: 3, reader: :public

      def after_component_initialize
        @properties = []
      end

      # Slot for an optional trailing action (button, link, menu) rendered
      # right-aligned in the title row.
      def with_cta(&block)
        @cta_block = block
        self
      end

      def cta? = @cta_block.present?

      # Append a property pair. Accepts a `value:` kwarg for plain text or
      # a block whose rendered output becomes the value (links, badges, etc.).
      def with_property(label:, value: nil, meta: nil, icon: nil, &block)
        @properties << {label: label, value: value, meta: meta, icon: icon, block: block}
        self
      end
    end
  end
end
