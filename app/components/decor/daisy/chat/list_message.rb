# frozen_string_literal: true

module Decor
  module Daisy
    module Chat
      class ListMessage < ::Decor::Components::Chat::ListMessage
        def view_template
          yield(self) if block_given?
          root_element do
            if @show_timestamp || (!@is_current_user && @author_name.present?)
              div(class: "decor:d-chat-header") do
                span { @author_name } unless @is_current_user
                if @show_timestamp
                  time(class: "decor:text-xs decor:opacity-50") do
                    format_timestamp
                  end
                end
              end
            end

            if @show_avatar && (!@is_current_user || @author_profile_image_url.present?)
              div(class: "decor:d-chat-image") do
                render ::Decor::Daisy::Avatar.new(
                  url: @author_profile_image_url,
                  initials: @author_initials || @author_name.first.upcase,
                  size: :md,
                  shape: :circle
                )
              end
            end

            div(class: chat_bubble_classes) do
              if @message.present?
                span { @message }
              end

              if @attachment_block
                instance_eval(&@attachment_block)
              end
            end

            # Chat footer - can be used for delivery status, etc.
            if @footer_text.present?
              div(class: "decor:d-chat-footer decor:opacity-50") do
                span { @footer_text }
              end
            end
          end
        end

        private

        def format_timestamp
          if older_than_24_hours?
            @localised_created_at.strftime("%m/%d")
          else
            @localised_created_at.strftime("%H:%M")
          end
        end

        def older_than_24_hours?
          Time.current - @localised_created_at > 24.hours
        end

        def chat_bubble_classes
          base_classes = "decor:d-chat-bubble"

          if @is_current_user
            "#{base_classes} decor:d-chat-bubble-primary"
          else
            base_classes
          end
        end

        def root_element_classes
          base_classes = "decor:d-chat"

          if @is_current_user
            "#{base_classes} decor:d-chat-end"
          else
            "#{base_classes} decor:d-chat-start"
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
end
