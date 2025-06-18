# frozen_string_literal: true

module Decor
  class PhlexComponent < ::Vident::Typed::Phlex::HTML
    include ::Vident::Caching
    include ::Vident::Tailwind

    include Phlex::Rails::Helpers::Routes
    include Phlex::Rails::Helpers::ImagePath

    # TODO: deprecate these?
    include ::Phlex::Rails::Helpers::T
    include ::Phlex::Rails::Helpers::ImageTag
    include ::Phlex::Rails::Helpers::LinkTo
    include ::Phlex::Rails::Helpers::ContentTag

    # Shared attribute helpers
    include Decor::Concerns::SizeClassHelper
    include Decor::Concerns::ColorClassHelper
    include Decor::Concerns::VariantClassHelper
  end
end
