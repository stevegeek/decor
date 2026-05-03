# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for PageSection. Owns the prop API + slot helpers.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus class-builder overrides for their visual language.
    class PageSection < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :title, _Nilable(String)
      prop :description, _Nilable(String)
      prop :separator, _Boolean, default: false

      prop :background, _Union(:default, :primary, :secondary, :neutral), default: :default
      prop :padding, _Union(:none, :sm, :md, :lg, :xl), default: :md

      default_size :md

      def with_hero(&block)
        @hero = block
      end

      def with_cta(&block)
        @cta = block
      end

      def with_tag(**attributes)
        @tags ||= []
        @tags << ::Decor::Daisy::Tag.new(**attributes)
      end

      def tags
        @tags ||= []
      end

      def hero_slot
        @hero
      end

      def cta_slot
        @cta
      end

      private

      def has_header_content?
        @title.present? || @description.present? || tags.any?
      end
    end
  end
end
