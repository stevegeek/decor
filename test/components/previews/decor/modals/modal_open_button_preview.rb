# @label ModalOpenButton
class ::Decor::Modals::ModalOpenButtonPreview < ::Lookbook::Preview
  # ModalOpenButton
  # -------
  #
  # A button that triggers the modal open action, typically rendered in views
  # as a way to open a modal and provide the url of the content to load.
  #
  # @param modal_id text
  # @param initial_content text
  # @param content_href select [~, "https://www.example.com", "/lookbook/decor/button_preview/playground"]
  # @param close_on_overlay_click toggle
  # @param label text
  # @param icon select [~, check-circle, x, check, download, play]
  # @param disabled toggle
  # @param variant select [contained, outlined, text]
  # @param color select [primary, secondary, danger, warning, neutral]
  # @param size select [medium, large, wide, small, micro, link]
  # @param full_width toggle
  def playground(
    modal_id: "example-modal",
    content_href: nil,
    initial_content: nil,
    close_on_overlay_click: false,
    label: "Open Modal",
    icon: nil,
    variant: :contained,
    color: :primary,
    size: :medium,
    disabled: false,
    full_width: false
  )
    render ::Decor::Modals::ModalOpenButton.new(
      modal_id: modal_id,
      content_href: content_href,
      initial_content: initial_content,
      close_on_overlay_click: close_on_overlay_click,
      label: label,
      icon: icon,
      variant: variant,
      color: color,
      size: size,
      disabled: disabled,
      full_width: full_width
    )
  end

  # @param modal_id text
  # @param initial_content text
  # @param content_href select [~, "https://www.example.com", "/lookbook/preview/decor/modal_close_button_preview/playground"]
  # @param close_on_overlay_click toggle
  # @param label text
  # @param disabled toggle
  # @param variant select [contained, outlined, text]
  # @param color select [primary, secondary, danger, warning, neutral]
  # @param size select [medium, large, wide, small, micro, link]
  # @param full_width toggle
  def opens_modal(
    modal_id: "example-modal",
    content_href: nil,
    initial_content: "Initial content goes here",
    close_on_overlay_click: false,
    label: "Open Modal",
    variant: :contained,
    color: :primary,
    size: :medium,
    disabled: false,
    full_width: false
  )
    render_with_template(
      locals: {
        modal_id: modal_id,
        content_href: content_href,
        initial_content: initial_content,
        close_on_overlay_click: close_on_overlay_click,
        label: label,
        variant: variant,
        color: color,
        size: size,
        disabled: disabled,
        full_width: full_width
      }
    )
  end
end
