# frozen_string_literal: true

require "test_helper"

class ::Decor::Daisy::Modals::InformationTest < ActiveSupport::TestCase
  test "inherits from Components::Modals::Information" do
    assert ::Decor::Daisy::Modals::Information.new(title: "X").is_a?(::Decor::Components::Modals::Information)
  end

  test "does not emit its own stimulus controller" do
    refute ::Decor::Daisy::Modals::Information.stimulus_controller?
  end

  test "renders a Daisy Modal as the outer chrome" do
    html = render_component(::Decor::Daisy::Modals::Information.new(title: "Terms"))
    assert_includes html, "<dialog"
    assert_includes html, "decor--daisy--modals--modal"
    assert_includes html, "decor:d-modal"
  end

  test "renders the footer Close button by default" do
    html = render_component(::Decor::Daisy::Modals::Information.new(title: "Terms"))
    assert_includes html, "Close"
    assert_includes html, "decor--daisy--modals--modal-close-button"
  end

  test "honours a custom close_label" do
    html = render_component(::Decor::Daisy::Modals::Information.new(title: "Terms", close_label: "Got it"))
    assert_includes html, "Got it"
  end

  test "close button uses Daisy ModalCloseButton with outlined chrome at sm size" do
    html = render_component(::Decor::Daisy::Modals::Information.new(title: "Terms"))
    assert_includes html, "decor:d-btn-outline"
    assert_includes html, "decor:d-btn-sm"
  end

  test "footer row sits outside the dialog (Daisy modal has no footer slot)" do
    html = render_component(::Decor::Daisy::Modals::Information.new(title: "Terms"))
    assert_includes html, "decor:flex"
    assert_includes html, "decor:justify-end"
    assert_includes html, "decor:gap-2"
  end

  test "accepts a body block without raising" do
    assert_nothing_raised do
      render_component(::Decor::Daisy::Modals::Information.new(title: "Terms")) do
        "<p>Body content</p>".html_safe
      end
    end
  end

  test "renders body block content inside the dialog body container" do
    info = ::Decor::Daisy::Modals::Information.new(title: "Terms")
    fragment = render_fragment(info) { "<p>info-body-marker</p>".html_safe }

    body = fragment.at_css("div[data-decor--daisy--modals--modal-target='modal']")
    assert_not_nil body
    assert_includes body.inner_html, "info-body-marker"
  end

  test "start_open flows through to the inner Modal as show_initial" do
    html = render_component(::Decor::Daisy::Modals::Information.new(title: "Terms", start_open: true))
    assert_includes html, 'data-decor--daisy--modals--modal-show-initial-value="true"'
  end

  test "renders without a block" do
    assert_nothing_raised do
      render_component(::Decor::Daisy::Modals::Information.new(title: "Terms"))
    end
  end
end
