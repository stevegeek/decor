# frozen_string_literal: true

module Decor
  module Components
    class Spinner < ::Decor::PhlexComponent
      no_stimulus_controller

      default_size :md
      default_color :neutral
      default_style :spinner

      redefine_styles :spinner, :dots, :ring, :ball, :bars, :infinity
    end
  end
end
