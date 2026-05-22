# frozen_string_literal: true

module Decor
  module Components
    module Modals
      class ConfirmModal < ::Decor::Components::Modals::Modal
        # Set defaults for the unified size/color/style system
        default_size :md
        default_color :base
        default_style :filled

        stimulus do
          targets :positive_button, :negative_button, :title, :message
          actions -> { [stimulus_scoped_event_on_window(:open), :handle_open_event] },
            -> { [stimulus_scoped_event_on_window(:close), :handle_close_event] }
          values_from_props :close_on_overlay_click
        end
      end
    end
  end
end
