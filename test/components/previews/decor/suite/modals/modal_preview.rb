# @label Modal
class ::Decor::Suite::Modals::ModalPreview < ::Lookbook::Preview
  # Primitive modal wrapping the native <dialog> element. Browser owns the
  # focus-trap, Escape, top-layer, and backdrop. Use ModalOpenButton to
  # trigger opening; clicking outside is opt-in via `close_on_overlay_click`
  # (or via the Baseline `closedby="any"` attribute the component sets when
  # `closeable: true`).

  # @group Examples
  # @label Default (start open)
  def default
    render ::Decor::Suite::Modals::Modal.new(
      id: "suite-modal-default",
      title: "Modal title",
      description: "A short description that sits below the title.",
      start_open: true
    ) do
      plain "Body content goes here."
    end
  end

  # @label Variant: info
  def variant_info
    render ::Decor::Suite::Modals::Modal.new(
      id: "suite-modal-info",
      variant: :info,
      title: "Heads up",
      description: "An informational notice.",
      start_open: true
    ) do
      plain "Body content for the info variant."
    end
  end

  # @label Variant: success
  def variant_success
    render ::Decor::Suite::Modals::Modal.new(
      id: "suite-modal-success",
      variant: :success,
      title: "All done",
      start_open: true
    ) do
      plain "Operation completed successfully."
    end
  end

  # @label Variant: warning
  def variant_warning
    render ::Decor::Suite::Modals::Modal.new(
      id: "suite-modal-warning",
      variant: :warning,
      title: "Are you sure?",
      start_open: true
    ) do
      plain "This will affect downstream consumers."
    end
  end

  # @label Variant: danger
  def variant_danger
    render ::Decor::Suite::Modals::Modal.new(
      id: "suite-modal-danger",
      variant: :danger,
      title: "Something went wrong",
      start_open: true
    ) do
      plain "We could not complete the request."
    end
  end

  # @label Variant: destructive (full red header)
  def variant_destructive
    render ::Decor::Suite::Modals::Modal.new(
      id: "suite-modal-destructive",
      variant: :destructive,
      title: "Delete forever?",
      description: "This cannot be undone.",
      start_open: true
    ) do
      plain "All associated records will also be removed."
    end
  end

  # @label With Remote Content
  def with_remote_content
    render ::Decor::Suite::Modals::Modal.new(
      id: "suite-modal-remote",
      title: "Remote",
      description: "Body is fetched on first open.",
      content_href: "/lookbook/preview/decor/suite/button_preview/playground",
      start_open: true
    )
  end

  # @label Sizes
  def size_narrow
    render ::Decor::Suite::Modals::Modal.new(id: "m-narrow", title: "Narrow", size: :narrow, start_open: true) { plain "360px" }
  end

  def size_default
    render ::Decor::Suite::Modals::Modal.new(id: "m-default", title: "Default", size: :default, start_open: true) { plain "420px" }
  end

  def size_wide
    render ::Decor::Suite::Modals::Modal.new(id: "m-wide", title: "Wide", size: :wide, start_open: true) { plain "560px" }
  end

  def size_extra_wide
    render ::Decor::Suite::Modals::Modal.new(id: "m-xwide", title: "Extra wide", size: :extra_wide, start_open: true) { plain "680px" }
  end

  def size_huge
    render ::Decor::Suite::Modals::Modal.new(id: "m-huge", title: "Huge", size: :huge, start_open: true) { plain "1024px" }
  end
  # @endgroup

  # @group Playground
  # @param title text
  # @param description text
  # @param variant select [neutral, info, success, warning, danger, destructive]
  # @param size select [default, wide, extra_wide, huge, narrow]
  # @param closeable toggle
  # @param show_close_button toggle
  # @param start_open toggle
  # @param content_href select [~, "/lookbook/preview/decor/suite/button_preview/playground"]
  # @param initial_content text
  def playground(
    title: "Modal title",
    description: "A short description.",
    variant: :neutral,
    size: :default,
    closeable: true,
    show_close_button: true,
    start_open: true,
    content_href: nil,
    initial_content: "Body content goes here."
  )
    render ::Decor::Suite::Modals::Modal.new(
      id: "suite-modal-playground",
      title: title,
      description: description,
      variant: variant,
      size: size,
      closeable: closeable,
      show_close_button: show_close_button,
      start_open: start_open,
      content_href: content_href,
      initial_content: initial_content
    )
  end
  # @endgroup
end
