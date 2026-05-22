# frozen_string_literal: true

require "test_helper"

class Decor::Suite::Modals::ModalTriggerTest < ActiveSupport::TestCase
  test "renders a span wrapper around the block content" do
    html = render_component(Decor::Suite::Modals::ModalTrigger.new(modal_id: "m1")) do
      "<a>Open it</a>".html_safe
    end
    assert_includes html, "<span"
    assert_includes html, "<a>Open it</a>"
  end

  test "wrapper exposes role=button and tabindex=0 for keyboard activation" do
    html = render_component(Decor::Suite::Modals::ModalTrigger.new(modal_id: "m1")) do
      "<span>x</span>".html_safe
    end
    assert_includes html, 'role="button"'
    assert_includes html, 'tabindex="0"'
  end

  test "emits modal-id stimulus value" do
    html = render_component(Decor::Suite::Modals::ModalTrigger.new(modal_id: "row-42")) do
      "<span>Edit</span>".html_safe
    end
    assert_includes html, 'data-decor--suite--modals--modal-trigger-modal-id-value="row-42"'
  end

  test "wires click → handleClick" do
    html = render_component(Decor::Suite::Modals::ModalTrigger.new(modal_id: "m1")) do
      "<span>x</span>".html_safe
    end
    assert_includes html, "click->decor--suite--modals--modal-trigger#handleClick"
  end

  test "carries content_href and title in stimulus values when supplied" do
    html = render_component(Decor::Suite::Modals::ModalTrigger.new(
      modal_id: "m1",
      content_href: "/rows/42/edit",
      title: "Edit row 42"
    )) do
      "<span>x</span>".html_safe
    end
    assert_includes html, 'data-decor--suite--modals--modal-trigger-content-href-value="/rows/42/edit"'
    assert_includes html, 'data-decor--suite--modals--modal-trigger-title-value="Edit row 42"'
  end

  test "applies suite-control radius and duration-suite-fast" do
    html = render_component(Decor::Suite::Modals::ModalTrigger.new(modal_id: "m1")) do
      "<span>x</span>".html_safe
    end
    assert_includes html, "decor:rounded-suite-control"
    assert_includes html, "decor:duration-suite-fast"
  end

  test "renders as inline-block + cursor-pointer (no padding / background)" do
    html = render_component(Decor::Suite::Modals::ModalTrigger.new(modal_id: "m1")) do
      "<span>x</span>".html_safe
    end
    assert_includes html, "decor:inline-block"
    assert_includes html, "decor:cursor-pointer"
    refute_includes html, "decor:bg-suite-primary-500"
    refute_includes html, "decor:bg-white"
    refute_includes html, "decor:px-"
  end

  test "uses suite-primary focus ring, not daisyUI semantics" do
    html = render_component(Decor::Suite::Modals::ModalTrigger.new(modal_id: "m1")) do
      "<span>x</span>".html_safe
    end
    assert_includes html, "var(--color-suite-primary-100)"
    refute_includes html, "decor:ring-info"
  end

  test "inherits from the Modals::ModalTrigger abstract base" do
    assert ::Decor::Suite::Modals::ModalTrigger.new(modal_id: "m1") \
      .is_a?(::Decor::Components::Modals::ModalTrigger)
  end

  test "bundled mode renders both a button trigger and a dialog when modal_title is set" do
    html = render_component(Decor::Suite::Modals::ModalTrigger.new(
      label: "Open",
      modal_title: "My Modal"
    ))
    assert_includes html, "<button"
    assert_includes html, "<dialog"
    assert_includes html, "My Modal"
  end

  test "bundled mode wires the button's modal_id stimulus value to the sibling dialog id" do
    html = render_component(Decor::Suite::Modals::ModalTrigger.new(
      label: "Open",
      modal_title: "Wired"
    ))
    dialog_id = html.scan(/id="(decor--suite--modals--modal-[a-f0-9]+)"/).flatten.first
    assert dialog_id, "dialog must have an id: #{html}"
    assert_includes html, %(data-decor--suite--modals--modal-open-button-modal-id-value="#{dialog_id}")
  end

  test "bundled mode renders the body block inside the dialog" do
    html = render_component(Decor::Suite::Modals::ModalTrigger.new(
      label: "Open",
      modal_title: "Details"
    )) do
      "<p>Bundled body</p>".html_safe
    end
    assert_includes html, "<dialog"
    assert_includes html, "Bundled body"
  end

  test "bundled mode forwards color/style/size/icon to the trigger button" do
    html = render_component(Decor::Suite::Modals::ModalTrigger.new(
      label: "Delete",
      color: :error,
      style: :outlined,
      modal_title: "Confirm"
    ))
    assert_includes html, "<button"
    assert_includes html, "Delete"
    assert_includes html, "decor:border-suite-danger-100"
  end

  test "bundled mode also fires when only modal_content_href is set (lazy modal)" do
    html = render_component(Decor::Suite::Modals::ModalTrigger.new(
      label: "View",
      modal_content_href: "/rows/1"
    ))
    assert_includes html, "<button"
    assert_includes html, "<dialog"
  end

  test "bundled mode forwards size: :link to the trigger button" do
    html = render_component(Decor::Suite::Modals::ModalTrigger.new(
      icon: "shopping-cart",
      size: :link,
      modal_title: "Sign in"
    ))
    assert_includes html, "decor:underline"
  end

  test "bundled mode forwards button_classes to the trigger button" do
    html = render_component(Decor::Suite::Modals::ModalTrigger.new(
      label: "Add",
      button_classes: "ml-6 hidden md:block",
      modal_title: "Modal"
    ))
    assert_includes html, "ml-6"
    assert_includes html, "hidden"
  end
end
