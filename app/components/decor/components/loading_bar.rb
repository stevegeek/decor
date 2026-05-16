# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for LoadingBar. A thin horizontal progress indicator —
    # either determinate (fills to `progress` percentage) or indeterminate
    # (animated sliding segment, used while work duration is unknown).
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus the visual class strings.
    class LoadingBar < ::Decor::PhlexComponent
      no_stimulus_controller

      default_size :md
      default_color :primary
      redefine_styles :determinate, :indeterminate
      default_style :indeterminate

      # Progress percentage (0-100). Only used for :determinate style.
      prop :progress, _Nilable(Integer), default: 0

      # Whether to animate the fill (smooth transition + hatch overlay
      # while progressing for :determinate; sliding segment for :indeterminate).
      prop :animated, _Boolean, default: true

      # Optional label shown above the bar.
      prop :label, _Nilable(String)

      # Show percentage text inside the bar (only for :determinate, larger sizes).
      prop :show_percentage, _Boolean, default: false

      private

      def determinate?
        (@style || :indeterminate) == :determinate
      end

      def indeterminate?
        !determinate?
      end

      def animated?
        @animated
      end

      def clamped_progress
        (@progress || 0).clamp(0, 100)
      end
    end
  end
end
