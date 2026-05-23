# frozen_string_literal: true

require "test_helper"

class ::Decor::Daisy::Modals::ModalTriggerTest < ActiveSupport::TestCase
  test "inherits from Components::Modals::ModalTrigger" do
    assert ::Decor::Daisy::Modals::ModalTrigger.new(modal_id: "m1") \
      .is_a?(::Decor::Components::Modals::ModalTrigger)
  end

  test "renders a span wrapper around the block content" do
    html = render_component(::Decor::Daisy::Modals::ModalTrigger.new(modal_id: "m1")) do
      "<a>Open it</a>".html_safe
    end
    assert_includes html, "<span"
    assert_includes html, "<a>Open it</a>"
  end

  test "wrapper exposes role=button and tabindex=0 for keyboard activation" do
    html = render_component(::Decor::Daisy::Modals::ModalTrigger.new(modal_id: "m1")) do
      "<span>x</span>".html_safe
    end
    assert_includes html, 'role="button"'
    assert_includes html, 'tabindex="0"'
  end

  test "applies inline-block and cursor-pointer chrome" do
    html = render_component(::Decor::Daisy::Modals::ModalTrigger.new(modal_id: "m1")) do
      "<span>x</span>".html_safe
    end
    assert_includes html, "decor:inline-block"
    assert_includes html, "decor:cursor-pointer"
  end

  test "wires the stimulus controller and click handler" do
    html = render_component(::Decor::Daisy::Modals::ModalTrigger.new(modal_id: "m1")) do
      "<span>x</span>".html_safe
    end
    assert_includes html, 'data-controller="decor--daisy--modals--modal-trigger"'
    assert_includes html, "click->decor--daisy--modals--modal-trigger#handleClick"
  end

  test "emits modal-id stimulus value" do
    html = render_component(::Decor::Daisy::Modals::ModalTrigger.new(modal_id: "row-42")) do
      "<span>Edit</span>".html_safe
    end
    assert_includes html, 'data-decor--daisy--modals--modal-trigger-modal-id-value="row-42"'
  end

  test "carries content_href and title stimulus values when supplied" do
    html = render_component(::Decor::Daisy::Modals::ModalTrigger.new(
      modal_id: "m1",
      content_href: "/rows/42/edit",
      title: "Edit row 42"
    )) do
      "<span>x</span>".html_safe
    end
    assert_includes html, 'data-decor--daisy--modals--modal-trigger-content-href-value="/rows/42/edit"'
    assert_includes html, 'data-decor--daisy--modals--modal-trigger-title-value="Edit row 42"'
  end

  test "defaults close_on_overlay_click to false" do
    html = render_component(::Decor::Daisy::Modals::ModalTrigger.new(modal_id: "m1")) do
      "<span>x</span>".html_safe
    end
    assert_includes html, 'data-decor--daisy--modals--modal-trigger-close-on-overlay-click-value="false"'
  end

  test "renders an empty wrapper when no block is given" do
    html = render_component(::Decor::Daisy::Modals::ModalTrigger.new(modal_id: "m1"))
    assert_includes html, "<span"
    assert_includes html, 'data-controller="decor--daisy--modals--modal-trigger"'
  end
end
