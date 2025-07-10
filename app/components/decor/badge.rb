# frozen_string_literal: true

module Decor
  class Badge < PhlexComponent
    no_stimulus_controller

    prop :label, _Nilable(String)

    prop :style, _Union(:warning, :info, :error, :standard, :success), default: :standard
    prop :size, _Union(:xs, :sm, :md, :lg), default: :md
    prop :variant, _Union(:outlined, :filled), default: :outlined
    prop :dashed, _Boolean, default: false

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

    def element_classes
      [
        "badge",
        style_classes,
        size_classes,
        variant_classes,
        dashed_classes
      ].compact.join(" ")
    end

    def view_template(&block)
      root_element do
        if @icon.present?
          render(
            ::Decor::Icon.new(
              name: @icon,
              variant: :solid,
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

    def size_classes
      case @size
      when :sm
        "badge-sm"
      when :lg
        "badge-lg"
      end
    end

    def style_classes
      case @style
      when :success
        "badge-success"
      when :error
        "badge-error"
      when :warning
        "badge-warning"
      when :info
        "badge-info"
      when :standard
        "badge-neutral"
      else
        "badge-neutral"
      end
    end

    def variant_classes
      (@variant == :outlined) ? "badge-outline" : nil
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
      end
    end

    def avatar_size
      case @size
      when :sm, :xs
        :xs
      when :md
        :sm
      else
        :md
      end
    end
  end
end
