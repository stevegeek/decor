# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Pagination. Owns the prop API + shared
    # SanitisedPaginationParams/StyleColorClasses includes + the
    # page-arithmetic helpers (current_page, total_count, page_indicies_and_ellipses,
    # *_page_path methods etc.). Concrete skins (Daisy, Suite) inherit and
    # provide `view_template` plus their visual-language overrides.
    class Pagination < ::Decor::PhlexComponent
      include ::Decor::Concerns::SanitisedPaginationParams
      include ::Decor::Concerns::StyleColorClasses

      no_stimulus_controller

      default_size :md
      default_color :base
      default_style :filled

      prop :page_size_selector, _Boolean, default: false

      # Pagination requires you pass a Quo::Query
      prop :collection, ::Quo::Query

      # Total count can be optionally set to override or set the total from the collection.
      # Also note if current_page is not set, it will be taken from the collection.
      prop :total_count, _Nilable(Integer)

      # Optionally set the path that the pagination links are for, else `url_for` is used
      # and thus the path is implicit based on controller and action
      prop :path, _Nilable(String)

      private

      def current_page
        @current_page || paginated.page || 1
      end

      def page_size
        return @page_size unless @page_size.nil?
        paginated.page_size || default_page_size
      end

      def total_count
        @total_count ||= paginated.results.total_count
      end

      def start_index
        (current_page - 1) * current_per_page + 1
      end

      def end_index
        (current_last_index > total_count) ? total_count : current_last_index
      end

      def page_sizes
        return standard_page_sizes if standard_page_sizes.include?(sanitised_page_size)
        (standard_page_sizes << sanitised_page_size).sort
      end

      def first_page?
        current_page.nil? || current_page == 1
      end

      def total_page_count
        c = (total_count.to_f / sanitised_page_size).ceil
        (c < 1) ? 1 : c
      end

      def last_page?
        current_page.present? && current_page >= total_page_count
      end

      def first_page_path
        url_for_page(1)
      end

      def next_page_path
        url_for_page([current_page + 1, total_page_count].min)
      end

      def prev_page_path
        url_for_page([1, current_page - 1].max)
      end

      def last_page_path
        url_for_page(total_page_count)
      end

      def page_indicies_and_ellipses
        pages_to_display.indicies_and_ellipses
      end

      # Path for page size selector - resets page to 1
      def page_size_selector_path(page_size)
        url_for_page(1, page_size)
      end

      def pages_to_display
        @pages_to_display ||= ::Decor::Components::Pagination::PagesToDisplay.new(current_page, total_page_count) do |page|
          url_for_page(page)
        end
      end

      def paginated
        @collection
      end

      def current_per_page
        paginated.page_size
      end

      def current_last_index
        current_page * current_per_page
      end
    end
  end
end
