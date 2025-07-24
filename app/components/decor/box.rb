# frozen_string_literal: true

module Decor
  class Box < PhlexComponent
    include Decor::Concerns::StyleColorClasses

    no_stimulus_controller

    prop :title, _Nilable(String)
    prop :description, _Nilable(String)

    default_size :md
    default_color :base
    default_style :outlined

    def html_title(&block)
      @html_title = block
    end

    def left(&block)
      @left = block
    end

    def right(&block)
      @right = block
    end

    def right?
      @right.present?
    end

    private

    def view_template(&)
      @content = capture(&) if block_given?

      root_element do
        div(class: "card-body") do
          if @left.present? && @right.present?
            div(class: "flex justify-between items-start") do
              div(class: "flex-1") do
                render @left
              end
              div(class: "flex-none") do
                render @right
              end
            end
          elsif @left.present?
            render @left
          else
            if @title.present? || @html_title.present?
              h2(class: "card-title") do
                if @html_title.present?
                  render @html_title
                else
                  plain(@title)
                end
              end
            end

            if @description.present?
              p(class: "text-base-content/70") do
                plain(@description)
              end
            end

            if @right.present?
              render @right
            elsif block_given?
              div do
                @content.html_safe
              end
            end
          end
        end
      end
    end

    def root_element_classes
      classes = ["card", "card-bordered"]
      classes << size_classes
      classes << style_classes
      classes.compact.join(" ")
    end

    def component_size_classes(size)
      case size
      when :xs then "card-xs"
      when :sm then "card-sm"
      when :md then "card-md"
      when :lg then "card-lg"
      when :xl then "card-xl"
      else
        ""
      end
    end

    def component_style_classes(style)
      # Override the base implementation to add box-specific styling
      case style
      when :filled
        "#{filled_color_classes(@color)} shadow-sm"
      when :outlined
        "#{outline_color_classes(@color)} bg-base-100"
      when :ghost
        "#{ghost_color_classes(@color)} shadow-none"
      else
        ""
      end
    end
  end
end
