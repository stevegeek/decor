require "test_helper"

class Decor::Forms::TagWrappers::ValidationParsers::TextFieldTest < ActiveSupport::TestCase
  test "returns mapped attributes for text field validations" do
    validations = {
      something: [{}],
      presence: [{}],
      length: [{minimum: 1}, {maximum: 5}],
      numericality: [{something: 1}]
    }

    tag_properties = Decor::Forms::TagWrappers::ValidationParsers::TextField.call(validations)

    expected_result = {required: true, numerical: true, minimum_length: 1, maximum_length: 5}
    assert_equal expected_result, tag_properties
  end
end
