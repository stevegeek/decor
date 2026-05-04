# frozen_string_literal: true

module Decor
  module Components
    module Forms
      # Abstract base for HiddenField. Owns the html_attributes builder +
      # root element attributes (skin-agnostic — `hidden` is HTML, not
      # daisy). Concrete skins (Daisy, Suite) inherit and provide
      # `view_template`.
      class HiddenField < ::Decor::Components::Forms::FormField
        private

        def root_element_attributes
          {
            html_options: {hidden: "hidden"}
          }
        end

        def html_attributes
          attrs = {
            type: "hidden",
            hidden: "hidden",
            autocomplete: "off",
            name: @name,
            value: @value,
            id: id
          }
          attrs[:disabled] = nil if @disabled
          attrs
        end
      end
    end
  end
end
