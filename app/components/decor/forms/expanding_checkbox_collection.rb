# frozen_string_literal: true

module Decor
  module Forms
    class ExpandingCheckboxCollection < FormField
      attribute :size, Integer
      attribute :hide_after_showing, Integer

      # Variant styling options
      attribute :variant, Symbol, default: :default
      attribute :color, Symbol, default: :primary

      def view_template
        render parent_element do |el|
          layout = ::Decor::Forms::FormFieldLayout.new(
            **form_field_layout_options(el),
            named_classes: {
              valid_label: @disabled ? "text-disabled" : "text-gray-900",
              invalid_label: "text-error-dark"
            }
          )

          layout.helper_text_section do
            render ::Decor::Forms::HelperTextSection.new(
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
              div(class: "mt-3") do
                button(
                  class: show_more_button_classes,
                  type: "button",
                  data: {
                    **action_data_attributes(el, :show_more),
                    **target_data_attributes(el, :show_more_link)
                  }
                ) { "Show more..." }
              end
            end
          end
        end
      end

      def root_element_attributes
        {
          values: [
            {label: "collection"},
            @required && {required: @required}
          ].compact_blank,
          outlets: [::Decor::Forms::Checkbox.stimulus_identifier],
          named_classes: {
            valid_label: @disabled ? "text-disabled" : "text-gray-900",
            invalid_label: "text-error",
            valid_helper_text: @disabled ? "text-disabled" : "text-gray-500",
            invalid_helper_text: "text-error"
          }
        }
      end

      def checkboxes(&block)
        @checkboxes = capture(&block) if block_given?
      end

      private

      def checkbox_container_classes
        classes = ["space-y-2"]
        classes << "join join-vertical" if @variant == :joined
        classes.compact.join(" ")
      end

      def show_more_button_classes
        classes = ["btn", "btn-sm"]
        classes << show_more_color_class unless @color == :primary
        classes << "btn-outline" unless @variant == :solid
        classes.compact.join(" ")
      end

      def show_more_color_class
        case @color
        when :secondary then "btn-secondary"
        when :accent then "btn-accent"
        when :neutral then "btn-neutral"
        when :success then "btn-success"
        when :warning then "btn-warning"
        when :info then "btn-info"
        when :error then "btn-error"
        else ""
        end
      end
    end
  end
end
