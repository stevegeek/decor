# frozen_string_literal: true

module Decor
  module Forms
    class ExpandingCheckboxCollection < FormField
      prop :size, _Nilable(Integer)
      prop :hide_after_showing, _Nilable(Integer)

      # Use unified color system for button styling
      default_color :primary

      # ExpandingCheckboxCollection uses domain-specific styles for layout
      default_style :default
      redefine_styles :default, :joined

      stimulus do
        outlets checkbox: ::Decor::Forms::Checkbox.stimulus_identifier
        values label: "collection", required: -> { @required }
        classes(
          valid_label: -> { @disabled ? "text-disabled" : "text-gray-900" },
          invalid_label: "text-error",
          valid_helper_text: -> { @disabled ? "text-disabled" : "text-gray-500" },
          invalid_helper_text: "text-error"
        )
      end

      def view_template
        root_element do |el|
          layout = ::Decor::Forms::FormFieldLayout.new(
            **form_field_layout_options(el),
            stimulus_classes: {
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
                    **el.stimulus_action(:show_more),
                    **el.stimulus_target(:show_more_link)
                  }
                ) { "Show more..." }
              end
            end
          end
        end
      end

      def checkboxes(&block)
        @checkboxes = capture(&block) if block_given?
      end

      private

      def checkbox_container_classes
        classes = ["space-y-2"]
        classes << "join join-vertical" if @style == :joined
        classes.compact.join(" ")
      end

      def show_more_button_classes
        classes = ["btn", "btn-sm"]
        classes << show_more_color_class unless @color == :primary
        classes << "btn-outline" unless @style == :solid
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
        when :base then ""
        else ""
        end
      end
    end
  end
end
