# frozen_string_literal: true

require "test_helper"

class Decor::TitleTest < ActiveSupport::TestCase
  def test_renders_basic_title
    component = Decor::Title.new(title: "Basic Title")

    rendered = render_fragment(component)

    # Should render h3 for md size (default)
    title_element = rendered.css("h3").first
    assert title_element
    assert_equal "Basic Title", title_element.text
    assert_includes title_element["class"], "text-lg"
  end

  def test_renders_title_with_description
    component = Decor::Title.new(
      title: "Title with Description",
      description: "This is a subtitle"
    )

    rendered = render_fragment(component)

    # Should render title
    title_element = rendered.css("h3").first
    assert title_element
    assert_equal "Title with Description", title_element.text

    # Should render description
    description_element = rendered.css("p").first
    assert description_element
    assert_equal "This is a subtitle", description_element.text
    assert_includes description_element["class"], "text-base-content/70"
  end

  def test_renders_title_with_icon
    component = Decor::Title.new(
      title: "Title with Icon",
      icon: "academic-cap"
    )

    rendered = render_fragment(component)

    # Should have icon container with top alignment
    icon_container = rendered.css(".flex.items-start.space-x-2").first
    assert icon_container

    # Should render title
    title_element = rendered.css("h3").first
    assert title_element
    assert_equal "Title with Icon", title_element.text
  end

  def test_renders_title_with_actions_block
    component = Decor::Title.new(title: "Title with Actions")

    rendered = render_fragment(component) { "Action Button" }

    # Should render title
    title_element = rendered.css("h3").first
    assert title_element
    assert_equal "Title with Actions", title_element.text

    # Should render actions area
    actions_area = rendered.css(".flex-shrink-0").first
    assert actions_area
    assert_includes rendered.text, "Action Button"
  end

  def test_size_xs_uses_h5_and_small_text
    component = Decor::Title.new(title: "XS Title", size: :xs)

    rendered = render_fragment(component)

    # Should use h5 tag
    title_element = rendered.css("h5").first
    assert title_element
    assert_includes title_element["class"], "text-sm"
  end

  def test_size_sm_uses_h4_and_base_text
    component = Decor::Title.new(title: "SM Title", size: :sm)

    rendered = render_fragment(component)

    # Should use h4 tag
    title_element = rendered.css("h4").first
    assert title_element
    assert_includes title_element["class"], "text-base"
  end

  def test_size_md_uses_h3_and_lg_text
    component = Decor::Title.new(title: "MD Title", size: :md)

    rendered = render_fragment(component)

    # Should use h3 tag
    title_element = rendered.css("h3").first
    assert title_element
    assert_includes title_element["class"], "text-lg"
  end

  def test_size_lg_uses_h2_and_xl_text
    component = Decor::Title.new(title: "LG Title", size: :lg)

    rendered = render_fragment(component)

    # Should use h2 tag
    title_element = rendered.css("h2").first
    assert title_element
    assert_includes title_element["class"], "text-xl"
  end

  def test_size_xl_uses_h1_and_2xl_text
    component = Decor::Title.new(title: "XL Title", size: :xl)

    rendered = render_fragment(component)

    # Should use h1 tag
    title_element = rendered.css("h1").first
    assert title_element
    assert_includes title_element["class"], "text-2xl"
  end

  def test_description_size_scales_with_title_size
    xs_component = Decor::Title.new(title: "XS", description: "Small desc", size: :xs)
    lg_component = Decor::Title.new(title: "LG", description: "Large desc", size: :lg)

    xs_rendered = render_fragment(xs_component)
    lg_rendered = render_fragment(lg_component)

    # XS should have smaller description text
    xs_desc = xs_rendered.css("p").first
    assert_includes xs_desc["class"], "text-xs"

    # LG should have larger description text
    lg_desc = lg_rendered.css("p").first
    assert_includes lg_desc["class"], "text-base"
  end

  def test_complete_title_with_all_features
    component = Decor::Title.new(
      title: "Complete Title",
      description: "With description and icon",
      icon: "academic-cap",
      size: :lg
    )

    rendered = render_fragment(component) { "CTA Button" }

    # Should have all elements
    assert rendered.css("h2").any? # Title with lg size
    assert rendered.css("p").any? # Description
    assert rendered.css(".flex.items-start.space-x-2").any? # Icon container with top alignment
    assert_includes rendered.text, "CTA Button" # Action block
  end

  def test_title_without_description_or_actions
    component = Decor::Title.new(title: "Simple Title")

    rendered = render_fragment(component)

    # Should only have title
    assert rendered.css("h3").any?
    assert_empty rendered.css("p") # No description
    assert_empty rendered.css(".flex-shrink-0") # No actions area
  end

  def test_title_styling_classes
    component = Decor::Title.new(title: "Styled Title")

    rendered = render_fragment(component)

    title_element = rendered.css("h3").first
    classes = title_element["class"]

    # Should have styling classes
    assert_includes classes, "font-semibold"
    assert_includes classes, "text-base-content"
    assert_includes classes, "leading-tight"
  end

  def test_container_layout_classes
    component = Decor::Title.new(title: "Layout Test")

    rendered = render_fragment(component) { "Action" }

    # Should have flex container with proper classes
    container = rendered.css(".flex.justify-between.items-center").first
    assert container
    assert_includes container["class"], "flex-wrap"
    assert_includes container["class"], "sm:flex-nowrap"
  end
end
