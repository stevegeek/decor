# frozen_string_literal: true

module Decor
  class CodeBlock < PhlexComponent
    prop :language, _Nilable(String)
    prop :highlight, _Boolean, default: false
    prop :show_line_numbers, _Boolean, default: false
    prop :highlight_lines, _Nilable(Array), default: [].freeze
    prop :filename, _Nilable(String)
    prop :copy_button, _Boolean, default: false

    # CodeBlock uses domain-specific styles for presentation modes
    default_style :default
    redefine_styles :default, :terminal

    stimulus do
      values_from_props :language, :highlight
    end

    private

    def view_template(&block)
      root_element do
        if @filename || @copy_button
          @code_content = capture(&block) if @copy_button && block_given?
          render_header
        end
        render_code_content(&block)
      end
    end

    def render_header
      div(class: "flex items-center justify-between px-4 py-2 border-b border-base-300 bg-base-200") do
        if @filename
          span(class: "text-sm font-medium") { @filename }
        else
          span { "" }
        end

        if @copy_button
          render Decor::ClickToCopy.new(to_copy: @code_content&.strip || "") do
            render Decor::Icon.new(name: "duplicate", size: :sm, html_options: {class: "h-4 w-4"})
          end
        end
      end
    end

    def render_code_content(&block)
      if @style == :terminal
        render_terminal_content(&block)
      else
        render_standard_content(&block)
      end
    end

    def render_terminal_content
      div(class: "mockup-code") do
        if block_given?
          content = capture { yield }
          lines = content.strip.split("\n")

          lines.each_with_index do |line, index|
            prefix = line.start_with?("$") ? "$" : ">"
            clean_line = line.sub(/^[$>]\s?/, "")

            pre_attrs = {data: {prefix: prefix}}
            pre_attrs[:class] = line_highlight_class(index + 1) if highlight_line?(index + 1)

            pre(**pre_attrs) do
              code(data: code_data_attributes) { clean_line }
            end
          end
        end
      end
    end

    def render_standard_content
      pre(class: pre_classes) do
        if @show_line_numbers
          render_with_line_numbers { yield if block_given? }
        else
          code(class: code_classes, data: code_data_attributes) do
            yield if block_given?
          end
        end
      end
    end

    # TODO: do a better implementation for line numbers
    def render_with_line_numbers
      content = capture { yield }
      lines = content.strip.split("\n")

      div(class: "flex") do
        # Line numbers column
        div(class: "select-none pr-4 text-base-content/50") do
          lines.each_index do |i|
            div(class: "text-right") { (i + 1).to_s }
          end
        end

        # Code content column
        div(class: "flex-1 overflow-x-auto") do
          lines.each_with_index do |line, index|
            div(class: line_wrapper_class(index + 1)) do
              code(class: code_classes, data: code_data_attributes) { line }
            end
          end
        end
      end
    end

    def root_element_classes
      [
        "rounded-lg overflow-hidden",
        style_classes
      ].compact.join(" ")
    end
    
    def component_style_classes(style)
      case style
      when :terminal then ""  # Terminal style has no background
      when :default then "bg-base-200"
      else "bg-base-200"
      end
    end

    def pre_classes
      [
        "p-4 overflow-x-auto",
        "text-sm"
      ].join(" ")
    end

    def code_classes
      [
        "font-mono",
        (@language && @highlight) ? "language-#{@language}" : nil
      ].compact.join(" ")
    end

    def code_data_attributes
      {**stimulus_target(:code)}
    end

    def line_wrapper_class(line_number)
      [
        "pr-4",
        highlight_line?(line_number) ? "bg-warning/20 -mx-4 px-4" : nil
      ].compact.join(" ")
    end

    def line_highlight_class(line_number)
      highlight_line?(line_number) ? "bg-warning text-warning-content" : nil
    end

    def highlight_line?(line_number)
      @highlight_lines.include?(line_number)
    end
  end
end
