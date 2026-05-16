# @label Form
class ::Decor::Suite::Modals::FormPreview < ::Lookbook::Preview
  # A Suite Modal pre-wired with a form body + Cancel/Submit footer for the
  # canonical "edit X" dialog pattern. The caller supplies the <form> body
  # (inline block or lazily via `content_href:`) — the modal owns the
  # footer buttons. The Submit button targets the inner form via the HTML5
  # `form="..."` attribute (the inner <form> must carry `id: modal.form_id`).

  # @group Examples
  # @label Default
  def default
    render ::Decor::Suite::Modals::Form.new(
      title: "Edit item",
      start_open: true
    )
  end

  # @label With description
  def with_description
    render ::Decor::Suite::Modals::Form.new(
      title: "Edit catalog",
      description: "Update the name and visibility for this catalog.",
      start_open: true
    )
  end

  # @label Destructive (delete)
  def destructive
    render ::Decor::Suite::Modals::Form.new(
      title: "Delete account",
      description: "This action cannot be undone.",
      variant: :destructive,
      submit_label: "Delete",
      submit_color: :error,
      start_open: true
    )
  end

  # @label Warning variant
  def warning
    render ::Decor::Suite::Modals::Form.new(
      title: "Restore from backup",
      description: "Existing data will be overwritten.",
      variant: :warning,
      submit_label: "Restore",
      submit_color: :warning,
      start_open: true
    )
  end

  # @label Wide size
  def wide
    render ::Decor::Suite::Modals::Form.new(
      title: "Edit product details",
      size: :wide,
      start_open: true
    )
  end

  # @label Lazy-loaded body
  def lazy_loaded
    render ::Decor::Suite::Modals::Form.new(
      title: "Edit row",
      content_href: "/lookbook/preview/decor/suite/button_preview/playground",
      start_open: false
    )
  end
  # @endgroup

  # @group Playground
  # @param title text
  # @param description text
  # @param variant [Symbol] select [neutral, info, success, warning, danger, destructive]
  # @param size [Symbol] select [default, wide, extra_wide, huge, narrow]
  # @param submit_label text
  # @param submit_color [Symbol] select [primary, error, warning]
  # @param cancel_label text
  # @param start_open toggle
  def playground(
    title: "Edit item",
    description: nil,
    variant: :neutral,
    size: :default,
    submit_label: "Save",
    submit_color: :primary,
    cancel_label: "Cancel",
    start_open: true
  )
    render ::Decor::Suite::Modals::Form.new(
      title: title,
      description: description,
      variant: variant,
      size: size,
      submit_label: submit_label,
      submit_color: submit_color,
      cancel_label: cancel_label,
      start_open: start_open
    )
  end
  # @endgroup
end
