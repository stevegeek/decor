# frozen_string_literal: true

module Decor
  module Tables
    class DataTableCell < PhlexComponent
      # The value to be rendered in the cell
      # Could be a string or a number, or anything that will be coerced to a string
      prop :value, _Nilable(_Interface(:to_s))

      # Whether the cell contains numeric content or not
      prop :numeric, _Boolean, default: false

      # Number of columns to span. For a column header a colspan of zero means hide the column header
      prop :colspan, _Nilable(Integer)
      # Min width in rem of the cell
      prop :min_width_rem, _Nilable(Numeric)
      # Max width in pixel of the cell # TODO: change to rem
      prop :max_width, _Nilable(Numeric)

      # If 'clickable' the contents is placed in an absolutely positioned div over the cell to
      # ensure the contents capture the mouse click event.
      prop :content_clickable, _Boolean, default: false

      # The cell is meant to stop propagation of events
      prop :stop_propagation, _Boolean, default: false

      # A cell can optionally link to another page.
      prop :path, _Nilable(String)

      # Typography emphasis
      prop :emphasis, _Union(:regular, :low), default: :regular
      # Typography weight
      prop :weight, _Union(:light, :regular, :medium), default: :regular
      # Row height
      prop :row_height, _Union(:comfortable, :standard, :tight), default: :standard

      # DaisyUI color options (in addition to existing emphasis system)
      prop :color, _Nilable(_Union(:primary, :secondary, :accent, :neutral, :info, :success, :warning, :error))

      stimulus do
        actions -> { [:click, :handle_cell_click_to_stop_propagation] if @stop_propagation }
        values no_path_navigation: -> { @path.nil? }
      end

      def view_template(&block)
        root_element do |s|
          if @max_width.present? || @min_width_rem.present?
            div(
              style: "#{@max_width ? "max-width: #{@max_width}px;" : ""}#{@min_width_rem ? "min-width: #{@min_width_rem}rem;" : ""}",
              class: "truncate"
            ) do
              render_cell_content(s, &block)
            end
          else
            render_cell_content(s, &block)
          end
        end
      end

      def resolved_content
        @value || ""
      end

      def element_classes
        [
          @numeric ? "text-right" : "text-left",
          row_height_classes,
          *typography_classes,
          "relative whitespace-nowrap",
          @path ? "cursor-pointer hover:bg-base-200" : nil
        ].compact_blank
      end

      def typography_classes
        [
          # DaisyUI color system (takes precedence over emphasis)
          daisyui_color_class,
          # Legacy emphasis system (only if no daisyUI color is set)
          !@color && @emphasis == :regular && "text-gray-900",
          !@color && @emphasis == :low && "text-gray-500",
          # Weight classes
          @weight == :light && "font-light",
          @weight == :medium && "font-medium",
          @weight == :regular && "font-normal"
        ]
      end

      def row_height_classes
        case @row_height
        when :tight
          "px-3 py-1 text-xs"
        when :comfortable
          "px-4 py-4 text-sm"
        else
          "px-3 py-2 text-sm"
        end
      end

      def daisyui_color_class
        return nil unless @color

        case @color
        when :primary
          "text-primary"
        when :secondary
          "text-secondary"
        when :accent
          "text-accent"
        when :neutral
          "text-neutral"
        when :info
          "text-info"
        when :success
          "text-success"
        when :warning
          "text-warning"
        when :error
          "text-error"
        end
      end

      def root_element_attributes
        attrs = {
          element_tag: :td
        }
        if @colspan&.positive?
          attrs[:html_options] = {colspan: @colspan}
        end
        attrs
      end

      private

      def numeric?
        @numeric
      end

      def sort_key?
        @sort_key.present?
      end

      def sorted_direction?
        @sorted_direction.present?
      end

      def render_cell_content(s)
        if @path.present?
          a(
            class: "cell-row-link-overlay absolute inset-0 no-underline cursor-pointer",
            tabindex: "-1",
            href: @path,
            data: {**stimulus_action(:click, :handle_link_click)}
          )
          if @content_clickable
            div(class: "absolute inset-0") do
              div(class: "h-full flex items-center place-content-center") do
                plain(resolved_content)
                yield if block_given?
              end
            end
          else
            plain(resolved_content)
            yield if block_given?
          end
        elsif @content_clickable
          div(class: "absolute inset-0") do
            div(class: "h-full flex items-center place-content-center") do
              plain(resolved_content)
              yield if block_given?
            end
          end
        else
          plain(resolved_content)
          yield if block_given?
        end
      end
    end
  end
end
