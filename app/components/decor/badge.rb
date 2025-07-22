# frozen_string_literal: true

module Decor
  class Badge < PhlexComponent
    no_stimulus_controller

    prop :label, _Nilable(String)
    prop :dashed, _Boolean, default: false
    
    default_size :md
    default_style :outlined
    default_color :neutral

    prop :icon, _Nilable(String)

    # Optional avatar
    prop :url, _Nilable(String)
    prop :initials, _Nilable(String)

    private

    def root_element_attributes
      {
        element_tag: :span
      }
    end

    def root_element_classes
      [
        "badge",
        component_color_classes(@color),
        component_size_classes(@size),
        component_style_classes(@style),
        dashed_classes
      ].compact.join(" ")
    end

    def view_template(&block)
      root_element do
        if @icon.present?
          render(
            ::Decor::Icon.new(
              name: @icon,
              style: :solid,
              html_options: {class: "-ml-1 mr-1.5 #{icon_size_classes}"}
            )
          )
        end
        if @url || @initials
          render(
            ::Decor::Avatar.new(
              size: avatar_size,
              initials: @initials,
              url: @url,
              html_options: {style: "left: -11px", class: "mr-1 -mt-0.5"}
            )
          )
        end
        if @label
          plain(@label)
        elsif block_given?
          yield
        end
      end
    end

    def component_size_classes(size)
      case size
      when :xs then "badge-xs"
      when :sm then "badge-sm"
      when :md then [] # default size, no class needed
      when :lg then "badge-lg"
      when :xl then "badge-xl"
      else []
      end
    end

    def component_color_classes(color)
      case color
      when :base then "badge-base"
      when :primary then "badge-primary"
      when :secondary then "badge-secondary"
      when :accent then "badge-accent"
      when :success then "badge-success"
      when :error then "badge-error"
      when :warning then "badge-warning"
      when :info then "badge-info"
      when :neutral then "badge-neutral"
      else []
      end
    end

    def component_style_classes(style)
      case style
      when :outlined then "badge-outline"
      when :filled then [] # default filled, no class needed
      when :ghost then "badge-ghost"
      else []
      end
    end

    def dashed_classes
      @dashed ? "border-dashed" : nil
    end

    def icon_size_classes
      case @size
      when :xs
        "h-2.5 w-2.5"
      when :sm
        "h-3 w-3"
      when :md
        "h-3.5 w-3.5"
      when :lg
        "h-4.5 w-4.5"
      when :xl
        "h-5 w-5"
      end
    end

    def avatar_size
      case @size
      when :sm, :xs
        :xs
      when :md, :lg
        :sm
      else
        :md
      end
    end
  end
end
