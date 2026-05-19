require "test_helper"
require "minitest/mock"
require_relative "../../../../../support/example_form"

class Decor::Forms::TagWrappers::Suite::ButtonRadioGroupTest < ActiveSupport::TestCase
  # Choice tuples are `[value, label]`, matching `Decor::Components::Forms::ButtonRadioGroup`.
  CHOICES = [["one", "One"], ["two", "Two"]].freeze

  def setup
    @fake_class = Class.new(ActionView::Base).with_empty_template_cache
    Object.send(:remove_const, :SuiteButtonRadioGroupFakeView) if Object.const_defined?(:SuiteButtonRadioGroupFakeView)
    Object.const_set(:SuiteButtonRadioGroupFakeView, @fake_class)

    @form = ExampleForm.factory_one
    @view = SuiteButtonRadioGroupFakeView.new(ActionView::LookupContext.new(""), {}, {})

    ActionView::PathRegistry.set_view_paths(@view.lookup_context, @view.lookup_context.view_paths + ["app/views"])
  end

  def render_wrapper(method, choices = CHOICES, options = {}, html_options = {})
    Decor::Forms::TagWrappers::Suite::ButtonRadioGroup.new(
      "form",
      method,
      @view,
      choices,
      options.merge(object: @form),
      html_options
    ).render
  end

  test "subclasses the Daisy ButtonRadioGroup tag wrapper" do
    assert_operator Decor::Forms::TagWrappers::Suite::ButtonRadioGroup,
      :<,
      Decor::Forms::TagWrappers::ButtonRadioGroup
  end

  test "BUTTON_RADIO_GROUP_ATTRS pulls prop names from Decor::Suite::Forms::ButtonRadioGroup" do
    expected = Decor::Suite::Forms::ButtonRadioGroup.prop_names.map(&:to_s).freeze
    assert_equal expected, Decor::Forms::TagWrappers::Suite::ButtonRadioGroup::BUTTON_RADIO_GROUP_ATTRS
  end

  test "delegates rendering to Decor::Suite::Forms::ButtonRadioGroup" do
    sentinel = "<!-- suite button radio group sentinel -->"
    fake_component = Object.new
    fake_component.define_singleton_method(:render_in) { |_| sentinel }

    Decor::Suite::Forms::ButtonRadioGroup.stub :new, ->(**_) { fake_component } do
      html = render_wrapper(:some_string_from_list_maybe, CHOICES, label: "Pick")
      assert_includes html, sentinel
    end
  end

  test "applies the Suite ButtonRadioGroup root class" do
    html = render_wrapper(:some_string_from_list_maybe, CHOICES, label: "Pick")
    assert_includes html, "decor--suite--forms--button-radio-group"
  end

  test "renders one radio input per choice with the namespaced form field name" do
    html = render_wrapper(:some_string_from_list_maybe, CHOICES, label: "Pick")
    assert_equal 2, html.scan(/<input[^>]*type="radio"/).size
    assert_includes html, 'name="form[some_string_from_list_maybe]"'
  end

  test "marks the bound value as the checked segment" do
    @form = ExampleForm.new(some_string_from_list_maybe: "two")
    html = render_wrapper(:some_string_from_list_maybe, CHOICES, label: "Pick")
    assert_match(/<input[^>]*value="two"[^>]*checked/, html)
    refute_match(/<input[^>]*value="one"[^>]*checked/, html)
  end

  test "renders each choice label text" do
    html = render_wrapper(:some_string_from_list_maybe, CHOICES, label: "Pick")
    assert_includes html, "One"
    assert_includes html, "Two"
  end

  test "renders the supplied group label when show_label is set" do
    html = render_wrapper(:some_string_from_list_maybe, CHOICES, label: "Pick One", show_label: true)
    assert_includes html, "Pick One"
  end

  test "accepts a Range of choices via the inherited initializer" do
    html = render_wrapper(:some_string_from_list_maybe, (1..3), label: "Pick")
    # The base wrapper converts the Range to an Array before passing it on.
    assert_equal 3, html.scan(/<input[^>]*type="radio"/).size
  end
end
