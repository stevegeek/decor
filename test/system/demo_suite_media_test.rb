require "application_system_test_case"

# Proves the dynamic behaviour of the media/misc components in a real browser:
# the Swiper carousel navigates slides, and click-to-copy + the code block's
# copy button write to the clipboard. Clipboard is asserted by spying on
# navigator.clipboard.writeText (reading the real clipboard needs permissions
# the headless browser withholds).
class DemoSuiteMediaTest < ApplicationSystemTestCase
  CTC = "[data-controller~='decor--suite--click-to-copy']"

  def stub_clipboard
    page.execute_script(
      "window.__copied = null;" \
      "navigator.clipboard.writeText = function (t) { window.__copied = t; return Promise.resolve(); };"
    )
  end

  test "carousel navigates between slides" do
    visit demo_suite_media_path
    # Swiper initialises and marks the first slide active.
    assert_selector ".swiper-slide-active", wait: 5
    assert_equal "Slide 1", page.evaluate_script("document.querySelector('.swiper-slide-active img')?.alt")

    find(".swiper-button-next").click
    sleep 0.4
    assert_equal "Slide 2", page.evaluate_script("document.querySelector('.swiper-slide-active img')?.alt"),
      "clicking next should advance the active slide"
  end

  test "click-to-copy writes its value to the clipboard" do
    visit demo_suite_media_path
    stub_clipboard
    within "#standalone-copy" do
      find(CTC).click
    end
    sleep 0.2
    assert_equal "copy-me-123", page.evaluate_script("window.__copied")
  end

  test "code block copy button copies the code" do
    visit demo_suite_media_path
    stub_clipboard
    within "[data-controller~='decor--suite--code-block']" do
      find(CTC).click
    end
    sleep 0.2
    assert_includes page.evaluate_script("window.__copied").to_s, "Hello, decor"
  end
end
