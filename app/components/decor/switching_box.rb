# frozen_string_literal: true

module Decor
  class SwitchingBox < Box
    no_stimulus_controller

    attribute :switch_options, Hash, default: {}

    # The property to switch - or use the content block to create the switch
    attribute :property_name, Symbol, allow_nil: false
    attribute :model
    attribute :url
    attribute :http_method, default: :patch

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

      # Set up the right content block for the Box
      right do
        render(::Decor::Forms::Form.new(model: @model, url: @url, local: true, http_method: @http_method)) do |form_component|
          render(::Decor::Forms::Switch.new(
            model: @model,
            disabled: @model.nil?,
            property_name: @property_name,
            name: @model ? "#{@model.class.name.underscore}[#{@property_name}]" : @property_name.to_s,
            submit_on_change: true,
            **@switch_options
          ))
        end
      end
    end
  end
end
