# frozen_string_literal: true

module Decor
  class PhlexComponent < ::Vident::Phlex::HTML
    include ::Vident::Caching

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

    # TODO: upstream to Vident
    def self.prop_names
      literal_properties.properties_index.keys.map(&:to_sym)
    end

    def prop_names
      self.class.prop_names
    end
  end
end
