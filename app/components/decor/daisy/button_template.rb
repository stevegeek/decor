# frozen_string_literal: true

module Decor
  module Daisy
    # Shared rendering for daisyUI button-shaped elements (Button, Link, ButtonLink).
    # Including class must define root_element_classes (and may override
    # component_*_classes for its visual variant).
    module ButtonTemplate
      private

      def view_template(&)
        @content = capture(&).html_safe if block_given?
        root_element do
          span(class: "decor:text-center") do
            render @before_label if @before_label.present?
            if @icon
              icon_options = {name: @icon, html_options: {class: icon_classes}}
              icon_options[:variant] = @icon_variant if @icon_variant
              render ::Decor::Daisy::Icon.new(**icon_options)
            end
            span(class: @icon_only_on_mobile ? "decor:hidden decor:md:inline" : "") do
              if @content
                raw @content
              elsif @label.present?
                plain @label
              end
            end
            render @after_label if @after_label.present?
          end
        end
      end

      def icon_classes
        normalized_size = normalize_size(@size)
        sized =
          case normalized_size
          when :xl
            "decor:size-10 decor:pr-2"
          when :lg
            "decor:size-8 decor:pr-2"
          when :md, nil
            "decor:size-6 decor:pr-1"
          when :sm
            "decor:size-5.5 decor:pr-1"
          when :xs
            "decor:size-4.5 decor:pr-1"
          else
            "decor:size-6 decor:pr-1"
          end
        "decor:inline #{@icon_only_on_mobile ? "decor:mr-0 decor:md:mr-1" : "decor:mr-1"} #{sized}"
      end
    end
  end
end
