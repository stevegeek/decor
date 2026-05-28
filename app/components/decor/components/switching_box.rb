# frozen_string_literal: true

module Decor
  module Components
    class SwitchingBox < ::Decor::Components::Box
      no_stimulus_controller

      prop :switch_options, Hash, default: -> { {} }

      prop :property_name, _Nilable(Symbol)
      prop :model, _Nilable(Object)
      prop :url, _Nilable(String)
      prop :http_method, Symbol, default: :patch

      attr_reader :model
      attr_reader :url
      attr_reader :property_name

      def with_left(&block)
        left(&block)
        self
      end

      # Wires the right form+switch slot after props are assigned. Using
      # `after_component_initialize` (Vident hook) instead of overriding
      # `def initialize`, because each subclass that adds a `prop` regenerates
      # its own `initialize`, which would shadow a parent-defined one and
      # silently drop the slot wiring.
      def after_component_initialize
        super if defined?(super)

        return unless @model.present?

        switch_kwargs = {
          disabled: false,
          # Match ActionView's field_id (model_property) so the rendered input
          # id is "<model>_<property>-control" rather than a random Vident id.
          id: "#{@model.class.name.underscore}_#{@property_name}",
          name: "#{@model.class.name.underscore}[#{@property_name}]",
          submit_on_change: true,
          **@switch_options
        }
        switch_kwargs[:checked] = @model.public_send(@property_name) unless switch_kwargs.key?(:checked)

        right do
          render(::Decor::Daisy::Forms::Form.new(model: @model, url: @url, local: true, http_method: @http_method)) do |form_component|
            render(::Decor::Daisy::Forms::Switch.new(**switch_kwargs))
          end
        end
      end
    end
  end
end
