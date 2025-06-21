# frozen_string_literal: true

module Decor
  module Forms
    # Maps ActiveModel or ActiveRecord validations from the given model/AM instance to an intermediate representation which
    # will then be used to map to View Component attributes. Note currently only a few validations are mapped
    module TagWrappers
      class ValidationMapping
        MAPPINGS =
          [
            {
              type: [
                ::ActiveModel::Validations::LengthValidator,
                ::ActiveRecord::Validations::LengthValidator
              ],
              method: ->(acc, options) { (acc[:length] ||= []) << options }
            },
            {
              type: [::ActiveModel::Validations::NumericalityValidator],
              method: ->(acc, options) { (acc[:numericality] ||= []) << options }
            },
            {
              type: [::ActiveModel::Validations::FormatValidator],
              method: ->(acc, options) do
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
              method: ->(acc, options) { (acc[:presence] ||= []) << options }
            },
            {
              # Used by typed attrs to exclude nil - can be ignored as nil isn't a possible UI value and we should not
              # equate to blank which is presence
              type: [::ActiveModel::Validations::ExclusionValidator],
              method: ->(acc, options) {}
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
              mapper[:method].call(acc, options)
            elsif ::Rails.env.development?
              ::Logging::Log.warn "Ignored validation '#{klass}' on #{object.class.name}.'#{method_name}'#{has_conditionals ? " as has conditional logic" : ""} (caller: #{name})", caller: name, related: object
            end
          end
        end
      end
    end
  end
end
