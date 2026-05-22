# frozen_string_literal: true

module Decor
  module Components
    module Forms
      class FormField < ::Decor::Components::Forms::FormChild
        prop :name, _String(_Predicate("present", &:present?))

        prop :label, _Nilable(String)

        # Description line under the label, useful on :left layouts.
        prop :description, _Nilable(String)

        prop :placeholder, _Nilable(String)

        # Not available on button, checkbox & radio.
        prop :autocomplete, _Nilable(String)

        prop :compact, _Boolean, default: false

        prop :value, _Nilable(String) do |v|
          v&.to_s
        end

        prop :required, _Boolean, default: false

        prop :disabled, _Boolean, default: false

        # Temporarily replaced by front-end validation text when invalid.
        prop :helper_text, _Nilable(String)
        prop :collapsing_helper_text, _Boolean, default: false
        prop :floating_error_text, _Boolean, default: false

        prop :hide_required_asterisk, _Boolean, default: false

        prop :valid_label_classes, _Nilable(String)
        prop :invalid_label_classes, _Nilable(String)

        # Stimulus targets/actions applied to the actual form control.
        prop :control_actions, Array, default: -> { [] }
        prop :control_targets, Array, default: -> { [] }
        prop :control_html_options, Hash, default: -> { {} }

        prop :error_messages, _Nilable(Array)
        prop :object, _Nilable(_Any)
        prop :object_name, _Nilable(_Any)
        prop :method_name, _Nilable(_Any)
        prop :type, _Nilable(_Any)

        prop :validations, _Nilable(_Any)
        prop :validation_messages, _Nilable(Hash)

        # Override the Stimulus controller used for this field.
        # Format: "decor/forms/form_control" → decor/forms/form_control_controller.ts
        prop :form_control_controller_path, String, default: "decor/forms/form_control"

        default_size :md
        default_color :primary
        default_style :filled

        private

        def root_element_classes
          [::Decor::Components::Forms::FormField.stimulus_identifier, "decor:w-full", disabled? && "decor:disabled"] + grid_span_class
        end

        def input_classes
          if @control_html_options&.key?(:class)
            produce_style_classes Array.wrap(@control_html_options[:class])
          end
        end

        # Joins a class list into a single string, filtering nil/false values.
        def produce_style_classes(class_names)
          Array.wrap(class_names).compact.reject { |c| c == false }.join(" ")
        end

        def input_container_classes
          label_top? ? "decor:mt-1" : ""
        end

        def control_actions?
          @control_actions.length.positive?
        end

        def control_targets?
          @control_targets.length.positive?
        end

        def form_control_controller
          ::Vident::Stimulus::Naming.stimulize_path(@form_control_controller_path)
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
            input_container_classes: input_container_classes,
            stimulus_classes: {
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

        def resolved_valid_label_classes
          return "decor:text-disabled" if disabled?
          @valid_label_classes || "decor:text-gray-900"
        end

        def resolved_invalid_label_classes
          @invalid_label_classes || "decor:text-error-dark"
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

        def control_data_attributes
          @control_html_options[:data] if @control_html_options&.key?(:data)
        end

        def input_data_attributes(el, target_name: :input)
          {
            **el.stimulus_target(target_name),
            **(control_actions? ? el.stimulus_action(*@control_actions) : {}),
            **(control_targets? ? el.stimulus_target(*@control_targets) : {}),
            **(control_data_attributes || {})
          }
        end

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
end
