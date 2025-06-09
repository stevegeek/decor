# frozen_string_literal: true

module Decor
  class PhlexComponent < ::Vident::Typed::Phlex::HTML
    include ::Vident::Caching
    include ::Vident::Tailwind

    # TODO: deprecate these?
    include ::Phlex::Rails::Helpers::T
    include ::Phlex::Rails::Helpers::ImageTag
    include ::Phlex::Rails::Helpers::LinkTo
    include ::Phlex::Rails::Helpers::ContentTag

    include ::Phlex::Slotable
  end
end
