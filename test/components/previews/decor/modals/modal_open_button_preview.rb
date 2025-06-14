# @label ModalOpenButton
class ::Decor::ModalOpenButtonPreview < ::Lookbook::Preview
  # ModalOpenButton
  # -------
  #
  # A button that triggers the modal open action, typically rendered in views
  # as a way to open a modal and provide the url of the content to load.
  #
  # @param initial_content text
  # @param content_href select [~, "https://www.example.com", "/lookbook/decor/button_preview/playground"]
  # @param close_on_overlay_click toggle
  # @param label text
  # @param icon select [~, check-circle, x, check, download, play]
  # @param disabled toggle
  # @param variant select [contained, outlined, text]
  # @param theme select [primary, secondary, inverse]
  # @param element_tag select [button, a]
  # @param size select [medium, large, wide, small, micro, link]
  # @param full_width toggle
  def playground(
    content_href: nil,
    initial_content: nil,
    close_on_overlay_click: false,
    label: "Open Modal",
    icon: nil,
    variant: :contained,
    theme: :primary,
    size: :medium,
    element_tag: :button,
    disabled: false,
    full_width: false
  )
    render ::Decor::ModalOpenButton.new(
      content_href: content_href,
      initial_content: initial_content,
      close_on_overlay_click: close_on_overlay_click,
      label: label,
      icon: icon,
      variant: variant,
      theme: theme,
      size: size,
      element_tag: element_tag,
      disabled: disabled,
      full_width: full_width
    )
  end

  # @param initial_content text
  # @param content_href select [~, "https://www.example.com", "/lookbook/preview/decor/modal_close_button_preview/playground"]
  # @param close_on_overlay_click toggle
  # @param label text
  # @param disabled toggle
  # @param variant select [contained, outlined, text]
  # @param theme select [primary, secondary, inverse]
  # @param element_tag select [button, a]
  # @param size select [medium, large, wide, small, micro, link]
  # @param full_width toggle
  def opens_modal(
    content_href: nil,
    initial_content: "Initial content goes here",
    close_on_overlay_click: false,
    label: "Open Modal",
    variant: :contained,
    theme: :primary,
    size: :medium,
    element_tag: :button,
    disabled: false,
    full_width: false
  )
    render_with_template(
      locals: {
        content_href: content_href,
        initial_content: initial_content,
        close_on_overlay_click: close_on_overlay_click,
        label: label,
        variant: variant,
        theme: theme,
        size: size,
        element_tag: element_tag,
        disabled: disabled,
        full_width: full_width
      }
    )
  end
end
