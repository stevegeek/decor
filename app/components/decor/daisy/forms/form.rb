# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class Form < ::Decor::Components::Forms::Form
        def view_template(&block)
          raw(
            form_with(**form_with_helper_options) do |builder|
              content = ""
              unless locked_version.nil?
                hidden_field_html = builder.hidden_field(:lock_version)
                content += hidden_field_html.to_s if hidden_field_html
              end
              yielded_form = form_contents(builder, &block)
              content += yielded_form.to_s if yielded_form
              content
            end
          )
        end
      end
    end
  end
end
