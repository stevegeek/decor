module Decor
  class Toggle < PhlexComponent
    no_stimulus_controller

    attribute :switch_options, Hash, default: {}
    attribute :checked_value, String, default: "true", allow_nil: false
    attribute :unchecked_value, String, default: "false", allow_nil: false

    # The property to toggle - or use the content block to create the toggle
    attribute :property_name
    attribute :model
    attribute :url
    attribute :http_method, default: :patch

    def view_template(&block)
      render parent_element do
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
