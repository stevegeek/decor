# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for CodeSnippet. Owns the defaults; concrete skins
    # provide `view_template` plus the daisyUI / Suite class strings.
    class CodeSnippet < ::Decor::PhlexComponent
      default_size :md
      default_color :base
      default_style :filled
    end
  end
end
