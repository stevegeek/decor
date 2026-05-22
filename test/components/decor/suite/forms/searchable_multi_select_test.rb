# frozen_string_literal: true

require "test_helper"

class Decor::Suite::Forms::SearchableMultiSelectTest < ActiveSupport::TestCase
  test "renders the search input shell with suite chrome tokens" do
    rendered = render_component(Decor::Suite::Forms::SearchableMultiSelect.new(name: "tags[]"))

    assert_includes rendered, "decor:rounded-suite-control"
    assert_includes rendered, "decor:border-suite-hairline-strong"
    assert_includes rendered, "decor:bg-white"
    assert_includes rendered, "decor:duration-suite-fast"
    refute_includes rendered, "decor:rounded-md"
    refute_includes rendered, "decor:border-black/10"
  end

  test "uses suite typography tokens — no raw text-sm on the input" do
    rendered = render_component(Decor::Suite::Forms::SearchableMultiSelect.new(name: "tags[]"))

    assert_includes rendered, "decor:placeholder:text-gray-400"
    assert_includes rendered, "decor:text-[length:var(--suite-input-font)]"
  end

  test "applies focus halo using suite-primary-100" do
    rendered = render_component(Decor::Suite::Forms::SearchableMultiSelect.new(name: "tags[]"))

    assert_includes rendered, "decor:focus-within:border-suite-primary-500"
    assert_includes rendered, "var(--color-suite-primary-100)"
  end

  test "renders a label and description above the control" do
    rendered = render_component(Decor::Suite::Forms::SearchableMultiSelect.new(
      name: "tags[]",
      label: "Invited users",
      description: "Start typing to find users"
    ))

    assert_includes rendered, "Invited users"
    assert_includes rendered, "Start typing to find users"
    assert_includes rendered, "decor:suite-field-label"
    assert_includes rendered, "decor:suite-field-help"
  end

  test "search input target is wired" do
    rendered = render_component(Decor::Suite::Forms::SearchableMultiSelect.new(name: "tags[]"))

    assert_includes rendered, "decor--suite--forms--searchable-multi-select-target=\"input\""
  end

  test "selected_container target wraps the chips" do
    rendered = render_component(Decor::Suite::Forms::SearchableMultiSelect.new(name: "tags[]"))

    assert_includes rendered, "decor--suite--forms--searchable-multi-select-target=\"selectedContainer\""
  end

  test "stimulus actions wire search/keydown/focus/click/blur on the input" do
    rendered = render_component(Decor::Suite::Forms::SearchableMultiSelect.new(name: "tags[]"))

    assert_includes rendered, "input->decor--suite--forms--searchable-multi-select#search"
    assert_includes rendered, "keydown->decor--suite--forms--searchable-multi-select#handleKeydown"
    assert_includes rendered, "focus->decor--suite--forms--searchable-multi-select#handleFocus"
    assert_includes rendered, "click->decor--suite--forms--searchable-multi-select#handleInputClick"
    assert_includes rendered, "blur->decor--suite--forms--searchable-multi-select#handleBlur"
  end

  test "stimulus values carry search url, extra params, free-text and field name" do
    rendered = render_component(Decor::Suite::Forms::SearchableMultiSelect.new(
      name: "user_ids[]",
      search_url: "/users/search",
      extra_search_params: "category_id=42",
      allow_free_text: true,
      delimiter: ";"
    ))

    assert_includes rendered, "search-url-value=\"/users/search\""
    assert_includes rendered, "extra-search-params-value=\"category_id=42\""
    assert_includes rendered, "allow-free-text-value=\"true\""
    assert_includes rendered, "delimiter-value=\";\""
    assert_includes rendered, "field-name-value=\"user_ids[]\""
  end

  test "renders no chips and no hidden inputs by default" do
    rendered = render_component(Decor::Suite::Forms::SearchableMultiSelect.new(name: "tags[]"))

    refute_includes rendered, "data-item-id"
    refute_includes rendered, "type=\"hidden\""
  end

  test "renders a chip and a hidden input per selected item" do
    rendered = render_component(Decor::Suite::Forms::SearchableMultiSelect.new(
      name: "user_ids[]",
      selected_items: [
        {id: 1, label: "Ada Lovelace"},
        {id: 2, label: "Grace Hopper"}
      ]
    ))

    assert_includes rendered, "Ada Lovelace"
    assert_includes rendered, "Grace Hopper"
    assert_includes rendered, "data-item-id=\"1\""
    assert_includes rendered, "data-item-id=\"2\""
    assert_includes rendered, "type=\"hidden\""
    assert_includes rendered, "name=\"user_ids[]\""
    assert_includes rendered, "value=\"1\""
    assert_includes rendered, "value=\"2\""
  end

  test "chip carries a dismiss button wired to remove_item" do
    rendered = render_component(Decor::Suite::Forms::SearchableMultiSelect.new(
      name: "tags[]",
      selected_items: [{id: 7, label: "alpha"}]
    ))

    assert_includes rendered, "click->decor--suite--forms--searchable-multi-select#removeItem"
  end

  test "chip uses suite-primary-50 fill and suite-primary-700 label" do
    rendered = render_component(Decor::Suite::Forms::SearchableMultiSelect.new(
      name: "tags[]",
      selected_items: [{id: 1, label: "Ada"}]
    ))

    assert_includes rendered, "decor:bg-suite-primary-50"
    assert_includes rendered, "decor:text-suite-primary-700"
    refute_includes rendered, "decor:bg-primary/10"
  end

  test "dropdown uses suite-token chrome and is hidden by default" do
    rendered = render_component(Decor::Suite::Forms::SearchableMultiSelect.new(name: "tags[]"))

    assert_includes rendered, "decor:shadow-suite-popover"
    assert_includes rendered, "decor:rounded-suite-control"
    assert_match(/<div[^>]*class="[^"]*decor:hidden[^"]*".*?target="dropdown"/, rendered)
  end

  test "does NOT use daisyUI semantic chrome" do
    rendered = render_component(Decor::Suite::Forms::SearchableMultiSelect.new(name: "tags[]"))

    refute_includes rendered, "decor:d-input"
    refute_includes rendered, "decor:bg-base-100"
    refute_includes rendered, "decor:bg-base-200"
    refute_includes rendered, "decor:bg-info"
    refute_includes rendered, "decor:text-info"
  end

  test "passes choices as a JSON string and sets min_chars to 0 in local mode" do
    rendered = render_component(Decor::Suite::Forms::SearchableMultiSelect.new(
      name: "tag",
      choices: [{id: "a", label: "Alpha"}, {id: "b", label: "Beta"}]
    ))

    assert_includes rendered, "choices-value="
    assert_includes rendered, "Alpha"
    assert_includes rendered, "min-chars-value=\"0\""
  end
end
