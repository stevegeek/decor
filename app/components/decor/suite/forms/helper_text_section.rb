# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      # Suite HelperTextSection — caption row that sits beneath a form control
      # and shows either helper text (muted gray) or error text (suite-danger).
      # Only one is visible at a time: the error_text wins when present, and
      # the helper line is hidden via `decor:hidden` rather than removed so
      # the Stimulus controller can swap visibility client-side without
      # rerendering.
      #
      # Typography uses density-aware `suite-field-help` so flipping
      # `<body class="density-relaxed">` recomputes the caption size.
      class HelperTextSection < ::Decor::Components::Forms::HelperTextSection
        def view_template
          root_element do |el|
            p(
              class: helper_classes,
              data: helper_text_target_data(el)
            ) do
              plain @helper_text if @helper_text.present?
            end

            if @error_section
              p(
                class: error_classes,
                data: error_text_target_data(el)
              ) do
                plain @error_text if @error_text.present?
              end
            end
          end
        end

        private

        def helper_classes
          [
            "decor:suite-field-help",
            (@helper_text.present? && @error_text.blank?) ? nil : "decor:hidden",
            @collapsing_helper_text ? nil : "decor:mt-2",
            @disabled ? "decor:text-gray-400" : "decor:text-gray-500"
          ].compact.join(" ")
        end

        def error_classes
          [
            "decor:suite-field-help decor:text-suite-danger-500",
            @error_text.present? ? nil : "decor:hidden",
            @collapsing_helper_text ? nil : "decor:mt-2"
          ].compact.join(" ")
        end

        def helper_text_target_data(el)
          el.stimulus_target(:helper_text).to_h
        end

        def error_text_target_data(el)
          el.stimulus_target(:error_text).to_h
        end

        def root_element_classes
          @collapsing_helper_text ? "decor:relative" : "decor:relative decor:mt-1"
        end
      end
    end
  end
end
