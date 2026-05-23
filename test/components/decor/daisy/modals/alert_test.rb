# frozen_string_literal: true

require "test_helper"

class ::Decor::Daisy::Modals::AlertTest < ActiveSupport::TestCase
  test "inherits from Components::Modals::Alert" do
    assert ::Decor::Daisy::Modals::Alert.new(title: "T", message: "m").is_a?(::Decor::Components::Modals::Alert)
  end

  test "renders a <dialog> root delegated to Daisy Modals::Modal" do
    html = render_component(::Decor::Daisy::Modals::Alert.new(title: "T", message: "m"))
    assert_includes html, "<dialog"
    assert_includes html, "decor--daisy--modals--modal"
    assert_includes html, "decor:d-modal"
  end

  test "renders the message in the modal body" do
    html = render_component(::Decor::Daisy::Modals::Alert.new(title: "T", message: "Please try again."))
    assert_includes html, "Please try again."
    assert_includes html, "decor:d-modal-box"
  end

  test "default button label is OK" do
    html = render_component(::Decor::Daisy::Modals::Alert.new(title: "T", message: "m"))
    assert_includes html, "OK"
  end

  test "renders a custom dismiss button label" do
    html = render_component(::Decor::Daisy::Modals::Alert.new(title: "T", message: "m", button_label: "Got it"))
    assert_includes html, "Got it"
  end

  test "renders a Daisy ModalCloseButton at sm size" do
    html = render_component(::Decor::Daisy::Modals::Alert.new(title: "T", message: "m"))
    assert_includes html, "decor--daisy--modals--modal-close-button"
    assert_includes html, "decor:d-btn-sm"
  end

  test "passes dismiss_event through as close_reason on the dismiss button" do
    html = render_component(
      ::Decor::Daisy::Modals::Alert.new(title: "T", message: "m", dismiss_event: "order-save-failed")
    )
    assert_includes html, "close-reason-value=\"order-save-failed\""
  end

  test "omits close_reason value when no dismiss_event provided" do
    html = render_component(::Decor::Daisy::Modals::Alert.new(title: "T", message: "m"))
    refute_includes html, "close-reason-value="
  end

  test "start_open: true forwards to the wrapped modal" do
    html = render_component(::Decor::Daisy::Modals::Alert.new(title: "T", message: "m", start_open: true))
    assert_includes html, 'data-decor--daisy--modals--modal-start-open-value="true"'
  end

  test "start_open defaults to false" do
    html = render_component(::Decor::Daisy::Modals::Alert.new(title: "T", message: "m"))
    assert_includes html, 'data-decor--daisy--modals--modal-start-open-value="false"'
  end

  test "modal is closeable so the dismiss button can close it" do
    html = render_component(::Decor::Daisy::Modals::Alert.new(title: "T", message: "m"))
    assert_includes html, 'data-decor--daisy--modals--modal-closeable-value="true"'
  end

  test "does not wire its own stimulus controller (alert has no_stimulus_controller)" do
    html = render_component(::Decor::Daisy::Modals::Alert.new(title: "T", message: "m"))
    refute_includes html, 'data-controller="decor--daisy--modals--alert"'
  end
end
