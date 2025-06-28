# frozen_string_literal: true

module Decor
  class Page < PhlexComponent
    no_stimulus_controller

    attribute :title, String
    attribute :subtitle, String
    attribute :description, String
    attribute :include_flash, :boolean, default: true
    attribute :cta_snap_large, :boolean, default: false
    attribute :full_height, :boolean, default: false

    # Modern attributes following Decor patterns
    attribute :size, Symbol, default: :md, in: [:xs, :sm, :md, :lg, :xl]
    attribute :background, Symbol, default: :default, in: [:default, :primary, :secondary, :hero, :neutral]
    attribute :padding, Symbol, default: :md, in: [:none, :sm, :md, :lg, :xl]
    attribute :spacing, Symbol, default: :md, in: [:none, :sm, :md, :lg, :xl]

    # Manual slot implementations
    def with_hero(&block)
      @hero = block
    end

    def with_header(&block)
      @header = block
    end

    def with_cta(&block)
      @cta = block
    end

    def with_tabs(&block)
      @tabs = block
    end

    def with_body(&block)
      @body = block
    end

    # Manual many relationship implementations
    def with_badge(**attributes, &block)
      @badges ||= []
      badge = ::Decor::Badge.new(**attributes)
      @badges << badge
      badge
    end

    def with_tag(**attributes, &block)
      @tags ||= []
      tag = ::Decor::Tag.new(**attributes)
      @tags << tag
      tag
    end

    def view_template
      render parent_element do
        render_hero if @hero

        if has_header_content?
          header(class: header_classes) do
            if @header
              result = capture { @header.call }
              plain result
            else
              div(class: header_content_wrapper_classes) do
                div(class: "sm:flex items-center sm:space-x-3") do
                  if @title.present?
                    h3(class: title_classes) { @title }
                  end

                  @badges&.each do |badge|
                    render badge
                  end
                end

                if @subtitle.present?
                  h4(class: subtitle_classes) { @subtitle }
                end

                div(class: "sm:flex items-center sm:space-x-3") do
                  if @description.present?
                    p(class: description_classes) { @description }
                  end

                  @tags&.each do |tag|
                    render tag
                  end
                end
              end
            end

            div(class: cta_wrapper_classes) do
              render_cta if @cta
            end
          end
        end

        if @tabs
          div(class: tabs_wrapper_classes) do
            result = capture { @tabs.call }
            plain result
          end
        end

        div(class: content_area_classes) do
          if @include_flash
            render ::Decor::Flash.new(collapse_if_empty: true)
          end

          if @body
            result = capture { @body.call }
            plain result
          elsif block_given?
            yield
          end
        end
      end
    end

    private

    def element_classes
      [
        (@full_height ? "min-h-screen" : nil),
        padding_classes,
        "space-y-4",
        ((@background != :default) ? background_classes : nil)
      ].compact.join(" ")
    end

    def header_classes
      classes = ["bg-base-100"]
      classes << (@cta_snap_large ? "xl:flex" : "md:flex")
      classes << (@cta_snap_large ? "xl:items-center" : "md:items-center")
      classes << (@cta_snap_large ? "xl:justify-between" : "md:justify-between")
      classes << header_border_classes unless @tabs
      classes.join(" ")
    end

    def header_content_wrapper_classes
      classes = ["space-y-2.5"]
      classes << (@cta_snap_large ? "xl:pr-6" : "md:pr-6")
      classes << "pb-4 sm:pb-0 border-b sm:border-b-0 border-base-300"
      classes.join(" ")
    end

    def title_classes
      classes = ["text-base-content", "font-medium"]
      classes << title_size_classes
      classes.join(" ")
    end

    def subtitle_classes
      classes = ["py-2 sm:py-0", "text-base-content/70"]
      classes << subtitle_size_classes
      classes.join(" ")
    end

    def description_classes
      classes = ["text-base-content/70"]
      classes << description_size_classes
      classes.join(" ")
    end

    def cta_wrapper_classes
      classes = ["mt-4"]
      classes << (@cta_snap_large ? "xl:mt-0" : "md:mt-0")
      classes.join(" ")
    end

    def tabs_wrapper_classes
      case @spacing
      when :none then ""
      when :sm then "pb-2"
      when :md then "pb-4"
      when :lg then "pb-6"
      when :xl then "pb-8"
      end
    end

    def content_area_classes
      case @spacing
      when :none then "space-y-4"
      when :sm then "space-y-6"
      when :md then "space-y-8"
      when :lg then "space-y-10"
      when :xl then "space-y-12"
      end
    end

    def padding_classes
      case @padding
      when :none then ""
      when :sm then "py-4"
      when :md then "py-8"
      when :lg then "py-12"
      when :xl then "py-16"
      end
    end

    def header_border_classes
      case @spacing
      when :none then ""
      when :sm then "pb-2 border-b border-base-300"
      when :md then "pb-4 border-b border-base-300"
      when :lg then "pb-6 border-b border-base-300"
      when :xl then "pb-8 border-b border-base-300"
      end
    end

    def title_size_classes
      case @size
      when :xs then "text-sm"
      when :sm then "text-base"
      when :md then "text-lg"
      when :lg then "text-xl"
      when :xl then "text-2xl"
      end
    end

    def subtitle_size_classes
      case @size
      when :xs then "text-xs"
      when :sm then "text-xs"
      when :md then "text-xs"
      when :lg then "text-sm"
      when :xl then "text-base"
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
      when :hero then "bg-base-200"
      when :neutral then "bg-neutral/10"
      end
    end

    def has_header_content?
      @header || @title.present? || @description.present? || @cta || @tags&.any? || @badges&.any?
    end

    def render_hero
      if @background != :default
        div(class: "mx-[-1.5rem] mt-[-2rem] mb-4 px-6 py-8 #{background_classes}") do
          result = capture { @hero.call }
          plain result
        end
      else
        result = capture { @hero.call }
        plain result
      end
    end

    def render_cta
      result = capture { @cta.call }
      plain result
    end
  end
end
