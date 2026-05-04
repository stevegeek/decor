# frozen_string_literal: true

module Decor
  module Components
    module Nav
      # Abstract base for SecondaryNavbar. Owns the prop API + style enum
      # plus the slot helpers (with_left, with_center, with_right) which
      # return self for chaining.
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus class-builder overrides for their visual language.
      class SecondaryNavbar < ::Decor::PhlexComponent
        no_stimulus_controller

        prop :bottom_border, _Boolean, default: false

        redefine_styles :wide, :narrow
        default_style :narrow

        def with_left(&block)
          @left_block = block
          self
        end

        def with_center(&block)
          @center_block = block
          self
        end

        def with_right(&block)
          @right_block = block
          self
        end
      end
    end
  end
end
