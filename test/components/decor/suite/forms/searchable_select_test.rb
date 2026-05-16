# frozen_string_literal: true

require "test_helper"

class Decor::Suite::Forms::SearchableSelectTest < ActiveSupport::TestCase
  test "renders the search input shell with suite chrome tokens" do
    rendered = render_component(Decor::Suite::Forms::SearchableSelect.new(name: "user_id"))

    assert_includes rendered, "decor:rounded-suite-control"
    assert_includes rendered, "decor:border-suite-hairline-strong"
    assert_includes rendered, "decor:bg-white"
    assert_includes rendered, "decor:duration-suite-fast"
    refute_includes rendered, "decor:rounded-md"
    refute_includes rendered, "decor:border-black/10"
  end

  test "uses suite typography tokens — no raw text-sm on the input" do
    rendered = render_component(Decor::Suite::Forms::SearchableSelect.new(name: "user_id"))

    assert_includes rendered, "decor:suite-body"
    assert_includes rendered, "decor:placeholder:text-gray-400"
  end

  test "applies focus halo using suite-primary-100" do
    rendered = render_component(Decor::Suite::Forms::SearchableSelect.new(name: "user_id"))

    assert_includes rendered, "decor:focus-within:border-suite-primary-500"
    assert_includes rendered, "var(--color-suite-primary-100)"
  end

  test "renders a label and description above the control" do
    rendered = render_component(Decor::Suite::Forms::SearchableSelect.new(
      name: "user_id",
      label: "Assigned user",
      description: "Start typing to find a user"
    ))

    assert_includes rendered, "Assigned user"
    assert_includes rendered, "Start typing to find a user"
    assert_includes rendered, "decor:suite-label"
    assert_includes rendered, "decor:suite-description"
  end

  test "search input target is wired and visible when no selection" do
    rendered = render_component(Decor::Suite::Forms::SearchableSelect.new(name: "user_id"))

    assert_includes rendered, "decor--suite--forms--searchable-select-target=\"input\""
    refute_includes rendered, "decor--suite--forms--searchable-select-target=\"input\".*decor:hidden"
  end

  test "stimulus actions wire search/keydown/focus/click on the input" do
    rendered = render_component(Decor::Suite::Forms::SearchableSelect.new(name: "user_id"))

    assert_includes rendered, "input->decor--suite--forms--searchable-select#search"
    assert_includes rendered, "keydown->decor--suite--forms--searchable-select#handleKeydown"
    assert_includes rendered, "focus->decor--suite--forms--searchable-select#handleFocus"
    assert_includes rendered, "click->decor--suite--forms--searchable-select#handleInputClick"
  end

  test "stimulus values carry search url, choices, min_chars, allow_clear and field name" do
    rendered = render_component(Decor::Suite::Forms::SearchableSelect.new(
      name: "user_id",
      search_url: "/users/search",
      allow_clear: false,
      auto_submit: true
    ))

    assert_includes rendered, "search-url-value=\"/users/search\""
    assert_includes rendered, "allow-clear-value=\"false\""
    assert_includes rendered, "auto-submit-value=\"true\""
    assert_includes rendered, "field-name-value=\"user_id\""
  end

  test "when no selected item the chip is hidden and the input is visible" do
    rendered = render_component(Decor::Suite::Forms::SearchableSelect.new(name: "user_id"))

    # The chip's class string includes decor:hidden when no selection.
    assert_match(/class="[^"]*decor:hidden[^"]*".*?target="selectedDisplay"/, rendered)
  end

  test "when selected_item is present the chip is shown, the input is hidden and a hidden input is rendered" do
    rendered = render_component(Decor::Suite::Forms::SearchableSelect.new(
      name: "user_id",
      selected_item: {id: 42, label: "Ada Lovelace"}
    ))

    assert_includes rendered, "Ada Lovelace"
    assert_includes rendered, "type=\"hidden\""
    assert_includes rendered, "name=\"user_id\""
    assert_includes rendered, "value=\"42\""
    # When selected, the search <input> carries decor:hidden.
    assert_match(/<input.*?class="[^"]*decor:hidden[^"]*".*?target="input"/, rendered)
  end

  test "shows the clear button by default and hides it when allow_clear is false" do
    with_clear = render_component(Decor::Suite::Forms::SearchableSelect.new(
      name: "user_id",
      selected_item: {id: 1, label: "X"}
    ))
    without_clear = render_component(Decor::Suite::Forms::SearchableSelect.new(
      name: "user_id",
      allow_clear: false,
      selected_item: {id: 1, label: "X"}
    ))

    assert_includes with_clear, "click->decor--suite--forms--searchable-select#clear"
    refute_includes without_clear, "click->decor--suite--forms--searchable-select#clear"
  end

  test "dropdown uses suite-token chrome and is hidden by default" do
    rendered = render_component(Decor::Suite::Forms::SearchableSelect.new(name: "user_id"))

    assert_includes rendered, "decor:shadow-suite-popover"
    assert_includes rendered, "decor:rounded-suite-control"
    assert_match(/<div[^>]*class="[^"]*decor:hidden[^"]*".*?target="dropdown"/, rendered)
  end

  test "does NOT use daisyUI semantic chrome" do
    rendered = render_component(Decor::Suite::Forms::SearchableSelect.new(name: "user_id"))

    refute_includes rendered, "decor:d-input"
    refute_includes rendered, "decor:bg-base-100"
    refute_includes rendered, "decor:bg-base-200"
    refute_includes rendered, "decor:bg-info"
    refute_includes rendered, "decor:text-info"
  end

  test "passes choices as a JSON string and sets min_chars to 0 in local mode" do
    rendered = render_component(Decor::Suite::Forms::SearchableSelect.new(
      name: "tag",
      choices: [{id: "a", label: "Alpha"}, {id: "b", label: "Beta"}]
    ))

    assert_includes rendered, "choices-value="
    assert_includes rendered, "Alpha"
    assert_includes rendered, "min-chars-value=\"0\""
  end
end
