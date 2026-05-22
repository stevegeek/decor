require "test_helper"
require "minitest/mock"
require_relative "../../../../../support/example_form"

class Decor::Forms::TagWrappers::Suite::TextAreaTest < ActiveSupport::TestCase
  def setup
    @fake_class = Class.new(ActionView::Base).with_empty_template_cache
    Object.send(:remove_const, :SuiteTextAreaFakeView) if Object.const_defined?(:SuiteTextAreaFakeView)
    Object.const_set(:SuiteTextAreaFakeView, @fake_class)

    @form = ExampleForm.factory_one
    @view = SuiteTextAreaFakeView.new(ActionView::LookupContext.new(""), {}, {})

    ActionView::PathRegistry.set_view_paths(@view.lookup_context, @view.lookup_context.view_paths + ["app/views"])
  end

  def render_wrapper(method, options = {})
    Decor::Forms::TagWrappers::Suite::TextArea.new(
      "form",
      method,
      @view,
      options.merge(object: @form)
    ).render
  end

  test "subclasses the Daisy TextArea tag wrapper" do
    assert_operator Decor::Forms::TagWrappers::Suite::TextArea, :<, Decor::Forms::TagWrappers::TextArea
  end

  test "TEXT_FIELD_ATTRS pulls prop names from Decor::Suite::Forms::TextArea" do
    expected = Decor::Suite::Forms::TextArea.prop_names.map(&:to_s).freeze
    assert_equal expected, Decor::Forms::TagWrappers::Suite::TextArea::TEXT_FIELD_ATTRS
  end

  test "delegates rendering to Decor::Suite::Forms::TextArea" do
    sentinel = "<!-- suite text area sentinel -->"
    fake_component = Object.new
    fake_component.define_singleton_method(:render_in) { |_| sentinel }

    Decor::Suite::Forms::TextArea.stub :new, ->(**_) { fake_component } do
      html = render_wrapper(:a_long_string, label: "Description")
      assert_includes html, sentinel
    end
  end

  test "renders a <textarea> with the namespaced form field name" do
    html = render_wrapper(:a_long_string, label: "Description")
    assert_match(/<textarea[^>]*name="form\[a_long_string\]"/m, html)
  end

  test "applies the Suite TextArea root class" do
    html = render_wrapper(:a_long_string, label: "Description")
    assert_includes html, "decor--suite--forms--text-area"
  end

  test "renders the supplied label text" do
    html = render_wrapper(:a_long_string, label: "My Long Field")
    assert_includes html, "My Long Field"
  end

  test "renders the bound model value inside the textarea" do
    @form = ExampleForm.new(a_long_string: "hello suite")
    html = render_wrapper(:a_long_string, label: "Long")
    assert_includes html, "hello suite"
  end

  test "passes helper_text through to the Suite component" do
    html = render_wrapper(:a_long_string, label: "Long", helper_text: "be brief")
    assert_includes html, "be brief"
  end
end
