# frozen_string_literal: true

module Decor
  module Modals
    class ModalOpenButton < Button
      prop :modal_id, String, reader: :public
      prop :initial_content, _Nilable(String)
      prop :content_href, _Nilable(String)
      prop :close_on_overlay_click, _Boolean, default: false
      prop :type, _Nilable(String), default: "button"

      stimulus do
        actions [:click, :handle_button_click]
        values_from_props :initial_content, :content_href, :close_on_overlay_click, :modal_id
      end

      private

      def root_element_attributes
        attributes = super
        attributes[:html_options] = (attributes[:html_options] || {}).merge(
          type: @type
        )
        attributes
      end
    end
  end
end
