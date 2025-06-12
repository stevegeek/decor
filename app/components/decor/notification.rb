# frozen_string_literal: true

module Decor
  # A notification, which can optionally also show an icon or avatar, and one or two action buttons.
  class Notification < PhlexComponent
    no_stimulus_controller

    class ActionButton < PhlexComponent
      # ActionButton is used to define an action button within a notification.
      # It can be a link or a button, and can be styled as primary or secondary.
      # The `href` attribute is optional; if provided, it will render as a link.
      # If `action_name` is provided, it will be used for Stimulus actions.
      attribute :label, String
      attribute :href, String
      attribute :action_name, String
      attribute :primary, :boolean, default: false

      def text_classes
        primary? ? "font-medium text-primary hover:text-primary-focus" : "text-base-content hover:text-base-content/70"
      end

      attr_reader :href
    end

    attribute :title, String
    attribute :description, String
    attribute :icon, String
    attribute :style, Symbol, in: %i[warning success error info].freeze, default: :info
    attribute :action_buttons, Array, sub_type: ActionButton, default: [], convert: true

    def avatar(&block)
      @avatar = block
    end

    def view_template(&)
      @content = capture(&) if block_given?

      render parent_element do |el|
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
          div(class: "join-item flex flex-col p-2 gap-1") do
            @action_buttons.each do |button|
              if button.href
                render ::Decor::ButtonLink.new(
                  label: button.label,
                  href: button.href,
                  variant: button.primary? ? :contained : :text,
                  theme: button.primary? ? :primary : :neutral,
                  size: :small,
                  full_width: true
                )
              else
                render ::Decor::Button.new(
                  label: button.label,
                  variant: button.primary? ? :contained : :text,
                  theme: button.primary? ? :primary : :neutral,
                  size: :small,
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

    def element_classes
      "join rounded-box shadow-lg max-w-md w-full"
    end

    def icon_background_class
      case @style
      when :success then "bg-success"
      when :error then "bg-error"
      when :warning then "bg-warning"
      when :info then "bg-info"
      else "bg-info"
      end
    end

    def icon_text_class
      case @style
      when :success then "text-success-content"
      when :error then "text-error-content"
      when :warning then "text-warning-content"
      when :info then "text-info-content"
      else "text-info-content"
      end
    end

    def title_text_class
      case @style
      when :success then "text-success"
      when :error then "text-error"
      when :warning then "text-warning"
      when :info then "text-info"
      else "text-info"
      end
    end

    def action_button_attributes(el, button)
      return {} unless button.action_name

      {
        data: {
          target: button.action_name
        }
      }
    end
  end
end
