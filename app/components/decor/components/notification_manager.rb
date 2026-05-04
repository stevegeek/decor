# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for NotificationManager. Owns the stimulus block + the
    # notifications slot helper.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus their visual-language overrides.
    #
    # Used to display notifications. These appear in the top right hand corner
    # of the screen, and are intended to convey information to the user. They
    # do not block interaction and are automatically dismissed after 3 seconds.
    #
    # One NotificationManager is created on page, and controlled by JS.
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
