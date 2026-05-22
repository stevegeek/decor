# frozen_string_literal: true

module Decor
  module Daisy
    class SettingsList < ::Decor::Components::SettingsList
      def view_template
        root_element(class: "decor:max-w-2xl decor:mx-auto") do
          div(class: "decor:d-card decor:bg-base-100 decor:border decor:border-base-300 decor:overflow-hidden") do
            if @title
              div(class: "decor:border-b decor:border-base-300 decor:px-5 decor:py-3.5") do
                h3(class: "decor:text-sm decor:font-semibold") { @title }
              end
            end
            rendered_groups.each_with_index do |group, idx|
              render_group(group, idx)
            end
          end
        end
      end

      private

      def render_group(group, idx)
        div(class: idx.zero? ? nil : "decor:border-t decor:border-base-300") do
          render_section_header(group) unless anonymous_group?(group)
          group.rows.each { |row| render_row(row) }
        end
      end

      def render_section_header(group)
        div(class: "decor:bg-base-200 decor:border-b decor:border-base-300 decor:px-4 decor:py-2.5 decor:flex decor:items-center decor:gap-2") do
          if group.icon
            render ::Decor::Icon.new(name: group.icon, classes: "decor:h-4 decor:w-4 decor:text-primary")
          end
          span(class: "decor:text-xs decor:font-medium decor:uppercase decor:tracking-wide") { group.name }
          span(class: "decor:text-xs decor:text-base-content/60 decor:ml-auto") { "#{group.rows.size} settings" }
        end
      end

      def render_row(row)
        div(class: "decor:border-t decor:border-base-300 decor:first:border-t-0") do
          if expandable_row?(row)
            render_expandable_row(row)
          else
            render_summary(row, expandable: false)
          end
        end
      end

      def render_expandable_row(row)
        details(class: "decor:group") do
          summary(class: summary_classes(expandable: true)) do
            render_summary_inner(row, expandable: true)
          end
          render_detail_panel(row)
        end
      end

      def render_summary(row, expandable:)
        button(type: "button", class: summary_classes(expandable: expandable)) do
          render_summary_inner(row, expandable: expandable)
        end
      end

      def summary_classes(expandable:)
        base = "decor:w-full decor:grid decor:grid-cols-[auto_1fr_auto_auto] decor:gap-4 decor:items-center decor:px-4 decor:py-2.5 decor:text-left decor:hover:bg-base-200"
        expandable ? "#{base} decor:cursor-pointer" : base
      end

      def render_summary_inner(row, expandable:)
        if expandable
          span(class: "decor:w-2 decor:text-base-content/60 decor:transition-transform decor:group-open:rotate-90", aria_hidden: "true") { "▶" }
        else
          span(class: "decor:w-2", aria_hidden: "true")
        end

        span(class: "decor:text-sm decor:font-semibold decor:flex decor:items-center decor:gap-1.5") do
          plain row.title
          render_scope_chip(row.scope_info) if row.scope_info
        end

        span(class: "decor:text-sm decor:font-medium decor:tabular-nums decor:text-right") do
          render_value(row.value)
        end

        render_state_pill(row.active)
      end

      def render_value(value)
        if value.nil?
          plain "—"
        elsif value.respond_to?(:render_in)
          render value
        else
          plain value.to_s
        end
      end

      def render_state_pill(active)
        render ::Decor::Daisy::Badge.new(
          label: active ? "Active" : "Off",
          color: active ? :success : :neutral,
          size: :sm
        )
      end

      def render_scope_chip(scope)
        chip_classes = "decor:text-xs decor:bg-base-200 decor:text-base-content/70 decor:rounded decor:px-1.5 decor:py-0.5"
        if scope.link_path
          a(href: scope.link_path, title: scope.tooltip, class: chip_classes) { scope.label }
        else
          span(title: scope.tooltip, class: chip_classes) { scope.label }
        end
      end

      def render_detail_panel(row)
        div(class: "decor:bg-base-200/50 decor:border-t decor:border-base-300 decor:px-4 decor:pl-8 decor:pb-3.5 decor:pt-3") do
          if row.description
            p(class: "decor:text-xs decor:text-base-content/70 decor:max-w-prose decor:pb-2") { row.description }
          end
          if row.edit_path
            a(
              href: row.edit_path,
              class: "decor:d-btn decor:d-btn-sm decor:d-btn-outline decor:d-btn-neutral"
            ) { @edit_label }
          end
        end
      end
    end
  end
end
