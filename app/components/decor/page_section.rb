# frozen_string_literal: true

module Decor
  # A PageSection is a part of the page that visually separates sections
  class PageSection < PhlexComponent
    no_stimulus_controller

    attribute :title, String
    attribute :description, String
    attribute :separator, :boolean, default: false

    # Modern attributes following Decor patterns
    attribute :size, Symbol, default: :md, in: [:xs, :sm, :md, :lg, :xl]
    attribute :background, Symbol, default: :default, in: [:default, :primary, :secondary, :neutral]
    attribute :padding, Symbol, default: :md, in: [:none, :sm, :md, :lg, :xl]

    # Manual slot implementations for Phlex
    def with_hero(&block)
      @hero = block
    end

    def with_cta(&block)
      @cta = block
    end

    # Manual many implementation for tags
    def with_tag(**attributes)
      @tags ||= []
      @tags << ::Decor::Tag.new(**attributes)
    end

    def tags
      @tags ||= []
    end

    # Convenience method to check if hero slot is present
    def hero_slot
      @hero
    end

    # Convenience method to check if cta slot is present
    def cta_slot
      @cta
    end

    def view_template
      render parent_element do
        # Render hero slot if present
        if @hero
          result = @hero.call
          plain result if result.is_a?(String)
        end

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
          # Render cta slot if present
          if @cta
            result = @cta.call
            plain result if result.is_a?(String)
          end
        end

        div(class: content_area_classes) do
          yield if block_given?
        end
      end
    end

    private

    def element_classes
      classes = []
      classes << "space-y-4"
      if @background != :default
        classes << background_classes
        classes << "p-6 rounded-lg" # Add padding and rounding when background is applied
      else
        classes << padding_bottom_classes
      end
      classes.compact.join(" ")
    end

    def header_wrapper_classes
      classes = ["sm:flex", "justify-between", "items-center", "lg:flex-nowrap", "lg:space-x-3"]
      classes << header_padding_classes if has_header_content? && @separator
      classes << separator_classes if @separator
      classes.compact.join(" ")
    end

    def content_wrapper_classes
      @cta.present? ? "pr-4 pb-4 sm:pb-0" : ""
    end

    def title_classes
      classes = ["font-medium", "text-base-content"]
      classes << title_size_classes
      classes.join(" ")
    end

    def description_classes
      classes = ["text-base-content/70"]
      classes << description_size_classes
      classes << "mt-2" if @title.present?
      classes.join(" ")
    end

    def content_area_classes
      case @size
      when :xs then "space-y-4"
      when :sm then "space-y-5"
      when :md then "space-y-6"
      when :lg then "space-y-8"
      when :xl then "space-y-10"
      end
    end

    def padding_bottom_classes
      case @padding
      when :none then nil
      when :sm then "pb-4"
      when :md then "pb-6"
      when :lg then "pb-8"
      when :xl then "pb-10"
      end
    end

    def header_padding_classes
      case @size
      when :xs then "pb-3"
      when :sm then "pb-4"
      when :md then "pb-5"
      when :lg then "pb-6"
      when :xl then "pb-8"
      end
    end

    def separator_classes
      "border-b border-base-300"
    end

    def title_size_classes
      case @size
      when :xs then "text-sm leading-5"
      when :sm then "text-base leading-5"
      when :md then "text-lg leading-6"
      when :lg then "text-xl leading-7"
      when :xl then "text-2xl leading-8"
      end
    end

    def description_size_classes
      case @size
      when :xs then "text-xs"
      when :sm then "text-sm"
      when :md then "text-sm"
      when :lg then "text-base"
      when :xl then "text-lg"
      end
    end

    def background_classes
      case @background
      when :primary then "bg-primary/10"
      when :secondary then "bg-secondary/10"
      when :neutral then "bg-neutral/10"
      end
    end

    def has_header_content?
      @title.present? || @description.present? || tags.any?
    end
  end
end
