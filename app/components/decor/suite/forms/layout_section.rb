# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      # Suite LayoutSection — wraps a group of form fields under an optional
      # heading + helper text. Sits inside a LayoutContainer; the container
      # owns the outer card chrome and the section paints a horizontal
      # hairline at the bottom (suppressed on the last sibling).
      #
      # Slots:
      # - `with_hero { ... }` — full-width content rendered above the heading
      #   (e.g. a banner or hero image).
      # - `with_cta { ... }` — right-aligned actions on the heading row.
      # - Block content — the form fields. Rendered inside a fields-region
      #   wrapper that lays the fields out either stacked (one per row) or
      #   in a flexible grid. Pass `custom_content_wrapper: true` to skip
      #   the wrapper entirely.
      class LayoutSection < ::Decor::Components::Forms::LayoutSection
        def view_template(&)
          @content = capture(&) if block_given?

          root_element do
            render @hero if @hero.present?

            if @flash
              render ::Decor::Suite::Flash.new(
                text: @flash_message,
                collapse_if_empty: true,
                flash_data: nil,
                html_options: {class: "decor:mb-4"}
              )
            end

            if @title.present? || @description.present? || @cta.present?
              div(class: "decor:flex decor:flex-wrap decor:items-start decor:justify-between decor:gap-3 decor:mb-4") do
                div do
                  if @title.present?
                    h3(class: "decor:suite-section-title decor:suite-section-title-d decor:text-gray-900 decor:m-0") { @title }
                  end
                  if @description.present?
                    p(class: "decor:suite-field-help decor:text-gray-500 decor:mx-0 decor:mb-0") { @description }
                  end
                end
                render @cta if @cta.present?
              end
            end

            if @custom_content_wrapper
              raw safe(@content) if @content.present?
            elsif @content.present?
              div(class: fields_region_classes) { raw safe(@content) }
            end
          end
        end

        private

        def root_element_attributes
          {element_tag: :section}
        end

        def root_element_classes
          "decor:suite-section-pad decor:border-b decor:border-suite-hairline decor:last-of-type:border-b-0"
        end

        def fields_region_classes
          if @stacked
            "decor:flex decor:flex-col decor:suite-section-gap"
          else
            "decor:flex decor:flex-wrap decor:suite-grid-gap"
          end
        end
      end
    end
  end
end
