# frozen_string_literal: true

module Decor
  module Components
    # One NotificationManager is created per page, and controlled by JS.
    # Notifications appear in the top-right corner and auto-dismiss after 3s.
    class NotificationManager < ::Decor::PhlexComponent
      stimulus do
        actions -> { [stimulus_scoped_event_on_window(:show), :handle_show_event] },
          -> { [stimulus_scoped_event_on_window(:dismiss_all), :handle_dismiss_all_event] },
          -> { [stimulus_scoped_event_on_window(:dismiss), :handle_dismiss_single_event] }
      end

      def notifications(&block)
        @notifications = block
      end
    end
  end
end
