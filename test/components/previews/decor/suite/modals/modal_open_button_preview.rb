# @label ModalOpenButton
class ::Decor::Suite::Modals::ModalOpenButtonPreview < ::Lookbook::Preview
  # A button that, when clicked, dispatches a window-scoped open event for the
  # Suite Modal. The detail carries `id`, optional `content_href` (remote body),
  # `initial_content` placeholder, `title` override and `closeOnOverlayClick`.

  # @group Examples
  def default
    render ::Decor::Suite::Modals::ModalOpenButton.new(
      modal_id: "example-modal",
      label: "Open Modal",
      color: :primary
    )
  end

  def with_initial_content
    render ::Decor::Suite::Modals::ModalOpenButton.new(
      modal_id: "content-modal",
      label: "Open Modal",
      initial_content: "<p>This content appears immediately when the modal opens.</p>",
      color: :primary
    )
  end

  def with_remote_content
    render ::Decor::Suite::Modals::ModalOpenButton.new(
      modal_id: "remote-modal",
      label: "Load Remote Content",
      content_href: "/lookbook/preview/decor/suite/button_preview/playground",
      color: :primary
    )
  end

  def with_title_override
    render ::Decor::Suite::Modals::ModalOpenButton.new(
      modal_id: "shared-modal",
      label: "Edit Row 42",
      title: "Edit row 42",
      content_href: "/rows/42/edit",
      style: :outlined,
      color: :primary
    )
  end

  def danger_action
    render ::Decor::Suite::Modals::ModalOpenButton.new(
      modal_id: "delete-modal",
      label: "Delete",
      icon: "x-mark",
      color: :error
    )
  end
  # @endgroup

  # @group Playground
  # @param modal_id text
  # @param label text
  # @param initial_content text
  # @param content_href select [~, "https://www.example.com", "/lookbook/preview/decor/suite/button_preview/playground"]
  # @param title text
  # @param close_on_overlay_click toggle
  # @param icon select [~, check-circle, x-mark, check, download, play, arrow-right]
  # @param style select [filled, outlined, ghost, soft]
  # @param color select [base, primary, neutral, error, warning, success]
  # @param size select [xs, sm, md, lg, xl]
  # @param disabled toggle
  # @param full_width toggle
  def playground(
    modal_id: "example-modal",
    label: "Open Modal",
    initial_content: nil,
    content_href: nil,
    title: nil,
    close_on_overlay_click: false,
    icon: nil,
    style: :filled,
    color: :primary,
    size: :sm,
    disabled: false,
    full_width: false
  )
    render ::Decor::Suite::Modals::ModalOpenButton.new(
      modal_id: modal_id,
      label: label,
      initial_content: initial_content,
      content_href: content_href,
      title: title,
      close_on_overlay_click: close_on_overlay_click,
      icon: icon,
      style: style,
      color: color,
      size: size,
      disabled: disabled,
      full_width: full_width
    )
  end
  # @endgroup

  # @group Sizes
  def size_xs
    render ::Decor::Suite::Modals::ModalOpenButton.new(modal_id: "xs-modal", label: "XS", size: :xs, color: :primary)
  end

  def size_sm
    render ::Decor::Suite::Modals::ModalOpenButton.new(modal_id: "sm-modal", label: "Small", size: :sm, color: :primary)
  end

  def size_md
    render ::Decor::Suite::Modals::ModalOpenButton.new(modal_id: "md-modal", label: "Medium", size: :md, color: :primary)
  end

  def size_lg
    render ::Decor::Suite::Modals::ModalOpenButton.new(modal_id: "lg-modal", label: "Large", size: :lg, color: :primary)
  end

  def size_xl
    render ::Decor::Suite::Modals::ModalOpenButton.new(modal_id: "xl-modal", label: "XL", size: :xl, color: :primary)
  end
  # @endgroup

  # @group States
  def disabled_state
    render ::Decor::Suite::Modals::ModalOpenButton.new(
      modal_id: "disabled-modal",
      label: "Disabled",
      disabled: true,
      color: :primary
    )
  end

  def full_width_state
    render ::Decor::Suite::Modals::ModalOpenButton.new(
      modal_id: "full-width-modal",
      label: "Full Width",
      full_width: true,
      color: :primary
    )
  end
  # @endgroup
end
