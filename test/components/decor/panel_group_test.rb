# frozen_string_literal: true

require "test_helper"

class Decor::PanelGroupTest < ActiveSupport::TestCase
  def test_renders_basic_details_box
    component = Decor::PanelGroup.new(title: "Basic Details Box")

    rendered = render_fragment(component) { "Details content" }

    # Should render as a Card component (with the updated styling from PanelGroup)
    assert rendered.css(".card").any?

    # Should use Title component with md size (h3)
    title_element = rendered.css("h3").first
    assert title_element
    assert_equal "Basic Details Box", title_element.text
    assert_includes title_element["class"], "text-lg"

    # Should render content
    assert_includes rendered.text, "Details content"
  end

  def test_renders_details_box_with_description
    component = Decor::PanelGroup.new(
      title: "Details with Description",
      description: "This is a helpful description"
    )

    rendered = render_fragment(component) { "Main content" }

    # Should render title
    title_element = rendered.css("h3").first
    assert title_element
    assert_equal "Details with Description", title_element.text

    # Should render description
    description_element = rendered.css("p").first
    assert description_element
    assert_equal "This is a helpful description", description_element.text
    assert_includes description_element["class"], "text-base-content/70"

    # Should render content
    assert_includes rendered.text, "Main content"
  end

  def test_renders_details_box_with_cta_slot
    component = Decor::PanelGroup.new(title: "Details with CTA")

    rendered = render_fragment(component) do |group|
      group.cta { "Action Button" }
      "Box content"
    end

    # Should render title
    title_element = rendered.css("h3").first
    assert title_element
    assert_equal "Details with CTA", title_element.text

    # Should render CTA content
    assert_includes rendered.text, "Action Button"

    # Should render main content
    assert_includes rendered.text, "Box content"
  end

  def test_renders_details_box_with_panels
    component = Decor::PanelGroup.new(
      title: "Details with Panels"
    )

    rendered = render_fragment(component) do |group|
      group.panels do
        [
          group.panel(title: "Panel 1") { |p| p.plain("Content 1") },
          group.panel(title: "Panel 2") { |p| p.plain("Content 2") }
        ]
      end
      group.panels do
        [
          group.panel(title: "Panel 3", icon: "academic-cap") { |p| p.plain("Content 3") }
        ]
      end
    end

    # Should render main title
    main_title = rendered.css("h3").first
    assert main_title
    assert_equal "Details with Panels", main_title.text

    # Should render panel titles (using Title component with sm size = h4)
    panel_titles = rendered.css("h4")
    assert_equal 3, panel_titles.length
    assert_equal "Panel 1", panel_titles[0].text
    assert_equal "Panel 2", panel_titles[1].text
    assert_equal "Panel 3", panel_titles[2].text

    # Should render panel content
    assert_includes rendered.text, "Content 1"
    assert_includes rendered.text, "Content 2"
    assert_includes rendered.text, "Content 3"

    # Should have grid layout for sections
    assert rendered.css(".grid").any?
  end

  def test_details_box_with_complete_configuration
    component = Decor::PanelGroup.new(
      title: "Dashboard Overview",
      description: "Key metrics and statistics"
    )

    rendered = render_fragment(component) do |group|
      group.panels do
        [
          group.panel(title: "Users", icon: "users") { |p| p.plain("1,234 active") },
          group.panel(title: "Revenue") { |p| p.plain("$12,345") }
        ]
      end
      group.cta { "Refresh Data" }
      "Additional content"
    end

    # Should have all elements
    assert rendered.css("h3").any? # Main title
    assert rendered.css("p").any? # Description
    assert_includes rendered.text, "Refresh Data" # CTA
    assert rendered.css("h4").any? # Panel titles
    assert_includes rendered.text, "1,234 active" # Panel content
    assert_includes rendered.text, "Additional content" # Main content
  end

  def test_details_box_styling_classes
    component = Decor::PanelGroup.new(title: "Styled Details Box")

    rendered = render_fragment(component)

    # Should have Card component structure
    assert rendered.css(".card").any?

    # Should use space-y-4 class from element_classes
    assert rendered.css(".space-y-4").any?

    # Should be using Card component internally (verifies refactoring)
    # The exact styling classes are handled by the Card component
    assert rendered.css(".card-body").any? # Card should have card-body
  end

  def test_details_box_section_alternating_backgrounds
    component = Decor::PanelGroup.new(
      title: "Alternating Sections"
    )

    rendered = render_fragment(component) do |group|
      group.panels do
        [group.panel(title: "Section 1") { |p| p.plain("Content 1") }]
      end
      group.panels do
        [group.panel(title: "Section 2") { |p| p.plain("Content 2") }]
      end
      group.panels do
        [group.panel(title: "Section 3") { |p| p.plain("Content 3") }]
      end
    end

    # Should have different background classes for alternating sections
    section_divs = rendered.css(".px-4.py-5")
    assert section_divs.length >= 3

    # First section (index 0) should have bg-base-200/50
    first_section = section_divs[0]
    assert_includes first_section["class"], "bg-base-200/50"

    # Second section (index 1) should have bg-base-100
    second_section = section_divs[1]
    assert_includes second_section["class"], "bg-base-100"

    # Third section (index 2) should have bg-base-200/50 again
    third_section = section_divs[2]
    assert_includes third_section["class"], "bg-base-200/50"
  end

  def test_details_box_grid_sizing
    # Test different grid sizes based on number of panels

    # Single panel should use md:grid-cols-1
    component = Decor::PanelGroup.new(title: "Single")
    rendered = render_fragment(component) do |group|
      group.panels do
        [group.panel(title: "Single") { |p| p.plain("Content") }]
      end
    end
    assert rendered.css(".md\\:grid-cols-1").any?

    # Two panels should use md:grid-cols-2
    component = Decor::PanelGroup.new(title: "Double")
    rendered = render_fragment(component) do |group|
      group.panels do
        [
          group.panel(title: "First") { |p| p.plain("Content") },
          group.panel(title: "Second") { |p| p.plain("Content") }
        ]
      end
    end
    assert rendered.css(".md\\:grid-cols-2").any?

    # Three panels should use md:grid-cols-3
    component = Decor::PanelGroup.new(title: "Triple")
    rendered = render_fragment(component) do |group|
      group.panels do
        [
          group.panel(title: "1") { |p| p.plain("A") },
          group.panel(title: "2") { |p| p.plain("B") },
          group.panel(title: "3") { |p| p.plain("C") }
        ]
      end
    end
    assert rendered.css(".md\\:grid-cols-3").any?
  end

  def test_details_box_without_panels
    component = Decor::PanelGroup.new(
      title: "No Panels",
      description: "Just title and description"
    )

    rendered = render_fragment(component) { "Main content only" }

    # Should render title and description
    assert rendered.css("h3").any?
    assert rendered.css("p").any?

    # Should render main content
    assert_includes rendered.text, "Main content only"

    # Should not have any section grids since no panels provided
    assert_empty rendered.css(".px-4.py-5")
  end

  def test_details_box_panel_with_callable_content
    component = Decor::PanelGroup.new(
      title: "Callable Content Test"
    )

    rendered = render_fragment(component) do |group|
      group.panels do
        [
          group.panel(title: "Dynamic Panel") do |p|
            content_proc = -> { "Dynamic content from proc" }
            p.plain(content_proc.call)
          end
        ]
      end
    end

    # Should render the result of the proc
    assert_includes rendered.text, "Dynamic content from proc"
  end

  def test_inherits_from_phlex_component
    component = Decor::PanelGroup.new(title: "Test")
    assert_kind_of Decor::PhlexComponent, component
  end

  def test_uses_title_component_internally
    component = Decor::PanelGroup.new(
      title: "Uses Title Component",
      description: "Testing internal Title usage"
    )

    rendered = render_fragment(component)

    # Should use Title component structure (div wrapping title and description)
    title_wrapper = rendered.css("h3").first.parent
    assert title_wrapper

    # Title and description should be in same wrapper div
    assert title_wrapper.css("h3").any?
    assert title_wrapper.css("p").any?
  end

  def test_size_attribute
    component = Decor::PanelGroup.new(title: "Large Panel Group", size: :lg)
    rendered = render_fragment(component)

    # Should use large size on Card component internally
    assert rendered.css(".card-lg").any?
  end

  def test_color_attribute
    component = Decor::PanelGroup.new(title: "Primary Panel Group", color: :primary)
    rendered = render_fragment(component)

    # Should use primary color on Card component internally
    assert rendered.css(".bg-primary").any?
  end

  def test_style_attribute
    component = Decor::PanelGroup.new(title: "Ghost Panel Group", style: :ghost)
    rendered = render_fragment(component)

    # Should use ghost style styling (no shadow)
    assert rendered.css(".shadow-none").any?
  end

  def test_default_attributes
    component = Decor::PanelGroup.new(title: "Default Panel Group")
    rendered = render_fragment(component)

    # Should use default values: size: :md, color: :base, style: :filled
    assert rendered.css(".card-md").any?
    assert rendered.css(".bg-base-100").any?
    assert rendered.css(".shadow-sm").any?
  end

  def test_attribute_validation
    # Valid sizes
    assert_nothing_raised { Decor::PanelGroup.new(title: "Test", size: :xs) }
    assert_nothing_raised { Decor::PanelGroup.new(title: "Test", size: :xl) }

    # Valid colors
    assert_nothing_raised { Decor::PanelGroup.new(title: "Test", color: :primary) }
    assert_nothing_raised { Decor::PanelGroup.new(title: "Test", color: :success) }

    # Valid styles
    assert_nothing_raised { Decor::PanelGroup.new(title: "Test", style: :outlined) }
    assert_nothing_raised { Decor::PanelGroup.new(title: "Test", style: :ghost) }

    # Should raise for invalid values
    assert_raises(Literal::TypeError) { Decor::PanelGroup.new(title: "Test", size: :invalid) }
    assert_raises(Literal::TypeError) { Decor::PanelGroup.new(title: "Test", color: :invalid) }
    assert_raises(Literal::TypeError) { Decor::PanelGroup.new(title: "Test", style: :invalid) }
  end
end
