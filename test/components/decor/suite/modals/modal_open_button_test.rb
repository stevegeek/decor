# frozen_string_literal: true

require "test_helper"

class Decor::Suite::Modals::ModalOpenButtonTest < ActiveSupport::TestCase
  test "renders a button with the label" do
    html = render_component(Decor::Suite::Modals::ModalOpenButton.new(modal_id: "m1", label: "Open"))
    assert_includes html, "<button"
    assert_includes html, "Open"
  end

  test "defaults to type=button" do
    html = render_component(Decor::Suite::Modals::ModalOpenButton.new(modal_id: "m1", label: "Open"))
    assert_includes html, 'type="button"'
  end

  test "emits modal-id stimulus value" do
    html = render_component(Decor::Suite::Modals::ModalOpenButton.new(modal_id: "row-42", label: "Edit"))
    assert_includes html, 'data-decor--suite--modals--modal-open-button-modal-id-value="row-42"'
  end

  test "wires click → handleButtonClick" do
    html = render_component(Decor::Suite::Modals::ModalOpenButton.new(modal_id: "m1", label: "Open"))
    assert_includes html, "click->decor--suite--modals--modal-open-button#handleButtonClick"
  end

  test "carries content_href and title in stimulus values when supplied" do
    html = render_component(Decor::Suite::Modals::ModalOpenButton.new(
      modal_id: "m1",
      label: "Edit",
      content_href: "/rows/42/edit",
      title: "Edit row 42"
    ))
    assert_includes html, 'data-decor--suite--modals--modal-open-button-content-href-value="/rows/42/edit"'
    assert_includes html, 'data-decor--suite--modals--modal-open-button-title-value="Edit row 42"'
  end

  test "applies suite-control radius and duration-suite-fast" do
    html = render_component(Decor::Suite::Modals::ModalOpenButton.new(modal_id: "m1", label: "Open"))
    assert_includes html, "decor:rounded-suite-control"
    assert_includes html, "decor:duration-suite-fast"
  end

  test "primary filled uses suite-primary tokens, not daisyUI semantics" do
    html = render_component(Decor::Suite::Modals::ModalOpenButton.new(
      modal_id: "m1", label: "Open", color: :primary, style: :filled
    ))
    assert_includes html, "decor:bg-suite-primary-500"
    refute_includes html, "d-btn"
  end

  test "outlined primary uses suite-primary-200 border + suite-primary-700 text" do
    html = render_component(Decor::Suite::Modals::ModalOpenButton.new(
      modal_id: "m1", label: "Open", color: :primary, style: :outlined
    ))
    assert_includes html, "decor:border-suite-primary-200"
    assert_includes html, "decor:text-suite-primary-700"
  end

  test "soft danger uses suite-danger-50 surface and -700 text" do
    html = render_component(Decor::Suite::Modals::ModalOpenButton.new(
      modal_id: "m1", label: "Delete", color: :error, style: :soft
    ))
    assert_includes html, "decor:bg-suite-danger-50"
    assert_includes html, "decor:text-suite-danger-700"
    assert_includes html, "decor:border-suite-danger-100"
  end

  test "default base/filled uses hairline-strong border + white surface" do
    html = render_component(Decor::Suite::Modals::ModalOpenButton.new(modal_id: "m1", label: "Open"))
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border-suite-hairline-strong"
  end

  test "disabled adds disabled attribute" do
    html = render_component(Decor::Suite::Modals::ModalOpenButton.new(
      modal_id: "m1", label: "Open", disabled: true
    ))
    assert_includes html, 'disabled="disabled"'
  end

  test "full_width adds w-full modifier" do
    html = render_component(Decor::Suite::Modals::ModalOpenButton.new(
      modal_id: "m1", label: "Open", full_width: true
    ))
    assert_includes html, "decor:w-full"
  end

  test "renders an icon when icon prop set" do
    html = render_component(Decor::Suite::Modals::ModalOpenButton.new(
      modal_id: "m1", label: "Open", icon: "x-mark"
    ))
    assert_includes html, "x-mark"
    assert_includes html, "Open"
  end

  test "default size :sm — applies 12px text and suite-control radius" do
    html = render_component(Decor::Suite::Modals::ModalOpenButton.new(modal_id: "m1", label: "Open"))
    assert_includes html, "decor:text-xs"
    assert_includes html, "decor:rounded-suite-control"
  end

  test "inherits from the Modals::ModalOpenButton abstract base" do
    assert ::Decor::Suite::Modals::ModalOpenButton.new(modal_id: "m1")
      .is_a?(::Decor::Components::Modals::ModalOpenButton)
  end
end
