# frozen_string_literal: true

module Decor
  module Forms
    class TextField < FormField
      # Optionally specify the HTML size attribute to control the width in characters of the textbox
      prop :html_size, _Nilable(Integer)

      # Leading or trailing add-ons: text, icon or slot
      prop :leading_text_add_on, _Nilable(String)
      prop :trailing_text_add_on, _Nilable(String)
      prop :leading_icon_name, _Nilable(String)
      prop :trailing_icon_name, _Nilable(String)

      def leading_add_on(&block)
        @leading_add_on = block
      end

      def trailing_add_on(&block)
        @trailing_add_on = block
      end

      # The attached on-adds can either appear as text, or boxed in a gray container
      prop :add_on_style, _Union(:text, :boxed), default: :text

      # Allows one to change the type of input. However normally you should use the specific ViewComponent (eg
      # NumberField or PasswordField)
      prop :type, Symbol, default: :text

      # A pattern to test against (a JavaScript Regex in a string)
      prop :pattern, _Nilable(String)

      # HTML inputmode attribute
      prop :inputmode, _Nilable(String)

      # A numerical text field is a text field which only accepts numbers
      prop :numerical, _Boolean, default: false

      # The min and max length HTML5 attributes are set with the following
      prop :maximum_length, _Nilable(Integer)
      prop :minimum_length, _Nilable(Integer)

      # If set this will apply validation that value is same as value in field with ID
      prop :validate_value_equal_to_id, _Nilable(String)

      # Attributes for text fields of type 'number'
      prop :min, _Nilable(Numeric)
      prop :max, _Nilable(Numeric)
      prop :step, _Nilable(Numeric)
      prop :greater_than, _Nilable(Numeric)
      prop :less_than, _Nilable(Numeric)

      stimulus do
        classes invalid_input: "invalid:border-error-dark"
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
            if has_any_add_on?
              label(class: input_classes) do
                render_leading_add_on(el) if has_leading_add_on?

                input(
                  data_hj_whitelist: true,
                  data_controller: form_control_controller,
                  class: daisyui_input_classes,
                  **html_attributes,
                  data: {
                    **el.stimulus_target(:input),
                    **(control_actions? ? el.stimulus_action(*@control_actions) : {}),
                    **(control_targets? ? el.stimulus_target(*@control_targets) : {}),
                    **(control_data_attributes || {})
                  }
                )

                render_trailing_add_on(el) if has_trailing_add_on?
              end
            else
              input(
                data_hj_whitelist: true,
                data_controller: form_control_controller,
                class: input_classes + " " + daisyui_input_classes,
                **html_attributes,
                data: {
                  **el.stimulus_target(:input),
                  **(control_actions? ? el.stimulus_action(*@control_actions) : {}),
                  **(control_targets? ? el.stimulus_target(*@control_targets) : {}),
                  **(control_data_attributes || {})
                }
              )
            end

            render ::Decor::Forms::ErrorIconSection.new(
              error_text: error_text,
              show_floating_message: floating_error_text?,
              html_options: {
                class: "#{errors? ? "" : "hidden"} #{number_field? ? "right-7" : "right-3"}"
              }
            )
          end
        end
      end

      private

      def html_attributes
        attrs = {
          id: "#{id}-control",
          type: @type,
          name: @name,
          value: @value
        }
        attrs[:required] = nil if @required
        attrs[:disabled] = nil if @disabled
        attrs[:size] = @html_size if @html_size
        attrs[:minlength] = @minimum_length if @minimum_length
        attrs[:maxlength] = @maximum_length if @maximum_length
        attrs[:pattern] = resolved_pattern if @pattern
        attrs[:inputmode] = @inputmode if @inputmode
        attrs[:autocomplete] = @autocomplete if @autocomplete
        if @placeholder || (@label_inside && @label)
          attrs[:placeholder] = @placeholder || label_with_required
        end
        if number_field?
          attrs[:max] = @max if @max
          attrs[:min] = @min if @min
          attrs[:step] = @step if @step
          attrs[:"data-form-control-validate-gt-value"] = @greater_than if @greater_than.present?
          attrs[:"data-form-control-validate-lt-value"] = @less_than if @less_than.present?
        end
        attrs[:"data-form-control-validate-type-value"] = "number" if @numerical
        attrs[:"data-form-control-validate-equal-to-value"] = @validate_value_equal_to_id if @validate_value_equal_to_id
        attrs
      end

      def has_leading_add_on?
        @leading_add_on.present? || @leading_text_add_on.present? || @leading_icon_name.present?
      end

      def has_trailing_add_on?
        @trailing_add_on.present? || @trailing_text_add_on.present? || @trailing_icon_name.present?
      end

      def has_any_add_on?
        has_leading_add_on? || has_trailing_add_on?
      end

      # On label or input itself if no label
      def input_classes
        classes = ["input"]
        classes << "validator" if @required || @pattern.present? || @minimum_length.present? || @maximum_length.present?
        classes.join(" ")
      end

      # Classes for the input
      def daisyui_input_classes
        classes = []
        classes << (@html_size ? "" : "w-full")
        classes << ((@numerical && @type == :tel) ? "tabular-nums" : "")
        classes << component_size_classes(@size).join(" ")
        classes << component_color_classes(@color).join(" ")
        classes << component_style_classes(@style).join(" ")
        classes.join(" ").strip
      end

      def component_size_classes(size)
        case size
        when :xs then ["input-xs"]
        when :sm then ["input-sm"]
        when :md then [] # default
        when :lg then ["input-lg"]
        when :xl then ["input-lg"] # DaisyUI doesn't have xl, use lg
        else []
        end
      end

      def component_color_classes(color)
        case color
        when :primary then ["input-primary"]
        when :secondary then ["input-secondary"]
        when :accent then ["input-accent"]
        when :success then ["input-success"]
        when :error then ["input-error"]
        when :warning then ["input-warning"]
        when :info then ["input-info"]
        when :ghost then ["input-ghost"]
        when :neutral then [] # neutral is default
        else [] # base/neutral
        end
      end

      def component_style_classes(style)
        case style
        when :filled then [] # default
        when :outlined then ["input-bordered"]
        when :ghost then ["input-ghost"]
        else []
        end
      end

      def render_leading_add_on(el)
        if @leading_add_on.present?
          render @leading_add_on
        elsif @leading_icon_name.present?
          render ::Decor::Icon.new(name: @leading_icon_name, html_options: {class: "h-[1em] opacity-50"})
        elsif @leading_text_add_on.present?
          span(
            class: "opacity-50",
            data: {**el.stimulus_target(:leading_text_add_on)}
          ) do
            @leading_text_add_on
          end
        end
      end

      def render_trailing_add_on(el)
        if @trailing_add_on.present?
          render @trailing_add_on
        elsif @trailing_icon_name.present?
          render ::Decor::Icon.new(name: @trailing_icon_name, html_options: {class: "h-[1em] opacity-50"})
        elsif @trailing_text_add_on.present?
          span(
            class: "opacity-50",
            data: {**el.stimulus_target(:trailing_text_add_on)}
          ) do
            @trailing_text_add_on
          end
        end
      end

      def resolved_pattern
        if @pattern.is_a?(Proc)
          @pattern.call(self)
        else
          @pattern
        end
      end

      def number_field?
        @type == :number
      end
    end
  end
end
