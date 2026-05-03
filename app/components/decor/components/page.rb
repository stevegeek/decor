# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Page. Owns the prop API + slot helpers.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus class-builder overrides for their visual language.
    class Page < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :flash_data, ActionDispatch::Flash::FlashHash, default: -> { ActionDispatch::Flash::FlashHash.new }, reader: :private

      prop :include_flash, _Boolean, default: true
      prop :full_height, _Boolean, default: false

      prop :background, _Union(:default, :primary, :secondary, :hero, :neutral), default: :default
      prop :padding, _Union(:none, :sm, :md, :lg, :xl), default: :md
      prop :spacing, _Union(:none, :sm, :md, :lg, :xl), default: :md

      def with_hero(&block)
        @hero = block
      end

      def with_header(&block)
        @header = block
      end

      def with_tabs(&block)
        @tabs = block
      end
    end
  end
end
