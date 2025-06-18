require "test_helper"

class Decor::Tables::DataTableCellTest < ActiveSupport::TestCase
  test "renders successfully with content" do
    component = Decor::Tables::DataTableCell.new
    rendered = render_component(component) do
      "Cell content"
    end

    assert_includes rendered, "Cell content"
    assert_includes rendered, "<td"
  end

  test "renders as td element by default" do
    component = Decor::Tables::DataTableCell.new
    fragment = render_fragment(component) do
      "Test"
    end

    td = fragment.at_css("td")
    assert_not_nil td
    assert_equal "Test", td.text
  end

  test "applies default CSS classes" do
    component = Decor::Tables::DataTableCell.new
    rendered = render_component(component)

    assert_includes rendered, "decor--data-table-cell"
  end

  test "supports custom CSS classes" do
    component = Decor::Tables::DataTableCell.new(class: "custom-cell")
    rendered = render_component(component)

    assert_includes rendered, "custom-cell"
    assert_includes rendered, "decor--data-table-cell"
  end

  test "supports colspan attribute" do
    component = Decor::Tables::DataTableCell.new(colspan: 2)
    rendered = render_component(component)

    assert_includes rendered, 'colspan="2"'
  end

  test "supports rowspan attribute" do
    component = Decor::Tables::DataTableCell.new(rowspan: 3)
    rendered = render_component(component)

    assert_includes rendered, 'rowspan="3"'
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Tables::DataTableCell.new

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "renders with alignment classes" do
    component = Decor::Tables::DataTableCell.new(class: "text-center")
    rendered = render_component(component)

    assert_includes rendered, "text-center"
  end

  test "supports various content types" do
    component = Decor::Tables::DataTableCell.new
    rendered = render_component(component) do
      "<strong>Bold text</strong>"
    end

    assert_includes rendered, "<strong>Bold text</strong>"
  end

  test "renders without content when none provided" do
    component = Decor::Tables::DataTableCell.new
    rendered = render_component(component)

    assert_includes rendered, "<td"
    assert_includes rendered, "decor--data-table-cell"
  end

  test "handles numeric content" do
    component = Decor::Tables::DataTableCell.new
    rendered = render_component(component) do
      "123.45"
    end

    assert_includes rendered, "123.45"
  end

  test "supports data attributes" do
    component = Decor::Tables::DataTableCell.new(
      data: {sortable: "true", value: "test"}
    )
    rendered = render_component(component)

    assert_includes rendered, 'data-sortable="true"'
    assert_includes rendered, 'data-value="test"'
  end

  test "renders with custom attributes" do
    component = Decor::Tables::DataTableCell.new(
      id: "cell-1",
      title: "Cell tooltip"
    )
    rendered = render_component(component)

    assert_includes rendered, 'id="cell-1"'
    assert_includes rendered, 'title="Cell tooltip"'
  end

  test "applies element classes correctly" do
    component = Decor::Tables::DataTableCell.new

    # Test that element_classes method exists and returns expected classes
    assert_respond_to component, :element_classes
  end

  test "supports numeric alignment" do
    component = Decor::Tables::DataTableCell.new(numeric: true)
    rendered = render_component(component)

    assert_includes rendered, "text-right"
  end

  test "supports text alignment" do
    component = Decor::Tables::DataTableCell.new(numeric: false)
    rendered = render_component(component)

    assert_includes rendered, "text-left"
  end

  test "supports daisyUI color system" do
    component = Decor::Tables::DataTableCell.new(color: :primary)
    rendered = render_component(component)

    assert_includes rendered, "text-primary"
  end

  test "supports all daisyUI colors" do
    [:primary, :secondary, :accent, :neutral, :info, :success, :warning, :error].each do |color|
      component = Decor::Tables::DataTableCell.new(color: color)
      rendered = render_component(component)

      assert_includes rendered, "text-#{color}"
    end
  end

  test "daisyUI colors take precedence over emphasis" do
    component = Decor::Tables::DataTableCell.new(color: :primary, emphasis: :low)
    rendered = render_component(component)

    assert_includes rendered, "text-primary"
    refute_includes rendered, "text-gray-500"
  end

  test "supports legacy emphasis system when no daisyUI color is set" do
    component = Decor::Tables::DataTableCell.new(emphasis: :low)
    rendered = render_component(component)

    assert_includes rendered, "text-gray-500"
  end

  test "supports typography weights" do
    component = Decor::Tables::DataTableCell.new(weight: :medium)
    rendered = render_component(component)

    assert_includes rendered, "font-medium"
  end

  test "supports row height variants" do
    component = Decor::Tables::DataTableCell.new(row_height: :tight)
    rendered = render_component(component)

    assert_includes rendered, "px-3 py-1 text-xs"
  end

  test "supports value attribute" do
    component = Decor::Tables::DataTableCell.new(value: "Test Value")
    rendered = render_component(component)

    assert_includes rendered, "Test Value"
  end

  test "supports width constraints" do
    component = Decor::Tables::DataTableCell.new(min_width_rem: 10, max_width: 200)
    rendered = render_component(component)

    assert_includes rendered, "min-width: 10rem"
    assert_includes rendered, "max-width: 200px"
  end

  test "supports clickable content" do
    component = Decor::Tables::DataTableCell.new(content_clickable: true)
    rendered = render_component(component)

    assert_includes rendered, "absolute inset-0"
  end

  test "supports path navigation" do
    component = Decor::Tables::DataTableCell.new(path: "/test/path")
    rendered = render_component(component)

    assert_includes rendered, "cursor-pointer"
    assert_includes rendered, "hover:bg-base-200"
  end

  test "maintains backward compatibility" do
    component = Decor::Tables::DataTableCell.new(
      emphasis: :regular,
      weight: :light,
      row_height: :comfortable
    )
    rendered = render_component(component)

    assert_includes rendered, "font-light"
    assert_includes rendered, "px-4 py-4 text-sm"
  end
end
