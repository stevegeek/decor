require "application_system_test_case"

# Proves the dynamic behaviour of the Daisy media/misc components in a real
# browser. The Daisy Carousel is the native daisyUI CSS carousel (no Swiper /
# Stimulus): slides are anchor targets (#slide1..) and the pagination buttons
# are in-page `<a href="#slideN">` links, so navigating scrolls the snap
# container. Click-to-copy and the code block's copy button write to the
# clipboard. Clipboard is asserted by spying on navigator.clipboard.writeText
# (reading the real clipboard needs permissions the headless browser withholds).
class DemoDaisyMediaTest < ApplicationSystemTestCase
  CTC = "[data-controller~='decor--daisy--click-to-copy']"
  # The scroll-snap container is the parent of the slide items. Reaching it via
  # `#slide1.parentElement` dodges the daisyUI `decor:d-carousel` class, whose
  # literal colon is awkward to escape through a JS-string selector.
  CAROUSEL_SCROLL_LEFT = "document.querySelector('#slide1').parentElement.scrollLeft"

  def stub_clipboard
    page.execute_script(
      "window.__copied = null;" \
      "navigator.clipboard.writeText = function (t) { window.__copied = t; return Promise.resolve(); };"
    )
  end

  test "carousel navigates between slides via the pagination links" do
    visit demo_daisy_media_path
    # The daisyUI carousel renders one item per slide, each an anchor target.
    assert_selector "#slide1", wait: 5
    assert_selector "#slide2"
    assert_selector "#slide3"

    # The carousel starts scrolled to the first slide.
    start_scroll = page.evaluate_script(CAROUSEL_SCROLL_LEFT)
    assert_equal 0, start_scroll.to_i, "carousel should start at the first slide"

    # The pagination links are in-page anchors to each slide.
    within "#daisy-carousel" do
      find("a[href='#slide2']").click
    end

    # Clicking the anchor scrolls the snap container towards the second slide.
    wait_until_scrolled(more_than: start_scroll.to_i)
    after_scroll = page.evaluate_script(CAROUSEL_SCROLL_LEFT)
    assert after_scroll.to_i > start_scroll.to_i,
      "clicking the slide-2 link should scroll the carousel forward (was #{start_scroll}, now #{after_scroll})"
  end

  test "click-to-copy writes its value to the clipboard" do
    visit demo_daisy_media_path
    stub_clipboard
    within "#standalone-copy" do
      find(CTC).click
    end
    sleep 0.2
    assert_equal "copy-me-123", page.evaluate_script("window.__copied")
  end

  test "code block copy button copies the code" do
    visit demo_daisy_media_path
    stub_clipboard
    within "#code-block" do
      find(CTC).click
    end
    sleep 0.2
    assert_includes page.evaluate_script("window.__copied").to_s, "Hello, decor"
  end

  private

  def wait_until_scrolled(more_than:, timeout: 3)
    deadline = Time.now + timeout
    loop do
      current = page.evaluate_script(CAROUSEL_SCROLL_LEFT).to_i
      return if current > more_than
      break if Time.now > deadline
      sleep 0.1
    end
  end
end
