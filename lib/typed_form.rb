# frozen_string_literal: true

class TypedForm < ::Literal::Struct
  extend ::ActiveModel::Naming
  include ::ActiveModel::Validations
  include ::ActiveModel::Validations::Callbacks

  prop :persisted, _Boolean, default: false

  def persisted?
    @persisted
  end

  class << self
    # Validations
    def validates_form(*attr_names)
      # Based on ActiveRecord::Validations `validates_associated`
      validates_with ::ActiveRecord::Validations::AssociatedValidator, _merge_attributes(attr_names)
    end

    # Utility methods

    # The name of the form, used by form builders
    def form_name
      model_name.param_key
    end

    # The params keys to be permitted by the controller to pass all attributes to this form
    def keys_for_permit
      # TODO:
      # prop_names.map { |key| permitted_key(key) }
    end


    def prop_names
      literal_properties.properties_index.keys.map(&:to_sym)
    end
  end

  # Access via #[] is indifferent to key type
  def [](key)
    send(key.to_sym)
  end

  # Returns an indifferent hash of the attributes that are resolved to include
  # default values and that are not nil.
  # In a form model the attributes should not include the :id by default.
  def attributes(include_id: false)
    @attributes ||= begin
                      # Use the schema attribute names directly (symbols)
                      attrs = self.class.prop_names.map do |attr_name|
                        value = instance_variable_get(:"@#{attr_name}")
                        [attr_name, value] unless value.nil?
                      end
                      final_attrs = attrs.compact.to_h
                      ActiveSupport::HashWithIndifferentAccess.new(include_id ? final_attrs : final_attrs.except(:id))
                    end
  end

  # When splatting for keyword arguments, use original attributes store to ensure all attributes are present and
  # symbol keys are used.
  def to_hash
    attributes(include_id: true)
  end

  def to_h
    to_hash
  end

  # Necessary for AssociatedValidator which we have stolen from ActiveRecord
  def custom_validation_context? # :nodoc:
    validation_context && [:create, :update].exclude?(validation_context)
  end

  # Utilities

  def ==(other)
    other.class == self.class && other.to_hash == to_hash
  end
  alias_method :eql?, :==

  def as_json(options = {})
    to_hash.as_json(options.merge(except: [:persisted, "persisted"]))
  end

  def cache_key
    raise NoMethodError, "You must implement `cache_key` in your form class"
  end

  def to_key
    [self.class.form_name, cache_key]
  end

  def to_params
    {self.class.form_name => attributes}
  end

  # Note: when you copy you create a new form object which means any validation errors
  # will be reset. Ie remember to re-validate the form after copying if you want to ensure
  # the form is valid.
  def copy(**params)
    self.class.new(attributes: attributes.merge(params), persisted: @persisted, context: @context)
  end

  # Override this method to apply any transformations to the attributes
  def apply_transformations(attributes)
    attributes || {}
  end
end
