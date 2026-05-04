# frozen_string_literal: true

module Decor
  module Components
    module Modals
      # Abstract base for Modal. Owns the prop API + stimulus block.
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus their visual-language overrides.
      class Modal < ::Decor::PhlexComponent
        prop :initial_content, _Nilable(String)
        prop :content_href, _Nilable(String)
        prop :start_shown, _Boolean, default: false
        prop :close_on_overlay_click, _Boolean, default: false

        stimulus do
          targets :overlay, :modal
          actions -> { [stimulus_scoped_event_on_window(:open), :handle_open_event] },
            -> { [stimulus_scoped_event_on_window(:close), :handle_close_event] }
          values_from_props :close_on_overlay_click, :content_href
          values show_initial: -> { @start_shown }
        end
      end
    end
  end
end
