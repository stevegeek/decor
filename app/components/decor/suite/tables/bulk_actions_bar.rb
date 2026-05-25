# frozen_string_literal: true

module Decor
  module Suite
    module Tables
      class BulkActionsBar < ::Decor::PhlexComponent
        include ::Phlex::Rails::Helpers::FormWith

        prop :selection_count, Integer, default: 0, reader: :public
        prop :bulk_actions, _Array(_Any), default: -> { [] }, reader: :public
        prop :form_url, _Nilable(String), reader: :public
        prop :form_method, Symbol, default: :post, reader: :public
        prop :selected_ids_field_name, _Nilable(String), reader: :public

        stimulus do
          targets :selection_count, :selected_ids_container, :dropdown_form
          values selected_ids_field_name: -> { (@selected_ids_field_name || "selected_ids").to_s }
        end

        def view_template
          root_element do
            render ::Decor::Suite::Modals::Modal.new(
              id: "#{id}-bulk-modal",
              closeable: true
            )

            span(
              class: "decor:suite-description decor:font-semibold decor:text-suite-primary-700 decor:shrink-0",
              data: {**stimulus_target(:selection_count)}
            ) do
              plain "#{selection_count} #{(selection_count == 1) ? "item" : "items"} selected"
            end

            span(
              class: "decor:w-px decor:h-4 decor:bg-suite-primary-200 decor:shrink-0",
              aria_hidden: "true"
            )

            div(class: "decor:flex decor:items-center decor:gap-2") do
              visible_actions = bulk_actions.select { |a| !a.visible || a.visible.call }
              inline_actions = visible_actions.select(&:inline)
              dropdown_actions = visible_actions.reject(&:inline)

              inline_actions.each { |action| render_inline_action(action) }
              render_dropdown_actions(dropdown_actions) if dropdown_actions.any?
            end

            button(
              type: "button",
              class: "decor:ml-auto decor:text-xs decor:font-medium decor:text-suite-primary-700 decor:underline decor:underline-offset-2 decor:cursor-pointer decor:hover:text-suite-primary-700 decor:shrink-0",
              data: {**stimulus_action(:click, :clear_selection)}
            ) { plain "Clear selection" }
          end
        end

        private

        def render_inline_action(action)
          form_with(
            url: action.url || @form_url,
            method: action.http_method || :post,
            local: true,
            html: {class: "decor:inline-block"}
          ) do
            div(
              data: {
                **stimulus_target(:selected_ids_container),
                field_name: (@selected_ids_field_name || "selected_ids").to_s
              }
            )

            render ::Decor::Suite::Button.new(
              label: action.label,
              icon: action.icon,
              icon_variant: action.icon_variant,
              style: :outlined,
              color: button_color(action),
              size: :sm,
              disabled: action.disabled,
              element_tag: :button,
              html_options: {
                type: "submit",
                "data-action-name": action.name.to_s,
                "data-bulk-confirm": action.confirm,
                "data-modal": (action.modal ? "true" : nil),
                "data-action": stimulus_action(:click, :handle_bulk_action).to_s
              }.compact
            )
          end
        end

        def render_dropdown_actions(dropdown_actions)
          dropdown = ::Decor::Suite::Dropdown.new(menu_position: :aligned_to_right)

          dropdown.trigger_button_content do
            span(class: "decor:flex decor:items-center decor:gap-1.5") do
              render ::Decor::Icon.new(name: "dots-vertical", style: :outline, html_options: {class: "decor:inline-block decor:shrink-0 decor:h-3 decor:w-3"})
              span { plain "Actions" }
            end
          end

          dropdown_actions.each do |action|
            dropdown.with_menu_item do
              a(
                href: "#",
                role: "menuitem",
                tabindex: "-1",
                class: dropdown_item_classes(action),
                data: {
                  action_name: action.name.to_s,
                  bulk_confirm: action.confirm,
                  modal: (action.modal ? "true" : nil),
                  action: stimulus_action(:click, :handle_dropdown_action).to_s
                }.compact
              ) do
                if action.icon
                  render ::Decor::Icon.new(
                    name: action.icon,
                    html_options: {class: "decor:w-[14px] decor:h-[14px] decor:shrink-0 #{(action.style == :danger) ? "decor:text-suite-danger-600" : "decor:text-gray-500"}"}
                  )
                end
                plain action.label
              end

              form_with(
                url: action.url || @form_url,
                method: action.http_method || :post,
                local: true,
                html: {class: "decor:hidden", data: {**stimulus_target(:dropdown_form)}}
              ) do
                input(type: "hidden", name: "action_name", value: action.name.to_s)
                div(
                  data: {
                    **stimulus_target(:selected_ids_container),
                    field_name: (@selected_ids_field_name || "selected_ids").to_s
                  }
                )
              end
            end
          end

          render dropdown
        end

        def button_color(action)
          case action.style
          when :danger then :error
          when :warning then :warning
          when :success, :primary then :primary
          else :base
          end
        end

        def dropdown_item_classes(action)
          base = "decor:flex decor:items-center decor:gap-2 decor:px-2 decor:py-1.5 " \
                 "decor:rounded-suite-control decor:suite-description decor:cursor-pointer " \
                 "decor:transition-colors decor:duration-suite-fast decor:no-underline"
          if action.style == :danger
            "#{base} decor:text-suite-danger-700 decor:hover:bg-suite-danger-50"
          else
            "#{base} decor:text-gray-900 decor:hover:bg-gray-100"
          end
        end

        def root_element_attributes
          {
            # Inline `display: none` (rather than a `hidden` utility) so the
            # `decor:flex` on the bar isn't dropped by TailwindMerge — JS
            # toggles `style.display` to show/hide.
            html_options: {style: "display: none;"}
          }
        end

        def root_element_classes
          [
            "decor:flex decor:items-center decor:gap-3",
            "decor:px-5 decor:py-[10px]",
            "decor:bg-suite-primary-50 decor:border-b decor:border-suite-primary-200",
            "decor:text-suite-primary-700"
          ].join(" ")
        end
      end
    end
  end
end
