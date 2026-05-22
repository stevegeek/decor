# frozen_string_literal: true

module Decor
  module Components
    module Chat
      class ListMessage < ::Decor::PhlexComponent
        prop :author_name, _String(_Predicate("present", &:present?))
        prop :author_initials, _Nilable(String)
        prop :author_profile_image_url, _Nilable(String)

        prop :localised_created_at, Time, default: -> { Time.zone.now }
        prop :message, _Nilable(String)

        prop :is_current_user, _Boolean, default: false
        prop :show_avatar, _Boolean, default: true
        prop :show_timestamp, _Boolean, default: true
        prop :footer_text, _Nilable(String)

        def initialize(**attributes)
          @attachment_block = nil
          super
        end

        def attachment(&block)
          @attachment_block = block
        end
      end
    end
  end
end
