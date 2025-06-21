# frozen_string_literal: true

module Decor
  module Forms
    class FormField < FormChild
      # The name attribute of the form field
      attribute :name, String, allow_blank: false

      # If the label is not set, no label will be rendered
      attribute :label, String

      # Optional description line under the label, useful on :left layouts
      attribute :description, String

      # Optional placeholder used when there is no value/label inside
      attribute :placeholder, String

      # Hint for form autofill feature (note not available on button, checkbox & radio)
      attribute :autocomplete, String

      # Compact style
      attribute :compact, :boolean, default: false

      # The value of the form field
      attribute :value, String, convert: true

      # Whether the field is required or not
      attribute :required, :boolean, default: false

      # If the field is disabled
      attribute :disabled, :boolean, default: false

      # Specify some helper text, this will temporarily disappear when validation text from the front end overrides it
      attribute :helper_text, String
      attribute :collapsing_helper_text, :boolean, default: false
      attribute :floating_error_text, :boolean, default: false

      # Whether to hide the asterisk that is displayed after a label for a required field or not
      attribute :hide_required_asterisk, :boolean, default: false

      # Additional style classes for label, passed to FormFieldLayout
      attribute :valid_label_classes, String
      attribute :invalid_label_classes, String

      # Allows stimulus targets and actions to be set on the actual form control
      attribute :control_actions, Array, default: []
      attribute :control_targets, Array, default: []
      # Additional HTML classes to add to control
      attribute :control_html_options, Hash, default: {}

      # Internals
      attribute :error_messages, Array, delegates: false
      attribute :object, :any, delegates: false
      attribute :object_name, :any, delegates: false
      attribute :method_name, :any, delegates: false
      attribute :type, :any, delegates: false

      # Optional messages for component validations
      attribute :validations, :any, delegates: false
      attribute :validation_messages, Hash, delegates: false

      # To override the Stimulus controller used for this field.
      # Format: "decor/forms/form_control" (which represents decor/forms/form_control_controller.ts)
      attribute :form_control_controller_path, String, default: "decor/forms/form_control"

      private

      def control_actions?
        @control_actions.length.positive?
      end

      def control_targets?
        @control_targets.length.positive?
      end

      def form_control_controller
        stimulus_identifier_from_path(@form_control_controller_path)
      end

      def form_field_layout_options(field_element)
        {
          field_id: id,
          form_field_element: field_element,
          label: label_with_required,
          description: @description,
          disabled: disabled?,
          label_position: @label_position,
          grid_span: @grid_span,
          input_container_classes: @input_container_classes,
          named_classes: {
            valid_label: resolved_valid_label_classes,
            invalid_label: resolved_invalid_label_classes
          }
        }
      end

      def disabled?
        @disabled
      end

      def required?
        @required
      end

      def floating_error_text?
        @floating_error_text
      end

      def element_classes
        [::Decor::Forms::FormField.stimulus_identifier, "w-full", disabled? && "disabled"] + grid_span_class
      end

      def input_classes
        if @control_html_options&.key?(:class)
          produce_style_classes Array.wrap(@control_html_options[:class])
        end
      end

      def resolved_valid_label_classes
        return "text-disabled" if disabled?
        @valid_label_classes || "text-gray-900"
      end

      def resolved_invalid_label_classes
        @invalid_label_classes || "text-error-dark"
      end

      def input_container_classes
        label_top? ? "mt-1" : ""
      end

      def label_with_required
        return if @label.blank?
        (required? && !@hide_required_asterisk) ? "#{@label} *" : @label
      end

      def error_text
        @error_messages.present? ? @error_messages.join(", ") : ""
      end

      def errors?
        error_text.present?
      end

      def validation_messages_data_map
        (@validation_messages || {}).transform_keys { |key| "validation_message_#{key}" }
      end

      # Additional control data attrs
      def render_control_data_attrs
        @control_html_options[:data]&.map { |key, value| "data-#{key.to_s.dasherize}=\"#{value}\"" }&.join(" ")
      end

      # Form fields have extra stimulus attributes
      def stimulus_options_for_root_component
        options = super
        options[:actions] ||= []
        options[:actions] << [:"#{form_control_controller}:validated", :handle_control_validated_event]
        options[:values] ||= []
        options[:values] << validation_messages_data_map if validation_messages_data_map.present?
        options[:values] << {label: @label || "field"}
        options
      end
    end
  end
end
