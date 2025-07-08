# frozen_string_literal: true

module Decor
  class SwitchingBox < Box
    no_stimulus_controller

    prop :switch_options, Hash, default: -> { {} }

    # The property to switch - or use the content block to create the switch
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

      # Set up the left content (title and description)
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

      # Set up the right content block for the Box (only if model is present)
      if @model.present?
        right do
          render(::Decor::Forms::Form.new(model: @model, url: @url, local: true, http_method: @http_method)) do |form_component|
            render(::Decor::Forms::Switch.new(
              model: @model,
              disabled: false,
              property_name: @property_name,
              name: "#{@model.class.name.underscore}[#{@property_name}]",
              submit_on_change: true,
              **@switch_options
            ))
          end
        end
      end
    end
  end
end
