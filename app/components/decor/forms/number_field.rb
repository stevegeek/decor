# frozen_string_literal: true

module Decor
  module Forms
    class NumberField < TextField
      # A number field is a input that allows only number values to be entered. However it is essentially a TextField so
      # `value` attribute is actually a string
      prop :type, Symbol, default: :number
      prop :numerical, _Boolean, default: true
      prop :allow_float_input, _Boolean, default: false

      # When dealing with mobile keyboards, we can bring up a numbers-only soft keyboard on iOS
      # by setting a pattern of (exactly) [0-9]*
      # This doesn't however include a decimal point, so if we need float inputs, we must make do with the
      # regular number keyboard (numbers on the top row of the keyboard, symbols elsewhere).
      # Modern Android devices respect the `inputmode` attribute to display the correct keyboard,
      # which is set inside the template view.
      # https://www.filamentgroup.com/lab/type-number.html
      # May want to consider the following in the future: https://github.com/filamentgroup/formcore#numeric-input
      prop :pattern, String, default: -> {
        # TODO: support for locales which use a comma as a decimal point
        # Also, this will only work if the allow_float_input is set before this is called, ie
        # does this enforce an order of props when initializing?
        @allow_float_input ? "[0-9-.]*" : "[0-9]*"
      }

      def control_html_options_classes
        "text-right #{super}"
      end
    end
  end
end
