# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::SelectTest < ActiveSupport::TestCase
  def options
    [["Option 1", "1"], ["Option 2", "2"]]
  end

  test "renders root with suite select identifier" do
    html = render_component(::Decor::Suite::Forms::Select.new(name: "n", label: "L", options_array: options))
    assert_includes html, "decor--suite--forms--select"
  end

  test "renders a <select> element with the given name and id-control suffix" do
    html = render_component(::Decor::Suite::Forms::Select.new(name: "category", label: "L", options_array: options))
    assert_match(/<select[^>]*name="category"/, html)
    assert_match(/<select[^>]*id="[^"]+-control"/, html)
  end

  test "renders each option from options_array" do
    html = render_component(::Decor::Suite::Forms::Select.new(name: "n", label: "L", options_array: options))
    assert_includes html, "Option 1"
    assert_includes html, "Option 2"
    assert_match(/<option[^>]*value="1"/, html)
    assert_match(/<option[^>]*value="2"/, html)
  end

  test "uses suite tokens on the <select> chrome (hairline-strong border, primary focus halo)" do
    html = render_component(::Decor::Suite::Forms::Select.new(name: "n", label: "L", options_array: options))
    assert_includes html, "decor:border-suite-hairline-strong"
    assert_includes html, "decor:focus:border-suite-primary-500"
    assert_includes html, "var(--color-suite-primary-100)"
    assert_includes html, "decor:rounded-suite-control"
  end

  test "uses suite motion tokens (no raw duration-150/200)" do
    html = render_component(::Decor::Suite::Forms::Select.new(name: "n", label: "L", options_array: options))
    assert_includes html, "decor:duration-suite-fast"
    refute_includes html, "decor:duration-150"
    refute_includes html, "decor:duration-200"
  end

  test "renders the chevron indicator using suite border tokens" do
    html = render_component(::Decor::Suite::Forms::Select.new(name: "n", label: "L", options_array: options))
    assert_includes html, "decor:rotate-45"
    assert_includes html, "decor:border-r-[1.5px]"
    assert_includes html, "decor:border-b-[1.5px]"
  end

  test "disabled prop marks the select disabled and renders not-allowed cursor" do
    html = render_component(::Decor::Suite::Forms::Select.new(name: "n", label: "L", options_array: options, disabled: true))
    assert_match(/<select[^>]*disabled/, html)
    assert_includes html, "decor:cursor-not-allowed"
  end

  test "required prop marks the select required and appends asterisk to the label" do
    html = render_component(::Decor::Suite::Forms::Select.new(name: "n", label: "Choose", options_array: options, required: true))
    assert_match(/<select[^>]*required/, html)
    assert_includes html, "Choose *"
  end

  test "hide_required_asterisk suppresses the asterisk on a required field" do
    html = render_component(::Decor::Suite::Forms::Select.new(name: "n", label: "Choose", options_array: options, required: true, hide_required_asterisk: true))
    refute_includes html, "Choose *"
    assert_includes html, "Choose"
  end

  test "error_messages render in suite-danger-700 and swap the border palette" do
    html = render_component(::Decor::Suite::Forms::Select.new(name: "n", label: "L", options_array: options, error_messages: ["Bad"]))
    assert_includes html, "Bad"
    assert_includes html, "decor:text-suite-danger-700"
    assert_includes html, "decor:border-suite-danger-500"
  end

  test "helper_text renders below the control in suite-field-help density-aware typography" do
    html = render_component(::Decor::Suite::Forms::Select.new(name: "n", label: "L", options_array: options, helper_text: "Pick one"))
    assert_includes html, "Pick one"
    assert_includes html, "decor:suite-field-help"
  end

  test "silent_helper_and_error_text suppresses the helper / error caption" do
    html = render_component(::Decor::Suite::Forms::Select.new(
      name: "n", label: "L", options_array: options,
      helper_text: "Help", error_messages: ["Bad"],
      silent_helper_and_error_text: true
    ))
    refute_includes html, ">Help<"
    refute_includes html, ">Bad<"
    assert_includes html, "decor:border-suite-danger-500"
  end

  test "include_blank_option prepends an empty-value option" do
    html = render_component(::Decor::Suite::Forms::Select.new(
      name: "n", label: "L", options_array: options, include_blank_option: true
    ))
    fragment = Nokogiri::HTML5.fragment(html)
    first_option = fragment.css("option").first
    assert_equal "", first_option["value"]
  end

  test "include_blank with a String label uses the supplied label" do
    html = render_component(::Decor::Suite::Forms::Select.new(
      name: "n", label: "L", options_array: options, include_blank: "(none)"
    ))
    assert_includes html, "(none)"
  end

  test "placeholder is rendered as the first option" do
    html = render_component(::Decor::Suite::Forms::Select.new(
      name: "n", label: "L", options_array: options, placeholder: "Pick…"
    ))
    fragment = Nokogiri::HTML5.fragment(html)
    first_option = fragment.css("option").first
    assert_equal "Pick…", first_option.text
    assert_equal "", first_option["value"]
  end

  test "selected_option marks the corresponding option selected" do
    html = render_component(::Decor::Suite::Forms::Select.new(
      name: "n", label: "L", options_array: options, selected_option: "2"
    ))
    fragment = Nokogiri::HTML5.fragment(html)
    selected_option = fragment.at_css("option[selected]")
    refute_nil selected_option
    assert_equal "2", selected_option["value"]
  end

  test "multiple: true marks the select multiple, renames the field with [], and emits a hidden field" do
    html = render_component(::Decor::Suite::Forms::Select.new(
      name: "tags", label: "L", options_array: options, multiple: true
    ))
    assert_match(/<select[^>]*multiple/, html)
    assert_match(/<select[^>]*name="tags\[\]"/, html)
    assert_match(/<input[^>]*type="hidden"[^>]*name="tags\[\]"/, html)
  end

  test "multi-select selected_option accepts an Array and marks each option" do
    html = render_component(::Decor::Suite::Forms::Select.new(
      name: "tags", label: "L",
      options_array: [["A", "a"], ["B", "b"], ["C", "c"]],
      multiple: true,
      selected_option: ["a", "c"]
    ))
    fragment = Nokogiri::HTML5.fragment(html)
    selected = fragment.css("option[selected]")
    assert_equal 2, selected.length
    assert_equal %w[a c], selected.map { |o| o["value"] }.sort
  end

  test "supports grouped options via <optgroup>" do
    grouped = [
      ["Group 1", [["1A", "1a"]]],
      ["Group 2", [["2A", "2a"]]]
    ]
    html = render_component(::Decor::Suite::Forms::Select.new(
      name: "n", label: "L", options_array: grouped
    ))
    fragment = Nokogiri::HTML5.fragment(html)
    optgroups = fragment.css("optgroup")
    assert_equal 2, optgroups.length
    assert_equal "Group 1", optgroups[0]["label"]
  end

  test "label_position :left renders a left-aligned label column on sm+ screens" do
    html = render_component(::Decor::Suite::Forms::Select.new(
      name: "n", label: "Country", options_array: options, label_position: :left
    ))
    assert_includes html, "decor:sm:w-[180px]"
  end

  test "invalid_input stimulus class uses suite-danger border so the select goes red on client-side validation" do
    html = render_component(::Decor::Suite::Forms::Select.new(name: "n", label: "L", options_array: options))
    assert_match(/invalid-input-class="[^"]*decor:border-suite-danger-500[^"]*"/, html)
    refute_includes html, "invalid:border-error-dark"
  end

  test "label_position :inside surfaces the label as a placeholder option (no separate label element)" do
    html = render_component(::Decor::Suite::Forms::Select.new(
      name: "n", label: "Country", options_array: options, label_position: :inside
    ))
    assert_includes html, ">Country<"
  end
end
