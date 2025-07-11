# frozen_string_literal: true

module Decor
  class Page < PhlexComponent
    no_stimulus_controller

    prop :include_flash, _Boolean, default: true
    prop :full_height, _Boolean, default: false

    # Modern attributes following Decor patterns
    prop :size, _Union(:xs, :sm, :md, :lg, :xl), default: :md
    prop :background, _Union(:default, :primary, :secondary, :hero, :neutral), default: :default
    prop :padding, _Union(:none, :sm, :md, :lg, :xl), default: :md
    prop :spacing, _Union(:none, :sm, :md, :lg, :xl), default: :md

    # Manual slot implementations
    def with_hero(&block)
      @hero = block
    end

    def with_header(&block)
      @header = block
    end


    def with_tabs(&block)
      @tabs = block
    end


    def view_template
      content = capture { yield(self) } if block_given?
      root_element do
        render_hero if @hero

        if @header
          result = @header.call
          if result.is_a?(PhlexComponent)
            render result
          else
            plain result
          end
        end

        if @tabs
          div(class: tabs_wrapper_classes) do
            render @tabs
          end
        end

        div(class: content_area_classes) do
          if @include_flash
            render ::Decor::Flash.new(collapse_if_empty: true)
          end
          raw content if content
        end
      end
    end

    private

    def element_classes
      [
        "w-full",
        (@full_height ? "min-h-screen" : nil),
        padding_classes,
        "space-y-4",
        ((@background != :default) ? background_classes : nil)
      ].compact.join(" ")
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


    def background_classes
      case @background
      when :primary then "bg-primary/10"
      when :secondary then "bg-secondary/10"
      when :hero then "bg-base-200"
      when :neutral then "bg-neutral/10"
      end
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

  end
end
