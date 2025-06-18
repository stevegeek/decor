# frozen_string_literal: true

module Decor
  module Concerns
    module SanitisedSortAndFilterParams
      extend ActiveSupport::Concern

      included do
        attribute :sort_parameter_name, Symbol, default: :sort_by
        attribute :sorted_direction_parameter_name, Symbol, default: :sorted_direction

        attribute :sorted_direction, Symbol
        attribute :sort_by, Symbol
        attribute :sorting_keys, Array, sub_type: Symbol, default: []
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
