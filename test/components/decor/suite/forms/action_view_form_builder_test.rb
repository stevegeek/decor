# frozen_string_literal: true

require "test_helper"
require "js_regex"
require_relative "../../../../support/example_form"

class ::Decor::Suite::Forms::ActionViewFormBuilderTest < ActiveSupport::TestCase
  def setup
    @form = ::ExampleForm.factory_one
    @builder = ::Decor::Suite::Forms::ActionViewFormBuilder.new(:form, @form, view_context, {})
  end

  test "text_field renders the Suite TextField component" do
    html = @builder.text_field(:a_string)
    assert_includes html, "decor--suite--forms--text-field"
    assert_match(/<input[^>]*type="text"/, html)
    assert_includes html, 'name="form[a_string]"'
  end

  test "email_field renders the Suite TextField component with email type" do
    html = @builder.email_field(:an_email)
    assert_includes html, "decor--suite--forms--text-field"
    assert_match(/<input[^>]*type="email"/, html)
  end

  test "password_field renders the Suite TextField component with password type" do
    html = @builder.password_field(:a_string)
    assert_includes html, "decor--suite--forms--text-field"
    assert_match(/<input[^>]*type="password"/, html)
  end

  test "date_field renders the Suite date-calendar component" do
    html = @builder.date_field(:a_long_string)
    assert_includes html, "decor--suite--forms--date-calendar"
    assert_includes html, "<calendar-date"
  end

  test "number_field renders the Suite NumberField component" do
    html = @builder.number_field(:a_number)
    assert_includes html, "decor--suite--forms--number-field"
    assert_match(/<input[^>]*type="number"/, html)
  end

  test "text_area renders the Suite TextArea component" do
    html = @builder.text_area(:a_long_string)
    assert_includes html, "decor--suite--forms--text-area"
    assert_match(/<textarea[^>]*name="form\[a_long_string\]"/, html)
  end

  test "hidden_field renders the Suite hidden field" do
    html = @builder.hidden_field(:a_string)
    assert_match(/<input[^>]*type="hidden"/, html)
    assert_includes html, 'name="form[a_string]"'
  end

  test "select renders the Suite Select component" do
    html = @builder.select(:some_string_from_list_maybe, [%w[One one], %w[Two two]], label: "List")
    assert_includes html, "decor--suite--forms--select"
    assert_includes html, 'name="form[some_string_from_list_maybe]"'
    assert_includes html, "One"
    assert_includes html, "Two"
  end

  test "check_box renders the Suite Checkbox component" do
    html = @builder.check_box(:a_boolean_choice, label: "Agree")
    assert_includes html, "decor--suite--forms--checkbox"
    assert_match(/<input[^>]*type="checkbox"/, html)
  end

  test "switch renders the Suite Switch component" do
    html = @builder.switch(:a_boolean_choice, label: "On/off")
    assert_includes html, "decor--suite--forms--switch"
  end

  test "radio_button renders a Suite radio input" do
    html = @builder.radio_button(:a_radio_option, "option1", label: "Option 1")
    assert_includes html, "decor--suite--forms--radio"
    assert_match(/<input[^>]*type="radio"/, html)
  end

  test "searchable_select renders the Suite SearchableSelect component" do
    html = @builder.searchable_select(:a_string, label: "Search")
    assert_includes html, "decor--suite--forms--searchable-select"
  end

  test "searchable_multi_select renders the Suite SearchableMultiSelect with [] name" do
    html = @builder.searchable_multi_select(:a_string, label: "Search")
    assert_includes html, "decor--suite--forms--searchable-multi-select"
  end

  test "submit renders a Suite button with type=submit" do
    html = @builder.submit("Save")
    assert_includes html, "decor--suite--button"
    assert_includes html, 'type="submit"'
    assert_includes html, "Save"
  end

  test "submit_primary forwards a primary color to the Suite button" do
    html = @builder.submit_primary("Save")
    assert_includes html, "decor--suite--button"
    assert_includes html, "Save"
  end

  test "button renders a Suite button with the given label" do
    html = @builder.button("Save")
    assert_includes html, "decor--suite--button"
    assert_includes html, "Save"
  end

  test "inherits from the base Decor ActionViewFormBuilder" do
    assert_kind_of ::Decor::Forms::ActionViewFormBuilder, @builder
  end
end
