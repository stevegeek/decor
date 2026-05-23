# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::TitleTest < ActiveSupport::TestCase
  def test_renders_basic_title
    component = Decor::Daisy::Title.new(title: "Basic Title")

    rendered = render_fragment(component)

    title_element = rendered.css("h3").first
    assert title_element
    assert_equal "Basic Title", title_element.text
    assert_includes title_element["class"], "decor:text-lg"
  end

  def test_renders_title_with_description
    component = Decor::Daisy::Title.new(
      title: "Title with Description",
      description: "This is a subtitle"
    )

    rendered = render_fragment(component)

    title_element = rendered.css("h3").first
    assert title_element
    assert_equal "Title with Description", title_element.text

    description_element = rendered.css("p").first
    assert description_element
    assert_equal "This is a subtitle", description_element.text
    assert_includes description_element["class"], "decor:text-base-content/70"
  end

  def test_renders_title_with_icon
    component = Decor::Daisy::Title.new(
      title: "Title with Icon",
      icon: "academic-cap"
    )

    rendered = render_fragment(component)

    icon_container = rendered.css('[class~="decor:flex"][class~="decor:items-start"][class~="decor:space-x-2"]').first
    assert icon_container

    title_element = rendered.css("h3").first
    assert title_element
    assert_equal "Title with Icon", title_element.text
  end

  def test_renders_title_with_actions_block
    component = Decor::Daisy::Title.new(title: "Title with Actions")

    rendered = render_fragment(component) { "Action Button" }

    title_element = rendered.css("h3").first
    assert title_element
    assert_equal "Title with Actions", title_element.text

    actions_area = rendered.css('[class~="decor:flex-shrink-0"]').first
    assert actions_area
    assert_includes rendered.text, "Action Button"
  end

  def test_size_xs_uses_h5_and_small_text
    component = Decor::Daisy::Title.new(title: "XS Title", size: :xs)

    rendered = render_fragment(component)

    title_element = rendered.css("h5").first
    assert title_element
    assert_includes title_element["class"], "decor:text-sm"
  end

  def test_size_sm_uses_h4_and_base_text
    component = Decor::Daisy::Title.new(title: "SM Title", size: :sm)

    rendered = render_fragment(component)

    title_element = rendered.css("h4").first
    assert title_element
    assert_includes title_element["class"], "decor:text-base"
  end

  def test_size_md_uses_h3_and_lg_text
    component = Decor::Daisy::Title.new(title: "MD Title", size: :md)

    rendered = render_fragment(component)

    title_element = rendered.css("h3").first
    assert title_element
    assert_includes title_element["class"], "decor:text-lg"
  end

  def test_size_lg_uses_h2_and_xl_text
    component = Decor::Daisy::Title.new(title: "LG Title", size: :lg)

    rendered = render_fragment(component)

    title_element = rendered.css("h2").first
    assert title_element
    assert_includes title_element["class"], "decor:text-xl"
  end

  def test_size_xl_uses_h1_and_2xl_text
    component = Decor::Daisy::Title.new(title: "XL Title", size: :xl)

    rendered = render_fragment(component)

    title_element = rendered.css("h1").first
    assert title_element
    assert_includes title_element["class"], "decor:text-2xl"
  end

  def test_description_size_scales_with_title_size
    xs_component = Decor::Daisy::Title.new(title: "XS", description: "Small desc", size: :xs)
    lg_component = Decor::Daisy::Title.new(title: "LG", description: "Large desc", size: :lg)

    xs_rendered = render_fragment(xs_component)
    lg_rendered = render_fragment(lg_component)

    xs_desc = xs_rendered.css("p").first
    assert_includes xs_desc["class"], "decor:text-xs"

    lg_desc = lg_rendered.css("p").first
    assert_includes lg_desc["class"], "decor:text-base"
  end

  def test_complete_title_with_all_features
    component = Decor::Daisy::Title.new(
      title: "Complete Title",
      description: "With description and icon",
      icon: "academic-cap",
      size: :lg
    )

    rendered = render_fragment(component) { "CTA Button" }

    assert rendered.css("h2").any? # Title with lg size
    assert rendered.css("p").any? # Description
    assert rendered.css('[class~="decor:flex"][class~="decor:items-start"][class~="decor:space-x-2"]').any? # Icon container with top alignment
    assert_includes rendered.text, "CTA Button" # Action block
  end

  def test_title_without_description_or_actions
    component = Decor::Daisy::Title.new(title: "Simple Title")

    rendered = render_fragment(component)

    assert rendered.css("h3").any?
    assert_empty rendered.css("p") # No description
    assert_empty rendered.css('[class~="decor:flex-shrink-0"]') # No actions area
  end

  def test_title_styling_classes
    component = Decor::Daisy::Title.new(title: "Styled Title")

    rendered = render_fragment(component)

    title_element = rendered.css("h3").first
    classes = title_element["class"]

    assert_includes classes, "decor:font-semibold"
    assert_includes classes, "decor:text-base-content"
    assert_includes classes, "decor:leading-tight"
  end

  def test_container_layout_classes
    component = Decor::Daisy::Title.new(title: "Layout Test")

    rendered = render_fragment(component) { "Action" }

    container = rendered.css('[class~="decor:flex"][class~="decor:justify-between"][class~="decor:items-center"]').first
    assert container
    assert_includes container["class"], "decor:flex-wrap"
    assert_includes container["class"], "decor:sm:flex-nowrap"
  end
end
