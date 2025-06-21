require "test_helper"

class Decor::Forms::TagWrappers::ValidationParsers::NumberFieldTest < ActiveSupport::TestCase
  def setup
    @allow_nil = false
    @validations = {
      something: [{}],
      presence: [{}],
      length: [{minimum: 1}, {maximum: 5}],
      numericality: [
        {
          greater_than: 1,
          greater_than_or_equal_to: 2,
          less_than: 6,
          less_than_or_equal_to: 5,
          allow_nil: @allow_nil
        }
      ]
    }
  end

  test "returns mapped attributes and respects required" do
    tag_properties = Decor::Forms::TagWrappers::ValidationParsers::NumberField.call(@validations)

    expected_attrs = {
      required: true,
      minimum_length: 1,
      maximum_length: 5,
      greater_than: 1,
      less_than: 6,
      min: 2,
      max: 5,
      type: "number"
    }

    assert_equal expected_attrs, tag_properties
  end

  test "returns mapped attributes and respects required when allow_nil is true" do
    validations_with_allow_nil = @validations.dup
    validations_with_allow_nil[:numericality] = [
      {
        greater_than: 1,
        greater_than_or_equal_to: 2,
        less_than: 6,
        less_than_or_equal_to: 5,
        allow_nil: true
      }
    ]

    tag_properties = Decor::Forms::TagWrappers::ValidationParsers::NumberField.call(validations_with_allow_nil)

    expected_attrs = {
      required: false,
      minimum_length: 1,
      maximum_length: 5,
      greater_than: 1,
      less_than: 6,
      min: 2,
      max: 5,
      type: "number"
    }

    assert_equal expected_attrs, tag_properties
  end
end
