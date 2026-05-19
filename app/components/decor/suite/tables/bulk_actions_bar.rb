# frozen_string_literal: true

module Decor
  module Suite
    module Tables
      # Suite BulkActionsBar — bottom band of a Suite DataTable that surfaces
      # bulk operations on the currently-selected rows.
      #
      # The bar is hidden in its initial state and revealed by the JS
      # controller when at least one row is selected. The Stimulus controller
      # also keeps the displayed selection count in sync, fills hidden
      # `selected_ids[]` inputs into each action form, optionally opens a
      # remote-fetched modal for actions marked `modal: true`, and shows a
      # confirm dialog for actions with a `confirm:` message before submitting.
      #
      # `bulk_actions` accepts any value object responding to the following
      # readers (the Confinus `DataTableBuilder::BulkAction` struct is the
      # canonical example):
      #   :name (Symbol), :label (String), :icon (String?),
      #   :icon_variant (:outline/:solid/:small_solid), :style (:primary/
      #   :secondary/:danger/:warning/:success), :confirm (String?),
      #   :disabled (Bool), :visible (Proc? — falsy => hidden),
      #   :url (String?), :http_method (Symbol), :inline (Bool),
      #   :modal (Bool).
      class BulkActionsBar < ::Decor::PhlexComponent
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
            # Hidden placeholder modal — opened lazily by the JS controller
            # via `showModal({ id: <id>-bulk-modal, contentHref: ... })` for
            # actions flagged `modal: true`.
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

        # Inline action — submitted by its own <form>. The JS controller
        # intercepts the submit button click (data-action), populates hidden
        # selected_ids[] inputs into the container div, optionally opens a
        # confirm or modal flow, then calls form.requestSubmit().
        def render_inline_action(action)
          form(
            action: action.url || @form_url,
            method: action_form_http_method(action),
            class: "decor:inline-block"
          ) do
            input(type: "hidden", name: "_method", value: action.http_method.to_s) if rails_method_field?(action)
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

              form(
                action: action.url || @form_url,
                method: action_form_http_method(action),
                class: "decor:hidden",
                data: {**stimulus_target(:dropdown_form)}
              ) do
                input(type: "hidden", name: "_method", value: action.http_method.to_s) if rails_method_field?(action)
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

        # The form `method` attribute only supports GET and POST. Anything
        # else is tunnelled via the Rails-style `_method` override input.
        def action_form_http_method(action)
          (action.http_method == :get) ? :get : :post
        end

        def rails_method_field?(action)
          action.http_method && action.http_method != :get && action.http_method != :post
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
