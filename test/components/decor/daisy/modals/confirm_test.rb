# frozen_string_literal: true

require "test_helper"

class ::Decor::Daisy::Modals::ConfirmTest < ActiveSupport::TestCase
  test "inherits from Components::Modals::Confirm" do
    assert ::Decor::Daisy::Modals::Confirm.new(title: "T", message: "M").is_a?(::Decor::Components::Modals::Confirm)
  end

  test "does not emit its own stimulus controller" do
    refute ::Decor::Daisy::Modals::Confirm.stimulus_controller?
  end

  test "renders a Daisy Modal as the outer chrome" do
    html = render_component(::Decor::Daisy::Modals::Confirm.new(title: "T", message: "M"))
    assert_includes html, "<dialog"
    assert_includes html, "decor--daisy--modals--modal"
    assert_includes html, "decor:d-modal"
  end

  test "renders the message in the modal body" do
    html = render_component(::Decor::Daisy::Modals::Confirm.new(title: "T", message: "This cannot be undone."))
    assert_includes html, "This cannot be undone."
    assert_includes html, "decor:d-modal-box"
  end

  test "renders Cancel and Confirm buttons by default" do
    html = render_component(::Decor::Daisy::Modals::Confirm.new(title: "T", message: "M"))
    assert_includes html, "Cancel"
    assert_includes html, "Confirm"
  end

  test "honours custom labels" do
    html = render_component(
      ::Decor::Daisy::Modals::Confirm.new(title: "Send?", message: "Now", confirm_label: "Send", cancel_label: "Wait")
    )
    assert_includes html, "Send"
    assert_includes html, "Wait"
  end

  test "cancel button uses Daisy ModalCloseButton at sm size with outlined chrome" do
    html = render_component(::Decor::Daisy::Modals::Confirm.new(title: "T", message: "M"))
    assert_includes html, "decor--daisy--modals--modal-close-button"
    assert_includes html, "decor:d-btn-outline"
    assert_includes html, "decor:d-btn-sm"
  end

  test "confirm button uses Daisy Button with d-btn-primary by default" do
    html = render_component(::Decor::Daisy::Modals::Confirm.new(title: "T", message: "M"))
    assert_includes html, "decor--daisy--button"
    assert_includes html, "decor:d-btn-primary"
  end

  test "destructive variant renders the confirm button with d-btn-error" do
    html = render_component(
      ::Decor::Daisy::Modals::Confirm.new(title: "Delete?", message: "M", variant: :destructive, confirm_label: "Delete")
    )
    assert_includes html, "decor:d-btn-error"
    refute_includes html, "decor:d-btn-primary"
  end

  test "wires the confirm controller and click action onto the confirm button" do
    html = render_component(::Decor::Daisy::Modals::Confirm.new(title: "T", message: "M"))
    assert_includes html, 'data-controller="decor--daisy--modals--confirm"'
    assert_includes html, "click->decor--daisy--modals--confirm#confirm"
  end

  test "confirm button carries the modal-id stimulus value pointing back at the wrapping modal id" do
    c = ::Decor::Daisy::Modals::Confirm.new(title: "T", message: "M")
    html = render_component(c)
    assert_includes html, %(data-decor--daisy--modals--confirm-modal-id-value="#{c.id}")
  end

  test "emits the confirm-event stimulus value attribute when confirm_event is set" do
    html = render_component(
      ::Decor::Daisy::Modals::Confirm.new(title: "T", message: "M", confirm_event: "delete-order")
    )
    assert_includes html, %(data-decor--daisy--modals--confirm-confirm-event-value="delete-order")
  end

  test "omits the confirm-event stimulus value when confirm_event is not set" do
    html = render_component(::Decor::Daisy::Modals::Confirm.new(title: "T", message: "M"))
    refute_includes html, "confirm-event-value="
  end

  test "start_open flows through to the inner Modal" do
    html = render_component(::Decor::Daisy::Modals::Confirm.new(title: "T", message: "M", start_open: true))
    assert_includes html, 'data-decor--daisy--modals--modal-show-initial-value="true"'
  end
end
