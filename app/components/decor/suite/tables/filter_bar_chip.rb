# frozen_string_literal: true

module Decor
  module Suite
    module Tables
      # Suite FilterBarChip — single clickable chip inside a FilterBar. Renders
      # as an `<a>` carrying the rebuilt query string for its `param_name`
      # (page reset, value added/removed). Active chips swap to the suite-
      # primary tinted surface; an optional icon + numeric count are
      # supported. Passive UI; no Stimulus controller.
      class FilterBarChip < ::Decor::PhlexComponent
        no_stimulus_controller

        include Phlex::Rails::Helpers::Request

        prop :label, String, reader: :public
        prop :value, _Nilable(String), reader: :public
        prop :count, _Nilable(Integer), predicate: :public, reader: :public
        prop :active, _Boolean, default: false, predicate: :public, reader: :public
        prop :icon, _Nilable(String), predicate: :public, reader: :public
        prop :param_name, Symbol, default: :by_status, reader: :public

        def view_template
          root_element(href: chip_href) do
            if icon?
              render ::Decor::Icon.new(name: icon, classes: "decor:h-3.5 decor:w-3.5")
            end
            plain label
            if count?
              span(class: count_classes) { plain count.to_s }
            end
          end
        end

        private

        def root_element_attributes
          {element_tag: :a}
        end

        def root_element_classes
          base = "decor:inline-flex decor:items-center decor:gap-1.5 decor:px-2.5 decor:py-1 decor:rounded-suite-control decor:text-xs decor:font-medium decor:border decor:cursor-pointer decor:transition-colors decor:duration-suite-fast decor:ease-out decor:leading-none decor:select-none"
          if active?
            "#{base} decor:bg-suite-primary-50 decor:text-suite-primary-700 decor:border-suite-primary-200"
          else
            "#{base} decor:bg-white decor:border-suite-hairline decor:text-gray-700 decor:hover:bg-gray-50"
          end
        end

        def count_classes
          if active?
            "decor:inline-flex decor:items-center decor:justify-center decor:min-w-[18px] decor:h-[18px] decor:px-[5px] decor:rounded-full decor:c-micro decor:font-semibold decor:font-tabular-nums decor:bg-suite-primary-100 decor:text-suite-primary-700"
          else
            "decor:inline-flex decor:items-center decor:justify-center decor:min-w-[18px] decor:h-[18px] decor:px-[5px] decor:rounded-full decor:c-micro decor:font-semibold decor:font-tabular-nums decor:bg-gray-200 decor:text-gray-700"
          end
        end

        def chip_href
          uri = URI.parse(request.fullpath)
          # CGI.parse was removed from Ruby's stdlib; use URI.decode_www_form
          # and group repeated keys into arrays for the same shape.
          query = uri.query ? URI.decode_www_form(uri.query).each_with_object({}) { |(k, v), h| (h[k] ||= []) << v } : {}
          # Remove pagination when changing filters
          query.delete("page")
          if value.present?
            query[param_name.to_s] = [value]
          else
            query.delete(param_name.to_s)
          end
          uri.query = query.any? ? query.to_query : nil
          uri.to_s
        end
      end
    end
  end
end
