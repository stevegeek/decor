# frozen_string_literal: true

module Decor
  module Components
    class Avatar < ::Decor::PhlexComponent
      include Decor::Concerns::StyleColorClasses

      no_stimulus_controller

      with_cache_key :to_h

      prop :url, _Nilable(_String(&:present?))
      prop :initials, _Nilable(_String(&:present?))
      prop :alt, _Nilable(_String(&:present?))

      prop :shape, _Nilable(_Union(:circle, :square)), default: :circle

      prop :border, _Boolean, default: false

      prop :status, _Nilable(_Union(:online, :away, :offline))

      default_style :filled
      default_color :neutral
      default_size :md
    end
  end
end
