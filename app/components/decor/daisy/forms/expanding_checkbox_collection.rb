# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class ExpandingCheckboxCollection < ::Decor::Components::Forms::ExpandingCheckboxCollection
        def view_template
          root_element do |el|
            layout = ::Decor::Daisy::Forms::FormFieldLayout.new(
              **form_field_layout_options(el),
              stimulus_classes: {
                valid_label: @disabled ? "text-disabled" : "text-gray-900",
                invalid_label: "text-error-dark"
              }
            )

            layout.helper_text_section do
              render ::Decor::Daisy::Forms::HelperTextSection.new(
                helper_text: @helper_text,
                error_text: error_text,
                disabled: @disabled,
                error_section: !floating_error_text?,
                collapsing_helper_text: @collapsing_helper_text
              )
            end

            render layout do
              div(class: checkbox_container_classes) do
                raw @checkboxes.html_safe if @checkboxes.present?
              end

              if @hide_after_showing.present? && @size.present? && @size > @hide_after_showing
                div(class: "decor:mt-3") do
                  button(
                    class: show_more_button_classes,
                    type: "button",
                    data: {
                      **el.stimulus_action(:show_more),
                      **el.stimulus_target(:show_more_link)
                    }
                  ) { "Show more..." }
                end
              end
            end
          end
        end

        private

        def checkbox_container_classes
          classes = ["decor:space-y-2"]
          classes << "decor:d-join decor:d-join-vertical" if @style == :joined
          classes.compact.join(" ")
        end

        def show_more_button_classes
          classes = ["decor:d-btn", "decor:d-btn-sm"]
          classes << show_more_color_class unless @color == :primary
          classes << "decor:d-btn-outline" unless @style == :solid
          classes.compact.join(" ")
        end

        def show_more_color_class
          case @color
          when :secondary then "decor:d-btn-secondary"
          when :accent then "decor:d-btn-accent"
          when :neutral then "decor:d-btn-neutral"
          when :success then "decor:d-btn-success"
          when :warning then "decor:d-btn-warning"
          when :info then "decor:d-btn-info"
          when :error then "decor:d-btn-error"
          when :base then ""
          else ""
          end
        end
      end
    end
  end
end
