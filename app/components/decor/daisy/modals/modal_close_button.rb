# frozen_string_literal: true

module Decor
  module Daisy
    module Modals
      class ModalCloseButton < ::Decor::Components::Modals::ModalCloseButton
        include ::Decor::Daisy::ButtonTemplate
        include ::Decor::Daisy::ButtonClasses

        def view_template(&block)
          @content = capture(&block) if block_given?

          root_element do
            button(
              type: "submit",
              class: root_element_classes,
              disabled: @disabled ? "disabled" : nil,
              data: root_element_data_attributes
            ) do
              span(class: "decor:text-center") do
                render @before_label if @before_label.present?

                icon_name = @icon || "x-mark"
                icon_options = {name: icon_name, html_options: {class: icon_classes}}
                icon_options[:variant] = @icon_variant if @icon_variant
                render ::Decor::Icon.new(**icon_options)

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
