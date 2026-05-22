require "test_helper"
require "minitest/mock"
require "support/example_form"

class Decor::Forms::TagWrappers::Suite::HiddenFieldTest < ActiveSupport::TestCase
  def setup
    @fake_class = Class.new(ActionView::Base).with_empty_template_cache
    if Object.const_defined?(:SuiteHiddenFieldTestFakeView)
      Object.send(:remove_const, :SuiteHiddenFieldTestFakeView)
    end
    Object.const_set(:SuiteHiddenFieldTestFakeView, @fake_class)

    @form = ExampleForm.factory_one
    @view = SuiteHiddenFieldTestFakeView.new(
      ActionView::LookupContext.new(""),
      {},
      {}
    )
    @builder = Decor::Suite::Forms::ActionViewFormBuilder.new :form, @form, @view, {}

    ActionView::PathRegistry.set_view_paths(@view.lookup_context, @view.lookup_context.view_paths + ["app/views"])
  end

  test "inherits from the Daisy HiddenField wrapper" do
    assert_operator Decor::Forms::TagWrappers::Suite::HiddenField, :<, Decor::Forms::TagWrappers::HiddenField
  end

  test "FIELD_ATTRS mirrors the Suite HiddenField prop names" do
    expected = Decor::Suite::Forms::HiddenField.prop_names.map(&:to_s)
    assert_equal expected, Decor::Forms::TagWrappers::Suite::HiddenField::FIELD_ATTRS
  end

  test "tag renders a Suite HiddenField component" do
    captured = nil
    Decor::Suite::Forms::HiddenField.stub :new, ->(**kwargs) {
      captured = kwargs
      Decor::Suite::Forms::HiddenField.allocate.tap do |inst|
        inst.define_singleton_method(:render_in) { |_view| "<suite-hidden/>".html_safe }
        inst.define_singleton_method(:call) { "<suite-hidden/>".html_safe }
      end
    } do
      wrapper = Decor::Forms::TagWrappers::Suite::HiddenField.new(
        "form", "a_string", @view, {object: @form}
      )
      html = wrapper.render
      assert_includes html.to_s, "<suite-hidden/>"
    end
    refute_nil captured, "Suite HiddenField.new was not invoked"
    assert_equal "form", captured[:object_name]
    assert_equal "a_string", captured[:method_name]
    assert_equal "test string", captured[:value]
    refute_includes captured.keys, :view_context, "view_context must be stripped from the component options"
  end

  test "renders a hidden input through the wrapper" do
    html = @builder.send(:create_tag, Decor::Forms::TagWrappers::Suite::HiddenField, :a_string, {}).to_s
    assert_match(/decor--suite--forms--hidden-field/, html)
    assert_match(/type="hidden"/, html)
    assert_match(/name="form\[a_string\]"/, html)
    assert_match(/value="test string"/, html)
  end
end
