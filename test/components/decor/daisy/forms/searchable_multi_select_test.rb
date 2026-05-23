# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::Forms::SearchableMultiSelectTest < ActiveSupport::TestCase
  test "renders root with daisy searchable-multi-select identifier" do
    html = render_component(::Decor::Daisy::Forms::SearchableMultiSelect.new(name: "tags[]"))
    assert_includes html, "decor--daisy--forms--searchable-multi-select"
  end

  test "shell uses gray-300 border and rounded-md (daisy default chrome)" do
    html = render_component(::Decor::Daisy::Forms::SearchableMultiSelect.new(name: "tags[]"))
    assert_includes html, "decor:rounded-md"
    assert_includes html, "decor:border-gray-300"
    assert_includes html, "decor:bg-white"
  end

  test "renders a label and description above the control with daisy label classes" do
    html = render_component(::Decor::Daisy::Forms::SearchableMultiSelect.new(
      name: "tags[]",
      label: "Invited users",
      description: "Start typing to find users"
    ))
    assert_includes html, "Invited users"
    assert_includes html, "Start typing to find users"
    assert_includes html, "decor:d-label"
    assert_includes html, "decor:d-label-text-alt"
  end

  test "search input target is wired" do
    html = render_component(::Decor::Daisy::Forms::SearchableMultiSelect.new(name: "tags[]"))
    assert_includes html, 'data-decor--daisy--forms--searchable-multi-select-target="input"'
  end

  test "selected_container target wraps the chips" do
    html = render_component(::Decor::Daisy::Forms::SearchableMultiSelect.new(name: "tags[]"))
    assert_includes html, 'data-decor--daisy--forms--searchable-multi-select-target="selectedContainer"'
  end

  test "stimulus actions wire search/keydown/focus/click/blur on the input" do
    html = render_component(::Decor::Daisy::Forms::SearchableMultiSelect.new(name: "tags[]"))
    assert_includes html, "input->decor--daisy--forms--searchable-multi-select#search"
    assert_includes html, "keydown->decor--daisy--forms--searchable-multi-select#handleKeydown"
    assert_includes html, "focus->decor--daisy--forms--searchable-multi-select#handleFocus"
    assert_includes html, "click->decor--daisy--forms--searchable-multi-select#handleInputClick"
    assert_includes html, "blur->decor--daisy--forms--searchable-multi-select#handleBlur"
  end

  test "stimulus values carry search url, extra params, free-text and field name" do
    html = render_component(::Decor::Daisy::Forms::SearchableMultiSelect.new(
      name: "user_ids[]",
      search_url: "/users/search",
      extra_search_params: "category_id=42",
      allow_free_text: true,
      delimiter: ";"
    ))
    assert_includes html, 'search-url-value="/users/search"'
    assert_includes html, 'extra-search-params-value="category_id=42"'
    assert_includes html, 'allow-free-text-value="true"'
    assert_includes html, 'delimiter-value=";"'
    assert_includes html, 'field-name-value="user_ids[]"'
  end

  test "renders no chips and no hidden inputs by default" do
    html = render_component(::Decor::Daisy::Forms::SearchableMultiSelect.new(name: "tags[]"))
    refute_includes html, "data-item-id"
    refute_includes html, 'type="hidden"'
  end

  test "renders a chip and a hidden input per selected item" do
    html = render_component(::Decor::Daisy::Forms::SearchableMultiSelect.new(
      name: "user_ids[]",
      selected_items: [
        {id: 1, label: "Ada Lovelace"},
        {id: 2, label: "Grace Hopper"}
      ]
    ))
    assert_includes html, "Ada Lovelace"
    assert_includes html, "Grace Hopper"
    assert_includes html, 'data-item-id="1"'
    assert_includes html, 'data-item-id="2"'
    assert_includes html, 'type="hidden"'
    assert_includes html, 'name="user_ids[]"'
    assert_includes html, 'value="1"'
    assert_includes html, 'value="2"'
  end

  test "chip carries a dismiss button wired to remove_item" do
    html = render_component(::Decor::Daisy::Forms::SearchableMultiSelect.new(
      name: "tags[]",
      selected_items: [{id: 7, label: "alpha"}]
    ))
    assert_includes html, "click->decor--daisy--forms--searchable-multi-select#removeItem"
  end

  test "chip uses daisy primary tint" do
    html = render_component(::Decor::Daisy::Forms::SearchableMultiSelect.new(
      name: "tags[]",
      selected_items: [{id: 1, label: "Ada"}]
    ))
    assert_includes html, "decor:bg-primary/10"
    assert_includes html, "decor:text-primary"
  end

  test "dropdown is hidden by default" do
    html = render_component(::Decor::Daisy::Forms::SearchableMultiSelect.new(name: "tags[]"))
    assert_match(/<div[^<]*class="[^"]*decor:hidden[^"]*"[^<]*data-decor--daisy--forms--searchable-multi-select-target="dropdown"/, html)
  end

  test "passes choices as JSON and sets min_chars to 0 in local mode" do
    html = render_component(::Decor::Daisy::Forms::SearchableMultiSelect.new(
      name: "tag",
      choices: [{id: "a", label: "Alpha"}, {id: "b", label: "Beta"}]
    ))
    assert_includes html, "choices-value="
    assert_includes html, "Alpha"
    assert_includes html, 'min-chars-value="0"'
  end
end
