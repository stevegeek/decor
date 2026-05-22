# frozen_string_literal: true

module Decor
  module Suite
    class NotificationManager < ::Decor::Components::NotificationManager
      POSITION_OPTIONS = %i[bottom_right bottom_left top_right top_left top_center bottom_center].freeze

      prop :position, _Union(*POSITION_OPTIONS), default: :top_right
      prop :max_visible, Integer, default: 5

      stimulus do
        targets :notification_container
        values position: -> { @position.to_s.tr("_", "-") },
          max_visible: -> { @max_visible }
        classes notification_base: "decor:flex decor:items-start decor:gap-2.5 decor:px-3.5 decor:py-3 decor:bg-white decor:rounded-suite-control decor:border decor:border-suite-hairline-strong decor:shadow-lg decor:min-w-[320px] decor:max-w-[380px] decor:pointer-events-auto"
      end

      def view_template
        root_element do
          div(
            class: "decor:flex decor:flex-col decor:gap-2",
            data: {**stimulus_target(:notification_container)}
          ) do
            if @notifications.present?
              instance_eval(&@notifications)
            end
          end
        end

        template(id: "#{id}-toast-template") do
          render ::Decor::Suite::Notification.new(color: :neutral)
        end
      end

      private

      def root_element_attributes
        {
          html_options: {
            aria_live: "assertive"
          }
        }
      end

      def root_element_classes
        "decor:fixed decor:z-50 decor:flex decor:flex-col decor:gap-2 decor:pointer-events-none #{position_classes}"
      end

      def position_classes
        case @position
        when :bottom_right then "decor:bottom-4 decor:right-4 decor:flex-col-reverse"
        when :bottom_left then "decor:bottom-4 decor:left-4 decor:flex-col-reverse"
        when :bottom_center then "decor:bottom-4 decor:left-1/2 decor:-translate-x-1/2 decor:flex-col-reverse"
        when :top_right then "decor:top-4 decor:right-4 decor:flex-col"
        when :top_left then "decor:top-4 decor:left-4 decor:flex-col"
        when :top_center then "decor:top-4 decor:left-1/2 decor:-translate-x-1/2 decor:flex-col"
        end
      end
    end
  end
end
