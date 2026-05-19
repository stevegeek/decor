# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::RadioTest < ActiveSupport::TestCase
  test "renders root element with suite radio identifier" do
    html = render_component(::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "L"))
    assert_includes html, "decor--suite--forms--radio"
  end

  test "renders an overlaid native input with type radio" do
    html = render_component(::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "L"))
    assert_match(/<input[^>]*type="radio"/, html)
    assert_includes html, "decor:opacity-[0.01]"
    assert_includes html, "decor:peer"
  end

  test "input name and value flow through" do
    html = render_component(::Decor::Suite::Forms::Radio.new(name: "plan", value: "pro", label: "Pro"))
    assert_match(/name="plan"/, html)
    assert_match(/value="pro"/, html)
    assert_match(/id="[^"]+-control"/, html)
  end

  test "checked prop marks the input checked" do
    html = render_component(::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "L", checked: true))
    assert_match(/<input[^>]*checked/, html)
  end

  test "disabled prop marks input disabled and applies cursor-not-allowed" do
    html = render_component(::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "L", disabled: true))
    assert_match(/<input[^>]*disabled/, html)
    assert_includes html, "decor:cursor-not-allowed"
    assert_includes html, "decor:opacity-60"
  end

  test "required (and not in_group) marks the input required" do
    html = render_component(::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "L", required: true))
    assert_match(/<input[^>]*required/, html)
  end

  test "required inside a group does NOT mark the input required" do
    html = render_component(::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "L", required: true, in_group: true))
    refute_match(/<input[^>]*required/, html)
  end

  test "required appends an asterisk to the label" do
    html = render_component(::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "Pro", required: true))
    assert_includes html, "Pro *"
  end

  test "hide_required_asterisk omits the asterisk" do
    html = render_component(
      ::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "Pro", required: true, hide_required_asterisk: true)
    )
    refute_includes html, "Pro *"
    assert_includes html, "Pro"
  end

  test "uses suite tokens for the visual ring (hairline-strong, primary-500, gray-900)" do
    html = render_component(::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "L"))
    assert_includes html, "decor:border-suite-hairline-strong"
    assert_includes html, "decor:peer-checked:border-suite-primary-500"
    assert_includes html, "decor:bg-suite-primary-500"
    assert_includes html, "decor:text-gray-900"
  end

  test "ring and dot are both round (rounded-full)" do
    html = render_component(::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "L"))
    # ring + dot both circular
    assert_equal 2, html.scan("decor:rounded-full").length
  end

  test "focus ring uses suite-primary-100 var, not raw primary" do
    html = render_component(::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "L"))
    assert_includes html, "var(--color-suite-primary-100)"
  end

  test "uses suite motion tokens (no raw duration-150/200)" do
    html = render_component(::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "L"))
    assert_includes html, "decor:duration-suite-fast"
    refute_includes html, "decor:duration-150"
    refute_includes html, "decor:duration-200"
  end

  test "renders helper text below the control with suite-field-help density-aware typography" do
    html = render_component(
      ::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "L", helper_text: "Pick one")
    )
    assert_includes html, "Pick one"
    assert_includes html, "decor:suite-field-help"
  end

  test "renders error text in suite-danger-700 and suppresses helper text" do
    html = render_component(
      ::Decor::Suite::Forms::Radio.new(
        name: "n", value: "v", label: "L",
        helper_text: "Helper", error_messages: ["Bad"]
      )
    )
    assert_includes html, "Bad"
    assert_includes html, "decor:text-suite-danger-700"
    # Helper paragraph stays in DOM (hidden) so the JS FormField controller
    # has a stable swap target once validation passes.
    assert_match(/data-decor--suite--forms--radio-target="helperText"/, html)
    assert_match(/class="[^"]*decor:hidden[^"]*"\s+data-decor--suite--forms--radio-target="helperText"/, html)
  end

  test "floating_error_text suppresses inline error rendering" do
    html = render_component(
      ::Decor::Suite::Forms::Radio.new(
        name: "n", value: "v", label: "L",
        floating_error_text: true,
        error_messages: ["Bad"]
      )
    )
    refute_includes html, ">Bad<"
  end

  test "default label_position :right indents helper text by 25px" do
    html = render_component(
      ::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "L", helper_text: "Hi")
    )
    assert_includes html, "decor:ml-[25px]"
  end

  test "label_position :left does NOT indent helper text" do
    html = render_component(
      ::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "L", helper_text: "Hi", label_position: :left)
    )
    assert_includes html, "decor:ml-0"
  end

  test "no daisy semantic color leakage (no bg-info / text-info / border-info / d-radio)" do
    html = render_component(::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "L", checked: true))
    refute_includes html, "decor:bg-info"
    refute_includes html, "decor:text-info"
    refute_includes html, "decor:border-info"
    refute_includes html, "decor:d-radio"
  end

  test "no raw hairline shorthand (border-black/10)" do
    html = render_component(::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "L"))
    refute_includes html, "decor:border-black/10"
  end

  test "description renders below label when label and description both present" do
    html = render_component(
      ::Decor::Suite::Forms::Radio.new(name: "n", value: "v", label: "Monthly", description: "Billed every 30 days")
    )
    assert_includes html, "Monthly"
    assert_includes html, "Billed every 30 days"
  end
end
