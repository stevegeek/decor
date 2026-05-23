# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::Forms::SearchableSelectTest < ActiveSupport::TestCase
  test "renders root with daisy searchable-select identifier" do
    html = render_component(::Decor::Daisy::Forms::SearchableSelect.new(name: "user_id"))
    assert_includes html, "decor--daisy--forms--searchable-select"
  end

  test "shell uses gray-300 border and rounded-md (daisy default chrome)" do
    html = render_component(::Decor::Daisy::Forms::SearchableSelect.new(name: "user_id"))
    assert_includes html, "decor:rounded-md"
    assert_includes html, "decor:border-gray-300"
    assert_includes html, "decor:bg-white"
  end

  test "renders a label and description above the control with daisy label classes" do
    html = render_component(::Decor::Daisy::Forms::SearchableSelect.new(
      name: "user_id",
      label: "Assigned user",
      description: "Start typing to find a user"
    ))
    assert_includes html, "Assigned user"
    assert_includes html, "Start typing to find a user"
    assert_includes html, "decor:d-label"
    assert_includes html, "decor:d-label-text-alt"
  end

  test "search input target is wired" do
    html = render_component(::Decor::Daisy::Forms::SearchableSelect.new(name: "user_id"))
    assert_includes html, 'data-decor--daisy--forms--searchable-select-target="input"'
  end

  test "stimulus actions wire search/keydown/focus/click on the input" do
    html = render_component(::Decor::Daisy::Forms::SearchableSelect.new(name: "user_id"))
    assert_includes html, "input->decor--daisy--forms--searchable-select#search"
    assert_includes html, "keydown->decor--daisy--forms--searchable-select#handleKeydown"
    assert_includes html, "focus->decor--daisy--forms--searchable-select#handleFocus"
    assert_includes html, "click->decor--daisy--forms--searchable-select#handleInputClick"
  end

  test "stimulus values carry search url, allow_clear, auto_submit, and field name" do
    html = render_component(::Decor::Daisy::Forms::SearchableSelect.new(
      name: "user_id",
      search_url: "/users/search",
      allow_clear: false,
      auto_submit: true
    ))
    assert_includes html, 'search-url-value="/users/search"'
    assert_includes html, 'allow-clear-value="false"'
    assert_includes html, 'auto-submit-value="true"'
    assert_includes html, 'field-name-value="user_id"'
  end

  test "without a selection the chip is hidden and the input is visible" do
    html = render_component(::Decor::Daisy::Forms::SearchableSelect.new(name: "user_id"))
    assert_match(/class="[^"]*decor:hidden[^"]*"[^<]*data-decor--daisy--forms--searchable-select-target="selectedDisplay"/, html)
  end

  test "with selected_item the chip label renders and a hidden input is emitted" do
    html = render_component(::Decor::Daisy::Forms::SearchableSelect.new(
      name: "user_id",
      selected_item: {id: 42, label: "Ada Lovelace"}
    ))
    assert_includes html, "Ada Lovelace"
    assert_includes html, 'type="hidden"'
    assert_includes html, 'name="user_id"'
    assert_includes html, 'value="42"'
  end

  test "shows the clear button by default and hides it when allow_clear is false" do
    with_clear = render_component(::Decor::Daisy::Forms::SearchableSelect.new(
      name: "user_id",
      selected_item: {id: 1, label: "X"}
    ))
    without_clear = render_component(::Decor::Daisy::Forms::SearchableSelect.new(
      name: "user_id",
      allow_clear: false,
      selected_item: {id: 1, label: "X"}
    ))
    assert_includes with_clear, "click->decor--daisy--forms--searchable-select#clear"
    refute_includes without_clear, "click->decor--daisy--forms--searchable-select#clear"
  end

  test "dropdown is hidden by default" do
    html = render_component(::Decor::Daisy::Forms::SearchableSelect.new(name: "user_id"))
    assert_match(/<div[^<]*class="[^"]*decor:hidden[^"]*"[^<]*data-decor--daisy--forms--searchable-select-target="dropdown"/, html)
  end

  test "passes choices as JSON and sets min_chars to 0 in local mode" do
    html = render_component(::Decor::Daisy::Forms::SearchableSelect.new(
      name: "tag",
      choices: [{id: "a", label: "Alpha"}, {id: "b", label: "Beta"}]
    ))
    assert_includes html, "choices-value="
    assert_includes html, "Alpha"
    assert_includes html, 'min-chars-value="0"'
  end

  test "root is full-width" do
    html = render_component(::Decor::Daisy::Forms::SearchableSelect.new(name: "user_id"))
    assert_includes html, "decor:w-full"
  end
end
