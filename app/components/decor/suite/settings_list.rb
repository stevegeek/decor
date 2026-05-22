# frozen_string_literal: true

module Decor
  module Suite
    class SettingsList < ::Decor::Components::SettingsList
      ROW_CTRL = "decor--suite--settings-list--row"
      private_constant :ROW_CTRL

      # Optional Suite modal instance (Suite::Modals::Modal or Suite::Modals::Form).
      # When supplied + a row has `edit_path:`, the row's Edit affordance becomes
      # a Suite::Modals::ModalOpenButton that fetches the row's edit_path into
      # the shared modal via `content_href:`. If nil, falls back to a bare
      # anchor link to the edit_path.
      prop :modal, _Nilable(_Any), default: nil, reader: :public

      def view_template
        root_element(class: "decor:max-w-2xl decor:mx-auto") do
          div(class: card_classes) do
            if @title
              div(class: "decor:border-b decor:border-suite-hairline decor:px-5 decor:py-3.5") do
                h3(class: "decor:suite-section-title decor:text-gray-900 decor:m-0") { @title }
              end
            end
            rendered_groups.each_with_index do |group, idx|
              render_group(group, idx)
            end
          end
        end
      end

      private

      def card_classes
        "decor:bg-white decor:border decor:border-suite-hairline decor:rounded-suite-card decor:overflow-hidden"
      end

      def render_group(group, idx)
        div(class: idx.zero? ? nil : "decor:border-t decor:border-suite-hairline") do
          render_section_header(group) unless anonymous_group?(group)
          group.rows.each { |row| render_row(row) }
        end
      end

      def render_section_header(group)
        div(class: "decor:bg-gray-50 decor:border-b decor:border-suite-hairline decor:px-4 decor:py-2.5") do
          div(class: "decor:flex decor:items-center decor:gap-2") do
            if group.icon
              render ::Decor::Icon.new(name: group.icon, classes: "decor:h-4 decor:w-4 decor:text-suite-primary-600")
            end
            span(class: "decor:suite-caption decor:text-gray-700") { group.name }
            span(class: "decor:suite-description decor:text-gray-500 decor:ml-auto") { "#{group.rows.size} settings" }
          end
          if group.description.present?
            p(class: "decor:suite-description decor:text-gray-500 decor:m-0 decor:mt-0.5") { group.description }
          end
        end
      end

      def render_row(row)
        detail_id = "settings-list-row-#{row.object_id}-detail"

        if expandable_row?(row)
          child_element(
            :div,
            class: "decor:border-t decor:border-suite-hairline decor:first:border-t-0",
            stimulus_controllers: [ROW_CTRL],
            stimulus_values: [[ROW_CTRL, :open, false]]
          ) do
            render_summary(row, detail_id, expandable: true)
            render_detail_panel(row, detail_id)
          end
        else
          div(class: "decor:border-t decor:border-suite-hairline decor:first:border-t-0") do
            render_summary(row, detail_id, expandable: false)
          end
        end
      end

      def render_summary(row, detail_id, expandable:)
        if expandable
          child_element(
            :button,
            type: "button",
            class: summary_classes(expandable: true),
            stimulus_action: [:click, ROW_CTRL, :toggle],
            stimulus_target: [ROW_CTRL, :summary],
            "aria-expanded": "false",
            "aria-controls": detail_id
          ) do
            render_summary_inner(row, expandable: true)
          end
        else
          div(class: summary_classes(expandable: false)) do
            render_summary_inner(row, expandable: false)
          end
        end
      end

      def summary_classes(expandable:)
        base = "decor:w-full decor:grid decor:grid-cols-[auto_1fr_auto_auto] decor:gap-4 decor:items-center decor:px-4 decor:py-2.5 decor:text-left decor:hover:bg-suite-gray-25 decor:transition-colors decor:duration-suite-fast"
        expandable ? "#{base} decor:cursor-pointer" : base
      end

      def render_summary_inner(row, expandable:)
        if expandable
          child_element(
            :span,
            class: "decor:w-2 decor:text-gray-500 decor:transition-transform decor:duration-suite-fast",
            "aria-hidden": "true",
            stimulus_target: [ROW_CTRL, :chevron]
          ) { "▶" }
        else
          span(class: "decor:w-2", "aria-hidden": "true")
        end

        span(class: "decor:suite-dense-body decor:font-semibold decor:text-gray-900 decor:flex decor:items-center decor:gap-1.5") do
          plain row.title
          render_scope_chip(row.scope_info) if row.scope_info
        end

        span(class: "decor:suite-dense-body decor:font-medium decor:tabular-nums decor:text-right decor:text-gray-700") do
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
        render ::Decor::Suite::Badge.new(
          label: active ? "Active" : "Off",
          color: active ? :success : :neutral,
          size: :sm,
          dot: true
        )
      end

      def render_scope_chip(scope)
        chip_classes = "decor:suite-description decor:bg-gray-100 decor:text-gray-500 decor:rounded-suite-control decor:px-1.5 decor:py-0.5"
        if scope.link_path
          a(href: scope.link_path, title: scope.tooltip, class: chip_classes) { scope.label }
        else
          span(title: scope.tooltip, class: chip_classes) { scope.label }
        end
      end

      def render_detail_panel(row, detail_id)
        child_element(
          :div,
          id: detail_id,
          class: "decor:bg-suite-gray-25 decor:border-t decor:border-suite-hairline decor:px-4 decor:pl-8 decor:pb-3.5 decor:pt-3",
          hidden: true,
          stimulus_target: [ROW_CTRL, :detail]
        ) do
          if row.description
            p(class: "decor:suite-description decor:text-gray-500 decor:max-w-prose decor:pb-2 decor:m-0") { row.description }
          end
          render_edit_affordance(row) if row.edit_path
        end
      end

      def render_edit_affordance(row)
        if @modal
          render ::Decor::Suite::Modals::ModalOpenButton.new(
            modal_id: @modal.id,
            content_href: edit_content_href_for(row),
            label: @edit_label,
            color: :base,
            style: :outlined,
            size: :sm
          )
        else
          a(
            href: row.edit_path,
            class: edit_link_classes
          ) { @edit_label }
        end
      end

      # When the modal is a Suite::Modals::Form, append its form_id so the
      # fetched fragment can wire its <form> to the footer Submit button.
      def edit_content_href_for(row)
        return row.edit_path unless @modal&.respond_to?(:form_id)
        separator = row.edit_path.include?("?") ? "&" : "?"
        "#{row.edit_path}#{separator}form_id=#{@modal.form_id}"
      end

      def edit_link_classes
        "decor:inline-flex decor:items-center decor:px-2.5 decor:py-1 decor:suite-dense-body decor:font-medium " \
          "decor:text-suite-primary-700 decor:bg-white decor:border decor:border-suite-primary-200 " \
          "decor:rounded-suite-control decor:transition-colors decor:duration-suite-fast " \
          "decor:hover:bg-suite-primary-50 decor:no-underline"
      end
    end
  end
end
