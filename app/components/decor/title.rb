# frozen_string_literal: true

module Decor
  # A title component with configurable size, optional icon, description, and CTA area
  class Title < PhlexComponent
    no_stimulus_controller

    prop :title, _Nilable(String)
    prop :description, _Nilable(String)
    prop :icon, _Nilable(String)
    
    default_size :md

    private

    def view_template(&)
      root_element do
        div(class: container_classes) do
          div(class: title_section_classes) do
            if @icon
              div(class: "flex items-start space-x-2") do
                render ::Decor::Icon.new(name: @icon, width: icon_size, height: icon_size, html_options: {class: "mt-1"})
                render_title_and_description
              end
            else
              render_title_and_description
            end
          end

          if block_given?
            div(class: actions_classes) do
              div(class: "flex items-center space-x-3") do
                yield
              end
            end
          end
        end
      end
    end

    def render_title_and_description
      div do
        send(title_tag, class: title_classes) { @title }
        p(class: description_classes) { @description } if @description
      end
    end

    def container_classes
      "flex justify-between items-center flex-wrap sm:flex-nowrap"
    end

    def title_section_classes
      "flex-1"
    end

    def actions_classes
      "flex-shrink-0"
    end

    def title_tag
      case @size
      when :xs
        :h5
      when :sm
        :h4
      when :md
        :h3
      when :lg
        :h2
      when :xl
        :h1
      end
    end

    def title_classes
      base_classes = "font-semibold text-base-content leading-tight"

      case @size
      when :xs
        "#{base_classes} text-sm"
      when :sm
        "#{base_classes} text-base"
      when :md
        "#{base_classes} text-lg"
      when :lg
        "#{base_classes} text-xl"
      when :xl
        "#{base_classes} text-2xl"
      end
    end

    def description_classes
      base_classes = "text-base-content/70 leading-relaxed"

      case @size
      when :xs
        "#{base_classes} text-xs mt-0.5"
      when :sm
        "#{base_classes} text-sm mt-1"
      when :md
        "#{base_classes} text-sm mt-1"
      when :lg
        "#{base_classes} text-base mt-1.5"
      when :xl
        "#{base_classes} text-lg mt-2"
      end
    end

    def icon_size
      case @size
      when :xs
        12
      when :sm
        14
      when :md
        16
      when :lg
        20
      when :xl
        24
      end
    end

    def root_element_classes
      case @size
      when :xs, :sm
        "space-y-1"
      when :md
        "space-y-2"
      when :lg, :xl
        "space-y-3"
      end
    end
  end
end
