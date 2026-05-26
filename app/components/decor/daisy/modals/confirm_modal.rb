# frozen_string_literal: true

module Decor
  module Daisy
    module Modals
      class ConfirmModal < ::Decor::Components::Modals::ConfirmModal
        include Decor::Concerns::StyleColorClasses

        MODAL_TYPES = [:info, :warning, :error, :success].freeze

        def view_template
          root_element do
            # Modal content box — centered + sized by daisyUI's d-modal.
            div(
              id: "#{id}-content",
              class: "decor:d-modal-box #{component_size_classes(@size)}",
              data: {**stimulus_target(:modal)}
            ) do
              div(class: component_style_classes(@style).presence || "") do
                div(class: "decor:sm:flex decor:sm:items-start") do
                  modal_types.each do |type|
                    div(class: "#{component_name}-#{type}-icon decor:hidden decor:mx-auto decor:flex-shrink-0 decor:flex decor:items-center decor:justify-center decor:h-12 decor:w-12 decor:rounded-full #{icon_bg_color(type)} decor:sm:mx-0 decor:sm:h-10 decor:sm:w-10") do
                      render ::Decor::Icon.new(name: icon_name(type), classes: "decor:h-6 decor:w-6 #{icon_color(type)}")
                    end
                  end
                  div(class: "decor:mt-3 decor:text-center decor:sm:mt-0 decor:sm:ml-4 decor:sm:text-left") do
                    h3(id: "#{id}-title", class: "decor:text-lg decor:leading-6 decor:font-medium decor:text-gray-900", data: {**stimulus_target(:title)}) do
                      "Are you sure?"
                    end
                    div(class: "decor:mt-2") do
                      p(id: "#{id}-message", class: "decor:text-sm decor:text-gray-500", data: {**stimulus_target(:message)})
                    end
                  end
                end
              end

              div(class: "decor:d-modal-action decor:mt-5 decor:sm:mt-4 decor:flex decor:flex-row-reverse decor:gap-3") do
                render ::Decor::Daisy::Button.new(
                  label: "Continue",
                  color: :primary,
                  classes: "decor:w-auto decor:text-sm",
                  html_options: {
                    data: {
                      **stimulus_target(:positive_button),
                      **stimulus_action(:click, :positive_button)
                    }
                  }
                )
                render ::Decor::Daisy::Button.new(
                  label: "Cancel",
                  color: :secondary,
                  style: :outlined,
                  classes: "decor:w-auto decor:text-sm",
                  html_options: {
                    data: {
                      **stimulus_target(:negative_button),
                      **stimulus_action(:click, :negative_button)
                    }
                  }
                )
              end
            end

            # Backdrop — a method="dialog" form closes the dialog natively on
            # click; the overlay target + action also notify the controller.
            form(
              method: "dialog",
              class: "decor:d-modal-backdrop",
              data: {
                **stimulus_action(:click, :overlay_clicked),
                **stimulus_target(:overlay)
              }
            ) do
              button { "" }
            end
          end
        end

        private

        def root_element_attributes
          {
            element_tag: :dialog,
            html_options: {
              aria_modal: true,
              aria_labelledby: "#{id}-title",
              aria_describedby: "#{id}-content"
            }
          }
        end

        def root_element_classes
          "decor:d-modal"
        end

        def component_size_classes(size)
          case size
          when :xs then "decor:max-w-xs"
          when :sm then "decor:max-w-sm"
          when :md then "decor:max-w-md"
          when :lg then "decor:max-w-lg"
          when :xl then "decor:max-w-xl"
          when :xxl then "decor:max-w-2xl"
          else
            "decor:max-w-md"
          end
        end

        def component_style_classes(style)
          case style
          when :filled
            filled_color_classes(@color)
          when :outlined
            "#{outline_color_classes(@color)} decor:bg-base-100"
          when :ghost
            "#{ghost_color_classes(@color)} decor:shadow-none"
          else
            ""
          end
        end

        def modal_types
          MODAL_TYPES
        end

        def icon_name(type)
          case type
          when :warning
            "exclamation-mark"
          when :error
            "exclamation-circle"
          when :success
            "check"
          else
            "info-circle"
          end
        end

        def icon_color(type)
          case type
          when :warning
            "text-warning"
          when :error
            "text-error"
          when :success
            "text-success"
          else
            "text-gray-900"
          end
        end

        def icon_bg_color(type)
          case type
          when :warning
            "bg-warning-pale"
          when :error
            "bg-error-pale"
          when :success
            "bg-success-pale"
          else
            "bg-gray-300"
          end
        end
      end
    end
  end
end
