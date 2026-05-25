# frozen_string_literal: true

require "js_regex"

module Decor
  module Forms
    # Note: only a subset of ActiveModel/ActiveRecord validations are mapped.
    module TagWrappers
      class ValidationMapping
        # Validator option keys whose values may be a Proc or Symbol that
        # ActiveModel resolves against the record at validation time. For
        # example Devise 5 declares the password length as
        # `maximum: proc { password_length.max }`. We resolve these the same
        # way ActiveModel does so the static field attributes (maxlength, min,
        # max) reflect the concrete value.
        LENGTH_BOUND_KEYS = %i[minimum maximum is].freeze
        NUMERICALITY_BOUND_KEYS = %i[
          greater_than greater_than_or_equal_to less_than less_than_or_equal_to equal_to other_than
        ].freeze

        MAPPINGS =
          [
            {
              type: [
                ::ActiveModel::Validations::LengthValidator,
                ::ActiveRecord::Validations::LengthValidator
              ],
              method: ->(acc, options, object) do
                (acc[:length] ||= []) << ValidationMapping.resolve_bounds(options, object, LENGTH_BOUND_KEYS)
              end
            },
            {
              type: [::ActiveModel::Validations::NumericalityValidator],
              method: ->(acc, options, object) do
                (acc[:numericality] ||= []) << ValidationMapping.resolve_bounds(options, object, NUMERICALITY_BOUND_KEYS)
              end
            },
            {
              type: [::ActiveModel::Validations::FormatValidator],
              method: ->(acc, options, _object) do
                format_options = options.dup
                format_options[:js_regexp] = ::JsRegex.new(options[:with]).source if options[:with]
                (acc[:format] ||= []) << format_options
              end
            },
            {
              type: [
                ::ActiveModel::Validations::PresenceValidator,
                ::ActiveRecord::Validations::PresenceValidator
              ],
              method: ->(acc, options, _object) { (acc[:presence] ||= []) << options }
            },
            {
              # Used by typed attrs to exclude nil - can be ignored as nil isn't a possible UI value and we should not
              # equate to blank which is presence
              type: [::ActiveModel::Validations::ExclusionValidator],
              method: ->(acc, _options, _object) {}
            }
          ].flat_map { |i| i[:type].map { |t| [t.name, i] } }.to_h.freeze

        # If options have :if or :unless then ignore as we cant run that on client
        def self.call(object, method_name)
          validations = object.class.validators_on(method_name)
          validations.each_with_object({}) do |v, acc|
            klass = v.class.name
            options = v.options
            has_conditionals = options&.key?(:unless) || options&.key?(:if)
            mapper = MAPPINGS.fetch(klass, nil)
            if mapper && !has_conditionals
              mapper[:method].call(acc, options, object)
            elsif ::Rails.env.development?
              Rails.logger.warn "Ignored validation '#{klass}' on #{object.class.name}.'#{method_name}'#{" as has conditional logic" if has_conditionals} (caller: #{name})"
            end
          end
        end

        # Resolve any Proc/Symbol bound values against the record, mirroring
        # ActiveModel's resolution. Returns the original options untouched when
        # there is nothing to resolve, so plain Integer bounds are a no-op.
        def self.resolve_bounds(options, record, keys)
          resolved = nil
          keys.each do |key|
            next unless options.key?(key)
            value = options[key]
            next unless value.is_a?(::Proc) || value.is_a?(::Symbol)
            (resolved ||= options.dup)[key] = resolve_value(record, value)
          end
          resolved || options
        end

        # Mirrors ActiveModel::Validations::ResolveValue (a private Rails API)
        # so we don't couple to internals.
        def self.resolve_value(record, value)
          case value
          when ::Proc
            (value.arity == 0) ? value.call : value.call(record)
          when ::Symbol
            record.send(value)
          else
            value.respond_to?(:call) ? value.call(record) : value
          end
        end
      end
    end
  end
end
