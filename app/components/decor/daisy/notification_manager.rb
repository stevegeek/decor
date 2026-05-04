# frozen_string_literal: true

module Decor
  module Daisy
    class NotificationManager < ::Decor::Components::NotificationManager
      def view_template
        root_element do
          div(
            class: "w-full flex flex-col items-center space-y-4 sm:items-end",
            data: {**stimulus_target(:notification_container)}
          ) do
            if @notifications.present?
              instance_eval(&@notifications)
            end
          end
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
        "toast toast-top toast-end fixed z-50"
      end
    end
  end
end
