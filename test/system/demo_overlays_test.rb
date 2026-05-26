require "application_system_test_case"

# Proves the dynamic behaviour of the overlay components in a real browser:
#   - NotificationManager toasts render + land in the configured viewport corner
#     + stack + dismiss (the Confinus "notifications in the wrong place" concern)
#   - Tooltip popover is hidden until hover, then anchored over its trigger
#     (Floating UI) — the "popovers appear correctly from their targets" concern
class DemoOverlaysTest < ApplicationSystemTestCase
  TOAST = ".decor--suite--notification"
  TIP_CONTENT = "[data-decor--suite--tooltip-target='content']"

  test "toast appears in the top-right corner and stacks" do
    visit demo_overlays_path

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
    visit demo_overlays_path
    find("#notify-success").click
    assert_selector TOAST, wait: 5
    find("#notify-dismiss-all").click
    assert_no_selector TOAST, wait: 5
  end

  test "tooltip is hidden until hover, then anchored over its trigger" do
    visit demo_overlays_path

    hidden_initially = page.evaluate_script(
      "!document.querySelector(\"#{TIP_CONTENT}\").matches(':popover-open')"
    )
    assert hidden_initially, "tooltip content should start closed (not a popover-open)"

    find("#tooltip-trigger").hover
    sleep 0.3 # 80ms show delay + Floating UI positioning

    state = page.evaluate_script(<<~JS)
      (function () {
        var c = document.querySelector("#{TIP_CONTENT}");
        var t = document.getElementById("tooltip-trigger");
        var cr = c.getBoundingClientRect();
        var tr = t.getBoundingClientRect();
        return {
          visible: c.matches(":popover-open"),
          positioned: (parseFloat(c.style.left) || 0) !== 0 || (parseFloat(c.style.top) || 0) !== 0,
          horizontallyOverlapsTrigger: cr.left < tr.right && cr.right > tr.left,
          inViewport: cr.top >= 0 && cr.left >= 0 && cr.right <= window.innerWidth
        };
      })()
    JS
    assert state["visible"], "tooltip should be visible on hover"
    assert state["positioned"], "Floating UI should have set left/top"
    assert state["horizontallyOverlapsTrigger"], "tooltip should sit over its trigger, not adrift"
    assert state["inViewport"], "tooltip should be kept inside the viewport"
  end

  test "flash renders its message" do
    visit demo_overlays_path
    assert_text "Saved successfully."
  end
end
