# frozen_string_literal: true

module Decor
  module Suite
    class PageSection < ::Decor::Components::PageSection
      # Override base to use Suite-skinned tags.
      def with_tag(**attributes)
        @tags ||= []
        @tags << ::Decor::Suite::Tag.new(**attributes)
      end

      def view_template(&)
        root_element do
          if @hero
            result = @hero.call
            plain result if result.is_a?(String)
          end

          if has_header_content? || @cta
            div(class: header_classes) do
              div(class: content_wrapper_classes) do
                if @title.present?
                  h3(class: title_classes) { plain @title }
                end
                if @description.present? || tags.any?
                  div(class: description_wrapper_classes) do
                    tags.each { |tag| render tag }
                    if @description.present?
                      p(class: description_classes) { plain @description }
                    end
                  end
                end
              end
              if @cta
                div(class: "decor:shrink-0 decor:flex decor:gap-2 decor:items-center") do
                  result = @cta.call
                  plain result if result.is_a?(String)
                end
              end
            end
          end

          if block_given?
            div(class: body_classes, &)
          end
        end
      end

      private

      def root_element_classes
        [
          "decor:bg-white decor:border decor:border-suite-hairline decor:rounded-suite-card decor:overflow-hidden",
          background_overlay_classes
        ].compact.join(" ")
      end

      def header_classes
        [
          "decor:suite-section-pad",
          "decor:flex decor:items-start decor:justify-between decor:gap-4"
        ].join(" ")
      end

      def content_wrapper_classes
        "decor:flex-1 decor:min-w-0"
      end

      def title_classes
        "decor:suite-section-title decor:text-gray-900 decor:m-0"
      end

      def description_wrapper_classes
        classes = ["decor:flex decor:flex-wrap decor:items-center decor:gap-2"]
        classes << "decor:mt-1.5" if @title.present?
        classes.join(" ")
      end

      def description_classes
        "decor:suite-description decor:text-gray-500 decor:m-0"
      end

      def body_classes
        [
          body_padding_classes,
          separator_classes,
          content_gap_classes
        ].compact.join(" ")
      end

      def body_padding_classes
        case @padding
        when :none then nil
        else "decor:suite-section-pad"
        end
      end

      def separator_classes
        return nil unless @separator && has_header_content?
        "decor:border-t decor:border-suite-hairline"
      end

      def content_gap_classes
        # Body's internal vertical rhythm. Suite-section-gap is the density-aware
        # default; @size lets callers tune denser/looser stacks.
        case @size
        when :xs then "decor:flex decor:flex-col decor:gap-3"
        when :sm then "decor:flex decor:flex-col decor:gap-4"
        when :md then "decor:flex decor:flex-col decor:suite-section-gap"
        when :lg then "decor:flex decor:flex-col decor:gap-6"
        when :xl then "decor:flex decor:flex-col decor:gap-8"
        end
      end

      def background_overlay_classes
        case @background
        when :primary then "decor:bg-suite-primary-50"
        when :secondary then "decor:bg-gray-50"
        when :neutral then "decor:bg-suite-gray-25"
        end
      end
    end
  end
end
