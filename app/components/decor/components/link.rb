# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Link. Inherits from Button (still monolithic until
    # Button itself is ported) and adds the link concern + style default.
    # Concrete skins (Daisy, Suite) inherit and provide root_element_classes
    # plus their visual-language overrides.
    class Link < ::Decor::Button
      include Decor::Concerns::ActsAsLink

      default_style :ghost
    end
  end
end
