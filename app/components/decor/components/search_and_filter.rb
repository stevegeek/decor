# frozen_string_literal: true

module Decor
  module Components
    class SearchAndFilter < ::Decor::PhlexComponent
      include ::Decor::Concerns::SanitisedSortAndFilterParams

      class Filter < Literal::Data
        prop :type, _Union(:select, :checkbox, :date_range)
        prop :name, String
        prop :label, String
        prop :value, _Nilable(String)

        prop :disabled, _Boolean, default: false
        prop :placeholder, _Nilable(String)

        prop :options, Array, default: [].freeze
        prop :disabled_options, Array, default: [].freeze

        prop :apply, _Nilable(Proc)
      end

      class Search < Literal::Data
        prop :name, String
        prop :label, String
        prop :value, _Nilable(String)
        prop :placeholder, _Nilable(String), default: "Search..."
        prop :apply, _Nilable(Proc)
      end

      prop :url, _Nilable(String)
      prop :filters, _Array(::Decor::Components::SearchAndFilter::Filter), default: -> { [] }

      prop :search, _Nilable(Search)

      prop :download_path, _Nilable(String)

      stimulus do
        actions [:click, :toggle], ["click@window", :hide_on_click_outside],
          [:keydown, :handle_search_input_keydown],
          [:focus, :handle_range_picker],
          [:click, :handle_clear_filters],
          [:click, :handle_apply]
      end

      def actions(&block)
        @actions = block
      end

      def with_actions(&block)
        @actions = block
        self
      end

      def filters(&block)
        @filters_slot = block
      end

      def with_filters(&block)
        @filters_slot = block
        self
      end

      def filters_on?
        @filters.any? { |s| s.value.present? } || @search&.value&.present?
      end
    end
  end
end
