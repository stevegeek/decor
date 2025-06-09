# frozen_string_literal: true

module Decor
  module Concerns
    module ActsAsLink
      extend ActiveSupport::Concern

      included do
        # Link href
        attribute :href, String, allow_nil: true, allow_blank: false

        # Link target
        attribute :target, String, allow_nil: true, allow_blank: false

        # Data attributes for custom data
        attribute :data, Hash, allow_nil: true

        # HTTP method for Turbo forms
        attribute :http_method, Symbol, in: [:get, :put, :post, :patch, :delete], allow_nil: true

        # Turbo frame target
        attribute :turbo_frame, String, allow_nil: true

        # Turbo prefetch behavior
        attribute :turbo_prefetch, Symbol, in: [:hover, :viewport], allow_nil: true

        # Turbo confirmation prompt
        attribute :turbo_confirm, String, allow_nil: true

        # Disable Turbo for this link
        attribute :turbo, :boolean, default: true
      end

      private

      def root_element_attributes
        {
          element_tag: link_element_tag,
          html_options: link_html_options
        }
      end

      def link_element_tag
        :a
      end

      def link_html_options
        options = base_link_options.merge(data_attributes)

        if @disabled && link_element_tag == :button
          # Disabled button attributes
          options.merge(disabled: "disabled").except(:href, :target)
        elsif @disabled
          # Disabled link attributes
          options.merge(
            "aria-disabled": "true",
            role: "link",
            tabindex: "-1"
          ).except(:href)
        else
          # Active link attributes
          options
        end
      end

      def base_link_options
        {
          href: @href,
          target: @target
        }.compact
      end

      def data_attributes
        return {} unless needs_data_attributes?

        attrs = (@data || {}).dup

        # Turbo method (uses data-turbo-method instead of data-method)
        attrs["turbo-method"] = @http_method.to_s if @http_method.present? && @http_method != :get

        # Turbo frame
        attrs["turbo-frame"] = @turbo_frame if @turbo_frame.present?

        # Turbo prefetch
        attrs["turbo-prefetch"] = @turbo_prefetch.to_s if @turbo_prefetch.present?

        # Turbo confirm
        attrs["turbo-confirm"] = @turbo_confirm if @turbo_confirm.present?

        # Disable Turbo
        attrs["turbo"] = "false" if @turbo == false

        attrs.empty? ? {} : {data: attrs}
      end

      def needs_data_attributes?
        @data.present? ||
          (@http_method.present? && @http_method != :get) ||
          @turbo_frame.present? ||
          @turbo_prefetch.present? ||
          @turbo_confirm.present? ||
          !@turbo
      end
    end
  end
end
