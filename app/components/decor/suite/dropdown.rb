# frozen_string_literal: true

module Decor
  module Suite
    # Suite Dropdown — popover-API menu with CSS anchor positioning.
    #
    # Visual identity:
    #   - White surface, hairline-strong border, suite-control corners
    #   - Subtle popover shadow + scale-in animation
    #   - Compact 4px padding for menu rows
    #
    # The browser owns aria-expanded toggling, light-dismiss, and Escape-to-close
    # via the native Popover API. Positioning is handled via CSS anchor
    # positioning (modern Chromium / fallback-safe via position-try-fallbacks).
    #
    # Public API (slots):
    #   dropdown.trigger_button { ... }          fully custom trigger
    #   dropdown.trigger_button_content { ... }  content for the default button
    #   dropdown.menu_header { ... }             rendered above menu items
    #   dropdown.menu_content { ... }            rendered below menu items
    #   dropdown.with_menu_item(...) { ... }     individual menu rows
    #
    # When supplying a custom trigger, spread `trigger_attributes` into your
    # element so popovertarget, the anchor-name style, and the stimulus
    # button target are wired correctly.
    class Dropdown < ::Decor::Components::Dropdown
      MENU_POSITION_OPTIONS = [:aligned_to_left, :aligned_to_right].freeze
      prop :menu_position, _Union(*MENU_POSITION_OPTIONS), default: :aligned_to_left

      stimulus do
        targets :button, :menu
        values_from_props :content_href, :placeholder
      end

      def trigger_attributes
        {
          popovertarget: "#{id}-menu",
          id: "#{id}-menu-button",
          style: "anchor-name: #{resolved_anchor_name};",
          data: {**stimulus_target(:button)}
        }
      end

      def resolved_anchor_name
        @anchor_name || "--decor-suite-dropdown-anchor-#{id}"
      end

      def view_template(&)
        capture(&) if block_given?

        root_element do
          if @trigger_button.present?
            render @trigger_button
          else
            button(
              type: "button",
              id: "#{id}-menu-button",
              popovertarget: "#{id}-menu",
              style: "anchor-name: #{resolved_anchor_name};",
              class: button_class_string,
              data: {**stimulus_target(:button)}
            ) do
              span(class: "decor:sr-only") { "Open menu" }
              render @trigger_button_content if @trigger_button_content.present?
            end
          end

          div(
            id: "#{id}-menu",
            popover: "auto",
            class: menu_class_string,
            style: "--decor-suite-dropdown-anchor: #{resolved_anchor_name};",
            role: "menu",
            aria: {orientation: "vertical", labelledby: "#{id}-menu-button"},
            tabindex: "-1",
            data: {
              **stimulus_target(:menu),
              position: @menu_position.to_s,
              **stimulus_actions([:beforetoggle, :handle_before_toggle]).to_h
            }
          ) do
            render @menu_header if @menu_header.present?

            if @menu_items&.any?
              @menu_items.each { |item| render item }
            end

            render @menu_content if @menu_content.present?
          end
        end
      end

      private

      def root_element_classes
        "decor:relative"
      end

      def button_class_string
        active = @button_active_classes.map { |c| "aria-expanded:#{c}" }
        (@button_classes + active).join(" ")
      end

      def menu_class_string
        [
          "decor--suite--dropdown-menu",
          "decor:overflow-auto decor:focus:outline-hidden",
          (@dropdown_size_classes&.join(" ") || "decor:w-auto decor:max-h-80"),
          base_menu_classes,
          @menu_classes&.join(" ")
        ].compact.join(" ")
      end

      # Tight chrome: rounded-suite-control matches button radii; the popover
      # shadow utility is defined in decor.css alongside the anchor-positioning
      # rules.
      def base_menu_classes
        "decor:bg-white decor:border decor:border-suite-hairline-strong " \
          "decor:rounded-suite-control decor:shadow-suite-popover decor:p-1 decor:min-w-[180px]"
      end
    end
  end
end
