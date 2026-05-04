# frozen_string_literal: true

module Decor
  module Components
    class Pagination
      class PagesToDisplay
        # <start -> before ellipsis>, ..., <before>, <current>, <after>, ..., <after ellipsis -> end>
        LINKS_BEFORE_ELLIPSIS = 1
        LINKS_BEFORE_CURRENT = 1
        LINKS_AFTER_CURRENT = 1
        LINKS_AFTER_ELLIPSIS = 1

        # Total links = Current + elipsis buttons + links
        TOTAL_LINKS = 1 + 2 + LINKS_BEFORE_ELLIPSIS + LINKS_BEFORE_CURRENT + LINKS_AFTER_CURRENT + LINKS_AFTER_ELLIPSIS

        # Max links under ellipsis dropdowns
        MAX_LINKS_UNDER_ELLIPSIS = 50

        def initialize(current_page, total_page_count, &block)
          @current_page = current_page
          @total_page_count = total_page_count
          @url_for_page = block
        end

        attr_reader :current_page, :total_page_count, :url_for_page

        def indicies_and_ellipses
          from = [current_page - LINKS_BEFORE_CURRENT, 1].max
          delta = if total_page_count - current_page <= LINKS_AFTER_ELLIPSIS + LINKS_BEFORE_CURRENT
            LINKS_BEFORE_ELLIPSIS - (total_page_count - (current_page + LINKS_AFTER_CURRENT + LINKS_BEFORE_ELLIPSIS))
          else
            0
          end
          max_links = LINKS_BEFORE_ELLIPSIS + delta
          initial_links_to_create = [[from - LINKS_BEFORE_ELLIPSIS - 1, 0].max, max_links].min # rubocop:disable Style/ComparableClamp
          pages = (1..initial_links_to_create).to_a
          if from - 2 > initial_links_to_create
            range_end = [from - 1, initial_links_to_create + 1 + MAX_LINKS_UNDER_ELLIPSIS].min
            pages << ((initial_links_to_create + 1)..range_end)
          elsif from - 2 == initial_links_to_create
            pages << from - 1
          end

          to_part1 = [from + LINKS_AFTER_CURRENT + LINKS_BEFORE_CURRENT, total_page_count].min
          pages.concat((from..to_part1).to_a)

          if total_page_count > to_part1
            final_links_to_display = [TOTAL_LINKS - pages.size - 1, LINKS_AFTER_ELLIPSIS].max
            start_of_part2 = total_page_count - final_links_to_display - 1
            from_part2 = [total_page_count - final_links_to_display + 1, to_part1 + 1].max
            to_part2 = total_page_count

            if to_part1 < start_of_part2
              range_end = [from_part2 - 1, to_part1 + 1 + MAX_LINKS_UNDER_ELLIPSIS].min
              pages << ((to_part1 + 1)..range_end)
            elsif to_part1 == start_of_part2
              pages << to_part1 + 1
            end
            pages.concat((from_part2..to_part2).to_a)
          end

          pages.map { |page| page_button_info(page) }
        end

        private

        def page_button_info(page)
          if page.is_a?(Range)
            first = page.first
            last = page.last
            dropdown_pages = (first..last).map { |i| page_button_info(i) }
            return {start: first, end: last, list_of_pages_for_dropdown: dropdown_pages}
          end
          {index: page, current: page == current_page, path: url_for_page.call(page)}
        end
      end
    end
  end
end
