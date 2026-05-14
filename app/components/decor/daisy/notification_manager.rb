# frozen_string_literal: true

module Decor
  module Daisy
    class NotificationManager < ::Decor::Components::NotificationManager
      def view_template
        root_element do
          div(
            class: "decor:w-full decor:flex decor:flex-col decor:items-center decor:space-y-4 decor:sm:items-end",
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
        "decor:d-toast decor:d-toast-top decor:d-toast-end decor:fixed decor:z-50"
      end
    end
  end
end
