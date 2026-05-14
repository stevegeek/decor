# frozen_string_literal: true

module Decor
  module Daisy
    # A notification, which can optionally also show an icon or avatar, and
    # one or two action buttons. Styled like daisyUI inline alerts with join
    # layout.
    class Notification < ::Decor::Components::Notification
      def view_template(&)
        @content = capture(&) if block_given?

        root_element do |el|
          # Icon section
          if @icon
            # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
            div(class: "decor:d-join-item decor:p-4 #{icon_background_class} #{icon_text_class} decor:text-xl") do
              render ::Decor::Icon.new(name: @icon, html_options: {class: "decor:h-6 decor:w-6"})
            end
          elsif @avatar.present?
            div(class: "decor:d-join-item decor:p-4 decor:bg-base-300") do
              render @avatar
            end
          end

          # Content section
          div(class: "decor:d-join-item decor:flex decor:flex-col decor:py-2 decor:px-4 decor:bg-base-200 decor:flex-1") do
            if @title
              # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
              h3(class: "#{title_text_class} decor:font-bold") { @title }
            end
            if @description
              span(class: "decor:text-sm decor:text-base-content/70") { @description }
            end
            render @content if @content
          end

          # Action buttons section
          if @action_buttons.any?
            div(class: "decor:d-join-item decor:flex decor:flex-col decor:justify-center decor:p-2 decor:gap-1") do
              @action_buttons.each do |button|
                if button.href
                  render ::Decor::Daisy::ButtonLink.new(
                    label: button.label,
                    href: button.href,
                    style: button.style || (button.primary? ? :filled : :ghost),
                    color: button.color || (button.primary? ? :primary : :neutral),
                    size: :sm,
                    full_width: true
                  )
                else
                  render ::Decor::Daisy::Button.new(
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
        "decor:d-join decor:rounded-box decor:shadow-lg decor:max-w-md decor:w-full"
      end

      def icon_background_class
        background_color_classes(@color)
      end

      def icon_text_class
        case @color
        when :base then "decor:text-base-content"
        when :primary then "decor:text-primary-content"
        when :secondary then "decor:text-secondary-content"
        when :accent then "decor:text-accent-content"
        when :success then "decor:text-success-content"
        when :error then "decor:text-error-content"
        when :warning then "decor:text-warning-content"
        when :info then "decor:text-info-content"
        when :neutral then "decor:text-neutral-content"
        else "decor:text-info-content"
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
end
