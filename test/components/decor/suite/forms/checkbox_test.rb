# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::CheckboxTest < ActiveSupport::TestCase
  test "renders root element with suite checkbox identifier" do
    html = render_component(::Decor::Suite::Forms::Checkbox.new(name: "n", label: "L"))
    assert_includes html, "decor--suite--forms--checkbox"
  end

  test "renders an overlaid native input with type checkbox" do
    html = render_component(::Decor::Suite::Forms::Checkbox.new(name: "n", label: "L"))
    assert_match(/<input[^>]*type="checkbox"/, html)
    assert_includes html, "decor:opacity-[0.01]"
    assert_includes html, "decor:peer"
  end

  test "input name and id derive from name + id-control" do
    html = render_component(::Decor::Suite::Forms::Checkbox.new(name: "agree", label: "Agree"))
    assert_match(/name="agree"/, html)
    assert_match(/id="[^"]+-control"/, html)
  end

  test "checked prop marks the input checked" do
    html = render_component(::Decor::Suite::Forms::Checkbox.new(name: "n", label: "L", checked: true))
    assert_match(/<input[^>]*checked/, html)
  end

  test "disabled prop marks input disabled and applies cursor-not-allowed" do
    html = render_component(::Decor::Suite::Forms::Checkbox.new(name: "n", label: "L", disabled: true))
    assert_match(/<input[^>]*disabled/, html)
    assert_includes html, "decor:cursor-not-allowed"
    assert_includes html, "decor:opacity-60"
  end

  test "required (and not in_group) marks the input required" do
    html = render_component(::Decor::Suite::Forms::Checkbox.new(name: "n", label: "L", required: true))
    assert_match(/<input[^>]*required/, html)
  end

  test "required inside a group does NOT mark the input required" do
    html = render_component(::Decor::Suite::Forms::Checkbox.new(name: "n", label: "L", required: true, in_group: true))
    refute_match(/<input[^>]*required/, html)
  end

  test "required appends an asterisk to the label" do
    html = render_component(::Decor::Suite::Forms::Checkbox.new(name: "n", label: "Agree", required: true))
    assert_includes html, "Agree *"
  end

  test "hide_required_asterisk omits the asterisk" do
    html = render_component(
      ::Decor::Suite::Forms::Checkbox.new(name: "n", label: "Agree", required: true, hide_required_asterisk: true)
    )
    refute_includes html, "Agree *"
    assert_includes html, "Agree"
  end

  test "uses suite tokens for the visual box (hairline-strong, primary-500, gray-900)" do
    html = render_component(::Decor::Suite::Forms::Checkbox.new(name: "n", label: "L"))
    assert_includes html, "decor:border-suite-hairline-strong"
    assert_includes html, "decor:peer-checked:bg-suite-primary-500"
    assert_includes html, "decor:peer-checked:border-suite-primary-500"
    assert_includes html, "decor:text-gray-900"
  end

  test "focus ring uses suite-primary-100 var, not raw primary" do
    html = render_component(::Decor::Suite::Forms::Checkbox.new(name: "n", label: "L"))
    assert_includes html, "var(--color-suite-primary-100)"
  end

  test "uses suite motion tokens (no raw duration-150/200)" do
    html = render_component(::Decor::Suite::Forms::Checkbox.new(name: "n", label: "L"))
    assert_includes html, "decor:duration-suite-fast"
    assert_includes html, "decor:duration-suite-base"
    refute_includes html, "decor:duration-150"
    refute_includes html, "decor:duration-200"
  end

  test "renders the check-tick SVG via Decor::Icon" do
    html = render_component(::Decor::Suite::Forms::Checkbox.new(name: "n", label: "L"))
    assert_includes html, "#decor-check-tick"
  end

  test "renders helper text below the control with suite-field-help density-aware typography" do
    html = render_component(
      ::Decor::Suite::Forms::Checkbox.new(name: "n", label: "L", helper_text: "Read the fine print")
    )
    assert_includes html, "Read the fine print"
    assert_includes html, "decor:suite-field-help"
  end

  test "renders error text in suite-danger-700 and visually suppresses helper text" do
    html = render_component(
      ::Decor::Suite::Forms::Checkbox.new(
        name: "n", label: "L",
        helper_text: "Helper", error_messages: ["Bad"]
      )
    )
    assert_includes html, "Bad"
    assert_includes html, "decor:text-suite-danger-700"
    # Helper paragraph stays in DOM (hidden) so the JS FormField controller
    # has a stable swap target once validation passes.
    assert_match(/data-decor--suite--forms--checkbox-target="helperText"/, html)
    assert_match(/class="[^"]*decor:hidden[^"]*"\s+data-decor--suite--forms--checkbox-target="helperText"/, html)
  end

  test "floating_error_text suppresses inline error rendering" do
    html = render_component(
      ::Decor::Suite::Forms::Checkbox.new(
        name: "n", label: "L",
        floating_error_text: true,
        error_messages: ["Bad"]
      )
    )
    refute_includes html, ">Bad<"
  end

  test "default label_position :right indents helper text by 25px" do
    html = render_component(
      ::Decor::Suite::Forms::Checkbox.new(name: "n", label: "L", helper_text: "Hi")
    )
    assert_includes html, "decor:ml-[25px]"
  end

  test "label_position :top does NOT indent helper text" do
    html = render_component(
      ::Decor::Suite::Forms::Checkbox.new(name: "n", label: "L", helper_text: "Hi", label_position: :top)
    )
    assert_includes html, "decor:ml-0"
  end

  test "description renders below label when label and description both present" do
    html = render_component(
      ::Decor::Suite::Forms::Checkbox.new(name: "n", label: "Opt in", description: "Optional")
    )
    assert_includes html, "Opt in"
    assert_includes html, "Optional"
  end
end
