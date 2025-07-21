# frozen_string_literal: true

module Decor
  # CardHeader provides structured header content for cards with title, subtitle, icon, and actions
  class CardHeader < PhlexComponent
    no_stimulus_controller

    # Content attributes
    prop :title, _Nilable(String)
    prop :subtitle, _Nilable(String)
    prop :icon, _Nilable(String)

    # Visual attributes
    default_size :md

    # Slots for flexible content
    def with_actions(&block)
      @actions_content = block
    end

    def with_meta(&block)
      @meta_content = block
    end

    private

    def view_template(&)
      vanish(&)
      root_element do
        div(class: "flex items-start justify-between") do
          # Left side: icon, title, and subtitle
          div(class: "flex items-start gap-3 min-w-0 flex-1") do
            render_icon if @icon.present?
            render_title_section
          end

          # Right side: actions
          render_actions if @actions_content
        end

        # Meta content below if provided
        render_meta if @meta_content
      end
    end

    def root_element_classes
      "card-header"
    end

    def render_icon
      div(class: "flex-shrink-0 mt-1") do
        render Decor::Icon.new(name: @icon, size: icon_size)
      end
    end

    def render_title_section
      div(class: "min-w-0 flex-1") do
        if @title.present?
          h3(class: title_classes) do
            plain @title
          end
        end

        if @subtitle.present?
          p(class: subtitle_classes) do
            plain @subtitle
          end
        end
      end
    end

    def render_actions
      div(class: "card-actions flex-shrink-0 flex items-center gap-2") do
        render @actions_content
      end
    end

    def render_meta
      div(class: "mt-3 pt-3 border-t border-base-300") do
        render @meta_content
      end
    end

    def title_classes
      base_classes = "card-title truncate"

      size_classes = case @size
      when :xs then "text-sm"
      when :sm then "text-base"
      when :md then "text-lg"
      when :lg then "text-xl"
      when :xl then "text-2xl"
      else "text-lg"
      end

      "#{base_classes} #{size_classes}"
    end

    def subtitle_classes
      base_classes = "text-base-content/70 mt-1"

      size_classes = case @size
      when :xs then "text-xs"
      when :sm then "text-xs"
      when :md then "text-sm"
      when :lg then "text-base"
      when :xl then "text-lg"
      else "text-sm"
      end

      "#{base_classes} #{size_classes}"
    end

    def icon_size
      case @size
      when :xs then :sm
      when :sm then :sm
      when :md then :md
      when :lg then :lg
      when :xl then :lg
      else :md
      end
    end
  end
end
