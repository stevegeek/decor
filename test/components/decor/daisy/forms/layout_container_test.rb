# frozen_string_literal: true

require "test_helper"

class ::Decor::Daisy::Forms::LayoutContainerTest < ActiveSupport::TestCase
  test "renders root with daisy layout-container identifier and section spacing" do
    html = render_component(::Decor::Daisy::Forms::LayoutContainer.new)
    assert_includes html, "decor--daisy--forms--layout-container"
    assert_includes html, "decor:space-y-8"
    assert_includes html, "decor:divide-y"
    assert_includes html, "decor:divide-gray-200"
  end

  test "renders block content inside the body wrapper" do
    html = render_component(::Decor::Daisy::Forms::LayoutContainer.new) do
      "<section class=\"sentinel\">child-section</section>".html_safe
    end
    assert_includes html, "child-section"
    assert_includes html, "sentinel"
  end

  test "omits the footer entirely when no buttons slot is configured" do
    html = render_component(::Decor::Daisy::Forms::LayoutContainer.new) do
      "<span>body</span>".html_safe
    end
    refute_includes html, "decor:pt-5"
    refute_includes html, "decor:justify-end"
  end

  test "renders the buttons slot inside a top-padded footer when buttons supplied" do
    component = ::Decor::Daisy::Forms::LayoutContainer.new
    component.with_buttons { "<button>save</button>".html_safe }
    html = render_component(component) { "<span>body</span>".html_safe }
    assert_includes html, "<button>save</button>"
    assert_includes html, "decor:pt-5"
  end

  test "footer right-aligns buttons via flex justify-end with horizontal spacing" do
    component = ::Decor::Daisy::Forms::LayoutContainer.new
    component.with_buttons { "<button>save</button>".html_safe }
    html = render_component(component)
    assert_includes html, "decor:flex"
    assert_includes html, "decor:justify-end"
    assert_includes html, "decor:space-x-3"
  end

  test "renders body content above the buttons footer" do
    component = ::Decor::Daisy::Forms::LayoutContainer.new
    component.with_buttons { "<button>FOOTER_MARK</button>".html_safe }
    html = render_component(component) { "<div>BODY_MARK</div>".html_safe }
    assert html.index("BODY_MARK") < html.index("FOOTER_MARK"),
      "expected body to render before footer buttons"
  end

  test "renders without body content when no block is given" do
    component = ::Decor::Daisy::Forms::LayoutContainer.new
    component.with_buttons { "<button>only-footer</button>".html_safe }
    html = render_component(component)
    assert_includes html, "only-footer"
  end
end
