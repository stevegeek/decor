# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for PageHeader. Owns the prop API + slot helpers.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus class-builder overrides for their visual language.
    class PageHeader < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :title, _Nilable(String)
      prop :subtitle, _Nilable(String)
      prop :description, _Nilable(String)

      prop :layout, _Union(:default, :centered, :minimal, :hero, :compact, :page_like), default: :default
      prop :background, _Union(:default, :hero, :gradient, :transparent), default: :default

      default_size :md

      prop :border, _Boolean, default: true
      prop :padding, _Union(:none, :sm, :md, :lg, :xl), default: :md
      prop :cta_snap_large, _Boolean, default: false

      def with_avatar(&block)
        @avatar_content = block
      end

      def with_title_content(&block)
        @title_content = block
      end

      def with_meta_content(&block)
        @meta_content = block
      end

      def with_actions(&block)
        @actions_content = block
      end

      def with_secondary_actions(&block)
        @secondary_actions_content = block
      end

      def with_breadcrumbs(&block)
        @breadcrumbs_content = block
      end

      def with_status(&block)
        @status_content = block
      end

      def with_cta(&block)
        @cta_content = block
      end

      def with_badge(**attributes, &block)
        @badges ||= []
        badge = ::Decor::Daisy::Badge.new(**attributes)
        @badges << badge
        badge
      end

      def with_tag(**attributes, &block)
        @tags ||= []
        tag = ::Decor::Daisy::Tag.new(**attributes)
        @tags << tag
        tag
      end
    end
  end
end
