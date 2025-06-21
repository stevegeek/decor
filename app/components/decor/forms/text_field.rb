# frozen_string_literal: true

module Decor
  module Forms
    class TextField < FormField
      # Optionally specify the HTML size attribute to control the width in characters of the textbox
      attribute :size, Integer

      # Leading or trailing add-ons: text, icon or slot
      attribute :leading_text_add_on, String
      attribute :trailing_text_add_on, String
      attribute :leading_icon_name, String
      attribute :trailing_icon_name, String

      def leading_add_on(&block)
        @leading_add_on = block
      end

      def trailing_add_on(&block)
        @trailing_add_on = block
      end

      # The attached on-adds can either appear as text, or boxed in a gray container
      attribute :add_on_style, Symbol, in: %i[text boxed], default: :text

      # Allows one to change the type of input. However normally you should use the specific ViewComponent (eg
      # NumberField or PasswordField)
      attribute :type, Symbol, default: :text

      # A pattern to test against (a JavaScript Regex in a string)
      attribute :pattern, String

      # HTML inputmode attribute
      attribute :inputmode, String

      # A numerical text field is a text field which only accepts numbers
      attribute :numerical, :boolean, default: false

      # The min and max length HTML5 attributes are set with the following
      attribute :maximum_length, Integer
      attribute :minimum_length, Integer

      # If set this will apply validation that value is same as value in field with ID
      attribute :validate_value_equal_to_id, String

      # Attributes for text fields of type 'number'
      attribute :min, Numeric
      attribute :max, Numeric
      attribute :step, Numeric
      attribute :greater_than, Numeric
      attribute :less_than, Numeric

      def view_template
        render parent_element do |el|
          layout = ::Decor::Forms::FormFieldLayout.new(
            **form_field_layout_options(el),
            named_classes: {
              valid_label: @disabled ? "text-disabled" : "text-gray-900",
              invalid_label: "text-error-dark"
            }
          )

          layout.helper_text_section do
            render ::Decor::Forms::HelperTextSection.new(
              helper_text: @helper_text,
              error_text: error_text,
              disabled: @disabled,
              error_section: !floating_error_text?,
              collapsing_helper_text: @collapsing_helper_text
            )
          end
          
          render layout do
            if has_any_add_on?
              label(class: input_classes) do
                render_leading_add_on(el) if has_leading_add_on?
                
                input(
                  data_hj_whitelist: true,
                  data_controller: form_control_controller,
                  class: daisyui_input_classes,
                  **html_attributes,
                  data: {
                    **target_data_attributes(el, :input),
                    **(control_actions? ? action_data_attributes(el, control_actions) : {}),
                    **(control_targets? ? target_data_attributes(el, *control_targets) : {}),
                    **(control_data_attributes || {})
                  }
                )
                
                render_trailing_add_on(el) if has_trailing_add_on?
              end
            else
              input(
                data_hj_whitelist: true,
                data_controller: form_control_controller,
                class: input_classes + " " + daisyui_input_classes,
                **html_attributes,
                data: input_data_attributes(el)
              )
            end

            render ::Decor::Forms::ErrorIconSection.new(
              error_text: error_text,
              show_floating_message: floating_error_text?,
              html_options: {
                class: "#{errors? ? "" : "hidden"} #{number_field? ? "right-7" : "right-3"}"
              }
            )
          end
        end
      end

      private

      def root_element_attributes
        {
          named_classes: {
            invalid_input: "invalid:border-error-dark"
          }
        }
      end

      def html_attributes
        attrs = {
          id: "#{id}-control",
          type: @type,
          name: @name,
          value: @value
        }
        attrs[:required] = nil if @required
        attrs[:disabled] = nil if @disabled
        attrs[:size] = @size if @size
        attrs[:minlength] = @minimum_length if @minimum_length
        attrs[:maxlength] = @maximum_length if @maximum_length
        attrs[:pattern] = resolved_pattern if @pattern
        attrs[:inputmode] = @inputmode if @inputmode
        attrs[:autocomplete] = @autocomplete if @autocomplete
        if @placeholder || (@label_inside && @label)
          attrs[:placeholder] = @placeholder || label_with_required
        end
        if number_field?
          attrs[:max] = @max if @max
          attrs[:min] = @min if @min
          attrs[:step] = @step if @step
          attrs[:"data-form-control-validate-gt-value"] = @greater_than if @greater_than.present?
          attrs[:"data-form-control-validate-lt-value"] = @less_than if @less_than.present?
        end
        attrs[:"data-form-control-validate-type-value"] = "number" if @numerical
        attrs[:"data-form-control-validate-equal-to-value"] = @validate_value_equal_to_id if @validate_value_equal_to_id
        attrs
      end

      def has_leading_add_on?
        @leading_add_on.present? || @leading_text_add_on.present? || @leading_icon_name.present?
      end

      def has_trailing_add_on?
        @trailing_add_on.present? || @trailing_text_add_on.present? || @trailing_icon_name.present?
      end

      def has_any_add_on?
        has_leading_add_on? || has_trailing_add_on?
      end

      # On label or input itself if no label
      def input_classes
        classes = ["input"]
        classes << "validator" if @required || @pattern.present? || @minimum_length.present? || @maximum_length.present?
        classes.join(" ")
      end

      # Classes for the input
      def daisyui_input_classes
        classes = []
        classes << (@size ? "" : "w-full")
        classes << (@numerical && @type == :tel ? "tabular-nums" : "")
        classes.join(" ").strip
      end

      def render_leading_add_on(el)
        if @leading_add_on.present?
          render @leading_add_on
        elsif @leading_icon_name.present?
          render ::Decor::Icon.new(name: @leading_icon_name, html_options: {class: "h-[1em] opacity-50"})
        elsif @leading_text_add_on.present?
          span(
            class: "opacity-50",
            **target_data_attributes(el, :leading_text_add_on)
          ) do
            @leading_text_add_on
          end
        end
      end

      def render_trailing_add_on(el)
        if @trailing_add_on.present?
          render @trailing_add_on
        elsif @trailing_icon_name.present?
          render ::Decor::Icon.new(name: @trailing_icon_name, html_options: {class: "h-[1em] opacity-50"})
        elsif @trailing_text_add_on.present?
          span(
            class: "opacity-50",
            data: {**target_data_attributes(el, :trailing_text_add_on)}
          ) do
            @trailing_text_add_on
          end
        end
      end

      def resolved_pattern
        if @pattern.is_a?(Proc)
          @pattern.call(self)
        else
          @pattern
        end
      end

      def number_field?
        @type == :number
      end
    end
  end
end
