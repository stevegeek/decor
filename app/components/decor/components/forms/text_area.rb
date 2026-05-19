# frozen_string_literal: true

module Decor
  module Components
    module Forms
      # Abstract base for TextArea. Owns the prop API + stimulus block +
      # html_attributes builder. Concrete skins (Daisy, Suite) inherit and
      # provide `view_template` plus the daisy-specific class builders.
      class TextArea < ::Decor::Components::Forms::FormField
        # HTML textarea size attributes by character rows and columns
        prop :rows, Integer, default: 5
        prop :cols, _Nilable(Integer)

        # A pattern to test against (a JavaScript Regex in a string)
        prop :pattern, _Nilable(String)

        # The min and max length HTML5 attributes are set with the following
        prop :maximum_length, _Nilable(Integer)
        prop :minimum_length, _Nilable(Integer)

        stimulus do
          classes invalid_input: "invalid:border-error-dark"
        end

        private

        def html_attributes
          attrs = {
            id: "#{id}-control",
            name: @name
          }
          attrs[:rows] = @rows if @rows
          attrs[:cols] = @cols if @cols
          attrs[:disabled] = true if @disabled
          attrs[:required] = true if @required
          attrs[:minlength] = @minimum_length if @minimum_length
          attrs[:maxlength] = @maximum_length if @maximum_length
          attrs[:pattern] = resolved_pattern if @pattern
          attrs[:autocomplete] = @autocomplete if @autocomplete
          if @placeholder || (label_inside? && @label.present?)
            attrs[:placeholder] = @placeholder || label_with_required
          end
          attrs
        end

        def resolved_pattern
          if @pattern.is_a?(Proc)
            @pattern.call(self)
          else
            @pattern
          end
        end
      end
    end
  end
end
