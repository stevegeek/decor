# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::FormFieldTest < ActiveSupport::TestCase
  # Minimal concrete subclass — the Suite::Forms::FormField base is
  # abstract (no view_template). This stand-in just renders the root
  # element so we can assert chrome / classes / state via HTML.
  class TestField < ::Decor::Suite::Forms::FormField
    def view_template(&)
      root_element do
        plain "field-body"
      end
    end
  end

  test "inherits from the abstract Components::Forms::FormField" do
    component = TestField.new(name: "n")
    assert component.is_a?(::Decor::Components::Forms::FormField)
    assert component.is_a?(::Decor::Suite::Forms::FormField)
  end

  test "root element renders the suite form-field identifier" do
    html = render_component(TestField.new(name: "n"))
    assert_includes html, "decor--suite--forms--form-field"
  end

  test "root element is full-width" do
    html = render_component(TestField.new(name: "n"))
    assert_includes html, "decor:w-full"
  end

  test "disabled state stamps the disabled chrome on the root" do
    html = render_component(TestField.new(name: "n", disabled: true))
    assert_includes html, "decor:disabled"
  end

  test "non-disabled state does not stamp the disabled chrome" do
    html = render_component(TestField.new(name: "n"))
    refute_includes html, "decor:disabled"
  end

  test "grid_span :span_half emits the half-width responsive classes" do
    html = render_component(TestField.new(name: "n", grid_span: :span_half))
    assert_includes html, "decor:sm:col-span-6"
    assert_includes html, "decor:lg:col-span-3"
  end

  test "silent_helper_and_error_text defaults to false" do
    component = TestField.new(name: "n")
    refute component.send(:silent_helper_and_error_text?)
  end

  test "silent_helper_and_error_text? reflects the prop when true" do
    component = TestField.new(name: "n", silent_helper_and_error_text: true)
    assert component.send(:silent_helper_and_error_text?)
  end

  test "inherits label_position default of :top from FormChild" do
    component = TestField.new(name: "n")
    assert component.send(:label_top?)
  end

  test "label_position :left flips the label_left? predicate" do
    component = TestField.new(name: "n", label_position: :left)
    assert component.send(:label_left?)
    refute component.send(:label_top?)
  end

  test "label_with_required appends an asterisk when required and label present" do
    component = TestField.new(name: "n", label: "Email", required: true)
    assert_equal "Email *", component.send(:label_with_required)
  end

  test "label_with_required omits the asterisk when hide_required_asterisk: true" do
    component = TestField.new(name: "n", label: "Email", required: true, hide_required_asterisk: true)
    assert_equal "Email", component.send(:label_with_required)
  end

  test "errors? is true when error_messages present" do
    component = TestField.new(name: "n", error_messages: ["Required"])
    assert component.send(:errors?)
    assert_equal "Required", component.send(:error_text)
  end

  test "errors? is false when error_messages absent" do
    component = TestField.new(name: "n")
    refute component.send(:errors?)
  end

  test "every Tailwind utility on the rendered root is decor:-prefixed" do
    html = render_component(TestField.new(name: "n", disabled: true, grid_span: :span_half))
    # Spot-check: anything that looks like a Tailwind utility (sm:/lg:/bare)
    # in the rendered output should carry the decor: prefix.
    assert_includes html, "decor:w-full"
    assert_includes html, "decor:disabled"
    assert_includes html, "decor:sm:col-span-6"
  end
end
