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
          "dropdown",
          position_classes,
          trigger_classes,
          force_open_classes
        ].compact.join(" ")
      end

      def dropdown_button_classes
        [
          "btn",
          size_classes,
          color_classes,
          style_button_classes,
          @button_classes
        ].compact.join(" ")
      end

      def dropdown_content_classes
        [
          "dropdown-content",
          "menu",
          "bg-base-100",
          "rounded-box",
          "z-[1]",
          size_content_classes,
          "p-2",
          "shadow-sm",
          color_content_classes,
          style_content_classes
        ].compact.join(" ")
      end

      def position_classes
        case @position
        when :right, :end
          "dropdown-end"
        when :top
          "dropdown-top"
        when :bottom
          "dropdown-bottom"
        when :center
          "dropdown-center"
        when :start
          "dropdown-start"
        else
          nil # :left is default and does not add a specific class
        end
      end

      def trigger_classes
        case @trigger
        when :hover then "dropdown-hover"
        when :focus then nil # default CSS focus behavior
        else nil # default click behavior
        end
      end

      def force_open_classes
        case @force_open
        when :open then "dropdown-open"
        when :closed then nil # forces closed state
        else nil # auto behavior
        end
      end

      def dropdown_content_classes_non_menu
        [
          "dropdown-content",
          "bg-base-100",
          "rounded-box",
          "z-[1]",
          size_content_classes,
          "p-2",
          "shadow-sm",
          color_content_classes,
          style_content_classes
        ].compact.join(" ")
      end

      def component_size_classes(size)
        case size
        when :xs then "btn-xs"
        when :sm then "btn-sm"
        when :lg then "btn-lg"
        when :xl then "btn-lg" # xl maps to lg for buttons
        else "" # md is default
        end
      end

      def component_color_classes(color)
        case color
        when :primary then "btn-primary"
        when :secondary then "btn-secondary"
        when :accent then "btn-accent"
        when :success then "btn-success"
        when :error then "btn-error"
        when :warning then "btn-warning"
        when :info then "btn-info"
        when :neutral then "btn-neutral"
        else "" # base is default
        end
      end

      def style_button_classes
        case @style
        when :outlined then "btn-outline"
        when :filled then nil # default filled style
        else nil # default
        end
      end

      def size_content_classes
        case @size
        when :xs then "w-32"
        when :sm then "w-40"
        when :lg then "w-64"
        when :xl then "w-80"
        else "w-52" # md is default
        end
      end

      def color_content_classes
        case @color
        when :primary then "bg-primary text-primary-content"
        when :secondary then "bg-secondary text-secondary-content"
        when :accent then "bg-accent text-accent-content"
        when :success then "bg-success text-success-content"
        when :error then "bg-error text-error-content"
        when :warning then "bg-warning text-warning-content"
        when :info then "bg-info text-info-content"
        when :neutral then "bg-neutral text-neutral-content"
        else nil # base is default
        end
      end

      def style_content_classes
        case @style
        when :outlined then "border border-base-300"
        when :filled then "bg-base-200"
        else nil # default
        end
      end
    end
  end
end
