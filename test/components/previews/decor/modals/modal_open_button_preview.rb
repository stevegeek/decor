# @label ModalOpenButton
class ::Decor::Modals::ModalOpenButtonPreview < ::Lookbook::Preview
  # Modal Open Button
  # -----------------
  #
  # A button that triggers modal open actions. Inherits all button properties
  # (style, color, size) and adds modal-specific functionality like content loading.
  #
  # @group Examples
  # @label Basic Modal Button
  def basic_modal_button
    render ::Decor::Modals::ModalOpenButton.new(
      modal_id: "example-modal",
      label: "Open Modal"
    )
  end

  # @group Examples
  # @label With Initial Content
  def with_initial_content
    render ::Decor::Modals::ModalOpenButton.new(
      modal_id: "content-modal",
      label: "Open Modal",
      initial_content: "<p>This content appears immediately when the modal opens.</p>"
    )
  end

  # @group Examples
  # @label With Remote Content
  def with_remote_content
    render ::Decor::Modals::ModalOpenButton.new(
      modal_id: "remote-modal",
      label: "Load Remote Content",
      content_href: "/lookbook/decor/button_preview/playground",
      color: :primary
    )
  end

  # @group Examples
  # @label Styled Modal Trigger
  def styled_modal_trigger
    render ::Decor::Modals::ModalOpenButton.new(
      modal_id: "styled-modal",
      label: "Delete Item",
      icon: "x",
      color: :error,
      style: :outlined,
      close_on_overlay_click: true
    )
  end

  # @group Playground
  # @param modal_id text
  # @param label text
  # @param initial_content text
  # @param content_href select [~, "https://www.example.com", "/lookbook/decor/button_preview/playground"]
  # @param close_on_overlay_click toggle
  # @param icon select [~, check-circle, x, check, download, play, arrow-right]
  # @param style select [filled, outlined, ghost]
  # @param color select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param size select [xs, sm, md, lg, xl]
  # @param disabled toggle
  # @param full_width toggle
  def playground(
    modal_id: "example-modal",
    label: "Open Modal",
    initial_content: nil,
    content_href: nil,
    close_on_overlay_click: false,
    icon: nil,
    style: :filled,
    color: :primary,
    size: :md,
    disabled: false,
    full_width: false
  )
    render ::Decor::Modals::ModalOpenButton.new(
      modal_id: modal_id,
      label: label,
      initial_content: initial_content,
      content_href: content_href,
      close_on_overlay_click: close_on_overlay_click,
      icon: icon,
      style: style,
      color: color,
      size: size,
      disabled: disabled,
      full_width: full_width
    )
  end

  # @group Modal Properties
  # @label Interactive Modal Demo
  def interactive_modal_demo
    render_with_template(
      locals: {
        modal_id: "demo-modal",
        label: "Open Interactive Modal",
        initial_content: "<h3>Modal Content</h3><p>This modal can be closed by clicking the overlay.</p>",
        content_href: nil,
        close_on_overlay_click: true,
        icon: nil,
        style: :filled,
        color: :primary,
        size: :md,
        disabled: false,
        full_width: false
      }
    )
  end

  # @group Sizes
  # @label Extra Small
  def size_xs
    render ::Decor::Modals::ModalOpenButton.new(
      modal_id: "xs-modal",
      label: "XS Modal",
      size: :xs
    )
  end

  # @group Sizes
  # @label Small
  def size_sm
    render ::Decor::Modals::ModalOpenButton.new(
      modal_id: "sm-modal",
      label: "Small Modal",
      size: :sm
    )
  end

  # @group Sizes
  # @label Medium
  def size_md
    render ::Decor::Modals::ModalOpenButton.new(
      modal_id: "md-modal",
      label: "Medium Modal",
      size: :md
    )
  end

  # @group Sizes
  # @label Large
  def size_lg
    render ::Decor::Modals::ModalOpenButton.new(
      modal_id: "lg-modal",
      label: "Large Modal",
      size: :lg
    )
  end

  # @group Sizes
  # @label Extra Large
  def size_xl
    render ::Decor::Modals::ModalOpenButton.new(
      modal_id: "xl-modal",
      label: "XL Modal",
      size: :xl
    )
  end

  # @group States
  # @label Disabled State
  def disabled_state
    render ::Decor::Modals::ModalOpenButton.new(
      modal_id: "disabled-modal",
      label: "Disabled Modal Button",
      disabled: true
    )
  end

  # @group States
  # @label Full Width
  def full_width_state
    render ::Decor::Modals::ModalOpenButton.new(
      modal_id: "full-width-modal",
      label: "Full Width Modal Button",
      full_width: true
    )
  end
end
