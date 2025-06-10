# frozen_string_literal: true

module Decor
  # Requires the use of https://github.com/shubhamjain/svg-loader (external-svg-loader)
  # Add this to your application.js:
  # import "external-svg-loader";
  #
  class Svg < PhlexComponent
    no_stimulus_controller
    with_cache_key

    attribute :inline, :boolean, default: true

    attribute :name, String, allow_blank: false
    attribute :title, String
    attribute :description, String

    attribute :width, Integer
    attribute :height, Integer

    def view_template
      if @inline
        # TODO: strip is now part of inline_svg_tag, https://github.com/jamesmartin/inline_svg/pull/150
        raw strip(helpers.inline_svg_tag(file_name, **svg_attributes))
      else
        svg(
          "data-src" => helpers.image_path(file_name),
          **svg_attributes
        ) {}
      end
    end

    private

    def svg_attributes
      {
        id: @id,
        class: render_classes,
        title: @title,
        desc: @description,
        aria: true,
        aria_hidden: true,
        width: @width,
        height: @height,
        data: ::Vident::ViewComponent::RootComponent.new(
          **stimulus_options_for_component({})
        ).send(:tag_data_attributes)
      }
    end

    def file_name
      "svgs/#{@name}.svg"
    end

    def strip(output)
      output.strip.html_safe
    end
  end
end
