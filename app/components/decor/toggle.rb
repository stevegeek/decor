# frozen_string_literal: true

module Decor
  class Toggle < PhlexComponent
    no_stimulus_controller

    prop :switch_options, Hash, default: -> { {} }
    prop :checked_value, String, default: "true"
    prop :unchecked_value, String, default: "false"

    # The property to toggle - or use the content block to create the toggle
    prop :property_name, _Nilable(_Interface(:to_s))
    prop :model, _Nilable(Object)
    prop :url, _Nilable(_Interface(:to_s))
    prop :http_method, Symbol, default: :patch

    def view_template(&block)
      root_element do
        render ::Decor::Forms::Form.new(model: @model, url: @url, local: false, http_method: @http_method) do |form_component|
          if block_given?
            capture(&block)
          else
            render(::Decor::Forms::Switch.new(
              model: @model,
              property_name: @property_name,
              name: @model ? "#{@model.class.name.underscore}[#{@property_name}]" : @property_name.to_s,
              submit_on_change: true,
              checked_value: @checked_value,
              unchecked_value: @unchecked_value,
              **@switch_options
            ))
          end
        end
      end
    end
  end
end
