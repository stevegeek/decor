# frozen_string_literal: true

module Decor
  module Daisy
    module Modals
      class ModalCloseButton < ::Decor::Components::Modals::ModalCloseButton
        # Pulled in for icon_classes and the daisyUI btn-* class composition.
        # The local view_template below overrides ButtonTemplate#view_template.
        include ::Decor::Daisy::ButtonTemplate
        include ::Decor::Daisy::ButtonClasses

        def view_template(&block)
          @content = capture(&block) if block_given?

          root_element do
            button(
              type: "submit",
              # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
              class: root_element_classes,
              disabled: @disabled ? "disabled" : nil,
              data: root_element_data_attributes
            ) do
              span(class: "decor:text-center") do
                render @before_label if @before_label.present?

                # Always show close icon or use provided icon
                icon_name = @icon || "x-mark"
                # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
                icon_options = {name: icon_name, html_options: {class: icon_classes}}
                icon_options[:variant] = @icon_variant if @icon_variant
                render ::Decor::Daisy::Icon.new(**icon_options)

                span(class: @icon_only_on_mobile ? "decor:hidden decor:md:inline" : "") do
                  render @content || @label
                end
                render @after_label if @after_label.present?
              end
            end
          end
        end

        private

        def root_element_attributes
          {
            element_tag: :form,
            html_options: {
              method: "dialog"
            }
          }
        end
      end
    end
  end
end
