require "test_helper"

class Decor::TabsTest < ActiveSupport::TestCase
  test "renders successfully with slot-based API" do
    component = Decor::Tabs.new
    rendered = render_fragment(component)

    assert rendered.css(".tabs").any?
  end

  test "renders with daisyUI tabs classes by default" do
    component = Decor::Tabs.new
    rendered = render_fragment(component)

    assert rendered.css(".tabs.tabs-border").any?
  end

  test "renders with legacy links API" do
    links = [
      {title: "Tab 1", href: "/tab1", active: true},
      {title: "Tab 2", href: "/tab2"}
    ]
    component = Decor::Tabs.new(links: links)
    rendered = render_fragment(component)

    assert rendered.css(".tabs").any?
    assert rendered.css(".tab").any?
    assert rendered.css(".tab-active").any?
  end

  test "supports tab_buttons slot" do
    component = Decor::Tabs.new
    rendered = render_component(component) do |c|
      c.with_tab_buttons { "<button class='tab'>Tab 1</button>" }
    end

    assert_includes rendered, "<button class='tab'>Tab 1</button>"
  end

  test "supports tab_content slot" do
    component = Decor::Tabs.new
    rendered = render_component(component) do |c|
      c.with_tab_content { "<div>Tab content here</div>" }
    end

    assert_includes rendered, "<div>Tab content here</div>"
  end

  test "renders both slots together" do
    component = Decor::Tabs.new
    rendered = render_component(component) do |c|
      c.with_tab_buttons { "Tab Buttons" }
      c.with_tab_content { "Tab Content" }
    end

    assert_includes rendered, "Tab Buttons"
    assert_includes rendered, "Tab Content"
  end

  test "renders with correct HTML structure" do
    component = Decor::Tabs.new
    fragment = render_fragment(component)

    # Check the outer div has decor--tabs class
    outer_div = fragment.at_css(".decor--tabs")
    assert_not_nil outer_div

    # Check the nav has tabs classes
    nav = fragment.at_css("nav.tabs")
    assert_not_nil nav
    assert_includes nav["class"], "tabs-border"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Tabs.new

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "applies default element classes" do
    component = Decor::Tabs.new
    rendered = render_component(component)

    assert_includes rendered, "tabs"
    assert_includes rendered, "tabs-border"
  end

  test "renders without slots when none provided" do
    component = Decor::Tabs.new
    rendered = render_component(component)

    # Should still render the container
    assert_includes rendered, "tabs"
    assert_includes rendered, "decor--tabs"
  end

  test "supports complex tab button content" do
    component = Decor::Tabs.new
    rendered = render_component(component) do |c|
      c.with_tab_buttons do
        "<button class='tab tab-active'>Active Tab</button><button class='tab'>Inactive Tab</button>"
      end
    end

    assert_includes rendered, "tab-active"
    assert_includes rendered, "Active Tab"
    assert_includes rendered, "Inactive Tab"
  end

  test "supports complex tab content" do
    component = Decor::Tabs.new
    rendered = render_component(component) do |c|
      c.with_tab_content do
        "<div class='tab-content'><h3>Content Title</h3><p>Content body</p></div>"
      end
    end

    assert_includes rendered, "tab-content"
    assert_includes rendered, "Content Title"
    assert_includes rendered, "Content body"
  end

  test "tab buttons appear before tab content in DOM order" do
    component = Decor::Tabs.new
    rendered = render_component(component) do |c|
      c.with_tab_buttons { "Buttons Here" }
      c.with_tab_content { "Content Here" }
    end

    buttons_pos = rendered.index("Buttons Here")
    content_pos = rendered.index("Content Here")

    assert_not_nil buttons_pos, "Buttons content not found"
    assert_not_nil content_pos, "Content content not found"
    assert buttons_pos < content_pos
  end

  test "renders as div element" do
    component = Decor::Tabs.new
    fragment = render_fragment(component)

    div = fragment.at_css("div")
    assert_not_nil div
    assert_includes div["class"], "tabs"
  end

  test "supports custom CSS classes via additional attributes" do
    component = Decor::Tabs.new(html_options: {class: "custom-tabs"})
    rendered = render_component(component)

    assert_includes rendered, "custom-tabs"
    assert_includes rendered, "tabs"
  end

  # Modern Attribute Tests
  test "supports size variants" do
    component = Decor::Tabs.new(size: :lg)
    rendered = render_component(component)

    assert_includes rendered, "tabs-lg"
  end

  test "supports color variants" do
    component = Decor::Tabs.new(color: :primary)
    rendered = render_component(component)

    assert_includes rendered, "text-primary"
  end

  test "supports visual variants" do
    component = Decor::Tabs.new(variant: :lifted)
    rendered = render_component(component)

    assert_includes rendered, "tabs-lift"
  end

  test "defaults to bordered variant" do
    component = Decor::Tabs.new
    rendered = render_component(component)

    assert_includes rendered, "tabs-border"
  end

  test "supports boxed variant" do
    component = Decor::Tabs.new(variant: :boxed)
    rendered = render_component(component)

    assert_includes rendered, "tabs-box"
  end

  test "supports size xs" do
    component = Decor::Tabs.new(size: :xs)
    rendered = render_component(component)

    assert_includes rendered, "tabs-xs"
  end

  test "medium size is default (no class added)" do
    component = Decor::Tabs.new(size: :md)
    rendered = render_component(component)

    refute_includes rendered, "tabs-md"
    assert_includes rendered, "tabs"
  end

  # Icon Integration Tests
  test "renders tab with icon before text" do
    links = [
      {title: "Home", href: "/", icon: "home", icon_position: :before}
    ]
    component = Decor::Tabs.new(links: links)
    rendered = render_component(component)

    assert_includes rendered, "mr-2" # Icon spacing
    assert_includes rendered, "Home"
  end

  test "renders tab with icon after text" do
    links = [
      {title: "Settings", href: "/settings", icon: "cog", icon_position: :after}
    ]
    component = Decor::Tabs.new(links: links)
    rendered = render_component(component)

    assert_includes rendered, "ml-2" # Icon spacing
    assert_includes rendered, "Settings"
  end

  test "renders icon-only tab with aria-label" do
    links = [
      {title: "Profile", href: "/profile", icon: "user", icon_position: :only}
    ]
    component = Decor::Tabs.new(links: links)
    fragment = render_fragment(component)

    tab_link = fragment.at_css("a.tab")
    assert_equal "Profile", tab_link["aria-label"]
  end

  # Badge Integration Tests
  test "renders tab with badge indicator" do
    links = [
      {title: "Messages", href: "/messages", badge_text: "3", badge_color: :error}
    ]
    component = Decor::Tabs.new(links: links)
    rendered = render_component(component)

    assert_includes rendered, "Messages"
    assert_includes rendered, "3" # Badge text
    assert_includes rendered, "ml-2" # Badge spacing
  end

  test "renders tab with both icon and badge" do
    links = [
      {title: "Notifications", href: "/notifications", icon: "bell", badge_text: "5"}
    ]
    component = Decor::Tabs.new(links: links)
    rendered = render_component(component)

    assert_includes rendered, "Notifications"
    assert_includes rendered, "5" # Badge
  end

  # ARIA and Accessibility Tests
  test "includes proper ARIA attributes for navigation" do
    links = [{title: "Tab 1", href: "/tab1", active: true}]
    component = Decor::Tabs.new(links: links)
    fragment = render_fragment(component)

    nav = fragment.at_css("nav")
    assert_equal "tablist", nav["role"]
    assert_equal "Tabs", nav["aria-label"]
  end

  test "includes proper ARIA attributes for active tab" do
    links = [{title: "Active Tab", href: "/active", active: true}]
    component = Decor::Tabs.new(links: links)
    fragment = render_fragment(component)

    active_tab = fragment.at_css("a.tab-active")
    assert_equal "true", active_tab["aria-selected"]
    assert_equal "0", active_tab["tabindex"]
  end

  test "includes proper ARIA attributes for inactive tab" do
    links = [{title: "Inactive Tab", href: "/inactive", active: false}]
    component = Decor::Tabs.new(links: links)
    fragment = render_fragment(component)

    inactive_tab = fragment.at_css("a.tab")
    assert_equal "false", inactive_tab["aria-selected"]
    assert_equal "-1", inactive_tab["tabindex"]
  end

  test "disabled tab has proper ARIA attributes" do
    links = [{title: "Disabled Tab", href: "/disabled", disabled: true}]
    component = Decor::Tabs.new(links: links)
    fragment = render_fragment(component)

    disabled_tab = fragment.at_css(".tab-disabled")
    assert_equal "true", disabled_tab["aria-disabled"]
  end

  # Mobile Responsive Tests
  test "shows select dropdown for many tabs" do
    links = 5.times.map { |i| {title: "Tab #{i + 1}", href: "/tab#{i + 1}"} }
    component = Decor::Tabs.new(links: links)
    fragment = render_fragment(component)

    # Should have mobile select
    mobile_nav = fragment.at_css("nav.sm\\:hidden")
    assert_not_nil mobile_nav

    select = fragment.at_css("select")
    assert_not_nil select
    assert_includes select["class"], "select-bordered"
  end

  test "does not show select dropdown for few tabs" do
    links = [{title: "Tab 1", href: "/tab1"}, {title: "Tab 2", href: "/tab2"}]
    component = Decor::Tabs.new(links: links)
    fragment = render_fragment(component)

    # Should not have mobile select
    mobile_nav = fragment.at_css("nav.sm\\:hidden")
    assert_nil mobile_nav
  end

  test "mobile select includes status text" do
    links = 5.times.map { |i| {title: "Tab #{i + 1}", href: "/tab#{i + 1}"} }
    component = Decor::Tabs.new(links: links, status: "Status message")
    rendered = render_component(component)

    assert_includes rendered, "Status message"
  end

  # Status Text Tests
  test "renders status text in desktop view" do
    links = [{title: "Tab 1", href: "/tab1"}]
    component = Decor::Tabs.new(links: links, status: "Status text here")
    rendered = render_component(component)

    assert_includes rendered, "Status text here"
    assert_includes rendered, "ml-auto" # Status positioning
  end

  # Edge Cases and Error Handling
  test "handles empty links array gracefully" do
    component = Decor::Tabs.new(links: [])
    rendered = render_component(component)

    assert_includes rendered, "tabs"
    refute_includes rendered, "tab-active"
  end

  test "TabInfo subcomponent allows optional attributes" do
    # Both title and href are optional in the current implementation
    tab_info_1 = Decor::Tabs::TabInfo.new(href: "/test") # title is optional
    assert_equal "/test", tab_info_1.href
    assert_nil tab_info_1.title

    tab_info_2 = Decor::Tabs::TabInfo.new(title: "Test") # href is optional  
    assert_equal "Test", tab_info_2.title
    assert_nil tab_info_2.href
  end

  test "TabInfo subcomponent accepts both title and href" do
    tab_info = Decor::Tabs::TabInfo.new(title: "Test", href: "/test")
    assert_equal "Test", tab_info.title
    assert_equal "/test", tab_info.href
  end

  # Legacy API Compatibility Tests
  test "maintains backward compatibility with existing API" do
    links = [
      {title: "Legacy Tab 1", href: "/legacy1", active: true},
      {title: "Legacy Tab 2", href: "/legacy2"}
    ]
    component = Decor::Tabs.new(links: links)
    rendered = render_component(component)

    assert_includes rendered, "Legacy Tab 1"
    assert_includes rendered, "Legacy Tab 2"
    assert_includes rendered, "tab-active"
  end

  # Dual API Mode Detection Tests
  test "detects slot API when tab_buttons provided" do
    component = Decor::Tabs.new
    component.with_tab_buttons { "Button content" }

    # Private method testing - use send to access
    assert component.send(:use_slot_api?)
  end

  test "detects slot API when tab_content provided" do
    component = Decor::Tabs.new
    component.with_tab_content { "Content here" }

    assert component.send(:use_slot_api?)
  end

  test "detects legacy API when links provided and no slots" do
    links = [{title: "Tab", href: "/tab"}]
    component = Decor::Tabs.new(links: links)

    refute component.send(:use_slot_api?)
  end

  test "defaults to slot API when no links and no slots provided" do
    component = Decor::Tabs.new

    assert component.send(:use_slot_api?)
  end
end
