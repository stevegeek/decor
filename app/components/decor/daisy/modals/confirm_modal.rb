# frozen_string_literal: true

module Decor
  module Daisy
    module Modals
      class ConfirmModal < ::Decor::Components::Modals::ConfirmModal
        include Decor::Concerns::StyleColorClasses
        MODAL_TYPES = [:info, :warning, :error, :success].freeze

        def view_template
          root_element do
            div(class: "decor:flex decor:items-center decor:justify-center decor:min-h-screen decor:pt-4 decor:px-4 decor:pb-20 decor:text-center decor:sm:p-0") do
              # The background overlay
              # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
              div(
                class: "decor:fixed decor:hidden decor:inset-0 decor:bg-gray-700 decor:transition-opacity #{class_list_for_stimulus_classes(:overlay_leaving_to)} ",
                aria_hidden: true,
                data: {
                  **stimulus_action(:click, :overlay_clicked),
                  **stimulus_target(:overlay)
                }
              )

              # This element is to trick the browser into centering the modal contents
              span(class: "decor:hidden decor:lg:inline-block decor:lg:align-middle decor:sm:h-screen", aria_hidden: true) { "&#8203;".html_safe }

              # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
              div(
                id: "#{id}-content",
                class: "#{class_list_for_stimulus_classes(:modal_entering_from)} decor:relative decor:inline-block decor:align-bottom decor:bg-white decor:rounded-lg decor:px-4 decor:pt-5 decor:pb-4 decor:text-left decor:overflow-hidden decor:shadow-xl decor:transform decor:transition-all decor:sm:my-8 decor:lg:align-middle #{component_size_classes(@size)} decor:sm:w-full decor:sm:p-6",
                data: {**stimulus_target(:modal)}
              ) do
                # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
                div(class: "#{component_style_classes(@style) || "decor:bg-white"} decor:px-4 decor:pt-5 decor:pb-4 decor:sm:p-6 decor:sm:pb-4") do
                  div(class: "decor:sm:flex decor:sm:items-start") do
                    modal_types.each do |type|
                      div(class: "#{component_name}-#{type}-icon decor:hidden decor:mx-auto decor:flex-shrink-0 decor:flex decor:items-center decor:justify-center decor:h-12 decor:w-12 decor:rounded-full #{icon_bg_color(type)} decor:sm:mx-0 decor:sm:h-10 decor:sm:w-10") do
                        # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
                        render ::Decor::Daisy::Icon.new(name: icon_name(type), classes: "decor:h-6 decor:w-6 #{icon_color(type)}")
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
                div(class: "decor:bg-gray-50 decor:px-4 decor:py-3 decor:sm:px-6 decor:flex decor:flex-row-reverse") do
                  render ::Decor::Daisy::Button.new(
                    label: "Continue",
                    color: :primary,
                    classes: "decor:ml-3 decor:w-auto decor:text-sm",
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
                    classes: "decor:ml-3 decor:w-auto decor:text-sm",
                    html_options: {
                      data: {
                        **stimulus_target(:negative_button),
                        **stimulus_action(:click, :negative_button)
                      }
                    }
                  )
                end
              end
            end
          end
        end

        private

        def root_element_attributes
          {
            element_tag: :aside,
            aria_modal: true,
            role: "dialog",
            aria_labelledby: "#{id}-title",
            aria_describedby: "#{id}-content"
          }
        end

        def root_element_classes
          "decor:fixed decor:hidden decor:z-10 decor:inset-0 decor:overflow-y-auto"
        end

        # Implement unified system methods
        def component_size_classes(size)
          # Modal size affects the max-width of the modal content
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
          # Modal styling affects the background and border of the modal content
          case style
          when :filled
            filled_color_classes(@color)
          when :outlined
            # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
            "#{outline_color_classes(@color)} decor:bg-base-100"
          when :ghost
            # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
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
            "exclamation"
          when :error
            "exclamation-circle"
          when :success
            "check"
          else
            "information-circle"
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
