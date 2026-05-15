# frozen_string_literal: true

module Decor
  module Suite
    # Suite DropdownItem — single menu row rendered inside a Suite Dropdown.
    #
    # Variants (mutually exclusive):
    #   :separator     thin horizontal divider
    #   :section_label uppercase caption row, non-interactive
    #   :danger        item styled with danger tokens
    #   (default)      regular menu row
    #
    # Optional `:icon_name` renders a 14px icon on the left. Optional
    # `:shortcut` renders monospaced keyboard text on the right.
    class DropdownItem < ::Decor::Components::DropdownItem
      def view_template(&)
        @content = capture(&) if block_given?

        root_element do
          next if @separator

          if @section_label
            if @text.present?
              plain @text.to_s
            elsif @content.present?
              raw safe(@content)
            end
          else
            if @icon_name.present? || @icon_name == ""
              render ::Decor::Icon.new(name: @icon_name, classes: icon_classes) unless @icon_name == ""
            end
            if @text.present?
              plain @text.to_s
            elsif @content.present?
              raw safe(@content)
            end
            if @shortcut.present?
              span(class: "decor:ml-auto decor:suite-caption decor:text-gray-400 decor:font-mono") do
                plain @shortcut.to_s
              end
            end
          end
        end
      end

      private

      def root_element_attributes
        # Emit both UJS (data-method, data-confirm) and Turbo (data-turbo-method,
        # data-turbo-confirm) so items work under either driver depending on
        # whether a data-turbo="true" ancestor is present.
        data_attrs = @http_method ? {method: @http_method, turbo_method: @http_method} : {}
        data_attrs.merge!(@data) if @data.present?
        if data_attrs[:confirm] && !data_attrs[:turbo_confirm] && !data_attrs["turbo-confirm"]
          data_attrs[:turbo_confirm] = data_attrs[:confirm]
        end

        if @separator || @section_label
          {element_tag: :div, html_options: {}}
        else
          {
            element_tag: :a,
            html_options: {
              href: @href,
              role: "menuitem",
              tabindex: @tabindex,
              data: data_attrs
            }
          }
        end
      end

      def root_element_classes
        if @separator
          "decor:h-px decor:bg-suite-hairline decor:my-1 decor:-mx-1"
        elsif @section_label
          "decor:px-2 decor:pt-1.5 decor:pb-1 decor:suite-caption decor:text-gray-500"
        elsif @danger
          "#{base_item_classes} decor:text-suite-danger-700 decor:hover:bg-suite-danger-50"
        else
          "#{base_item_classes} decor:text-gray-900 decor:hover:bg-gray-100"
        end
      end

      def icon_classes
        base = "decor:w-[14px] decor:h-[14px] decor:shrink-0"
        @danger ? "#{base} decor:text-suite-danger-600" : "#{base} decor:text-gray-500"
      end

      def base_item_classes
        "decor:flex decor:items-center decor:gap-2 decor:px-2 decor:py-1.5 " \
          "decor:rounded-suite-control decor:suite-description decor:cursor-pointer " \
          "decor:transition-colors decor:duration-suite-fast"
      end
    end
  end
end
