# frozen_string_literal: true

module Decor
  module Components
    module Nav
      class CompactFooter < ::Decor::Components::Nav::Footer
        include ::Phlex::Rails::Helpers::ImagePath

        prop :status_site_url, _Nilable(String)
        prop :footer_links, _Array(Object), default: -> { [].freeze }
        prop :show_logo, _Boolean, default: true
      end
    end
  end
end
