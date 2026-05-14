# frozen_string_literal: true

module Decor
  module Daisy
    # Shared daisyUI card-styled box rendering for Box and SwitchingBox.
    # Including class inherits the prop API from Decor::Components::Box (or a
    # subclass) and may override component_*_classes for its visual variant.
    module BoxTemplate
      private

      def view_template(&)
        @content = capture(&) if block_given?

        root_element do
          div(class: "decor:d-card-body") do
            if @left.present? && @right.present?
              div(class: "decor:flex decor:justify-between decor:items-start") do
                div(class: "decor:flex-1") do
                  render @left
                end
                div(class: "decor:flex-none") do
                  render @right
                end
              end
            elsif @left.present?
              render @left
            else
              if @title.present? || @html_title.present?
                h2(class: "decor:d-card-title") do
                  if @html_title.present?
                    render @html_title
                  else
                    plain(@title)
                  end
                end
              end

              if @description.present?
                p(class: "decor:text-base-content/70") do
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
        classes = ["decor:d-card", "decor:d-card-bordered"]
        classes << size_classes
        classes << style_classes
        classes.compact.join(" ")
      end

      def component_size_classes(size)
        case size
        when :xs then "decor:d-card-xs"
        when :sm then "decor:d-card-sm"
        when :md then "decor:d-card-md"
        when :lg then "decor:d-card-lg"
        when :xl then "decor:d-card-xl"
        else
          ""
        end
      end

      def component_style_classes(style)
        # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
        case style
        when :filled
          "#{filled_color_classes(@color)} decor:shadow-sm"
        when :outlined
          "#{outline_color_classes(@color)} decor:bg-base-100"
        when :ghost
          "#{ghost_color_classes(@color)} decor:shadow-none"
        else
          ""
        end
      end
    end
  end
end
