# frozen_string_literal: true

require "test_helper"

class ::Decor::Daisy::Forms::LayoutSectionTest < ActiveSupport::TestCase
  test "renders root with daisy layout-section identifier and spacing" do
    html = render_component(::Decor::Daisy::Forms::LayoutSection.new(title: "Profile"))
    assert_includes html, "decor--daisy--forms--layout-section"
    assert_includes html, "decor:pt-5"
    assert_includes html, "decor:mb-5"
  end

  test "renders title in an h3 with daisy typography classes" do
    html = render_component(::Decor::Daisy::Forms::LayoutSection.new(title: "Profile"))
    assert_includes html, "Profile"
    assert_includes html, "<h3"
    assert_includes html, "decor:text-lg"
    assert_includes html, "decor:font-medium"
  end

  test "renders description with muted gray helper styling" do
    html = render_component(::Decor::Daisy::Forms::LayoutSection.new(
      title: "Profile",
      description: "Public information"
    ))
    assert_includes html, "Public information"
    assert_includes html, "decor:text-gray-500"
  end

  test "renders block content inside a 6-col grid wrapper by default" do
    html = render_component(::Decor::Daisy::Forms::LayoutSection.new(title: "Section")) do
      "<span>field-marker</span>".html_safe
    end
    assert_includes html, "field-marker"
    assert_includes html, "decor:sm:grid-cols-6"
    assert_includes html, "decor:grid-cols-1"
  end

  test "stacked: true switches block content to a divider list (no grid)" do
    html = render_component(::Decor::Daisy::Forms::LayoutSection.new(title: "Section", stacked: true)) do
      "<span>stacked-marker</span>".html_safe
    end
    assert_includes html, "stacked-marker"
    assert_includes html, "decor:sm:mt-5"
    assert_includes html, "decor:divide-y"
    refute_includes html, "decor:sm:grid-cols-6"
  end

  test "custom_content_wrapper: true skips the fields-region wrapper" do
    html = render_component(::Decor::Daisy::Forms::LayoutSection.new(title: "Section", custom_content_wrapper: true)) do
      "<div class=\"sentinel\">payload</div>".html_safe
    end
    assert_includes html, "payload"
    assert_includes html, "sentinel"
    refute_includes html, "decor:sm:grid-cols-6"
  end

  test "with_cta renders the CTA block on the heading row" do
    component = ::Decor::Daisy::Forms::LayoutSection.new(title: "Members")
    component.with_cta { "<button>invite</button>".html_safe }
    html = render_component(component)
    assert_includes html, "<button>invite</button>"
  end

  test "with_hero renders the hero block above the heading" do
    component = ::Decor::Daisy::Forms::LayoutSection.new(title: "Cover")
    component.with_hero { "<div data-testid=\"hero\">hero-content</div>".html_safe }
    html = render_component(component)
    assert_includes html, "hero-content"
    hero_at = html.index("hero-content")
    title_at = html.index("Cover")
    assert hero_at && title_at && hero_at < title_at, "hero should render above the title"
  end

  test "flash: true renders a Daisy Flash with the supplied flash_message" do
    html = render_component(::Decor::Daisy::Forms::LayoutSection.new(
      title: "Address",
      flash: true,
      flash_message: "Verified."
    ))
    assert_includes html, "Verified."
    assert_includes html, "decor--daisy--flash"
  end

  test "flash: false omits the flash banner" do
    html = render_component(::Decor::Daisy::Forms::LayoutSection.new(title: "Profile"))
    refute_includes html, "decor--daisy--flash"
  end
end
