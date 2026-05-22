# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::LayoutContainerTest < ActiveSupport::TestCase
  test "renders an outer card with suite hairline border and rounded-suite-card chrome" do
    html = render_component(::Decor::Suite::Forms::LayoutContainer.new)
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:rounded-suite-card"
    assert_includes html, "decor:overflow-hidden"
  end

  test "renders block content inside the card" do
    html = render_component(::Decor::Suite::Forms::LayoutContainer.new) do
      "<section class=\"sentinel\">child-section</section>".html_safe
    end
    assert_includes html, "child-section"
    assert_includes html, "sentinel"
  end

  test "omits the footer entirely when no buttons slot is configured" do
    html = render_component(::Decor::Suite::Forms::LayoutContainer.new) do
      "<span>body</span>".html_safe
    end
    refute_includes html, "decor:border-t"
    refute_includes html, "decor:bg-suite-gray-25"
  end

  test "renders the buttons slot inside a tinted footer strip with a top hairline" do
    component = ::Decor::Suite::Forms::LayoutContainer.new
    component.with_buttons { "<button>save</button>".html_safe }
    html = render_component(component) { "<span>body</span>".html_safe }
    assert_includes html, "<button>save</button>"
    assert_includes html, "decor:border-t"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:bg-suite-gray-25"
  end

  test "footer right-aligns buttons via flex justify-end with horizontal gap" do
    component = ::Decor::Suite::Forms::LayoutContainer.new
    component.with_buttons { "<button>save</button>".html_safe }
    html = render_component(component)
    assert_includes html, "decor:flex"
    assert_includes html, "decor:justify-end"
    assert_includes html, "decor:gap-2"
  end

  test "renders body content above the buttons footer" do
    component = ::Decor::Suite::Forms::LayoutContainer.new
    component.with_buttons { "<button>FOOTER_MARK</button>".html_safe }
    html = render_component(component) { "<div>BODY_MARK</div>".html_safe }
    assert html.index("BODY_MARK") < html.index("FOOTER_MARK"),
      "expected body to render before footer buttons"
  end

  test "renders nothing in the body region when no block is given" do
    component = ::Decor::Suite::Forms::LayoutContainer.new
    component.with_buttons { "<button>only-footer</button>".html_safe }
    html = render_component(component)
    assert_includes html, "only-footer"
    assert_includes html, "decor:bg-white"
  end
end
