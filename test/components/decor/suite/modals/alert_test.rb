# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Modals::AlertTest < ActiveSupport::TestCase
  test "renders a <dialog> root (delegated to Suite::Modals::Modal)" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m"))
    assert_includes html, "<dialog"
    assert_includes html, "cf-modal"
  end

  test "renders the title in the modal header" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "Could not save", message: "m"))
    assert_includes html, "Could not save"
    assert_includes html, "decor:suite-section-title"
  end

  test "renders the message in the modal body" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "Please try again."))
    assert_includes html, "Please try again."
    assert_includes html, "cf-modal__body"
  end

  test "renders the dismiss button label in the footer" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m", button_label: "Got it"))
    assert_includes html, "cf-modal__footer"
    assert_includes html, "Got it"
  end

  test "default button label is OK" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m"))
    assert_includes html, "OK"
  end

  test "default variant is :info (renders suite-primary accent bar)" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m"))
    assert_includes html, "decor:bg-suite-primary-500"
  end

  test "danger variant renders suite-danger accent bar" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m", variant: :danger))
    assert_includes html, "decor:bg-suite-danger-500"
  end

  test "warning variant renders suite-warning accent bar" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m", variant: :warning))
    assert_includes html, "decor:bg-suite-warning-500"
  end

  test "success variant renders suite-success accent bar" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m", variant: :success))
    assert_includes html, "decor:bg-suite-success-500"
  end

  test "destructive variant renders the danger header chrome" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "Delete?", message: "m", variant: :destructive))
    assert_includes html, "decor:bg-suite-danger-50"
    assert_includes html, "decor:text-suite-danger-700"
  end

  test "danger variant tints the dismiss button suite-danger" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m", variant: :danger))
    assert_includes html, "decor:bg-suite-danger-500"
  end

  test "warning variant tints the dismiss button with suite-warning chrome" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m", variant: :warning))
    assert_includes html, "decor:bg-suite-warning-50"
    assert_includes html, "decor:text-suite-warning-700"
  end

  test "success variant tints the dismiss button suite-success" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m", variant: :success))
    assert_includes html, "decor:bg-suite-success-500"
  end

  test "info variant tints the dismiss button suite-primary" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m", variant: :info))
    assert_includes html, "decor:bg-suite-primary-500"
  end

  test "neutral variant uses the default (neutral) dismiss button chrome" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m", variant: :neutral))
    assert_includes html, "decor:border-suite-hairline-strong"
  end

  test "passes dismiss_event through as close_reason on the dismiss button" do
    html = render_component(
      ::Decor::Suite::Modals::Alert.new(title: "T", message: "m", dismiss_event: "order-save-failed")
    )
    assert_includes html, "close-reason-value=\"order-save-failed\""
  end

  test "omits close_reason value when no dismiss_event provided" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m"))
    refute_includes html, "close-reason-value="
  end

  test "start_open: true forwards to the wrapped modal" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m", start_open: true))
    assert_includes html, "start-open-value=\"true\""
  end

  test "start_open defaults to false" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m"))
    assert_includes html, "start-open-value=\"false\""
  end

  test "modal is always closeable so the dismiss button can close it" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m"))
    assert_includes html, 'closedby="any"'
  end

  test "renders the dismiss button as a Suite ModalCloseButton with control radius" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m"))
    assert_includes html, "decor:rounded-suite-control"
    assert_includes html, "decor--suite--modals--modal-close-button"
  end

  test "does not wire its own stimulus controller (alert has no_stimulus_controller)" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "m"))
    refute_includes html, 'data-controller="decor--suite--modals--alert"'
  end

  test "inherits from the Components::Modals::Alert abstract base" do
    assert ::Decor::Suite::Modals::Alert.new(title: "T", message: "m").is_a?(::Decor::Components::Modals::Alert)
  end

  test "body uses suite-body typography utility" do
    html = render_component(::Decor::Suite::Modals::Alert.new(title: "T", message: "Hi"))
    assert_includes html, "decor:suite-body"
  end
end
