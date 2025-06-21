require "test_helper"

class Decor::Forms::ActionViewFormBuilderTest < ActiveSupport::TestCase
  def setup
    @fake_class = Class.new(ActionView::Base).with_empty_template_cache
    stub_const "FormBuilderTestFakeView", @fake_class

    # https://stackoverflow.com/questions/19628063/testing-a-rails-formbuilder-extension
    # https://stackoverflow.com/questions/5791211/how-do-i-extract-rails-view-helpers-into-a-gem
    @form = ExampleForm.factory_one
    @view = FormBuilderTestFakeView.send(:include, ViewComponentsHelper).new(
      ActionView::LookupContext.new(""),
      {},
      {}
    )
    @builder = Decor::Forms::ActionViewFormBuilder.new :form, @form, @view, {}

    ActionView::PathRegistry.set_view_paths(@view.lookup_context, @view.lookup_context.view_paths + ["app/views"])
  end

  test "collection_radio_buttons performs valid calls to TagWrappers::RadioButton" do
    collection = [
      OpenStruct.new(text: "United States", value: "US"),
      OpenStruct.new(text: "Canada", value: "CA")
    ]

    # Mock the RadioButton class
    mock_radio_button = Minitest::Mock.new
    mock_radio_button.expect :new, mock_radio_button, [
      :form, :a_radio_option, ActionView::Base, "US", Hash
    ]
    mock_radio_button.expect :new, mock_radio_button, [
      :form, :a_radio_option, ActionView::Base, "CA", Hash
    ]

    Decor::Forms::TagWrappers::RadioButton.stub :new, mock_radio_button do
      @builder.collection_radio_buttons :a_radio_option, collection, :value, :text, label: "Radio Collection"
    end

    mock_radio_button.verify
  end

  test "collection_radio_buttons concatenates the returns from radio button methods" do
    collection = [
      OpenStruct.new(text: "United States", value: "US"),
      OpenStruct.new(text: "Canada", value: "CA")
    ]

    @builder.stub(:radio_button, "radio_button_") do
      output = @builder.collection_radio_buttons :a_radio_option, collection, :value, :text, label: "Radio Collection"
      assert_equal "radio_button_radio_button_", output
    end
  end

  test "collection_radio_buttons generates html" do
    collection = [
      OpenStruct.new(text: "United States", value: "US"),
      OpenStruct.new(text: "Canada", value: "CA")
    ]

    html = @builder.collection_radio_buttons :a_radio_option, collection, :value, :text, label: "Radio Collection"
    assert_match(/<input.*type="radio"/m, html)
  end

  test "radio_button generates html" do
    html = @builder.radio_button :a_radio_option, "1", label: "Radio"
    assert_match(/<input.*type="radio"/m, html)
  end

  test "radio_button instantiates TagWrappers::RadioButton instance with correct args" do
    mock_radio_button = Minitest::Mock.new
    mock_radio_button.expect :new, mock_radio_button, [
      :form, :a_radio_option, ActionView::Base, "gaga", Hash
    ]
    mock_radio_button.expect :render, "radio_button"

    Decor::Forms::TagWrappers::RadioButton.stub :new, mock_radio_button do
      @builder.radio_button :a_radio_option, "gaga", label: "Radio"
    end

    mock_radio_button.verify
  end

  test "radio_button returns the rendered TagWrapper::RadioButton" do
    mock_radio_button = Minitest::Mock.new
    mock_radio_button.expect :render, "radio_button"

    Decor::Forms::TagWrappers::RadioButton.stub :new, mock_radio_button do
      output = @builder.radio_button :a_radio_option, "gaga", label: "Radio"
      assert_equal "radio_button", output
    end

    mock_radio_button.verify
  end

  test "check_box generates html" do
    html = @builder.check_box :a_boolean_choice, label: "checkbox"
    assert_match(/<input.*type="checkbox"/m, html)
  end

  test "select generates html" do
    html = @builder.select :some_string_from_list_maybe, [%w[One one], %w[Two two]], label: "checkbox"
    assert_includes html, "name=\"form[some_string_from_list_maybe]\""
    assert_includes html, "<option selected=\"selected\" value=\"one\">One</option>"
  end

  test "collection_select instantiates TagWrappers::Select with valid args" do
    collection = [
      OpenStruct.new(text: "Mexica", value: "ME"),
      OpenStruct.new(text: "Canada", value: "CA")
    ]

    mock_select = Minitest::Mock.new
    mock_select.expect :new, mock_select, [
      :form, :a_string, FormBuilderTestFakeView, Array, Hash, Hash
    ]
    mock_select.expect :render, "collection_select"

    Decor::Forms::TagWrappers::Select.stub :new, mock_select do
      @builder.collection_select :a_string, collection, :value, :text, {}, {label: "Collection Select"}
    end

    mock_select.verify
  end

  test "collection_select returns the result of TagWrapper::Select render method" do
    collection = [
      OpenStruct.new(text: "Mexica", value: "ME"),
      OpenStruct.new(text: "Canada", value: "CA")
    ]

    mock_select = Minitest::Mock.new
    mock_select.expect :render, "collection_select"

    Decor::Forms::TagWrappers::Select.stub :new, mock_select do
      output = @builder.collection_select :a_string, collection, :value, :text, label: "Collection Select"
      assert_equal "collection_select", output
    end

    mock_select.verify
  end

  test "collection_select generates html" do
    collection = [
      OpenStruct.new(text: "Mexica", value: "ME"),
      OpenStruct.new(text: "Canada", value: "CA")
    ]

    html = @builder.collection_select :a_string, collection, :value, :text, label: "Collection Select"
    assert_includes html, "name=\"form[a_string]\""
  end

  test "grouped_collection_select instantiates TagWrappers::Select with valid args" do
    collection = [
      OpenStruct.new(country: "Mexica", cities: [
        OpenStruct.new(name: "capital", value: "Mexico"),
        OpenStruct.new(name: "not a capital", value: "Zapopan")
      ])
    ]

    mock_select = Minitest::Mock.new
    mock_select.expect :new, mock_select, [
      :form, :a_string, FormBuilderTestFakeView, Array, Hash, Hash
    ]
    mock_select.expect :render, "grouped_collection_select"

    Decor::Forms::TagWrappers::Select.stub :new, mock_select do
      @builder.grouped_collection_select :a_string, collection, :cities, :country, :name, :value, {},
        {label: "Grouped Collection Select"}
    end

    mock_select.verify
  end

  test "grouped_collection_select returns the result of TagWrapper::Select render method" do
    collection = [
      OpenStruct.new(country: "Mexica", cities: [
        OpenStruct.new(name: "capital", value: "Mexico"),
        OpenStruct.new(name: "not a capital", value: "Zapopan")
      ])
    ]

    mock_select = Minitest::Mock.new
    mock_select.expect :render, "grouped_collection_select"

    Decor::Forms::TagWrappers::Select.stub :new, mock_select do
      output = @builder.grouped_collection_select :a_string, collection, :cities, :country, :name, :value, {},
        {label: "Grouped Collection Select"}
      assert_equal "grouped_collection_select", output
    end

    mock_select.verify
  end

  test "grouped_collection_select generates html" do
    collection = [
      OpenStruct.new(country: "Mexica", cities: [
        OpenStruct.new(name: "capital", value: "Mexico"),
        OpenStruct.new(name: "not a capital", value: "Zapopan")
      ])
    ]

    html = @builder.grouped_collection_select :a_string, collection, :cities, :country, :name, :value
    assert_includes html, "name=\"form[a_string]\""
  end

  test "text_field generates html" do
    html = @builder.text_field :a_string
    assert_match(/<input.*type="text"/m, html)
  end

  test "text_area generates html" do
    html = @builder.text_area :a_long_string
    assert_match(/<textarea.*name="form\[a_long_string\]"/m, html)
  end

  test "number_field generates html" do
    html = @builder.number_field :a_number_between
    assert_match(/<input.*type="number"/m, html)
  end

  test "password_field generates html" do
    html = @builder.password_field :a_string
    assert_match(/<input.*type="password"/m, html)
  end

  test "email_field generates html" do
    html = @builder.email_field :a_string
    assert_match(/<input.*type="email"/m, html)
  end

  test "submit generates html" do
    html = @builder.submit "Submit"
    assert_includes html, "type=\"submit\""
  end

  private

  def stub_const(const_name, value)
    if Object.const_defined?(const_name)
      @original_const = Object.const_get(const_name)
      Object.send(:remove_const, const_name)
    end
    Object.const_set(const_name, value)

    # This will be cleaned up in teardown if needed
  end
end
