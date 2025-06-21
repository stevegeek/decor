require "test_helper"

class Decor::Forms::TextAreaTest < ActiveSupport::TestCase
  test "renders successfully with valid attributes" do
    component = Decor::Forms::TextArea.new(name: "my_text", label: "Label", value: "Lots of words")
    rendered = render_component(component)

    assert_includes rendered, "Label"
    assert_includes rendered, 'name="my_text"'
    assert_includes rendered, "Lots of words"
  end

  test "renders without errors when given valid attributes" do
    assert_nothing_raised do
      component = Decor::Forms::TextArea.new(name: "my_text", label: "Label", value: "Lots of words")
      render_component(component)
    end
  end

  test "textarea contains the correct value" do
    component = Decor::Forms::TextArea.new(name: "my_text", label: "Label", value: "Lots of words")
    fragment = render_fragment(component)

    textarea = fragment.at_css("textarea")
    assert_not_nil textarea
    assert_equal "Lots of words", textarea.text
  end

  test "renders with DaisyUI textarea classes by default" do
    component = Decor::Forms::TextArea.new(name: "my_text", label: "Label", value: "Test")
    fragment = render_fragment(component)

    textarea = fragment.at_css("textarea")
    assert_not_nil textarea
    assert_includes textarea["class"], "textarea"
    assert_includes textarea["class"], "w-full"
  end

  test "applies color attribute correctly" do
    component = Decor::Forms::TextArea.new(name: "my_text", label: "Label", value: "Test", color: :secondary)
    fragment = render_fragment(component)

    textarea = fragment.at_css("textarea")
    assert_includes textarea["class"], "textarea-secondary"
  end

  test "applies size attribute correctly" do
    component = Decor::Forms::TextArea.new(name: "my_text", label: "Label", value: "Test", size: :lg)
    fragment = render_fragment(component)

    textarea = fragment.at_css("textarea")
    assert_includes textarea["class"], "textarea-lg"
  end

  test "applies error styling when errors present" do
    component = Decor::Forms::TextArea.new(
      name: "my_text", 
      label: "Label", 
      value: "Test",
      error_messages: ["This field is required"]
    )
    fragment = render_fragment(component)

    textarea = fragment.at_css("textarea")
    assert_includes textarea["class"], "textarea-error"
  end

  test "renders helper text when provided" do
    component = Decor::Forms::TextArea.new(
      name: "my_text", 
      label: "Label", 
      value: "Test",
      helper_text: "This is helper text"
    )
    rendered = render_component(component)

    assert_includes rendered, "This is helper text"
  end
end
