# frozen_string_literal: true

module Decor
  module Daisy
    class Toggle < ::Decor::Components::Toggle
      def view_template(&block)
        root_element do
          render ::Decor::Forms::Form.new(model: @model, url: @url, local: false, http_method: @http_method) do |form_component|
            if block_given?
              capture(&block)
            else
              render(::Decor::Forms::Switch.new(
                name: @model ? "#{@model.class.name.underscore}[#{@property_name}]" : @property_name.to_s,
                checked: @model ? @model.public_send(@property_name) : false,
                value: @checked_value,
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
