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
        # ONLY the window-scoped dismiss belongs on the root: it light-dismisses
        # the filter dropdown (`toggle` stopPropagation()s so its own click never
        # reaches this listener). toggle / apply / clear / keydown / range-picker
        # are bound to their own child elements by each variant — a root `click`
        # action fires on EVERY click in the subtree, so an actions-slot CTA would
        # trigger apply+clear → reloadWith → full-page nav, tearing down a modal it
        # just opened.
        action :hide_on_click_outside, on: :click, window: true
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
