# frozen_string_literal: true

module Decor
  module Suite
    module Tables
      # Suite FilterBar — horizontal chip-row above a data table for switching
      # the active filter scope (e.g. ?by_status=open). Renders chips left and
      # an optional muted "meta" string right-aligned (count/timestamp). Holds
      # a list of FilterBarChip children — populate via `with_chip(...)`
      # before rendering. Passive UI; no Stimulus controller.
      class FilterBar < ::Decor::PhlexComponent
        no_stimulus_controller

        prop :param_name, Symbol, default: :by_status, reader: :public
        prop :meta, _Nilable(String), predicate: :public, reader: :public

        def after_component_initialize
          @chips = []
        end

        def with_chip(label:, value: nil, count: nil, active: false, icon: nil)
          chip = ::Decor::Suite::Tables::FilterBarChip.new(
            label: label,
            value: value,
            count: count,
            active: active,
            icon: icon,
            param_name: param_name
          )
          @chips << chip
          chip
        end

        def chips? = @chips.any?

        def view_template(&)
          capture(&) if block_given?

          root_element do
            div(class: "decor:flex decor:items-center decor:gap-2 decor:flex-wrap") do
              @chips.each { |chip| render chip }
            end

            if meta?
              div(class: "decor:ml-auto decor:flex decor:items-center decor:shrink-0") do
                span(class: "decor:text-xs decor:text-gray-500 decor:font-tabular-nums") { plain meta.to_s }
              end
            end
          end
        end

        private

        def root_element_attributes
          {element_tag: :div}
        end

        def root_element_classes
          "decor:w-full decor:flex decor:items-center decor:gap-2 decor:pl-5 decor:pr-4 decor:py-[9px] decor:border-b decor:border-suite-hairline decor:bg-suite-gray-25"
        end
      end
    end
  end
end
