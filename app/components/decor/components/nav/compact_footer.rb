# frozen_string_literal: true

module Decor
  module Components
    module Nav
      # Abstract base for CompactFooter. Inherits the parent Footer's prop
      # API (company_name, theme, link_groups, social_links, ...) plus its
      # FooterLink/LinkGroup/SocialLink Literal::Data inner classes, and
      # adds CompactFooter-specific props (status_site_url, footer_links,
      # show_logo) plus the ImagePath helper. Slot helpers (with_logo,
      # with_links, with_copyright) are inherited unchanged from the parent.
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus class-builder overrides for their visual language.
      class CompactFooter < ::Decor::Components::Nav::Footer
        include ::Phlex::Rails::Helpers::ImagePath

        prop :status_site_url, _Nilable(String)
        prop :footer_links, _Array(Object), default: -> { [].freeze }
        prop :show_logo, _Boolean, default: true
      end
    end
  end
end
