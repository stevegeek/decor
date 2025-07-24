# frozen_string_literal: true

module Decor
  # A notification, which can optionally also show an icon or avatar, and one or two action buttons.
  class Notification < PhlexComponent
    no_stimulus_controller

    class ActionButton < ::Literal::Data
      # ActionButton is used to define an action button within a notification.
      # It can be a link or a button, and can be styled as primary or secondary.
      # The `href` attribute is optional; if provided, it will render as a link.
      # If `action_name` is provided, it will be used for Stimulus actions.
      prop :label, String
      prop :href, _Nilable(String)
      prop :action_name, _Nilable(String)
      prop :primary, _Boolean, default: false, predicate: :public
      prop :color, _Nilable(Symbol)
      prop :style, _Nilable(Symbol)

      def text_classes
        primary? ? "font-medium text-primary hover:text-primary-focus" : "text-base-content hover:text-base-content/70"
      end

      attr_reader :href
    end

    prop :title, String
    prop :description, _Nilable(String)
    prop :icon, _Nilable(String)
    prop :action_buttons, _Array(ActionButton), default: -> { [] }

    default_color :info

    def avatar(&block)
      @avatar = block
    end

    def view_template(&)
      @content = capture(&) if block_given?

      root_element do |el|
        # Icon section
        if @icon
          div(class: "join-item p-4 #{icon_background_class} #{icon_text_class} text-xl") do
            render ::Decor::Icon.new(name: @icon, html_options: {class: "h-6 w-6"})
          end
        elsif @avatar.present?
          div(class: "join-item p-4 bg-base-300") do
            render @avatar
          end
        end

        # Content section
        div(class: "join-item flex flex-col py-2 px-4 bg-base-200 flex-1") do
          if @title
            h3(class: "#{title_text_class} font-bold") { @title }
          end
          if @description
            span(class: "text-sm text-base-content/70") { @description }
          end
          render @content if @content
        end

        # Action buttons section
        if @action_buttons.any?
          div(class: "join-item flex flex-col justify-center p-2 gap-1") do
            @action_buttons.each do |button|
              if button.href
                render ::Decor::ButtonLink.new(
                  label: button.label,
                  href: button.href,
                  style: button.style || (button.primary? ? :filled : :ghost),
                  color: button.color || (button.primary? ? :primary : :neutral),
                  size: :sm,
                  full_width: true
                )
              else
                render ::Decor::Button.new(
                  label: button.label,
                  style: button.style || (button.primary? ? :filled : :ghost),
                  color: button.color || (button.primary? ? :primary : :neutral),
                  size: :sm,
                  full_width: true,
                  **action_button_attributes(el, button)
                )
              end
            end
          end
        end
      end
    end

    private

    def root_element_classes
      "join rounded-box shadow-lg max-w-md w-full"
    end

    def icon_background_class
      background_color_classes(@color)
    end

    def icon_text_class
      case @color
      when :base then "text-base-content"
      when :primary then "text-primary-content"
      when :secondary then "text-secondary-content"
      when :accent then "text-accent-content"
      when :success then "text-success-content"
      when :error then "text-error-content"
      when :warning then "text-warning-content"
      when :info then "text-info-content"
      when :neutral then "text-neutral-content"
      else "text-info-content"
      end
    end

    def title_text_class
      text_color_classes(@color)
    end

    def action_button_attributes(el, button)
      return {} unless button.action_name

      {
        stimulus_actions: [button.action_name]
      }
    end
  end
end
