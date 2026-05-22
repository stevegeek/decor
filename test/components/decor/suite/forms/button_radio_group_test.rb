# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::ButtonRadioGroupTest < ActiveSupport::TestCase
  CHOICES = [["a", "Alpha"], ["b", "Beta"], ["c", "Gamma"]].freeze

  test "renders root element with suite button-radio-group identifier" do
    html = render_component(::Decor::Suite::Forms::ButtonRadioGroup.new(name: "n", choices: CHOICES))
    assert_includes html, "decor--suite--forms--button-radio-group"
  end

  test "renders one radio input per choice with the shared name" do
    html = render_component(::Decor::Suite::Forms::ButtonRadioGroup.new(name: "plan", choices: CHOICES))
    assert_equal 3, html.scan(/<input[^>]*type="radio"/).length
    assert_equal 3, html.scan(/name="plan"/).length
  end

  test "renders each choice label" do
    html = render_component(::Decor::Suite::Forms::ButtonRadioGroup.new(name: "n", choices: CHOICES))
    assert_includes html, "Alpha"
    assert_includes html, "Beta"
    assert_includes html, "Gamma"
  end

  test "selected_choice marks exactly that input checked" do
    html = render_component(
      ::Decor::Suite::Forms::ButtonRadioGroup.new(name: "n", choices: CHOICES, selected_choice: "b")
    )
    checked_inputs = html.scan(/<input[^>]*checked[^>]*>/)
    assert_equal 1, checked_inputs.length
    assert_match(/value="b"/, checked_inputs.first)
  end

  test "disabled marks every input disabled and applies disabled segment style" do
    html = render_component(
      ::Decor::Suite::Forms::ButtonRadioGroup.new(name: "n", choices: CHOICES, disabled: true)
    )
    assert_equal 3, html.scan(/<input[^>]*disabled/).length
    assert_includes html, "decor:cursor-not-allowed"
    assert_includes html, "decor:opacity-50"
  end

  test "required marks every input required" do
    html = render_component(
      ::Decor::Suite::Forms::ButtonRadioGroup.new(name: "n", choices: CHOICES, required: true)
    )
    assert_equal 3, html.scan(/<input[^>]*required/).length
  end

  test "inputs are visually hidden via sr-only" do
    html = render_component(::Decor::Suite::Forms::ButtonRadioGroup.new(name: "n", choices: CHOICES))
    assert_includes html, "decor:sr-only"
  end

  test "segmented container uses suite control radius and gray pill background" do
    html = render_component(::Decor::Suite::Forms::ButtonRadioGroup.new(name: "n", choices: CHOICES))
    assert_includes html, "decor:rounded-suite-control"
    assert_includes html, "decor:bg-gray-100"
  end

  test "selected segment uses has-[input:checked] selector with white surface" do
    html = render_component(::Decor::Suite::Forms::ButtonRadioGroup.new(name: "n", choices: CHOICES))
    assert_includes html, "decor:has-[input:checked]:bg-white"
    assert_includes html, "decor:has-[input:checked]:text-suite-primary-500"
  end

  test "selected segment shadow references the suite hairline-strong token" do
    html = render_component(::Decor::Suite::Forms::ButtonRadioGroup.new(name: "n", choices: CHOICES))
    assert_includes html, "var(--color-suite-hairline-strong)"
  end

  test "uses suite motion tokens (no raw duration-150/200)" do
    html = render_component(::Decor::Suite::Forms::ButtonRadioGroup.new(name: "n", choices: CHOICES))
    assert_includes html, "decor:duration-suite-fast"
    refute_includes html, "decor:duration-150"
    refute_includes html, "decor:duration-200"
  end

  test "error_messages render below the control in suite-danger-500" do
    html = render_component(
      ::Decor::Suite::Forms::ButtonRadioGroup.new(name: "n", choices: CHOICES, error_messages: ["Pick one"])
    )
    assert_includes html, "Pick one"
    assert_includes html, "decor:text-suite-danger-500"
  end

  test "error state outlines the container with a suite-danger-500 ring" do
    html = render_component(
      ::Decor::Suite::Forms::ButtonRadioGroup.new(name: "n", choices: CHOICES, error_messages: ["Bad"])
    )
    assert_includes html, "decor:ring-suite-danger-500"
  end

  test "errors visually suppress helper text (paragraph stays hidden in DOM)" do
    html = render_component(
      ::Decor::Suite::Forms::ButtonRadioGroup.new(
        name: "n", choices: CHOICES, helper_text: "Helper", error_messages: ["Bad"]
      )
    )
    assert_includes html, "Bad"
    # Helper paragraph stays in DOM (hidden) so the JS FormField controller
    # has a stable swap target once validation passes.
    assert_match(/data-decor--suite--forms--button-radio-group-target="helperText"/, html)
    assert_match(/class="[^"]*decor:hidden[^"]*"\s+data-decor--suite--forms--button-radio-group-target="helperText"/, html)
  end

  test "floating_error_text suppresses inline error rendering" do
    html = render_component(
      ::Decor::Suite::Forms::ButtonRadioGroup.new(
        name: "n", choices: CHOICES, floating_error_text: true, error_messages: ["Bad"]
      )
    )
    refute_includes html, ">Bad<"
  end

  test "helper text renders with suite-field-help density-aware typography" do
    html = render_component(
      ::Decor::Suite::Forms::ButtonRadioGroup.new(name: "n", choices: CHOICES, helper_text: "Pick wisely")
    )
    assert_includes html, "Pick wisely"
    assert_includes html, "decor:suite-field-help"
  end

  test "show_label true renders the label above the control" do
    html = render_component(
      ::Decor::Suite::Forms::ButtonRadioGroup.new(name: "n", choices: CHOICES, label: "Plan", show_label: true)
    )
    assert_includes html, "Plan"
    assert_includes html, "decor:suite-field-label"
  end

  test "show_label defaults to false and omits the label" do
    html = render_component(
      ::Decor::Suite::Forms::ButtonRadioGroup.new(name: "n", choices: CHOICES, label: "Plan")
    )
    refute_includes html, ">Plan<"
  end

end
