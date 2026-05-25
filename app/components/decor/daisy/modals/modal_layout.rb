# frozen_string_literal: true

module Decor
  module Daisy
    module Modals
      class ModalLayout < ::Decor::Components::Modals::ModalLayout
        def view_template
          root_element do
            # Header slot
            if @header
              div(class: "decor:d-modal-header") do
                render @header
              end
            end

            # Body slot with icon/title/description support
            div(class: "decor:d-modal-body") do
              if @body
                render @body
              elsif @title || @description
                # Icon/title/description layout
                div(class: "decor:sm:flex decor:sm:items-start") do
                  if show_icon?
                    div(class: "decor:mx-auto decor:flex-shrink-0 decor:flex decor:items-center decor:justify-center decor:h-12 decor:w-12 decor:rounded-full #{icon_background_classes} decor:sm:mx-0 decor:sm:h-10 decor:sm:w-10") do
                      render ::Decor::Icon.new(name: @icon, html_options: {class: "decor:h-6 decor:w-6 #{icon_text_classes}"})
                    end
                  end
                  div(class: "#{"decor:mt-3 decor:sm:mt-0 decor:sm:ml-4" if show_icon?} decor:text-center decor:sm:text-left") do
                    if @title
                      h3(class: "decor:text-lg decor:leading-6 decor:font-medium") { @title }
                    end
                    if @description.present?
                      div(class: "decor:mt-2") do
                        p(class: "decor:text-sm decor:opacity-70") { @description }
                      end
                    end
                  end
                end
              end
              # Content from yield
              yield if block_given? && !@body
            end

            # Footer slot
            if @footer
              div(class: "decor:d-modal-action") do
                render @footer
              end
            end
          end
        end

        private

        def root_element_classes
          classes = ["decor:d-modal-box", "decor:relative"]
          classes << size_classes
          classes << style_classes
          classes.compact.join(" ")
        end

        def component_size_classes(size)
          case size
          when :xs then "decor:max-w-sm"   # extra small - new
          when :sm then "decor:max-w-md"   # small -> sm
          when :md then "decor:max-w-2xl"  # medium -> md (default)
          when :lg then "decor:max-w-5xl"  # large -> lg
          when :xl then "decor:max-w-7xl"  # extra_large -> xl
          else "decor:max-w-2xl"
          end
        end

        def component_color_classes(color)
          return "" if @style == :ghost

          case color
          when :primary
            (@style == :outlined) ? "decor:border-primary" : "decor:bg-primary/10"
          when :secondary
            (@style == :outlined) ? "decor:border-secondary" : "decor:bg-secondary/10"
          when :accent
            (@style == :outlined) ? "decor:border-accent" : "decor:bg-accent/10"
          when :info
            (@style == :outlined) ? "decor:border-info" : "decor:bg-info/10"
          when :success
            (@style == :outlined) ? "decor:border-success" : "decor:bg-success/10"
          when :warning
            (@style == :outlined) ? "decor:border-warning" : "decor:bg-warning/10"
          when :error
            (@style == :outlined) ? "decor:border-error" : "decor:bg-error/10"
          when :neutral
            (@style == :outlined) ? "decor:border-neutral" : "decor:bg-neutral/10"
          when :base
            ""
          else
            ""
          end
        end

        def component_style_classes(style)
          case style
          when :outlined
            "decor:border-2"
          when :ghost
            "decor:bg-transparent decor:border-0 decor:shadow-none"
          when :filled
            ""  # Default filled style
          else
            ""
          end
        end

        def show_icon?
          @icon.present?
        end

        def icon_text_classes
          case @color
          when :primary
            "decor:text-primary"
          when :secondary
            "decor:text-secondary"
          when :accent
            "decor:text-accent"
          when :info
            "decor:text-info"
          when :success
            "decor:text-success"
          when :warning
            "decor:text-warning"
          when :error
            "decor:text-error"
          when :neutral
            "decor:text-neutral"
          else
            "decor:text-base-content"
          end
        end

        def icon_background_classes
          case @color
          when :primary
            "decor:bg-primary/20"
          when :secondary
            "decor:bg-secondary/20"
          when :accent
            "decor:bg-accent/20"
          when :info
            "decor:bg-info/20"
          when :success
            "decor:bg-success/20"
          when :warning
            "decor:bg-warning/20"
          when :error
            "decor:bg-error/20"
          when :neutral
            "decor:bg-neutral/20"
          else
            "decor:bg-base-300"
          end
        end
      end
    end
  end
end
