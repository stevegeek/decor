# frozen_string_literal: true

module Decor
  class PhlexComponent < ::Vident::Phlex::HTML
    include ActiveSupport::Configurable

    include ::Vident::Caching

    include Phlex::Rails::Helpers::Routes
    include Phlex::Rails::Helpers::ImagePath

    # TODO: deprecate these?
    include ::Phlex::Rails::Helpers::T
    include ::Phlex::Rails::Helpers::ImageTag
    include ::Phlex::Rails::Helpers::LinkTo
    include ::Phlex::Rails::Helpers::ContentTag

    # Shared attribute helpers
    include Decor::Concerns::SizeClasses
    include Decor::Concerns::ColorClasses
    include Decor::Concerns::StyleClasses
  end
end
