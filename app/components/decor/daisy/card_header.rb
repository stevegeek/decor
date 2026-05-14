# frozen_string_literal: true

module Decor
  module Daisy
    # CardHeader provides structured header content for cards with title, subtitle, icon, and actions.
    class CardHeader < ::Decor::Components::CardHeader
      private

      def view_template(&)
        vanish(&)
        root_element do
          div(class: "decor:flex decor:items-start decor:justify-between") do
            div(class: "decor:flex decor:items-start decor:gap-3 decor:min-w-0 decor:flex-1") do
              render_icon if @icon.present?
              render_title_section
            end

            render_actions if @actions_content
          end

          render_meta if @meta_content
        end
      end

      def root_element_classes
        "decor:d-card-header"
      end

      def render_icon
        div(class: "decor:flex-shrink-0 decor:mt-1") do
          render ::Decor::Icon.new(name: @icon, size: icon_size)
        end
      end

      def render_title_section
        div(class: "decor:min-w-0 decor:flex-1") do
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
        div(class: "decor:d-card-actions decor:flex-shrink-0 decor:flex decor:items-center decor:gap-2") do
          render @actions_content
        end
      end

      def render_meta
        div(class: "decor:mt-3 decor:pt-3 decor:border-t decor:border-base-300") do
          render @meta_content
        end
      end

      def title_classes
        base_classes = "decor:d-card-title decor:truncate"

        size_classes = case @size
        when :xs then "decor:text-sm"
        when :sm then "decor:text-base"
        when :md then "decor:text-lg"
        when :lg then "decor:text-xl"
        when :xl then "decor:text-2xl"
        else "decor:text-lg"
        end

        # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
        "#{base_classes} #{size_classes}"
      end

      def subtitle_classes
        base_classes = "decor:text-base-content/70 decor:mt-1"

        size_classes = case @size
        when :xs then "decor:text-xs"
        when :sm then "decor:text-xs"
        when :md then "decor:text-sm"
        when :lg then "decor:text-base"
        when :xl then "decor:text-lg"
        else "decor:text-sm"
        end

        # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
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
end
