require "test_helper"

class Decor::Forms::TagWrappers::ValidationParsers::RequiredFieldTest < ActiveSupport::TestCase
  test "returns required true when presence validation exists" do
    validations = {something: [{}], presence: [{}]}
    tag_properties = Decor::Forms::TagWrappers::ValidationParsers::RequiredField.call(validations)

    assert_equal({required: true}, tag_properties)
  end
end
