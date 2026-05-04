# frozen_string_literal: true

module Decor
  module Components
    module Nav
      # Abstract base for TopNavbar. Owns the prop API + stimulus block
      # plus the slot helpers (with_brand, with_nav_items, with_account_menu,
      # with_notifications_menu).
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus class-builder overrides for their visual language.
      class TopNavbar < ::Decor::PhlexComponent
        include ::Phlex::Rails::Helpers::ButtonTo # TODO: Remove need for this

        prop :has_search, _Boolean, default: true
        prop :instant_search_path, _Nilable(String)
        prop :brand_text, _Nilable(String)
        prop :brand_href, String, default: "/"

        stimulus do
          values_from_props :instant_search_path
        end

        # Manual slot implementations
        def with_brand(&block)
          @brand_block = block
          self
        end

        def with_nav_items(&block)
          @nav_items_block = block
          self
        end

        def with_account_menu(**options, &block)
          @account_menu_options = options
          @account_menu = block
          self
        end

        def with_notifications_menu(**options, &block)
          @notifications_menu_options = options
          @notifications_menu = block
          self
        end
      end
    end
  end
end
