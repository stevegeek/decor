# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      # Daisy skin for FormField. Still abstract — concrete input subclasses
      # (TextField, Select, Checkbox, ...) supply `view_template`. This layer
      # provides the daisy-flavoured class-string builders and root-element
      # marker class.
      class FormField < ::Decor::Components::Forms::FormField
        private

        def root_element_classes
          [::Decor::Daisy::Forms::FormField.stimulus_identifier, "w-full", disabled? && "disabled"] + grid_span_class
        end

        def input_classes
          if @control_html_options&.key?(:class)
            produce_style_classes Array.wrap(@control_html_options[:class])
          end
        end

        def input_container_classes
          label_top? ? "mt-1" : ""
        end
      end
    end
  end
end
