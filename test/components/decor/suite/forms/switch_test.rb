# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::SwitchTest < ActiveSupport::TestCase
  test "renders a checkbox input with role switch and given name" do
    html = render_component(::Decor::Suite::Forms::Switch.new(name: "notifications", label: "Notify"))
    assert_includes html, 'type="checkbox"'
    assert_includes html, 'role="switch"'
    assert_includes html, 'name="notifications"'
    assert_includes html, "Notify"
  end

  test "renders the visual track at compact 26x15 with rounded-full" do
    html = render_component(::Decor::Suite::Forms::Switch.new(name: "x", label: "x"))
    assert_includes html, "decor:w-[26px]"
    assert_includes html, "decor:h-[15px]"
    assert_includes html, "decor:rounded-full"
  end

  test "track uses suite-hairline when off and suite-primary-500 when on by default" do
    html = render_component(::Decor::Suite::Forms::Switch.new(name: "x", label: "x"))
    assert_includes html, "decor:bg-suite-hairline"
    assert_includes html, "decor:peer-checked:bg-suite-primary-500"
  end

  test "color :success swaps on-state to suite-success-500" do
    html = render_component(::Decor::Suite::Forms::Switch.new(name: "x", label: "x", color: :success))
    assert_includes html, "decor:peer-checked:bg-suite-success-500"
    refute_includes html, "decor:peer-checked:bg-suite-primary-500"
  end

  test "color :warning swaps on-state to suite-warning-500" do
    html = render_component(::Decor::Suite::Forms::Switch.new(name: "x", label: "x", color: :warning))
    assert_includes html, "decor:peer-checked:bg-suite-warning-500"
  end

  test "thumb slides 11px when peer is checked" do
    html = render_component(::Decor::Suite::Forms::Switch.new(name: "x", label: "x"))
    assert_includes html, "decor:after:w-[11px]"
    assert_includes html, "decor:after:h-[11px]"
    assert_includes html, "decor:after:translate-x-0"
    assert_includes html, "decor:peer-checked:after:translate-x-[11px]"
    assert_includes html, "decor:after:bg-white"
  end

  test "transition uses suite motion tokens (no daisy duration shortcuts)" do
    html = render_component(::Decor::Suite::Forms::Switch.new(name: "x", label: "x"))
    assert_includes html, "decor:duration-suite-base"
    assert_includes html, "decor:duration-suite-fast"
    refute_includes html, "decor:duration-150"
    refute_includes html, "decor:duration-200"
    refute_includes html, "decor:duration-400"
  end

  test "checked prop emits checked attribute on input" do
    html = render_component(::Decor::Suite::Forms::Switch.new(name: "x", label: "x", checked: true))
    assert_includes html, "checked"
  end

  test "disabled prop emits disabled attribute and opacity on track" do
    html = render_component(::Decor::Suite::Forms::Switch.new(name: "x", label: "x", disabled: true))
    assert_includes html, "disabled"
    assert_includes html, "decor:peer-disabled:opacity-50"
    assert_includes html, "decor:peer-disabled:cursor-not-allowed"
  end

  test "disabled state mutes the label text color" do
    html = render_component(::Decor::Suite::Forms::Switch.new(name: "x", label: "X label", disabled: true))
    assert_includes html, "decor:text-gray-400"
  end

  test "default label position is right and renders label after the control in the row" do
    html = render_component(::Decor::Suite::Forms::Switch.new(name: "x", label: "Right label"))
    assert_includes html, "Right label"
    assert_includes html, "decor:inline-flex"
    assert_includes html, "decor:items-center"
  end

  test "label_position :top stacks label above the control" do
    html = render_component(::Decor::Suite::Forms::Switch.new(name: "x", label: "Top label", label_position: :top))
    assert_includes html, "Top label"
    assert_includes html, "decor:flex-col"
  end

  test "required field appends asterisk to label" do
    html = render_component(::Decor::Suite::Forms::Switch.new(name: "x", label: "Accept", required: true))
    assert_includes html, "Accept *"
  end

  test "hide_required_asterisk suppresses the asterisk" do
    html = render_component(::Decor::Suite::Forms::Switch.new(
      name: "x", label: "Accept", required: true, hide_required_asterisk: true
    ))
    assert_includes html, "Accept"
    refute_includes html, "Accept *"
  end

  test "helper_text renders below the control with suite-field-help density-aware typography" do
    html = render_component(::Decor::Suite::Forms::Switch.new(
      name: "x", label: "x", helper_text: "Some helper guidance."
    ))
    assert_includes html, "Some helper guidance."
    assert_includes html, "decor:suite-field-help"
    assert_includes html, "decor:text-gray-500"
  end

  test "error_messages renders error text in suite-danger and swaps track color when checked" do
    html = render_component(::Decor::Suite::Forms::Switch.new(
      name: "x", label: "x", error_messages: ["Required"], checked: true
    ))
    assert_includes html, "Required"
    assert_includes html, "decor:text-suite-danger-700"
    assert_includes html, "decor:peer-checked:bg-suite-danger-500"
  end

  test "renders tick and cross glyphs with suite motion timing" do
    html = render_component(::Decor::Suite::Forms::Switch.new(name: "x", label: "x"))
    assert_includes html, "<svg"
    assert_includes html, "M1.5 4.2 L3.2 6 L6.5 2.2"
    assert_includes html, "M2 2 L6 6 M6 2 L2 6"
    assert_includes html, "decor:duration-suite-fast"
  end

  test "focus ring uses suite-primary-100 token for the primary color" do
    html = render_component(::Decor::Suite::Forms::Switch.new(name: "x", label: "x"))
    assert_includes html, "var(--color-suite-primary-100)"
  end

  test "uses suite tokens only — no daisy semantic chrome or raw shorthands" do
    html = render_component(::Decor::Suite::Forms::Switch.new(
      name: "x", label: "x", helper_text: "h", checked: true
    ))
    refute_includes html, "decor:bg-primary-500"
    refute_includes html, "decor:bg-gray-300"
    refute_includes html, "decor:bg-success "
    refute_includes html, "decor:bg-warning "
    refute_includes html, "decor:bg-info"
    refute_includes html, "decor:rounded-md"
    refute_includes html, "decor:border-black/10"
  end

  test "stimulus controller identifier reflects the suite forms switch path" do
    html = render_component(::Decor::Suite::Forms::Switch.new(name: "x", label: "x", submit_on_change: true))
    assert_includes html, "decor--suite--forms--switch"
  end

  test "submit_on_change passes through as stimulus value" do
    html = render_component(::Decor::Suite::Forms::Switch.new(name: "x", label: "x", submit_on_change: true))
    assert_includes html, "submit-on-change-value"
  end
end
