# frozen_string_literal: true

module Decor
  module Components
    module Nav
      class Footer < ::Decor::PhlexComponent
        no_stimulus_controller

        class FooterLink < ::Literal::Data
          prop :label, String
          prop :href, String
          prop :external, _Boolean, default: false, predicate: :public
          prop :icon, _Nilable(String)
        end

        class LinkGroup < ::Literal::Data
          prop :title, String
          prop :links, Array, default: [].freeze
          prop :visible, _Boolean, default: true
        end

        class SocialLink < ::Literal::Data
          prop :platform, Symbol
          prop :url, String
          prop :label, _Nilable(String)
          prop :visible, _Boolean, default: true
        end

        prop :company_name, _String(_Predicate("present", &:present?))
        prop :leads_model, _Nilable(Object)
        prop :leads_submit_path, _Nilable(String)
        prop :link_groups, Array, default: [].freeze
        prop :social_links, Array, default: [].freeze
        prop :theme, _Union(:light, :dark), default: :dark
        prop :show_newsletter, _Boolean, default: true
        prop :show_social, _Boolean, default: true

        def with_logo(&block)
          @logo_content = block
        end

        def with_content(&block)
          @custom_content = block
        end

        def with_links(&block)
          @custom_links = block
        end

        def with_copyright(&block)
          @copyright_content = block
        end
      end
    end
  end
end
