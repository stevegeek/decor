# frozen_string_literal: true

module Decor
  module Components
    module Modals
      # Abstract base for ModalLayout. Owns the prop API + slot helpers.
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus their visual-language overrides.
      class ModalLayout < ::Decor::PhlexComponent
        prop :title, _Nilable(String)
        prop :description, _Nilable(String)
        prop :icon, _Nilable(String)

        # Use unified prop system
        default_size :md  # medium maps to md
        default_color :base
        default_style :filled

        # Modal uses custom size mapping for width classes
        redefine_sizes :sm, :md, :lg, :xl  # small->sm, medium->md, large->lg, extra_large->xl

        # Slot definitions
        def with_header(&block)
          @header = block
        end

        def with_body(&block)
          @body = block
        end

        def with_footer(&block)
          @footer = block
        end
      end
    end
  end
end
