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
          span(class: "text-center") do
            render @before_label if @before_label.present?
            if @icon
              icon_options = {name: @icon, html_options: {class: icon_classes}}
              icon_options[:variant] = @icon_variant if @icon_variant
              render ::Decor::Daisy::Icon.new(**icon_options)
            end
            span(class: @icon_only_on_mobile ? "hidden md:inline" : "") do
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
            "size-10 pr-2"
          when :lg
            "size-8 pr-2"
          when :md, nil
            "size-6 pr-1"
          when :sm
            "size-5.5 pr-1"
          when :xs
            "size-4.5 pr-1"
          else
            "size-6 pr-1"
          end
        "inline #{@icon_only_on_mobile ? "mr-0 md:mr-1" : "mr-1"} #{sized}"
      end
    end
  end
end
