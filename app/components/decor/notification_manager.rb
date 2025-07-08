# frozen_string_literal: true

module Decor
  # Used to display notifications. These appear in the top right hand corner of the screen, and are
  # intended to convey information to the user. They do not block interaction and are automatically
  # dismissed after 3 seconds.
  #
  # One NotificationManager is created on page, and controlled by JS.
  class NotificationManager < PhlexComponent
    stimulus do
      actions -> { [stimulus_scoped_event_on_window(:show), :handle_show_event] },
        -> { [stimulus_scoped_event_on_window(:dismiss_all), :handle_dismiss_all_event] },
        -> { [stimulus_scoped_event_on_window(:dismiss), :handle_dismiss_single_event] }
    end

    def notifications(&block)
      @notifications = block
    end

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

    def element_classes
      "toast toast-top toast-end fixed z-50"
    end
  end
end
