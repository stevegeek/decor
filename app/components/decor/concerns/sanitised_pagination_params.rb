# frozen_string_literal: true

module Decor
  module Concerns
    module SanitisedPaginationParams
      extend ActiveSupport::Concern

      included do
        include Phlex::Rails::Helpers::Request
        include Phlex::Rails::Helpers::UrlFor

        # The name of the query params used for the pagination options
        attribute :page_parameter_name, Symbol, default: :page, allow_blank: false
        attribute :page_size_parameter_name, Symbol, default: :page_size, allow_blank: false

        # Current page number
        attribute :current_page, Integer
        # You can optionally pass the paging size
        attribute :page_size, Integer
        # An array of page sizes that are normal options
        attribute :custom_page_sizes, Array, sub_type: Integer
      end

      private

      def sanitised_current_page
        @current_page&.positive? ? @current_page : 1
      end

      def sanitised_page_size
        return default_page_size if @page_size.nil?
        return standard_page_sizes[-1] if @page_size > standard_page_sizes[-1]
        return 1 if @page_size < 1
        @page_size || default_page_size
      end

      def standard_page_sizes
        @custom_page_sizes.presence || [5, 10, 20, 50, 100, 200]
      end

      def default_page_size
        20
      end

      def url_for_page(page, page_size = nil)
        p = [[@page_parameter_name, page]]
        if page_size || sanitised_page_size != default_page_size
          p << [@page_size_parameter_name, page_size || sanitised_page_size]
        end
        base_url = @path || (respond_to?(:url_for) ? url_for : request.url)
        add_query_params_to_url(base_url, p.to_h)
      end

      def add_query_params_to_url(url, page_params)
        parsed = ::URI.parse(url)
        query = if parsed.query
          ::CGI.parse(parsed.query)
        else
          {}
        end
        other_params = request.query_parameters.except(*page_params.keys)
        query.merge!(other_params)
        query.merge!(page_params)
        parsed.query = query.to_query
        parsed.to_s
      end
    end
  end
end
