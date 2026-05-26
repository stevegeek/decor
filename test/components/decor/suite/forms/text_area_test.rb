# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::TextAreaTest < ActiveSupport::TestCase
  test "renders root element with suite text-area identifier" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "n", label: "Notes"))
    assert_includes html, "decor--suite--forms--text-area"
  end

  test "renders a native textarea element" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "n", label: "Notes"))
    assert_match(/<textarea\b/, html)
  end

  test "textarea name and id derive from name + id-control" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "notes", label: "Notes"))
    assert_match(/name="notes"/, html)
    assert_match(/id="[^"]+-control"/, html)
  end

  test "value renders as textarea content" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "n", label: "L", value: "Hello"))
    assert_match(/<textarea[^>]*>[^<]*Hello[^<]*<\/textarea>/m, html)
  end

  test "renders label text with suite-field-label density-aware typography" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "n", label: "Description"))
    assert_includes html, "Description"
    assert_includes html, "decor:suite-field-label"
  end

  test "required appends an asterisk to the label" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "n", label: "Bio", required: true))
    assert_includes html, "Bio *"
  end

  test "rows attribute defaults to 5 and propagates" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "n", label: "L"))
    assert_match(/rows="5"/, html)
  end

  test "rows attribute can be overridden" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "n", label: "L", rows: 10))
    assert_match(/rows="10"/, html)
  end

  test "cols attribute propagates when set" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "n", label: "L", cols: 40))
    assert_match(/cols="40"/, html)
  end

  test "disabled marks textarea disabled and applies suite hairline + gray-50 chrome" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "n", label: "L", disabled: true))
    assert_match(/<textarea[^>]*disabled/, html)
    assert_includes html, "decor:bg-gray-50"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:cursor-not-allowed"
  end

  test "placeholder propagates to textarea" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "n", label: "L", placeholder: "Type something"))
    assert_match(/placeholder="Type something"/, html)
  end

  test "uses suite tokens for default textarea chrome (hairline-strong border, rounded-suite-control, suite-input-base)" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "n", label: "L"))
    assert_includes html, "decor:border-suite-hairline-strong"
    assert_includes html, "decor:rounded-suite-control"
    assert_includes html, "decor:suite-input-base"
  end

  test "focus chrome uses suite-primary-500 + suite-primary-100 ring var" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "n", label: "L"))
    assert_includes html, "decor:focus:border-suite-primary-500"
    assert_includes html, "var(--color-suite-primary-100)"
  end

  test "uses suite motion tokens (no raw duration-150/200)" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "n", label: "L"))
    assert_includes html, "decor:duration-suite-fast"
    refute_includes html, "decor:duration-150"
    refute_includes html, "decor:duration-200"
  end

  test "error state applies suite-danger border + bg + ring var + label color" do
    html = render_component(
      ::Decor::Suite::Forms::TextArea.new(name: "n", label: "L", error_messages: ["Too short"])
    )
    assert_includes html, "decor:border-suite-danger-500"
    assert_includes html, "decor:bg-suite-danger-50"
    assert_includes html, "var(--color-suite-danger-100)"
    assert_includes html, "Too short"
    assert_includes html, "decor:text-suite-danger-700"
  end

  test "helper text renders below the field with suite-field-help density-aware typography" do
    html = render_component(
      ::Decor::Suite::Forms::TextArea.new(name: "n", label: "L", helper_text: "Markdown supported")
    )
    assert_includes html, "Markdown supported"
    assert_includes html, "decor:suite-field-help"
  end

  test "error text suppresses helper text visually (helper paragraph stays hidden in DOM)" do
    html = render_component(
      ::Decor::Suite::Forms::TextArea.new(name: "n", label: "L", helper_text: "Help", error_messages: ["Bad"])
    )
    assert_includes html, "Bad"
    # Helper paragraph kept (with `decor:hidden`) so the JS FormField
    # controller has a stable target to swap content into once validation
    # passes.
    assert_match(/data-decor--suite--forms--text-area-target="helperText"/, html)
    assert_match(/class="[^"]*decor:hidden[^"]*"\s+data-decor--suite--forms--text-area-target="helperText"/, html)
  end

  test "minimum_length and maximum_length pass through to attributes" do
    html = render_component(
      ::Decor::Suite::Forms::TextArea.new(name: "n", label: "L", minimum_length: 3, maximum_length: 240)
    )
    assert_match(/minlength="3"/, html)
    assert_match(/maxlength="240"/, html)
  end

  test "maximum_length triggers character counter rendering" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "n", label: "L", maximum_length: 100))
    assert_includes html, "data-character-counter"
    assert_includes html, "/ 100"
    assert_includes html, "character-count"
  end

  test "textarea allows vertical resize" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "n", label: "L"))
    assert_includes html, "decor:resize-y"
  end

  test "applies min-height baseline" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "n", label: "L"))
    assert_includes html, "decor:min-h-[84px]"
  end

  test "silent_helper_and_error_text hides both helper and error rendering" do
    html = render_component(
      ::Decor::Suite::Forms::TextArea.new(
        name: "n", label: "L",
        helper_text: "Help",
        error_messages: ["Bad"],
        silent_helper_and_error_text: true
      )
    )
    refute_includes html, "Help"
    refute_includes html, ">Bad<"
  end

  test "label_position :inside renders a floating label inside the textarea and reserves the strip" do
    html = render_component(
      ::Decor::Suite::Forms::TextArea.new(name: "n", label: "Notes", label_position: :inside)
    )
    assert_match(/<label[^>]*for="[^"]+-control"[^>]*>Notes<\/label>/, html)
    assert_includes html, "decor:pt-[22px]"
  end

  test "invalid_input stimulus class uses suite-danger tokens, not the daisy invalid:border-error-dark" do
    html = render_component(::Decor::Suite::Forms::TextArea.new(name: "n", label: "L"))
    assert_match(/invalid-input-class="[^"]*decor:border-suite-danger-500[^"]*"/, html)
    refute_includes html, "invalid:border-error-dark"
  end
end
