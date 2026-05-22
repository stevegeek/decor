# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Tables::TagFilterBarTest < ActiveSupport::TestCase
  TestTag = Struct.new(:encoded_id, :name, :color)

  def tags
    [
      TestTag.new("id_red", "Urgent", "red"),
      TestTag.new("id_blue", "Internal", "blue"),
      TestTag.new("id_unknown", "Mystery", "chartreuse")
    ]
  end

  test "renders a chip per visible tag with its label" do
    html = render_component(::Decor::Suite::Tables::TagFilterBar.new(tags: tags))
    assert_includes html, "Urgent"
    assert_includes html, "Internal"
    assert_includes html, "Mystery"
  end

  test "emits Suite stimulus controller identifier" do
    html = render_component(::Decor::Suite::Tables::TagFilterBar.new(tags: tags))
    assert_includes html, "decor--suite--tables--tag-filter-bar"
  end

  test "wires click→toggleTag on each chip" do
    html = render_component(::Decor::Suite::Tables::TagFilterBar.new(tags: tags))
    assert_includes html, "click->decor--suite--tables--tag-filter-bar#toggleTag"
  end

  test "wires click→setMode on the OR / AND toggle buttons" do
    html = render_component(::Decor::Suite::Tables::TagFilterBar.new(tags: tags))
    assert_includes html, "click->decor--suite--tables--tag-filter-bar#setMode"
    assert_includes html, ">OR<"
    assert_includes html, ">AND<"
  end

  test "OR mode is visually active when tag_mode == \"or\"" do
    html = render_component(::Decor::Suite::Tables::TagFilterBar.new(tags: tags, tag_mode: "or"))
    # Phlex emits class= before data-mode=, so check the active fill on the
    # button whose data-mode matches.
    assert_match(/decor:bg-gray-800 decor:text-white"[^>]*data-mode="or"/, html)
    assert_match(/decor:bg-white decor:text-gray-600[^"]*"[^>]*data-mode="and"/, html)
  end

  test "AND mode flips which button is active" do
    html = render_component(::Decor::Suite::Tables::TagFilterBar.new(tags: tags, tag_mode: "and"))
    assert_match(/decor:bg-gray-800 decor:text-white"[^>]*data-mode="and"/, html)
    assert_match(/decor:bg-white decor:text-gray-600[^"]*"[^>]*data-mode="or"/, html)
  end

  test "exposes selected_ids / tag_mode / param_name / mode_param_name as stimulus values" do
    html = render_component(
      ::Decor::Suite::Tables::TagFilterBar.new(
        tags: tags,
        selected_tag_ids: ["id_red"],
        tag_mode: "and",
        param_name: "my_param",
        mode_param_name: "my_mode_param"
      )
    )
    assert_includes html, "selected-ids-value"
    assert_includes html, "id_red"
    assert_includes html, "tag-mode-value=\"and\""
    assert_includes html, "param-name-value=\"my_param\""
    assert_includes html, "mode-param-name-value=\"my_mode_param\""
  end

  test "selected chips paint in the tag's color palette" do
    html = render_component(
      ::Decor::Suite::Tables::TagFilterBar.new(tags: tags, selected_tag_ids: ["id_red"])
    )
    assert_match(/decor:bg-red-100 decor:text-red-800 decor:border-red-300"[^>]*data-tag-id="id_red"/, html)
    assert_match(/decor:bg-white decor:border-suite-hairline-strong[^"]*"[^>]*data-tag-id="id_blue"/, html)
    assert_includes html, "data-selected-classes=\"decor:bg-red-100 decor:text-red-800 decor:border-red-300\""
  end

  test "unknown color falls through to gray defaults without raising" do
    html = render_component(
      ::Decor::Suite::Tables::TagFilterBar.new(tags: tags, selected_tag_ids: ["id_unknown"])
    )
    assert_match(/decor:bg-gray-100 decor:text-gray-800 decor:border-gray-300"[^>]*data-tag-id="id_unknown"/, html)
  end

  test "Clear button only appears when something is selected" do
    plain_html = render_component(::Decor::Suite::Tables::TagFilterBar.new(tags: tags))
    refute_includes plain_html, ">Clear<"

    selected_html = render_component(
      ::Decor::Suite::Tables::TagFilterBar.new(tags: tags, selected_tag_ids: ["id_red"])
    )
    assert_includes selected_html, ">Clear<"
    assert_includes selected_html, "click->decor--suite--tables--tag-filter-bar#clearAll"
  end

  test "Apply button is always rendered with hidden class so JS can reveal it" do
    html = render_component(::Decor::Suite::Tables::TagFilterBar.new(tags: tags))
    assert_includes html, ">Apply<"
    # applyButton stimulus target; matching across attr-value `>` requires
    # `[\s\S]` since `.` won't cross the apostrophe-free greedy boundary.
    assert_match(/<button[^>]*decor:hidden[\s\S]*?applyButton[\s\S]*?>Apply</, html)
    assert_includes html, "click->decor--suite--tables--tag-filter-bar#apply"
  end

  test "renders +N more overflow button when tag count > max_visible" do
    big = (1..20).map { |i| TestTag.new("id#{i}", "Tag #{i}", "blue") }
    html = render_component(::Decor::Suite::Tables::TagFilterBar.new(tags: big, max_visible: 5))
    assert_includes html, "+15 more"
    assert_includes html, "click->decor--suite--tables--tag-filter-bar#showAll"
  end

  test "no overflow button when tag count <= max_visible" do
    html = render_component(::Decor::Suite::Tables::TagFilterBar.new(tags: tags, max_visible: 10))
    refute_includes html, " more"
    refute_match(/\+\d+ more/, html)
  end

  test "root uses suite-gray-25 bar with suite-hairline bottom border" do
    html = render_component(::Decor::Suite::Tables::TagFilterBar.new(tags: tags))
    assert_includes html, "decor:bg-suite-gray-25"
    assert_includes html, "decor:border-b"
    assert_includes html, "decor:border-suite-hairline"
  end

  test "inherits from Decor::PhlexComponent (no abstract base for this Suite-only component)" do
    assert_operator ::Decor::Suite::Tables::TagFilterBar, :<, ::Decor::PhlexComponent
  end
end
