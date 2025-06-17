# frozen_string_literal: true

module Navigo
  class PhlexComponent < ::Vident::Typed::Phlex::HTML
    include ::Vident::Caching
    include ::Vident::Tailwind

    include Phlex::Rails::Helpers::Routes
    include Phlex::Rails::Helpers::ImagePath
  end
end
