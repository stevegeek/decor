# frozen_string_literal: true

module Decor
  module Suite
    # Suite Banner — muted card-style chrome. Optional left icon, body content
    # via the bare block, optional "Learn more" link, and optional CTA slot.
    # Mirrors the Suite::Flash palette: suite-* numbered shades on a hairline-
    # bordered rounded-suite-card body with a content-max-width centered wrap.
    class Banner < ::Decor::Components::Banner
      prop :centered, _Boolean, default: true

      def view_template(&block)
        root_element do
          if @centered
            div(class: "decor:max-w-7xl decor:mx-auto") do
              render_body(&block)
            end
          else
            render_body(&block)
          end
        end
      end

      private

      def render_body(&block)
        div(class: body_classes) do
          if @icon
            render ::Decor::Icon.new(
              name: @icon,
              html_options: {class: "decor:shrink-0 decor:w-[18px] decor:h-[18px] #{icon_color_class}"}
            )
          end
          div(class: "decor:flex-1 decor:min-w-0") do
            yield if block_given?
          end
          if @link.present? || @call_to_action.present?
            div(class: "decor:shrink-0 decor:flex decor:gap-1.5 decor:items-center") do
              if @link.present?
                a(href: @link, class: link_classes) { plain "Learn more" }
              end
              if @call_to_action.present?
                render @call_to_action
              end
            end
          end
        end
      end

      def root_element_classes
        "decor:mb-4"
      end

      def body_classes
        "decor:flex decor:items-center decor:gap-3 decor:px-5 decor:py-3 decor:rounded-suite-card decor:border decor:suite-dense-body #{variant_classes}"
      end

      def variant_classes
        case @color
        when :success then "decor:bg-suite-success-50 decor:border-suite-success-100 decor:text-suite-success-700"
        when :error then "decor:bg-suite-danger-50 decor:border-suite-danger-100 decor:text-suite-danger-700"
        when :warning then "decor:bg-suite-warning-50 decor:border-suite-warning-100 decor:text-suite-warning-700"
        when :info, :primary then "decor:bg-suite-primary-50 decor:border-suite-primary-100 decor:text-suite-primary-700"
        else "decor:bg-suite-gray-25 decor:border-suite-hairline decor:text-gray-800"
        end
      end

      def icon_color_class
        case @color
        when :success then "decor:text-suite-success-600"
        when :error then "decor:text-suite-danger-600"
        when :warning then "decor:text-suite-warning-600"
        when :info, :primary then "decor:text-suite-primary-600"
        else "decor:text-gray-500"
        end
      end

      def link_classes
        "decor:font-semibold decor:no-underline decor:px-2.5 decor:py-1 decor:rounded-suite-control decor:bg-white/55 decor:hover:bg-white/85 decor:transition-colors decor:duration-suite-fast decor:suite-description"
      end
    end
  end
end
