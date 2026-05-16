# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::LayoutSectionTest < ActiveSupport::TestCase
  test "renders section element with suite hairline divider chrome" do
    html = render_component(::Decor::Suite::Forms::LayoutSection.new(title: "Profile"))
    assert_includes html, "<section"
    assert_includes html, "decor:border-b"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:last-of-type:border-b-0"
  end

  test "renders title with suite-section-title typography" do
    html = render_component(::Decor::Suite::Forms::LayoutSection.new(title: "Profile"))
    assert_includes html, "Profile"
    assert_includes html, "decor:suite-section-title"
  end

  test "renders description with suite-description typography" do
    html = render_component(::Decor::Suite::Forms::LayoutSection.new(
      title: "Profile",
      description: "Public information"
    ))
    assert_includes html, "Public information"
    assert_includes html, "decor:suite-description"
  end

  test "omits heading row entirely when title, description and cta are absent" do
    html = render_component(::Decor::Suite::Forms::LayoutSection.new)
    refute_includes html, "decor:suite-section-title"
    refute_includes html, "decor:suite-description"
  end

  test "renders block content inside a flex-wrap grid wrapper by default" do
    html = render_component(::Decor::Suite::Forms::LayoutSection.new(title: "Section")) do
      "<span>field-marker</span>".html_safe
    end
    assert_includes html, "field-marker"
    assert_includes html, "decor:flex-wrap"
  end

  test "stacked: true renders block content in a vertical flex column" do
    html = render_component(::Decor::Suite::Forms::LayoutSection.new(title: "Section", stacked: true)) do
      "<span>stacked-marker</span>".html_safe
    end
    assert_includes html, "stacked-marker"
    assert_includes html, "decor:flex-col"
  end

  test "custom_content_wrapper: true skips the fields-region wrapper" do
    html = render_component(::Decor::Suite::Forms::LayoutSection.new(title: "Section", custom_content_wrapper: true)) do
      "<div class=\"sentinel\">payload</div>".html_safe
    end
    assert_includes html, "payload"
    assert_includes html, "sentinel"
    refute_includes html, "decor:flex-wrap decor:gap-y-2.5"
  end

  test "with_cta renders the CTA block on the heading row" do
    component = ::Decor::Suite::Forms::LayoutSection.new(title: "Members")
    component.with_cta { "<button>invite</button>".html_safe }
    html = render_component(component)
    assert_includes html, "<button>invite</button>"
  end

  test "with_hero renders the hero block above the heading" do
    component = ::Decor::Suite::Forms::LayoutSection.new(title: "Cover")
    component.with_hero { "<div>hero-content</div>".html_safe }
    html = render_component(component)
    assert_includes html, "hero-content"
  end

  test "flash: true renders a Suite Flash with the supplied flash_message" do
    html = render_component(::Decor::Suite::Forms::LayoutSection.new(
      title: "Address",
      flash: true,
      flash_message: "Verified."
    ))
    assert_includes html, "Verified."
    assert_includes html, "decor:rounded-suite-card"
  end

  test "no Confinus-era brand tokens leak into the rendered chrome" do
    html = render_component(::Decor::Suite::Forms::LayoutSection.new(
      title: "Profile",
      description: "Public information"
    )) { "<span>body</span>".html_safe }
    refute_includes html, "c-section-pad"
    refute_includes html, "c-section-title"
    refute_includes html, "c-description"
    refute_includes html, "c-grid-gap"
    refute_includes html, "c-section-gap"
    refute_includes html, "border-hairline"
  end
end
