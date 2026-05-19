require "test_helper"
require "minitest/mock"
require "support/example_form"

class Decor::Forms::TagWrappers::Suite::DateFieldTest < ActiveSupport::TestCase
  def setup
    @fake_class = Class.new(ActionView::Base).with_empty_template_cache
    if Object.const_defined?(:SuiteDateFieldTestFakeView)
      Object.send(:remove_const, :SuiteDateFieldTestFakeView)
    end
    Object.const_set(:SuiteDateFieldTestFakeView, @fake_class)

    @form = ExampleForm.factory_one
    @view = SuiteDateFieldTestFakeView.new(
      ActionView::LookupContext.new(""),
      {},
      {}
    )
    @builder = Decor::Suite::Forms::ActionViewFormBuilder.new :form, @form, @view, {}

    ActionView::PathRegistry.set_view_paths(@view.lookup_context, @view.lookup_context.view_paths + ["app/views"])
  end

  test "inherits from the Daisy DateField wrapper" do
    assert_operator Decor::Forms::TagWrappers::Suite::DateField, :<, Decor::Forms::TagWrappers::DateField
  end

  test "DATE_FIELD_ATTRS mirrors the Suite DateCalendar prop names" do
    expected = Decor::Suite::Forms::DateCalendar.prop_names.map(&:to_s)
    assert_equal expected, Decor::Forms::TagWrappers::Suite::DateField::DATE_FIELD_ATTRS
  end

  test "tag renders a Suite DateCalendar component" do
    captured = nil
    Decor::Suite::Forms::DateCalendar.stub :new, ->(**kwargs) {
      captured = kwargs
      Decor::Suite::Forms::DateCalendar.allocate.tap do |inst|
        inst.define_singleton_method(:render_in) { |_view| "<suite-date-calendar/>".html_safe }
        inst.define_singleton_method(:call) { "<suite-date-calendar/>".html_safe }
      end
    } do
      wrapper = Decor::Forms::TagWrappers::Suite::DateField.new(
        "form", "a_string", @view, {object: @form}
      )
      html = wrapper.render
      assert_includes html.to_s, "<suite-date-calendar/>"
    end
    refute_nil captured, "Suite DateCalendar.new was not invoked"
    assert_equal "form", captured[:object_name]
    assert_equal "a_string", captured[:method_name]
    assert_equal "test string", captured[:value]
  end

  test "renders an HTML date input section through the form builder" do
    # Use a_long_string (no validations) to avoid the base Daisy DateField wrapper's
    # `validation_attrs` injecting text-only props (minimum_length / maximum_length)
    # that the underlying DateCalendar component does not accept.
    html = @builder.send(:create_tag, Decor::Forms::TagWrappers::Suite::DateField, :a_long_string, {}).to_s
    assert_match(/decor--suite--forms--date-calendar/, html)
    assert_match(/name="form\[a_long_string\]"/, html)
    assert_match(/type="hidden"/, html)
  end
end
