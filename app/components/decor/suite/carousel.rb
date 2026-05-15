# frozen_string_literal: true

module Decor
  module Suite
    # Suite skin of Carousel. Renders Swiper-compatible markup with Suite design
    # tokens for theming. Supports image slides (via `images:`) or arbitrary
    # content slides (via `with_slide`). Pre-init `hidden` class is stripped by
    # the Stimulus controller to prevent the stacked-slides flash.
    class Carousel < ::Decor::Components::Carousel
      def view_template(&)
        capture(&) if block_given?

        root_element do
          div(class: "swiper-wrapper decor:w-full decor:h-full") do
            @slides&.each do |slide|
              div(class: "swiper-slide") do
                render slide
              end
            end

            @images&.each do |slide|
              div(class: "swiper-slide") do
                img(
                  src: resolve_image_src(slide),
                  alt: slide[:alt].to_s,
                  class: image_classes,
                  style: @max_height.nil? ? nil : "max-height: #{@max_height}px;"
                )
              end
            end
          end

          if @show_pagination
            div(class: "swiper-pagination decor:relative decor:mt-3 decor:bottom-0!")
          end

          if @show_arrows
            button(
              type: "button",
              class: arrow_button_classes("swiper-button-prev decor:left-2"),
              "aria-label": "Previous slide"
            ) do
              render ::Decor::Icon.new(name: "chevron-left", width: 20, height: 20, stroke_width: 2)
            end
            button(
              type: "button",
              class: arrow_button_classes("swiper-button-next decor:right-2"),
              "aria-label": "Next slide"
            ) do
              render ::Decor::Icon.new(name: "chevron-right", width: 20, height: 20, stroke_width: 2)
            end
          end
        end
      end

      private

      # Accepts either:
      # - `url: "https://.../img.jpg"` or `url: "/static/logo.svg"` — passed
      #   through verbatim (absolute, CDN, or public-served).
      # - `path: "avatar-dark.png"` — resolved via Rails' `image_path` helper so
      #   the asset-pipeline fingerprint is applied.
      def resolve_image_src(slide)
        return slide[:url] if slide[:url].present?
        path = slide[:path].to_s
        return path if path.start_with?("http://", "https://", "/")
        helpers.image_path(path)
      end

      def root_element_attributes
        {
          element_tag: :section,
          html_options: {
            role: "region",
            "aria-roledescription": "carousel",
            "aria-label": @aria_label
          }
        }
      end

      def root_element_classes
        # `decor:hidden` is removed on Swiper init to prevent the pre-init
        # stacked-slides flash. Theme CSS vars override swiper-bundle.css
        # defaults with Suite tokens.
        [
          "decor:hidden decor:overflow-hidden decor:relative",
          "decor:[--swiper-theme-color:var(--color-suite-primary-500)]",
          "decor:[--swiper-pagination-color:var(--color-suite-primary-500)]",
          "decor:[--swiper-pagination-bullet-inactive-color:var(--color-gray-300)]",
          "decor:[--swiper-pagination-bullet-inactive-opacity:1]",
          "decor:[--swiper-pagination-bullet-size:7px]",
          "decor:[--swiper-pagination-bullet-horizontal-gap:4px]"
        ].join(" ")
      end

      def arrow_button_classes(extra)
        [
          # Swiper's default navigation CSS positions absolute at top:50% with a
          # negative margin; keep those defaults and only restyle chrome.
          "decor:absolute decor:top-1/2 decor:-mt-4 decor:z-20",
          "decor:flex decor:items-center decor:justify-center",
          "decor:w-8 decor:h-8 decor:rounded-full",
          "decor:bg-white decor:border decor:border-suite-hairline decor:shadow-md",
          "decor:text-gray-600 decor:hover:text-gray-900 decor:hover:bg-suite-gray-25",
          "decor:focus:outline-hidden",
          "decor:focus-visible:shadow-[0_0_0_3px_var(--color-suite-primary-100)]",
          "decor:transition-[background-color,color,box-shadow] decor:duration-suite-fast decor:ease-out",
          # Swiper applies `swiper-button-disabled` at carousel endpoints; dim it
          # and block clicks.
          "decor:[&.swiper-button-disabled]:opacity-40",
          "decor:[&.swiper-button-disabled]:cursor-not-allowed",
          # Suppress Swiper's default icon pseudo-element content — we render
          # our own <svg>. `after:content-none!` wins over swiper-bundle.css.
          "decor:after:content-none!",
          extra
        ].join(" ")
      end

      def image_classes
        if @max_height.nil?
          "decor:w-full"
        else
          "decor:w-auto decor:mx-auto"
        end
      end
    end
  end
end
