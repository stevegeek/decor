# frozen_string_literal: true

module Decor
  module Suite
    # Suite CodeBlock — syntax-highlighted code block for docs / admin contexts.
    #
    # Visual chrome:
    # - suite-gray-25 surface with suite-hairline border and rounded-suite-card corners.
    # - Optional header strip (filename + copy button) separated by a hairline border.
    # - Body uses font-mono with overflow-x-auto for long lines.
    # - `:terminal` style swaps the surface for a darker (gray-900) panel with
    #   light text and `$`/`>` prompt prefixes.
    #
    # Stimulus: this skin reuses the Daisy code_block controller (which lazy-loads
    # highlight.js) by overriding `stimulus_identifier_path` to point at the daisy
    # controller path. The data-controller, data-target and value attributes
    # therefore emit `decor--daisy--code-block` so the existing JS binds without
    # duplication.
    class CodeBlock < ::Decor::Components::CodeBlock
      # Bind to the existing Daisy code_block Stimulus controller (no Suite JS).
      def self.stimulus_identifier_path
        "decor/daisy/code_block"
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
        div(class: header_classes) do
          if @filename
            span(class: "decor:suite-description decor:font-medium decor:text-gray-700") { @filename }
          else
            span { "" }
          end

          if @copy_button
            render ::Decor::Suite::ClickToCopy.new(
              variant: :inline,
              to_copy: @code_content&.strip || ""
            )
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
        div(class: terminal_body_classes) do
          if block_given?
            content = capture { yield }
            lines = content.strip.split("\n")

            lines.each_with_index do |line, index|
              prefix = line.start_with?("$") ? "$" : ">"
              clean_line = line.sub(/^[$>]\s?/, "")

              pre(class: terminal_line_classes(index + 1)) do
                span(class: "decor:select-none decor:mr-2 decor:text-gray-500") { prefix }
                code(class: "decor:font-mono", data: code_data_attributes) { clean_line }
              end
            end
          end
        end
      end

      def render_standard_content(&block)
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

      def render_with_line_numbers
        content = capture { yield }
        lines = content.strip.split("\n")

        div(class: "decor:flex") do
          div(class: "decor:select-none decor:pr-4 decor:text-gray-400 decor:suite-description") do
            lines.each_index do |i|
              div(class: "decor:text-right") { (i + 1).to_s }
            end
          end

          div(class: "decor:flex-1 decor:overflow-x-auto") do
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
          "decor:overflow-hidden decor:rounded-suite-card decor:border decor:border-suite-hairline",
          style_classes
        ].compact.join(" ")
      end

      def component_style_classes(style)
        case style
        when :terminal then "decor:bg-gray-900 decor:text-gray-100"
        when :default then "decor:bg-suite-gray-25"
        else "decor:bg-suite-gray-25"
        end
      end

      def header_classes
        [
          "decor:flex decor:items-center decor:justify-between",
          "decor:px-4 decor:py-2",
          "decor:border-b decor:border-suite-hairline",
          (@style == :terminal) ? "decor:bg-gray-800" : "decor:bg-white"
        ].compact.join(" ")
      end

      def terminal_body_classes
        "decor:p-4 decor:overflow-x-auto decor:suite-dense-body"
      end

      def terminal_line_classes(line_number)
        [
          "decor:flex decor:items-baseline",
          highlight_line?(line_number) ? "decor:bg-amber-500/20 decor:text-amber-100" : nil
        ].compact.join(" ")
      end

      def pre_classes
        "decor:p-4 decor:overflow-x-auto decor:suite-dense-body"
      end

      def code_classes
        [
          "decor:font-mono",
          (@language && @highlight) ? "decor:language-#{@language}" : nil
        ].compact.join(" ")
      end

      def code_data_attributes
        {**stimulus_target(:code)}
      end

      def line_wrapper_class(line_number)
        [
          "decor:pr-4",
          highlight_line?(line_number) ? "decor:bg-amber-500/15 decor:-mx-4 decor:px-4" : nil
        ].compact.join(" ")
      end
    end
  end
end
