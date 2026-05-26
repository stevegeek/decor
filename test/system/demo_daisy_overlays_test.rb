require "application_system_test_case"

# Proves the dynamic behaviour of the Daisy-skin overlay components in a real
# browser. The Daisy skin diverges from Suite in several ways the assertions
# below pin down:
#   - NotificationManager: daisyUI <toast>, hardcoded top-right (no position
#     prop), innerHTML-driven content (no <template>/slots) -> toasts must
#     render, stack and dismiss.
#   - Tooltip: pure CSS :hover (data-tip + ::after), NOT a JS popover -> assert
#     the tip text rides on data-tip and is revealed (not :popover-open).
#   - Dropdown: daisyUI CSS anchoring (.decor:d-dropdown positions
#     .decor:d-dropdown-content under the trigger), NOT a native popover.
#     QUIRK: the Daisy dropdown's Stimulus targets render as a bare
#     `stimulus-target="menu|button"` attribute instead of
#     `data-decor--daisy--dropdown-target=...`, so the JS controller never wires
#     menuTarget/buttonTarget and its decor:hidden toggle is a no-op. Open/close
#     is therefore driven purely by daisyUI's :focus-within opacity CSS, which is
#     what this test asserts.
#   - Flash: renders its message.
class DemoDaisyOverlaysTest < ApplicationSystemTestCase
  TOAST = ".decor--daisy--notification-manager-notification"

  test "toast appears in the top-right daisyUI toast corner and stacks" do
    visit demo_daisy_overlays_path

    find("#notify-success").click
    assert_selector TOAST, text: /Saved/, wait: 5

    pos = page.evaluate_script(<<~JS)
      (function () {
        var n = document.querySelector("#{TOAST}");
        var r = n.getBoundingClientRect();
        return { fromRight: window.innerWidth - r.right, top: r.top, width: r.width };
      })()
    JS
    assert_operator pos["top"], :<, 80, "toast should hug the top (top=#{pos["top"]})"
    assert_operator pos["fromRight"], :<, 80, "toast should hug the right (fromRight=#{pos["fromRight"]})"
    assert_operator pos["width"], :>, 0, "toast should have a rendered width"

    find("#notify-error").click
    assert_selector TOAST, count: 2, wait: 5
  end

  test "notifications dismiss on demand" do
    visit demo_daisy_overlays_path
    find("#notify-success").click
    assert_selector TOAST, wait: 5
    find("#notify-dismiss-all").click
    assert_no_selector TOAST, wait: 5
  end

  test "tooltip is CSS :hover positioned via data-tip (no JS popover)" do
    visit demo_daisy_overlays_path

    tip = find("#demo-tooltip")

    # daisyUI keeps the tip text in data-tip and renders it through a CSS
    # pseudo-element; there is no separate popover element to open.
    assert_equal "I'm a CSS-positioned daisyUI tip", tip["data-tip"]
    assert tip[:class].include?("decor:d-tooltip"), "should carry the daisyUI tooltip class"

    # No JS popover anywhere on the page (this is the Suite-vs-Daisy difference).
    has_popover = page.evaluate_script(
      "Array.prototype.some.call(document.querySelectorAll('[popover]'), function (e) { return e.matches(':popover-open'); })"
    )
    refute has_popover, "Daisy tooltip must not use a JS :popover-open element"

    # daisyUI renders the tip TEXT through the ::before pseudo-element
    # (content: attr(data-tip)); ::after is just the arrow. The tip is
    # opacity:0 until the .d-tooltip element is :hover'd.
    before_hover = page.evaluate_script(<<~JS)
      (function () {
        var b = window.getComputedStyle(document.getElementById("demo-tooltip"), "::before");
        return { content: b.content, opacity: parseFloat(b.opacity) };
      })()
    JS
    assert_includes before_hover["content"].to_s, "CSS-positioned",
      "daisyUI ::before should carry the data-tip text (got #{before_hover["content"].inspect})"
    assert_equal 0.0, before_hover["opacity"], "tip should be hidden (opacity 0) before hover"

    # Hovering the trigger bubbles :hover to the .d-tooltip ancestor, fading the
    # tip in (opacity -> 1). This is the Suite-vs-Daisy difference: pure CSS, no
    # Floating UI / popover.
    find("#tooltip-trigger").hover
    sleep 0.4

    state = page.evaluate_script(<<~JS)
      (function () {
        var el = document.getElementById("demo-tooltip");
        var before = window.getComputedStyle(el, "::before");
        var tr = document.getElementById("tooltip-trigger").getBoundingClientRect();
        return {
          tipOpacity: parseFloat(before.opacity),
          triggerVisible: tr.width > 0 && tr.height > 0,
          inViewport: tr.top >= 0 && tr.left >= 0 && tr.right <= window.innerWidth
        };
      })()
    JS
    assert state["triggerVisible"], "tooltip trigger should be rendered"
    assert state["inViewport"], "tooltip trigger should be inside the viewport"
    assert_operator state["tipOpacity"], :>, 0,
      "daisyUI tip ::before should fade in (opacity>0) on hover"
  end

  test "dropdown opens/closes and the menu is anchored to its trigger" do
    visit demo_daisy_overlays_path

    container = find("#demo-dropdown")
    trigger = container.find("button", match: :first)

    # daisyUI hides the .d-dropdown-content via opacity:0 until the dropdown is
    # focused (CSS :focus-within), then fades it in to opacity:1. NOTE: in this
    # skin the visibility is driven purely by that CSS — see the Daisy bug noted
    # in the test header about the JS controller's targets not being wired.
    opacity = ->(state = nil) do
      page.evaluate_script(<<~JS)
        (function () {
          var m = document.querySelector("#demo-dropdown ul.decor\\\\:d-dropdown-content");
          return parseFloat(window.getComputedStyle(m).opacity);
        })()
      JS
    end

    assert_equal 0.0, opacity.call, "menu should start hidden (opacity 0)"

    trigger.click
    sleep 0.4

    assert_operator opacity.call, :>, 0, "menu should be visible (opacity>0) after opening"

    anchored = page.evaluate_script(<<~JS)
      (function () {
        var c = document.querySelector("#demo-dropdown");
        var m = c.querySelector("ul.decor\\\\:d-dropdown-content");
        var b = c.querySelector("button");
        var cr = c.getBoundingClientRect();
        var mr = m.getBoundingClientRect();
        var br = b.getBoundingClientRect();
        return {
          menuRendered: mr.width > 0 && mr.height > 0,
          horizontallyAnchored: mr.left < br.right && mr.right > br.left,
          // daisyUI anchor-positions the menu just below the trigger button.
          near: Math.abs(mr.top - br.bottom) < 40,
          insideContainerBox: mr.left >= cr.left - 1 && mr.left <= cr.right + 1,
          inViewport: mr.left >= 0 && mr.right <= window.innerWidth
        };
      })()
    JS
    assert anchored["menuRendered"], "menu should have a rendered box after opening"
    assert anchored["horizontallyAnchored"], "menu should be anchored to its trigger, not adrift"
    assert anchored["near"], "menu should sit just below its trigger"
    assert anchored["insideContainerBox"], "menu should be positioned within its dropdown container"
    assert anchored["inViewport"], "menu should stay inside the viewport"

    # The populated menu items should be present (instance-based menu_item slot).
    assert_selector "#demo-dropdown a", text: "Edit", visible: :all
    assert_selector "#demo-dropdown a", text: "Delete", visible: :all

    # Clicking outside removes focus, fading the menu back out.
    find("body").click
    sleep 0.4
    assert_equal 0.0, opacity.call, "menu should close (opacity 0) when focus leaves"
  end

  test "flash renders its message" do
    visit demo_daisy_overlays_path
    assert_text "Saved successfully."
  end
end
