# frozen_string_literal: true

module Decor
  module Components
    module Forms
      # Abstract base for TextField. Owns the prop API + add-on slot helpers
      # + the stimulus block + the html_attributes builder (skin-agnostic).
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus the daisy-specific CSS class builders.
      class TextField < ::Decor::Components::Forms::FormField
        # Optionally specify the HTML size attribute to control the width in characters of the textbox
        prop :html_size, _Nilable(Integer)

        # Leading or trailing add-ons: text, icon or slot
        prop :leading_text_add_on, _Nilable(String)
        prop :trailing_text_add_on, _Nilable(String)
        prop :leading_icon_name, _Nilable(String)
        prop :trailing_icon_name, _Nilable(String)

        def leading_add_on(&block)
          @leading_add_on = block
        end

        def trailing_add_on(&block)
          @trailing_add_on = block
        end

        # The attached on-adds can either appear as text, or boxed in a gray container
        prop :add_on_style, _Union(:text, :boxed), default: :text

        # Allows one to change the type of input. However normally you should use the specific ViewComponent (eg
        # NumberField or PasswordField)
        prop :type, Symbol, default: :text

        # A pattern to test against (a JavaScript Regex in a string)
        prop :pattern, _Nilable(String)

        # HTML inputmode attribute
        prop :inputmode, _Nilable(String)

        # A numerical text field is a text field which only accepts numbers
        prop :numerical, _Boolean, default: false

        # The min and max length HTML5 attributes are set with the following
        prop :maximum_length, _Nilable(Integer)
        prop :minimum_length, _Nilable(Integer)

        # If set this will apply validation that value is same as value in field with ID
        prop :validate_value_equal_to_id, _Nilable(String)

        # Attributes for text fields of type 'number'
        prop :min, _Nilable(Numeric)
        prop :max, _Nilable(Numeric)
        prop :step, _Nilable(Numeric)
        prop :greater_than, _Nilable(Numeric)
        prop :less_than, _Nilable(Numeric)

        stimulus do
          classes invalid_input: "invalid:border-error-dark"
        end

        private

        def html_attributes
          attrs = {
            id: "#{id}-control",
            type: @type,
            name: @name,
            value: @value
          }
          attrs[:required] = true if @required
          attrs[:disabled] = true if @disabled
          attrs[:size] = @html_size if @html_size
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
end
