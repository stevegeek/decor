# frozen_string_literal: true

module Decor
  module Suite
    module Tables
      # Suite skin of DataTableCell. Renders a `<td>` with Suite typography
      # (suite-body / suite-dense-body), suite-hairline bottom divider, and
      # optional cell-to-row link overlay (absolutely-positioned anchor that
      # fills the cell to keep ctrl-click + middle-click navigation working
      # without trapping events on inner controls).
      #
      # Padding density follows row_height (:tight/:standard/:comfortable)
      # plus an opt-in :compact horizontal padding for high-density admin rows.
      class DataTableCell < ::Decor::Components::Tables::DataTableCell
        def view_template(&block)
          root_element do
            if @max_width.present? || @min_width_rem.present?
              div(
                style: "#{@max_width ? "max-width: #{@max_width}px;" : ""}#{@min_width_rem ? "min-width: #{@min_width_rem}rem;" : ""}",
                class: "decor:truncate"
              ) do
                render_cell_content(&block)
              end
            else
              render_cell_content(&block)
            end
          end
        end

        def resolved_content
          @value || ""
        end

        private

        def root_element_attributes
          attrs = {element_tag: :td}
          if @colspan&.positive?
            attrs[:html_options] = {colspan: @colspan}
          end
          attrs
        end

        def root_element_classes
          [
            alignment_class,
            padding_classes,
            *typography_classes,
            "decor:relative decor:align-middle decor:leading-snug decor:border-b decor:border-suite-hairline decor:whitespace-nowrap",
            @path ? "decor:cursor-pointer" : nil
          ].compact_blank
        end

        def render_cell_content(&block)
          if @align == :center && @path.blank? && !@content_clickable
            div(class: "decor:flex decor:justify-center") { inner_content(&block) }
          else
            inner_content(&block)
          end
        end

        def inner_content(&block)
          if @path.present?
            a(
              # CODEMOD-REVIEW: cell-row-link-overlay is a custom/non-utility class — leave unprefixed
              class: "cell-row-link-overlay decor:absolute decor:inset-0 decor:no-underline decor:cursor-pointer",
              tabindex: "-1",
              href: @path,
              data: {**stimulus_action(:click, :handle_link_click)}
            )
          end

          if @content_clickable
            div(class: "decor:absolute decor:inset-0") do
              div(class: "decor:h-full decor:flex decor:items-center decor:place-content-center") do
                cell_content(&block)
              end
            end
          else
            cell_content(&block)
          end
        end

        # `safe`/`raw` rules:
        # - Block given → emit it verbatim (caller is responsible).
        # - Value carries `html_safe?` true (e.g. ActionText / capture buffer) → re-wrap
        #   as a Phlex SafeValue and emit raw. A plain `String` containing `<` is NOT
        #   html_safe and falls through to `plain` for escaping — do not regress this.
        def cell_content(&block)
          if block
            yield
          elsif @value.respond_to?(:html_safe?) && @value.html_safe?
            raw safe(@value.to_s)
          elsif @value.present?
            plain @value.to_s
          end
        rescue => e
          Rails.logger.error { "[Decor::Suite::Tables::DataTableCell#cell_content] ERROR: #{e.class}: #{e.message}" }
          plain "[render error]"
        end

        def alignment_class
          case @align
          when :center then "decor:text-center"
          when :right then "decor:text-right"
          when :left then "decor:text-left"
          else
            @numeric ? "decor:text-right decor:tabular-nums" : "decor:text-left"
          end
        end

        def padding_classes
          if @compact
            "decor:px-3 decor:py-[5px]"
          else
            case @row_height
            when :tight       then "decor:px-3 decor:py-1"
            when :comfortable then "decor:px-4 decor:py-3"
            else                   "decor:px-[14px] decor:py-[7px]"
            end
          end
        end

        def typography_classes
          base_size = (@row_height == :tight) ? "decor:suite-dense-body" : "decor:suite-body"
          [
            base_size,
            @emphasis == :regular && "decor:text-gray-800",
            @emphasis == :low && "decor:text-gray-500",
            @weight == :light && "decor:font-light",
            @weight == :medium && "decor:font-medium",
            @weight == :regular && "decor:font-normal"
          ]
        end
      end
    end
  end
end
