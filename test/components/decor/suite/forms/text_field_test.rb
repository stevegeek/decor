# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::TextFieldTest < ActiveSupport::TestCase
  test "renders root element with suite text-field identifier" do
    html = render_component(::Decor::Suite::Forms::TextField.new(name: "n", label: "Label"))
    assert_includes html, "decor--suite--forms--text-field"
  end

  test "renders a native input with type text by default" do
    html = render_component(::Decor::Suite::Forms::TextField.new(name: "n", label: "L"))
    assert_match(/<input[^>]*type="text"/, html)
  end

  test "input name and id derive from name + id-control" do
    html = render_component(::Decor::Suite::Forms::TextField.new(name: "first", label: "First"))
    assert_match(/name="first"/, html)
    assert_match(/id="[^"]+-control"/, html)
  end

  test "value attribute passes through" do
    html = render_component(::Decor::Suite::Forms::TextField.new(name: "n", label: "L", value: "Hello"))
    assert_match(/value="Hello"/, html)
  end

  test "renders label text with suite-field-label density-aware typography" do
    html = render_component(::Decor::Suite::Forms::TextField.new(name: "n", label: "First name"))
    assert_includes html, "First name"
    assert_includes html, "decor:suite-field-label"
  end

  test "required appends an asterisk to the label" do
    html = render_component(::Decor::Suite::Forms::TextField.new(name: "n", label: "Email", required: true))
    assert_includes html, "Email *"
  end

  test "hide_required_asterisk omits the asterisk" do
    html = render_component(
      ::Decor::Suite::Forms::TextField.new(name: "n", label: "Email", required: true, hide_required_asterisk: true)
    )
    refute_includes html, "Email *"
    assert_includes html, "Email"
  end

  test "disabled marks input disabled and applies suite hairline + gray-50 chrome" do
    html = render_component(::Decor::Suite::Forms::TextField.new(name: "n", label: "L", disabled: true))
    assert_match(/<input[^>]*disabled/, html)
    assert_includes html, "decor:bg-gray-50"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:cursor-not-allowed"
  end

  test "type :password emits type='password'" do
    html = render_component(::Decor::Suite::Forms::TextField.new(name: "p", label: "Password", type: :password))
    assert_match(/<input[^>]*type="password"/, html)
  end

  test "type :number emits type='number' and accepts min/max/step" do
    html = render_component(
      ::Decor::Suite::Forms::TextField.new(name: "qty", label: "Quantity", type: :number, min: 0, max: 10, step: 1)
    )
    assert_match(/<input[^>]*type="number"/, html)
    assert_match(/min="0"/, html)
    assert_match(/max="10"/, html)
    assert_match(/step="1"/, html)
  end

  test "placeholder propagates to input" do
    html = render_component(::Decor::Suite::Forms::TextField.new(name: "n", label: "L", placeholder: "Jane"))
    assert_match(/placeholder="Jane"/, html)
  end

  test "uses suite tokens for default input chrome (hairline-strong border, rounded-suite-control)" do
    html = render_component(::Decor::Suite::Forms::TextField.new(name: "n", label: "L"))
    assert_includes html, "decor:border-suite-hairline-strong"
    assert_includes html, "decor:rounded-suite-control"
  end

  test "focus chrome uses suite-primary-500 + suite-primary-100 ring var" do
    html = render_component(::Decor::Suite::Forms::TextField.new(name: "n", label: "L"))
    assert_includes html, "decor:focus:border-suite-primary-500"
    assert_includes html, "var(--color-suite-primary-100)"
  end

  test "uses suite motion tokens (no raw duration-150/200)" do
    html = render_component(::Decor::Suite::Forms::TextField.new(name: "n", label: "L"))
    assert_includes html, "decor:duration-suite-fast"
    refute_includes html, "decor:duration-150"
    refute_includes html, "decor:duration-200"
  end

  test "error state applies suite-danger border + bg + ring var" do
    html = render_component(
      ::Decor::Suite::Forms::TextField.new(name: "n", label: "L", error_messages: ["Bad"])
    )
    assert_includes html, "decor:border-suite-danger-500"
    assert_includes html, "decor:bg-suite-danger-50"
    assert_includes html, "var(--color-suite-danger-100)"
    assert_includes html, "Bad"
    assert_includes html, "decor:text-suite-danger-700"
  end

  test "helper text renders below the field with suite-field-help density-aware typography" do
    html = render_component(
      ::Decor::Suite::Forms::TextField.new(name: "n", label: "L", helper_text: "Must be unique")
    )
    assert_includes html, "Must be unique"
    assert_includes html, "decor:suite-field-help"
  end

  test "error text suppresses helper text visually (helper paragraph is hidden for JS validation pipeline)" do
    html = render_component(
      ::Decor::Suite::Forms::TextField.new(name: "n", label: "L", helper_text: "Help", error_messages: ["Bad"])
    )
    assert_includes html, "Bad"
    # Helper paragraph is kept in the DOM (with `decor:hidden`) so the JS
    # FormField controller has a stable target to swap back in once
    # validation passes. The "Help" text travels with it.
    assert_match(/data-decor--suite--forms--text-field-target="helperText"/, html)
    assert_match(/class="[^"]*decor:hidden[^"]*"\s+data-decor--suite--forms--text-field-target="helperText"/, html)
  end

  test "leading icon renders absolutely positioned with Decor::Icon" do
    html = render_component(
      ::Decor::Suite::Forms::TextField.new(name: "n", label: "L", leading_icon_name: "magnifying-glass")
    )
    assert_includes html, "decor:absolute"
    assert_includes html, "decor:left-0"
    assert_includes html, "tabler-magnifying-glass"
  end

  test "trailing icon renders absolutely positioned with Decor::Icon" do
    html = render_component(
      ::Decor::Suite::Forms::TextField.new(name: "n", label: "L", trailing_icon_name: "envelope")
    )
    assert_includes html, "decor:absolute"
    assert_includes html, "decor:right-0"
    assert_includes html, "tabler-envelope"
  end

  test "leading add-on block slot renders custom content (non-boxed)" do
    component = ::Decor::Suite::Forms::TextField.new(name: "n", label: "L")
    component.leading_add_on { "Custom slot" }
    html = render_component(component)
    assert_includes html, "Custom slot"
  end

  test "leading text add-on (non-boxed) renders inline span" do
    html = render_component(
      ::Decor::Suite::Forms::TextField.new(name: "n", label: "L", leading_text_add_on: "$")
    )
    assert_match(/<span[^>]*>\$<\/span>/, html)
  end

  test "boxed add-on style wraps the input in a shell with rounded-suite-control + suite-gray-25 cell" do
    html = render_component(
      ::Decor::Suite::Forms::TextField.new(
        name: "n", label: "L",
        leading_text_add_on: "https://", add_on_style: :boxed
      )
    )
    assert_includes html, "decor:bg-suite-gray-25"
    assert_includes html, "decor:rounded-suite-control"
    assert_includes html, "decor:group"
    assert_includes html, "decor:group-focus-within:bg-suite-primary-500"
  end

  test "boxed add-on focus highlight is suppressed in error state" do
    html = render_component(
      ::Decor::Suite::Forms::TextField.new(
        name: "n", label: "L",
        leading_text_add_on: "https://", add_on_style: :boxed,
        error_messages: ["Bad"]
      )
    )
    refute_includes html, "decor:group-focus-within:bg-suite-primary-500"
    assert_includes html, "decor:border-suite-danger-500"
  end

  test "minimum_length and maximum_length pass through" do
    html = render_component(
      ::Decor::Suite::Forms::TextField.new(name: "n", label: "L", minimum_length: 3, maximum_length: 32)
    )
    assert_match(/minlength="3"/, html)
    assert_match(/maxlength="32"/, html)
  end

  test "label left position uses 180px label column" do
    html = render_component(
      ::Decor::Suite::Forms::TextField.new(name: "n", label: "Company", label_position: :left)
    )
    assert_includes html, "decor:sm:w-[180px]"
  end

  test "description renders below label" do
    html = render_component(
      ::Decor::Suite::Forms::TextField.new(name: "n", label: "Company", description: "Legal name")
    )
    assert_includes html, "Legal name"
  end

  test "label_position :inside renders a floating label element inside the field (issue: was reserved space with no label)" do
    html = render_component(
      ::Decor::Suite::Forms::TextField.new(name: "n", label: "Title", label_position: :inside)
    )
    # A real <label for=...-control> with the text must render (previously the
    # strip was reserved via pt-[19px] but no label element was emitted).
    assert_match(/<label[^>]*for="[^"]+-control"[^>]*>Title<\/label>/, html)
    # The label is pinned inside the input box and the input reserves the strip.
    assert_includes html, "decor:pt-[19px]"
  end

  test "label_position :inside floating label carries the suite-field-label typography + label target" do
    html = render_component(
      ::Decor::Suite::Forms::TextField.new(name: "n", label: "Title", label_position: :inside)
    )
    assert_match(/<label[^>]*data-decor--suite--forms--text-field-target="label"[^>]*>Title<\/label>/, html)
  end

  test "label_position :inside without a label does not reserve the floating-label strip" do
    html = render_component(
      ::Decor::Suite::Forms::TextField.new(name: "n", placeholder: "Search...", label_position: :inside)
    )
    # No label means no floating-label element, so the input must not reserve
    # the top strip — otherwise the placeholder/value gets jammed into the
    # bottom 5px and the field looks broken.
    refute_match(/<label[^>]*for="[^"]+-control"/, html)
    refute_includes html, "decor:pt-[19px]"
    refute_includes html, "decor:pb-[5px]"
  end

  test "invalid_input stimulus class uses suite-danger tokens, not the daisy invalid:border-error-dark" do
    html = render_component(::Decor::Suite::Forms::TextField.new(name: "n", label: "L"))
    assert_match(/invalid-input-class="[^"]*decor:border-suite-danger-500[^"]*"/, html)
    refute_includes html, "invalid:border-error-dark"
  end

  test "silent_helper_and_error_text hides both helper and error rendering" do
    html = render_component(
      ::Decor::Suite::Forms::TextField.new(
        name: "n", label: "L",
        helper_text: "Help",
        error_messages: ["Bad"],
        silent_helper_and_error_text: true
      )
    )
    refute_includes html, "Help"
    refute_includes html, ">Bad<"
  end
end
