# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for SwitchingBox. Extends Components::Box for its prop API
    # and adds switch-specific props + the initializer that wires up the left
    # title/description block and the right form+switch block.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template` via a
    # mixin (e.g. Decor::Daisy::BoxTemplate) for their visual language.
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

      def initialize(**attributes)
        super

        left do
          if @title.present?
            h2(class: "card-title") do
              plain(@title)
            end
          end

          if @description.present?
            p(class: "text-base-content/70") do
              plain(@description)
            end
          end
        end

        if @model.present?
          right do
            render(::Decor::Daisy::Forms::Form.new(model: @model, url: @url, local: true, http_method: @http_method)) do |form_component|
              render(::Decor::Daisy::Forms::Switch.new(
                disabled: false,
                name: "#{@model.class.name.underscore}[#{@property_name}]",
                checked: @model.public_send(@property_name),
                submit_on_change: true,
                **@switch_options
              ))
            end
          end
        end
      end
    end
  end
end
