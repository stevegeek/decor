# frozen_string_literal: true

module Decor
  module Daisy
    class Dropdown < ::Decor::Components::Dropdown
      def view_template(&)
        @content = capture(&) if block_given?

        root_element do |s|
          if @trigger_button.present?
            render @trigger_button
          else
            s.tag(
              :button,
              stimulus_target: :button,
              type: "button",
              tabindex: "0",
              role: "button",
              aria_haspopup: "true",
              aria_expanded: "false",
              # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
              class: dropdown_button_classes
            ) do
              if @trigger_button_content.present?
                render @trigger_button_content
              else
                plain "Menu"
              end
            end
          end

          if @card_content.present? || @custom_content.present?
            # Non-menu content (cards, custom elements)
            s.tag(
              :div,
              stimulus_target: :content,
              # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
              class: dropdown_content_classes_non_menu,
              role: "dialog",
              aria_labelledby: "#{id}-menu-button",
              tabindex: "-1"
            ) do
              render @card_content if @card_content.present?
              render @custom_content if @custom_content.present?
            end
          else
            # Traditional menu content
            s.tag(
              :ul,
              stimulus_target: :menu,
              tabindex: "0",
              # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
              class: dropdown_content_classes
            ) do
              render @menu_header if @menu_header.present?

              if @menu_items&.any?
                @menu_items.each do |item|
                  render item
                end
              end

              render @menu_content if @menu_content.present?
            end
          end

          raw @content if @content
        end
      end

      private

      def root_element_classes
        [
          "decor:d-dropdown",
          position_classes,
          trigger_classes,
          force_open_classes
        ].compact.join(" ")
      end

      def dropdown_button_classes
        [
          "decor:d-btn",
          size_classes,
          color_classes,
          style_button_classes,
          @button_classes
        ].compact.join(" ")
      end

      def dropdown_content_classes
        [
          "decor:d-dropdown-content",
          "decor:d-menu",
          "decor:bg-base-100",
          "decor:rounded-box",
          "decor:z-[1]",
          size_content_classes,
          "decor:p-2",
          "decor:shadow-sm",
          color_content_classes,
          style_content_classes
        ].compact.join(" ")
      end

      def position_classes
        case @position
        when :right, :end
          "decor:d-dropdown-end"
        when :top
          "decor:d-dropdown-top"
        when :bottom
          "decor:d-dropdown-bottom"
        when :center
          "decor:d-dropdown-center"
        when :start
          "decor:d-dropdown-start"
        else
          nil # :left is default and does not add a specific class
        end
      end

      def trigger_classes
        case @trigger
        when :hover then "decor:d-dropdown-hover"
        when :focus then nil # default CSS focus behavior
        else nil # default click behavior
        end
      end

      def force_open_classes
        case @force_open
        when :open then "decor:d-dropdown-open"
        when :closed then nil # forces closed state
        else nil # auto behavior
        end
      end

      def dropdown_content_classes_non_menu
        [
          "decor:d-dropdown-content",
          "decor:bg-base-100",
          "decor:rounded-box",
          "decor:z-[1]",
          size_content_classes,
          "decor:p-2",
          "decor:shadow-sm",
          color_content_classes,
          style_content_classes
        ].compact.join(" ")
      end

      def component_size_classes(size)
        case size
        when :xs then "decor:d-btn-xs"
        when :sm then "decor:d-btn-sm"
        when :lg then "decor:d-btn-lg"
        when :xl then "decor:d-btn-lg" # xl maps to lg for buttons
        else "" # md is default
        end
      end

      def component_color_classes(color)
        case color
        when :primary then "decor:d-btn-primary"
        when :secondary then "decor:d-btn-secondary"
        when :accent then "decor:d-btn-accent"
        when :success then "decor:d-btn-success"
        when :error then "decor:d-btn-error"
        when :warning then "decor:d-btn-warning"
        when :info then "decor:d-btn-info"
        when :neutral then "decor:d-btn-neutral"
        else "" # base is default
        end
      end

      def style_button_classes
        case @style
        when :outlined then "decor:d-btn-outline"
        when :filled then nil # default filled style
        else nil # default
        end
      end

      def size_content_classes
        case @size
        when :xs then "decor:w-32"
        when :sm then "decor:w-40"
        when :lg then "decor:w-64"
        when :xl then "decor:w-80"
        else "decor:w-52" # md is default
        end
      end

      def color_content_classes
        case @color
        when :primary then "decor:bg-primary decor:text-primary-content"
        when :secondary then "decor:bg-secondary decor:text-secondary-content"
        when :accent then "decor:bg-accent decor:text-accent-content"
        when :success then "decor:bg-success decor:text-success-content"
        when :error then "decor:bg-error decor:text-error-content"
        when :warning then "decor:bg-warning decor:text-warning-content"
        when :info then "decor:bg-info decor:text-info-content"
        when :neutral then "decor:bg-neutral decor:text-neutral-content"
        else nil # base is default
        end
      end

      def style_content_classes
        case @style
        when :outlined then "decor:border decor:border-base-300"
        when :filled then "decor:bg-base-200"
        else nil # default
        end
      end
    end
  end
end
