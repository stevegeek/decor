# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::PanelGroupTest < ActiveSupport::TestCase
  def test_renders_basic_details_box
    component = Decor::Daisy::PanelGroup.new(title: "Basic Details Box")

    rendered = render_fragment(component) { "Details content" }

    assert rendered.css(".card").any?

    title_element = rendered.css("h3").first
    assert title_element
    assert_equal "Basic Details Box", title_element.text
    assert_includes title_element["class"], "text-lg"

    assert_includes rendered.text, "Details content"
  end

  def test_renders_details_box_with_description
    component = Decor::Daisy::PanelGroup.new(
      title: "Details with Description",
      description: "This is a helpful description"
    )

    rendered = render_fragment(component) { "Main content" }

    title_element = rendered.css("h3").first
    assert title_element
    assert_equal "Details with Description", title_element.text

    description_element = rendered.css("p").first
    assert description_element
    assert_equal "This is a helpful description", description_element.text
    assert_includes description_element["class"], "text-base-content/70"

    assert_includes rendered.text, "Main content"
  end

  def test_renders_details_box_with_cta_slot
    component = Decor::Daisy::PanelGroup.new(title: "Details with CTA")

    rendered = render_fragment(component) do |group|
      group.cta { "Action Button" }
      "Box content"
    end

    title_element = rendered.css("h3").first
    assert title_element
    assert_equal "Details with CTA", title_element.text

    assert_includes rendered.text, "Action Button"

    assert_includes rendered.text, "Box content"
  end

  def test_renders_details_box_with_panels
    component = Decor::Daisy::PanelGroup.new(
      title: "Details with Panels"
    )

    rendered = render_fragment(component) do |group|
      group.with_panel_row do
        group.render ::Decor::Daisy::Panel.new(title: "Panel 1") { |p| p.plain("Content 1") }
        group.render ::Decor::Daisy::Panel.new(title: "Panel 2") { |p| p.plain("Content 2") }
      end
      group.with_panel_row do
        group.render ::Decor::Daisy::Panel.new(title: "Panel 3", icon: "academic-cap") { |p| p.plain("Content 3") }
      end
    end

    main_title = rendered.css("h3").first
    assert main_title
    assert_equal "Details with Panels", main_title.text

    panel_titles = rendered.css("h4")
    assert_equal 3, panel_titles.length
    assert_equal "Panel 1", panel_titles[0].text
    assert_equal "Panel 2", panel_titles[1].text
    assert_equal "Panel 3", panel_titles[2].text

    assert_includes rendered.text, "Content 1"
    assert_includes rendered.text, "Content 2"
    assert_includes rendered.text, "Content 3"

    assert rendered.css(".flex").any?
  end

  def test_details_box_with_complete_configuration
    component = Decor::Daisy::PanelGroup.new(
      title: "Dashboard Overview",
      description: "Key metrics and statistics"
    )

    rendered = render_fragment(component) do |group|
      group.with_panel_row do
        group.render ::Decor::Daisy::Panel.new(title: "Users", icon: "users") { |p| p.plain("1,234 active") }
        group.render ::Decor::Daisy::Panel.new(title: "Revenue") { |p| p.plain("$12,345") }
      end
      group.cta { "Refresh Data" }
    end

    assert rendered.css("h3").any? # Main title
    assert rendered.css("p").any? # Description
    assert_includes rendered.text, "Refresh Data" # CTA
    assert rendered.css("h4").any? # Panel titles
    assert_includes rendered.text, "1,234 active" # Panel content
  end

  def test_details_box_styling_classes
    component = Decor::Daisy::PanelGroup.new(title: "Styled Details Box")

    rendered = render_fragment(component)

    assert rendered.css(".card").any?

    assert rendered.css(".space-y-4").any?

    assert rendered.css(".card-body").any? # Card should have card-body
  end

  def test_details_box_section_alternating_backgrounds
    component = Decor::Daisy::PanelGroup.new(
      title: "Alternating Sections"
    )

    rendered = render_fragment(component) do |group|
      group.with_panel_row do
        group.render ::Decor::Daisy::Panel.new(title: "Section 1") { |p| p.plain("Content 1") }
      end
      group.with_panel_row do
        group.render ::Decor::Daisy::Panel.new(title: "Section 2") { |p| p.plain("Content 2") }
      end
      group.with_panel_row do
        group.render ::Decor::Daisy::Panel.new(title: "Section 3") { |p| p.plain("Content 3") }
      end
    end

    section_divs = rendered.css(".px-4.py-5")
    assert section_divs.length >= 3

    first_section = section_divs[0]
    assert_includes first_section["class"], "bg-base-200/50"

    second_section = section_divs[1]
    assert_includes second_section["class"], "bg-base-100"

    third_section = section_divs[2]
    assert_includes third_section["class"], "bg-base-200/50"
  end

  def test_details_box_flex_layout
    component = Decor::Daisy::PanelGroup.new(title: "Flex Layout Test")
    rendered = render_fragment(component) do |group|
      group.with_panel_row do
        group.render ::Decor::Daisy::Panel.new(title: "Panel 1") { |p| p.plain("Content 1") }
        group.render ::Decor::Daisy::Panel.new(title: "Panel 2") { |p| p.plain("Content 2") }
        group.render ::Decor::Daisy::Panel.new(title: "Panel 3") { |p| p.plain("Content 3") }
      end
    end

    assert rendered.css(".flex").any?
    assert rendered.css(".flex-wrap").any?
    assert rendered.css(".gap-4").any?
  end

  def test_details_box_without_panels
    component = Decor::Daisy::PanelGroup.new(
      title: "No Panels",
      description: "Just title and description"
    )

    rendered = render_fragment(component) { "Main content only" }

    assert rendered.css("h3").any?
    assert rendered.css("p").any?

    assert_includes rendered.text, "Main content only"

    assert_empty rendered.css(".px-4.py-5")
  end

  def test_details_box_panel_with_callable_content
    component = Decor::Daisy::PanelGroup.new(
      title: "Callable Content Test"
    )

    rendered = render_fragment(component) do |group|
      group.with_panel_row do
        group.render ::Decor::Daisy::Panel.new(title: "Dynamic Panel") do |p|
          content_proc = -> { "Dynamic content from proc" }
          p.plain(content_proc.call)
        end
      end
    end

    assert_includes rendered.text, "Dynamic content from proc"
  end

  def test_inherits_from_phlex_component
    component = Decor::Daisy::PanelGroup.new(title: "Test")
    assert_kind_of Decor::PhlexComponent, component
  end

  def test_uses_title_component_internally
    component = Decor::Daisy::PanelGroup.new(
      title: "Uses Title Component",
      description: "Testing internal Title usage"
    )

    rendered = render_fragment(component)

    title_wrapper = rendered.css("h3").first.parent
    assert title_wrapper

    assert title_wrapper.css("h3").any?
    assert title_wrapper.css("p").any?
  end

  def test_size_attribute
    component = Decor::Daisy::PanelGroup.new(title: "Large Panel Group", size: :lg)
    rendered = render_fragment(component)

    assert rendered.css(".card-lg").any?
  end

  def test_color_attribute
    component = Decor::Daisy::PanelGroup.new(title: "Primary Panel Group", color: :primary)
    rendered = render_fragment(component)

    assert rendered.css(".bg-primary").any?
  end

  def test_style_attribute
    component = Decor::Daisy::PanelGroup.new(title: "Ghost Panel Group", style: :ghost)
    rendered = render_fragment(component)

    assert rendered.css(".shadow-none").any?
  end

  def test_default_attributes
    component = Decor::Daisy::PanelGroup.new(title: "Default Panel Group")
    rendered = render_fragment(component)

    assert rendered.css(".card-md").any?
    assert rendered.css(".bg-base-100").any?
    assert rendered.css(".shadow-sm").any?
  end

  def test_attribute_validation
    assert_nothing_raised { Decor::Daisy::PanelGroup.new(title: "Test", size: :xs) }
    assert_nothing_raised { Decor::Daisy::PanelGroup.new(title: "Test", size: :xl) }

    assert_nothing_raised { Decor::Daisy::PanelGroup.new(title: "Test", color: :primary) }
    assert_nothing_raised { Decor::Daisy::PanelGroup.new(title: "Test", color: :success) }

    assert_nothing_raised { Decor::Daisy::PanelGroup.new(title: "Test", style: :outlined) }
    assert_nothing_raised { Decor::Daisy::PanelGroup.new(title: "Test", style: :ghost) }

    assert_raises(Literal::TypeError) { Decor::Daisy::PanelGroup.new(title: "Test", size: :invalid) }
    assert_raises(Literal::TypeError) { Decor::Daisy::PanelGroup.new(title: "Test", color: :invalid) }
    assert_raises(Literal::TypeError) { Decor::Daisy::PanelGroup.new(title: "Test", style: :invalid) }
  end
end
