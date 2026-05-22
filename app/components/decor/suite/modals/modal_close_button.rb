# frozen_string_literal: true

module Decor
  module Suite
    module Modals
      class ModalCloseButton < ::Decor::Components::Modals::ModalCloseButton
        def view_template(&)
          @content = capture(&) if block_given?
          root_element do
            span(class: "decor:inline-flex decor:items-center decor:gap-1.5") do
              if @icon
                icon_options = {name: @icon, html_options: {class: icon_classes}}
                icon_options[:variant] = @icon_variant if @icon_variant
                render ::Decor::Icon.new(**icon_options)
              elsif @content.blank? && @label.blank?
                render ::Decor::Icon.new(name: "x-mark", html_options: {class: icon_classes})
              end
              if @content.present?
                raw @content
              elsif @label.present?
                plain @label
              end
            end
          end
        end

        private

        def root_element_attributes
          {
            element_tag: :button,
            html_options: {
              type: "button",
              disabled: @disabled ? "disabled" : nil
            }
          }
        end

        def root_element_classes
          [
            "decor:inline-flex decor:items-center decor:justify-center decor:gap-1.5",
            "decor:whitespace-nowrap decor:font-medium",
            "decor:rounded-suite-control",
            "decor:transition-all decor:duration-suite-fast decor:ease-out",
            "decor:focus-visible:outline-hidden",
            "decor:focus-visible:shadow-[0_0_0_3px_var(--color-suite-primary-100)]",
            "decor:disabled:opacity-50 decor:disabled:cursor-not-allowed",
            *size_classes,
            *color_style_classes,
            modifier_classes
          ].compact.join(" ")
        end

        def size_classes
          case @size
          when :xs then ["decor:px-[9px] decor:py-1 decor:text-[11px] decor:leading-[1.2]"]
          when :sm then ["decor:px-[11px] decor:py-[5px] decor:text-xs decor:leading-[1.2]"]
          when :lg then ["decor:px-[18px] decor:py-[9px] decor:text-sm decor:h-[38px]"]
          when :xl then ["decor:px-5 decor:py-2.5 decor:text-base"]
          else ["decor:px-3.5 decor:py-[7px] decor:text-[13px] decor:leading-[1.2]"]
          end
        end

        def color_style_classes
          case @style
          when :outlined
            outlined_classes
          when :ghost
            ghost_classes
          else
            filled_classes
          end
        end

        def filled_classes
          case @color
          when :primary
            [
              "decor:bg-suite-primary-500 decor:text-white decor:border decor:border-transparent",
              "decor:hover:bg-suite-primary-700"
            ]
          when :error, :danger
            [
              "decor:bg-suite-danger-500 decor:text-white decor:border decor:border-transparent",
              "decor:hover:bg-suite-danger-700"
            ]
          when :warning
            [
              "decor:bg-suite-warning-50 decor:text-suite-warning-700 decor:border decor:border-transparent",
              "decor:hover:bg-suite-warning-100"
            ]
          when :success
            [
              "decor:bg-suite-success-500 decor:text-white decor:border decor:border-transparent",
              "decor:hover:bg-suite-success-700"
            ]
          else
            [
              "decor:bg-white decor:text-gray-700 decor:border decor:border-suite-hairline-strong",
              "decor:hover:bg-gray-50"
            ]
          end
        end

        def outlined_classes
          case @color
          when :error, :danger
            [
              "decor:bg-white decor:text-suite-danger-700 decor:border decor:border-suite-danger-100",
              "decor:hover:bg-suite-danger-50"
            ]
          when :primary
            [
              "decor:bg-white decor:text-suite-primary-700 decor:border decor:border-suite-primary-200",
              "decor:hover:bg-suite-primary-50"
            ]
          else
            [
              "decor:bg-white decor:text-gray-700 decor:border decor:border-suite-hairline-strong",
              "decor:hover:bg-gray-50"
            ]
          end
        end

        def ghost_classes
          case @color
          when :primary
            [
              "decor:bg-transparent decor:text-suite-primary-700 decor:border decor:border-transparent",
              "decor:hover:bg-suite-primary-50"
            ]
          when :error, :danger
            [
              "decor:bg-transparent decor:text-suite-danger-700 decor:border decor:border-transparent",
              "decor:hover:bg-suite-danger-50"
            ]
          else
            [
              "decor:bg-transparent decor:text-gray-700 decor:border decor:border-transparent",
              "decor:hover:bg-gray-100"
            ]
          end
        end

        def modifier_classes
          @full_width ? "decor:w-full decor:justify-center" : nil
        end

        def icon_classes
          sized =
            case @size
            when :xs then "decor:w-[11px] decor:h-[11px]"
            when :sm then "decor:w-3 decor:h-3"
            when :lg then "decor:w-[15px] decor:h-[15px]"
            when :xl then "decor:w-4 decor:h-4"
            else "decor:w-[13px] decor:h-[13px]"
            end
          "decor:inline-block decor:shrink-0 #{sized}"
        end
      end
    end
  end
end
