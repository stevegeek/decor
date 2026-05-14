# frozen_string_literal: true

module Decor
  module Daisy
    # A title component with configurable size, optional icon, description, and CTA area.
    class Title < ::Decor::Components::Title
      private

      def view_template(&)
        root_element do
          div(class: container_classes) do
            div(class: title_section_classes) do
              if @icon
                div(class: "decor:flex decor:items-start decor:space-x-2") do
                  render ::Decor::Daisy::Icon.new(name: @icon, width: icon_size, height: icon_size, html_options: {class: "decor:mt-1"})
                  render_title_and_description
                end
              else
                render_title_and_description
              end
            end

            if block_given?
              div(class: actions_classes) do
                div(class: "decor:flex decor:items-center decor:space-x-3") do
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
        "decor:flex decor:justify-between decor:items-center decor:flex-wrap decor:sm:flex-nowrap"
      end

      def title_section_classes
        "decor:flex-1"
      end

      def actions_classes
        "decor:flex-shrink-0"
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
        else
          :h3
        end
      end

      def title_classes
        base_classes = "decor:font-semibold decor:text-base-content decor:leading-tight"

        case @size
        when :xs
          # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
          "#{base_classes} decor:text-sm"
        when :sm
          # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
          "#{base_classes} decor:text-base"
        when :md
          # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
          "#{base_classes} decor:text-lg"
        when :lg
          # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
          "#{base_classes} decor:text-xl"
        when :xl
          # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
          "#{base_classes} decor:text-2xl"
        end
      end

      def description_classes
        base_classes = "decor:text-base-content/70 decor:leading-relaxed"

        case @size
        when :xs
          # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
          "#{base_classes} decor:text-xs decor:mt-0.5"
        when :sm
          # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
          "#{base_classes} decor:text-sm decor:mt-1"
        when :md
          # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
          "#{base_classes} decor:text-sm decor:mt-1"
        when :lg
          # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
          "#{base_classes} decor:text-base decor:mt-1.5"
        when :xl
          # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
          "#{base_classes} decor:text-lg decor:mt-2"
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
          "decor:space-y-1"
        when :md
          "decor:space-y-2"
        when :lg, :xl
          "decor:space-y-3"
        end
      end
    end
  end
end
