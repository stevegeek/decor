# frozen_string_literal: true

require "test_helper"

class Decor::Suite::Modals::ModalCloseButtonTest < ActiveSupport::TestCase
  test "renders a button element with the Suite stimulus identifier" do
    rendered = render_component(::Decor::Suite::Modals::ModalCloseButton.new(label: "OK"))

    assert_includes rendered, "<button"
    assert_includes rendered, "decor--suite--modals--modal-close-button"
  end

  test "wires the click action to handleButtonClick on the Suite controller" do
    rendered = render_component(::Decor::Suite::Modals::ModalCloseButton.new(label: "OK"))

    assert_includes rendered, "click->decor--suite--modals--modal-close-button#handleButtonClick"
  end

  test "default neutral chrome uses suite hairline border + control radius + suite-fast motion" do
    rendered = render_component(::Decor::Suite::Modals::ModalCloseButton.new(label: "Close"))

    assert_includes rendered, "decor:border-suite-hairline-strong"
    assert_includes rendered, "decor:rounded-suite-control"
    assert_includes rendered, "decor:duration-suite-fast"
  end

  test "primary color uses suite-primary-500 fill" do
    rendered = render_component(::Decor::Suite::Modals::ModalCloseButton.new(label: "OK", color: :primary))

    assert_includes rendered, "decor:bg-suite-primary-500"
    assert_includes rendered, "decor:hover:bg-suite-primary-700"
  end

  test "danger color uses suite-danger-500 fill" do
    rendered = render_component(::Decor::Suite::Modals::ModalCloseButton.new(label: "Delete", color: :error))

    assert_includes rendered, "decor:bg-suite-danger-500"
  end

  test "outlined danger uses suite-danger-100 border + suite-danger-700 text" do
    rendered = render_component(
      ::Decor::Suite::Modals::ModalCloseButton.new(label: "Delete", color: :error, style: :outlined)
    )

    assert_includes rendered, "decor:border-suite-danger-100"
    assert_includes rendered, "decor:text-suite-danger-700"
  end

  test "ghost primary uses transparent surface and suite-primary-700 text" do
    rendered = render_component(
      ::Decor::Suite::Modals::ModalCloseButton.new(label: "Close", color: :primary, style: :ghost)
    )

    assert_includes rendered, "decor:bg-transparent"
    assert_includes rendered, "decor:text-suite-primary-700"
  end

  test "carries close_reason as a Stimulus value" do
    rendered = render_component(
      ::Decor::Suite::Modals::ModalCloseButton.new(label: "Cancel", close_reason: "cancel")
    )

    assert_includes rendered, "close-reason-value=\"cancel\""
  end

  test "omits close_reason value when not provided" do
    rendered = render_component(::Decor::Suite::Modals::ModalCloseButton.new(label: "Close"))

    refute_includes rendered, "close-reason-value="
  end

  test "renders provided label" do
    rendered = render_component(::Decor::Suite::Modals::ModalCloseButton.new(label: "Dismiss"))

    assert_includes rendered, "Dismiss"
  end

  test "renders block content over label" do
    rendered = render_component(::Decor::Suite::Modals::ModalCloseButton.new(label: "label")) { "block" }

    assert_includes rendered, "block"
    refute_includes rendered, ">label<"
  end

  test "renders default x-mark icon when no label and no icon provided" do
    rendered = render_component(::Decor::Suite::Modals::ModalCloseButton.new)

    assert_includes rendered, "x-mark"
  end

  test "renders provided icon ahead of label" do
    rendered = render_component(::Decor::Suite::Modals::ModalCloseButton.new(label: "Save", icon: "check"))

    assert_includes rendered, "check"
    assert_includes rendered, "Save"
  end

  test "disabled state renders disabled attribute" do
    rendered = render_component(::Decor::Suite::Modals::ModalCloseButton.new(label: "OK", disabled: true))

    assert_includes rendered, "disabled"
  end

  test "full_width adds w-full justify-center modifiers" do
    rendered = render_component(::Decor::Suite::Modals::ModalCloseButton.new(label: "OK", full_width: true))

    assert_includes rendered, "decor:w-full"
    assert_includes rendered, "decor:justify-center"
  end

  test "renders as button type to avoid implicit form submission" do
    rendered = render_component(::Decor::Suite::Modals::ModalCloseButton.new(label: "OK"))

    assert_includes rendered, "type=\"button\""
  end

  test "inherits prop API from Components::Modals::ModalCloseButton" do
    assert ::Decor::Suite::Modals::ModalCloseButton.new.is_a?(::Decor::Components::Modals::ModalCloseButton)
  end
end
