# frozen_string_literal: true

module Decor
  module Suite
    class SettingsList < ::Decor::Components::SettingsList
      # Suite SettingsList::Row — one expandable row inside a SettingsList card.
      #
      # Renders a 4-column grid summary (chevron / title (+ scope chip) /
      # value / state pill) above a hidden detail panel containing the
      # description and an optional Edit affordance. Open state is owned by
      # a per-row Stimulus controller, so each row toggles independently
      # (no accordion).
      #
      # Non-expandable rows are rendered inline by the parent SettingsList;
      # this component always carries the toggle wiring.
      class Row < ::Decor::PhlexComponent
        # Data carrier reused (no new type — base owns the schema).
        RowData = ::Decor::Components::SettingsList::Row

        prop :row, RowData, reader: :public
        prop :edit_label, String, default: "Edit", reader: :public

        stimulus do
          targets :chevron, :detail, :summary
          actions :toggle
          values open: false
        end

        def view_template
          detail_id = "#{id}-detail"

          root_element do
            render_summary(detail_id)
            render_detail_panel(detail_id)
          end
        end

        private

        def root_element_attributes
          {element_tag: :div}
        end

        def root_element_classes
          "decor:border-t decor:border-suite-hairline decor:first:border-t-0"
        end

        def render_summary(detail_id)
          button(
            type: "button",
            class: summary_classes,
            data: {
              **stimulus_target(:summary),
              **stimulus_action(:click, :toggle)
            },
            "aria-expanded": "false",
            "aria-controls": detail_id
          ) do
            render_summary_inner
          end
        end

        def summary_classes
          "decor:w-full decor:grid decor:grid-cols-[auto_1fr_auto_auto] decor:gap-4 decor:items-center decor:px-4 decor:py-2.5 decor:text-left decor:hover:bg-suite-gray-25 decor:transition-colors decor:duration-suite-fast decor:cursor-pointer"
        end

        def render_summary_inner
          span(
            class: "decor:w-2 decor:text-gray-500 decor:transition-transform decor:duration-suite-fast",
            "aria-hidden": "true",
            data: {**stimulus_target(:chevron)}
          ) { "▶" }

          span(class: "decor:suite-dense-body decor:font-semibold decor:text-gray-900 decor:flex decor:items-center decor:gap-1.5") do
            plain @row.title
            render_scope_chip(@row.scope_info) if @row.scope_info
          end

          span(class: "decor:suite-dense-body decor:font-medium decor:tabular-nums decor:text-right decor:text-gray-700") do
            render_value(@row.value)
          end

          render_state_pill(@row.active)
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

        def render_detail_panel(detail_id)
          div(
            id: detail_id,
            class: "decor:bg-suite-gray-25 decor:border-t decor:border-suite-hairline decor:px-4 decor:pl-8 decor:pb-3.5 decor:pt-3",
            hidden: true,
            data: {**stimulus_target(:detail)}
          ) do
            if @row.description
              p(class: "decor:suite-description decor:text-gray-500 decor:max-w-prose decor:pb-2 decor:m-0") { @row.description }
            end
            if @row.edit_path
              a(
                href: @row.edit_path,
                class: edit_link_classes
              ) { @edit_label }
            end
          end
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
end
