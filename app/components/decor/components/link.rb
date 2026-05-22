# frozen_string_literal: true

module Decor
  module Components
    class Link < ::Decor::Components::Button
      include Decor::Concerns::ActsAsLink

      default_style :ghost
    end
  end
end
