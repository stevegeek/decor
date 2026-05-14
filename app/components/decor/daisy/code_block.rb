# frozen_string_literal: true

module Decor
  module Daisy
    class CodeBlock < ::Decor::Components::CodeBlock
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
        div(class: "decor:flex decor:items-center decor:justify-between decor:px-4 decor:py-2 decor:border-b decor:border-base-300 decor:bg-base-200") do
          if @filename
            span(class: "decor:text-sm decor:font-medium") { @filename }
          else
            span { "" }
          end

          if @copy_button
            render Decor::Daisy::ClickToCopy.new(to_copy: @code_content&.strip || "") do
              render Decor::Icon.new(name: "copy", size: :sm, html_options: {class: "decor:h-4 decor:w-4"})
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

        div(class: "decor:flex") do
          # Line numbers column
          div(class: "decor:select-none decor:pr-4 decor:text-base-content/50") do
            lines.each_index do |i|
              div(class: "decor:text-right") { (i + 1).to_s }
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
    end
  end
end
