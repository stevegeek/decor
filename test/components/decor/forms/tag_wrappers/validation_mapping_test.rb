require "test_helper"

class Decor::Forms::TagWrappers::ValidationMappingTest < ActiveSupport::TestCase
  def setup
    @object = ExampleForm.factory_one
  end

  test "maps length validation" do
    attribute = :a_string
    mapped_validations = Decor::Forms::TagWrappers::ValidationMapping.call(@object, attribute)

    assert_equal({minimum: 5, maximum: 15}, mapped_validations[:length].first)
  end

  test "does not map validation with conditional" do
    attribute = :a_long_string
    mapped_validations = Decor::Forms::TagWrappers::ValidationMapping.call(@object, attribute)

    assert_nil mapped_validations[:presence]
  end

  test "maps numericality validation" do
    attribute = :a_number
    mapped_validations = Decor::Forms::TagWrappers::ValidationMapping.call(@object, attribute)

    assert_includes mapped_validations, :numericality
  end

  test "maps format validation" do
    attribute = :a_us_phone
    mapped_validations = Decor::Forms::TagWrappers::ValidationMapping.call(@object, attribute)

    assert_includes mapped_validations, :format
    format_validation = mapped_validations[:format].first
    assert_includes format_validation, :with
    assert_includes format_validation, :js_regexp
  end

  test "maps presence validation" do
    attribute = :some_string_from_list_maybe
    mapped_validations = Decor::Forms::TagWrappers::ValidationMapping.call(@object, attribute)

    assert_includes mapped_validations, :presence
  end
end
