# frozen_string_literal: true

module Decor
  module Concerns
    module SanitisedSortAndFilterParams
      extend ActiveSupport::Concern

      included do
        prop :sort_parameter_name, Symbol, default: :sort_by
        prop :sorted_direction_parameter_name, Symbol, default: :sorted_direction

        prop :sorted_direction, _Nilable(Symbol)
        prop :sort_by, _Nilable(Symbol)
        prop :sorting_keys, _Array(Symbol), default: -> { [] }
      end

      private

      def sanitised_sort_by
        @sanitised_sort_by ||= begin
          key = @sort_by || default_sort_by
          (key && @sorting_keys.include?(key)) ? key : nil
        end
      end

      def sanitised_sorted_direction
        if @sorted_direction.present?
          (@sorted_direction == :asc) ? :asc : :desc
        else
          default_sort_direction
        end
      end

      # Can be overridden
      def default_sort_direction
        :asc
      end

      def default_sort_by
      end
    end
  end
end
