# frozen_string_literal: true

module Decor
  module Suite
    # Suite Banner — muted card-style chrome. Optional left icon, body content
    # via the bare block, optional "Learn more" link, and optional CTA slot.
    # Mirrors the Suite::Flash palette: bg-{color}/10 + border-{color}/30 on
    # a hairline-bordered rounded body, with a content-max-width centered wrap.
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
        "decor:flex decor:items-center decor:gap-3 decor:px-5 decor:py-3 decor:rounded-md decor:border decor:text-sm #{variant_classes}"
      end

      def variant_classes
        case @color
        when :success then "decor:bg-success/10 decor:border-success/30 decor:text-success"
        when :error then "decor:bg-error/10 decor:border-error/30 decor:text-error"
        when :warning then "decor:bg-warning/10 decor:border-warning/30 decor:text-warning"
        when :info, :primary then "decor:bg-info/10 decor:border-info/30 decor:text-info"
        else "decor:bg-base-200 decor:border-black/15 decor:text-base-content"
        end
      end

      def icon_color_class
        case @color
        when :success then "decor:text-success"
        when :error then "decor:text-error"
        when :warning then "decor:text-warning"
        when :info, :primary then "decor:text-info"
        else "decor:text-base-content/60"
        end
      end

      def link_classes
        "decor:font-semibold decor:no-underline decor:px-2.5 decor:py-1 decor:rounded-md decor:bg-base-100/55 decor:hover:bg-base-100/85 decor:transition-colors decor:duration-150 decor:text-xs"
      end
    end
  end
end
