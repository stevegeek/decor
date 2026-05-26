# frozen_string_literal: true

module Decor
  module Daisy
    class PageSection < ::Decor::Components::PageSection
      def view_template
        root_element do
          render_slot(@hero) if @hero

          div(class: header_wrapper_classes) do
            div(class: content_wrapper_classes) do
              if @title.present?
                h3(class: title_classes) do
                  @title
                end
              end
              if @description.present? || tags.any?
                p(class: description_classes) do
                  tags.each do |tag|
                    render tag
                  end
                  plain @description if @description.present?
                end
              end
            end
            if @cta
              render_slot(@cta)
            end
          end

          div(class: content_area_classes) do
            yield if block_given?
          end
        end
      end

      private

      def root_element_classes
        classes = []
        classes << "decor:space-y-4"
        if @background != :default
          classes << background_classes
          classes << "decor:p-6 decor:rounded-lg"
        else
          classes << padding_bottom_classes
        end
        classes.compact.join(" ")
      end

      def header_wrapper_classes
        classes = ["decor:sm:flex", "decor:justify-between", "decor:items-center", "decor:lg:flex-nowrap", "decor:lg:space-x-3"]
        classes << header_padding_classes if has_header_content? && @separator
        classes << separator_classes if @separator
        classes.compact.join(" ")
      end

      def content_wrapper_classes
        @cta.present? ? "decor:pr-4 decor:pb-4 decor:sm:pb-0" : ""
      end

      def title_classes
        classes = ["decor:font-medium", "decor:text-base-content"]
        classes << title_size_classes
        classes.join(" ")
      end

      def description_classes
        classes = ["decor:text-base-content/70"]
        classes << description_size_classes
        classes << "decor:mt-2" if @title.present?
        classes.join(" ")
      end

      def content_area_classes
        case @size
        when :xs then "decor:space-y-4"
        when :sm then "decor:space-y-5"
        when :md then "decor:space-y-6"
        when :lg then "decor:space-y-8"
        when :xl then "decor:space-y-10"
        end
      end

      def padding_bottom_classes
        case @padding
        when :none then nil
        when :sm then "decor:pb-4"
        when :md then "decor:pb-6"
        when :lg then "decor:pb-8"
        when :xl then "decor:pb-10"
        end
      end

      def header_padding_classes
        case @size
        when :xs then "decor:pb-3"
        when :sm then "decor:pb-4"
        when :md then "decor:pb-5"
        when :lg then "decor:pb-6"
        when :xl then "decor:pb-8"
        end
      end

      def separator_classes
        "decor:border-b decor:border-base-300"
      end

      def title_size_classes
        case @size
        when :xs then "decor:text-sm decor:leading-5"
        when :sm then "decor:text-base decor:leading-5"
        when :md then "decor:text-lg decor:leading-6"
        when :lg then "decor:text-xl decor:leading-7"
        when :xl then "decor:text-2xl decor:leading-8"
        end
      end

      def description_size_classes
        case @size
        when :xs then "decor:text-xs"
        when :sm then "decor:text-sm"
        when :md then "decor:text-sm"
        when :lg then "decor:text-base"
        when :xl then "decor:text-lg"
        end
      end

      def background_classes
        case @background
        when :primary then "decor:bg-primary/10"
        when :secondary then "decor:bg-secondary/10"
        when :neutral then "decor:bg-neutral/10"
        end
      end
    end
  end
end
