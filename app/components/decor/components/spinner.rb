# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Spinner. Owns the prop API + defaults.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus `component_size_classes` / `component_color_classes` /
    # `component_style_classes` overrides for their visual language.
    class Spinner < ::Decor::PhlexComponent
      no_stimulus_controller

      default_size :md
      default_color :neutral
      default_style :spinner

      redefine_styles :spinner, :dots, :ring, :ball, :bars, :infinity
    end
  end
end
