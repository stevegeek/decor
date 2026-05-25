# frozen_string_literal: true

module Decor
  module Components
    module Forms
      class NumberField < ::Decor::Components::Forms::TextField
        # A number field is a input that allows only number values to be entered. However it is essentially a TextField so
        # `value` attribute is actually a string
        prop :type, Symbol, default: :number
        prop :numerical, _Boolean, default: true
        prop :allow_float_input, _Boolean, default: false, reader: :public

        def allow_float_input?
          @allow_float_input
        end

        # When dealing with mobile keyboards, we can bring up a numbers-only soft keyboard on iOS
        # by setting a pattern of (exactly) [0-9]*
        # This doesn't however include a decimal point, so if we need float inputs, we must make do with the
        # regular number keyboard (numbers on the top row of the keyboard, symbols elsewhere).
        # Modern Android devices respect the `inputmode` attribute to display the correct keyboard,
        # which is set inside the template view.
        # https://www.filamentgroup.com/lab/type-number.html
        # May want to consider the following in the future: https://github.com/filamentgroup/formcore#numeric-input
        # Stored as a Proc so the pattern resolves at render time via resolved_pattern — Literal
        # otherwise evaluates default lambdas in prop-declaration order at init time, which races
        # with @allow_float_input being assigned.
        # TODO: support for locales which use a comma as a decimal point
        prop :pattern, _Nilable(_Any), default: -> {
          ->(instance) { instance.allow_float_input? ? "[0-9-.]*" : "[0-9]*" }
        }, reader: :public
      end
    end
  end
end
