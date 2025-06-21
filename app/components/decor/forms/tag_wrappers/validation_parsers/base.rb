# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      module ValidationParsers
        class Base
          MAPPERS = {
            presence: ->(_v) do
              {required: true}
            end,
            length: ->(v) do
              {}.tap do |props|
                props[:minimum_length] = v[:minimum] unless v[:minimum].nil?
                props[:maximum_length] = v[:maximum] unless v[:maximum].nil?
              end
            end,
            numericality_number_field: {
              key: :numericality,
              mapper: ->(v) do
                options = {
                  type: "number",
                  greater_than: v[:greater_than],
                  min: v[:greater_than_or_equal_to],
                  less_than: v[:less_than],
                  max: v[:less_than_or_equal_to]
                }
                options[:required] = !v[:allow_nil] if v.key?(:allow_nil)
                options
              end
            },
            numericality_text_field: {
              key: :numericality,
              mapper: ->(_v) do
                {numerical: true}
              end
            },
            format: ->(v) do
              {pattern: v[:js_regexp]} if v[:js_regexp].present?
            end
          }.freeze

          class << self
            def call(validations)
              return {} if validations.blank?
              validations.keys.each_with_object({}) do |type_name, acc|
                mapped = validations[type_name].each_with_object({}) do |v, props|
                  mapper = @_mappers[type_name]
                  next unless mapper
                  props.merge!(mapper.call(v))
                end
                acc.merge! mapped
              end
            end

            private

            MAPPERS.each do |name, mapper|
              key = name.to_sym
              define_method(:"validates_#{key}") do
                @_mappers ||= {}
                if mapper.is_a? Proc
                  @_mappers[key] = mapper
                else
                  @_mappers[mapper[:key]] = mapper[:mapper]
                end
              end
            end
          end
        end
      end
    end
  end
end
