# frozen_string_literal: true

module Decor
  module Chat
    class ListMessage < PhlexComponent
      slot :attachment

      attribute :author_name, String, allow_nil: false
      attribute :author_initials, String
      attribute :author_profile_image_url, String

      attribute :localised_created_at, Time, default: ->(_) { Time.zone.now }
      attribute :message, String

      attribute :is_current_user, :boolean, default: false
      attribute :show_avatar, :boolean, default: true
      attribute :show_timestamp, :boolean, default: true
      attribute :footer_text, String

      def view_template
        render parent_element do
          if @show_timestamp || (!@is_current_user && @author_name.present?)
            div(class: "chat-header") do
              span { @author_name } unless @is_current_user
              if @show_timestamp
                time(class: "text-xs opacity-50") do
                  format_timestamp
                end
              end
            end
          end

          if @show_avatar && (!@is_current_user || @author_profile_image_url.present?)
            div(class: "chat-image") do
              render ::Decor::Avatar.new(
                url: @author_profile_image_url,
                initials: @author_initials || @author_name.first.upcase,
                size: :medium,
                shape: :circle
              )
            end
          end

          div(class: chat_bubble_classes) do
            if attachment_slot.present?
              render attachment_slot
            end

            if @message.present?
              span { @message }
            end
          end

          # Chat footer - can be used for delivery status, etc.
          if @footer_text.present?
            div(class: "chat-footer opacity-50") do
              span { @footer_text }
            end
          end
        end
      end

      private

      def format_timestamp
        if older_than_18_hours?
          @localised_created_at.strftime("%m/%d %H:%M")
        else
          @localised_created_at.strftime("%H:%M")
        end
      end

      def older_than_18_hours?
        Time.current - @localised_created_at > 24.hours
      end

      def chat_bubble_classes
        base_classes = "chat-bubble"

        if @is_current_user
          "#{base_classes} chat-bubble-primary"
        else
          base_classes
        end
      end

      def element_classes
        base_classes = "chat"

        if @is_current_user
          "#{base_classes} chat-end"
        else
          "#{base_classes} chat-start"
        end
      end

      def root_element_attributes
        {
          element_tag: :div
        }
      end
    end
  end
end
