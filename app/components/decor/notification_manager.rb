# frozen_string_literal: true

module Decor
  # Used to display notifications. These appear in the top right hand corner of the screen, and are
  # intended to convey information to the user. They do not block interaction and are automatically
  # dismissed after 3 seconds.
  #
  # One NotificationManager is created on page, and controlled by JS.
  class NotificationManager < PhlexComponent
    def notifications(&block)
      @notifications = block
    end

    def view_template
      render parent_element do |el|
        div(
          class: "w-full flex flex-col items-center space-y-4 sm:items-end",
          data: {**el.send(:build_target_data_attributes, el.send(:parse_targets, [:notification_container]))}
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
        actions: [
          [:"#{js_event_name_prefix}:show@window", :handleShowEvent],
          [:"#{js_event_name_prefix}:dismissAll@window", :handleDismissAllEvent],
          [:"#{js_event_name_prefix}:dismiss@window", :handleDismissSingleEvent]
        ],
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
