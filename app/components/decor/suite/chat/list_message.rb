# frozen_string_literal: true

module Decor
  module Suite
    module Chat
      # Suite skin of Chat::ListMessage — a single message row rendered as an
      # email-preview-style list item: small avatar on the left, header
      # (author + timestamp) and message body stacked on the right. Designed
      # to sit inside a <ul> that provides hairline dividers between rows.
      #
      # Own messages (`is_current_user`) get a subtle suite-primary-50 tint
      # and a stronger primary text color on the author name — there is no
      # speech-bubble; bubbles belong to the Daisy skin.
      class ListMessage < ::Decor::Components::Chat::ListMessage
        def view_template(&)
          yield(self) if block_given?

          root_element do
            if @show_avatar
              div(class: "decor:flex-none decor:pt-[2px]") do
                if @author_initials.present? || @author_profile_image_url.present?
                  render ::Decor::Suite::Avatar.new(
                    initials: @author_initials,
                    url: @author_profile_image_url,
                    size: :sm,
                    shape: :circle
                  )
                else
                  span(
                    role: "img",
                    aria_label: "User",
                    class: "decor:inline-flex decor:items-center decor:justify-center decor:w-7 decor:h-7 decor:rounded-full decor:bg-suite-gray-25 decor:border decor:border-suite-hairline decor:text-gray-500"
                  ) do
                    render ::Decor::Icon.new(name: "user", style: :solid, width: 14, height: 14)
                  end
                end
              end
            end

            div(class: "decor:grow decor:min-w-0") do
              div(class: "decor:flex decor:items-baseline decor:flex-wrap decor:gap-x-2 decor:gap-y-0") do
                span(class: "decor:font-semibold decor:suite-body decor:leading-tight #{author_name_color}") { @author_name }
                if @show_timestamp
                  time(
                    datetime: @localised_created_at.iso8601,
                    class: "decor:suite-description decor:font-normal decor:text-gray-500 decor:tabular-nums decor:leading-tight"
                  ) do
                    plain format_timestamp
                  end
                end
              end

              if @attachment_block
                div(class: "decor:mt-2 decor:border decor:border-suite-hairline decor:rounded-suite-card decor:bg-suite-gray-25 decor:p-2 decor:overflow-hidden") do
                  instance_eval(&@attachment_block)
                end
              end

              if @message.present?
                p(class: "decor:mt-1 decor:suite-body decor:leading-6 decor:text-gray-700 decor:m-0 decor:whitespace-pre-wrap") do
                  plain @message
                end
              end

              if @footer_text.present?
                div(class: "decor:mt-1 decor:suite-caption decor:text-gray-500") do
                  span { @footer_text }
                end
              end
            end
          end
        end

        private

        def author_name_color
          if @is_current_user
            "decor:text-suite-primary-700"
          else
            "decor:text-gray-900"
          end
        end

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

        def root_element_attributes
          {element_tag: :li}
        end

        def root_element_classes
          base = "decor--suite--chat-list-message decor:flex decor:items-start decor:gap-3 decor:py-3 decor:px-3 decor:rounded-suite-card"
          if @is_current_user
            "#{base} decor:bg-suite-primary-50"
          else
            base
          end
        end
      end
    end
  end
end
