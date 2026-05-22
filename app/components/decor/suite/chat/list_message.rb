# frozen_string_literal: true

module Decor
  module Suite
    module Chat
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
                span(class: "decor:font-semibold decor:suite-section-title decor:text-gray-900 decor:leading-tight") { @author_name }
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

        def format_timestamp
          if I18n.t(:"time.formats.date_time_concise", default: nil)
            I18n.l(@localised_created_at, format: :date_time_concise)
          else
            @localised_created_at.strftime("%b %-d, %H:%M")
          end
        end

        def root_element_attributes
          {element_tag: :li}
        end

        def root_element_classes
          "decor--suite--chat-list-message decor:flex decor:items-start decor:gap-3 decor:py-3"
        end
      end
    end
  end
end
