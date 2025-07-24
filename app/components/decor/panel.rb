# frozen_string_literal: true

module Decor
  class Panel < PhlexComponent
    include Decor::Concerns::StyleColorClasses

    no_stimulus_controller

    prop :title, String
    prop :icon, _Nilable(String)

    default_size :md
    default_color :base
    default_style :filled

    def view_template(&)
      root_element do
        render ::Decor::Title.new(
          title: @title,
          icon: @icon,
          size: :sm
        )

        div(class: "mt-1.5 text-sm", &)
      end
    end

    private

    def root_element_classes
      classes = ["space-y-2"]
      classes << size_classes
      classes << style_classes
      classes.compact.join(" ")
    end

    def component_size_classes(size)
      case size
      when :xs then "p-2 text-xs"
      when :sm then "p-3 text-sm"
      when :md then "p-4 text-base"
      when :lg then "p-6 text-lg"
      when :xl then "p-8 text-xl"
      else
        ""
      end
    end

    def component_style_classes(style)
      # Override the base implementation to add panel-specific styling
      case style
      when :filled
        "#{filled_color_classes(@color)} rounded-box border border-base-300"
      when :outlined
        "#{outline_color_classes(@color)} bg-base-100 rounded-box"
      when :ghost
        "#{ghost_color_classes(@color)} rounded-box"
      else
        ""
      end
    end
  end
end
