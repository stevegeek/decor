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

  test "does not emit a daisyUI btn class anywhere" do
    html = render_component(Decor::Suite::Modals::ModalTrigger.new(modal_id: "m1")) do
      "<span>x</span>".html_safe
    end
    refute_includes html, "d-btn"
  end

  test "inherits from the Modals::ModalTrigger abstract base" do
    assert ::Decor::Suite::Modals::ModalTrigger.new(modal_id: "m1") \
      .is_a?(::Decor::Components::Modals::ModalTrigger)
  end
end
