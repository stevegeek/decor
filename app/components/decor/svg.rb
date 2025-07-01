# frozen_string_literal: true

module Decor
  # Requires the use of https://github.com/shubhamjain/svg-loader (external-svg-loader)
  # Add this to your application.js:
  # import "external-svg-loader";
  #
  class Svg < PhlexComponent
    no_stimulus_controller
    with_cache_key

    register_output_helper :inline_svg_tag

    attribute :inline, :boolean, default: true

    attribute :file_name, String, allow_nil: false
    attribute :title, String
    attribute :description, String

    attribute :size, Symbol, default: :md, in: [:xs, :sm, :md, :lg, :xl]

    attribute :width, Integer
    attribute :height, Integer

    def view_template
      if @inline
        raw inline_svg_tag(file_name, **svg_attributes)
      else
        svg(
          "data-src" => image_path(file_name),
          **svg_attributes
        ) {}
      end
    end

    private

    attr_reader :file_name

    def svg_attributes
      {
        id: @id,
        class: render_classes,
        title: @title,
        desc: @description,
        aria: true,
        aria_hidden: true,
        width: svg_width,
        height: svg_height,
        data: ::Vident::Phlex::RootComponent.new(
          **stimulus_options_for_component({})
        ).send(:tag_data_attributes)
      }
    end

    def svg_width
      @width || size_value
    end

    def svg_height
      @height || size_value
    end

    def size_value
      case @size
      when :xs then 16
      when :sm then 20
      when :md then 24
      when :lg then 28
      when :xl then 32
      end
    end

    def strip(output)
      output.strip.html_safe
    end
  end
end
