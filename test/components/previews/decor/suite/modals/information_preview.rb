# @label Information
class ::Decor::Suite::Modals::InformationPreview < ::Lookbook::Preview
  # A Suite Modal pre-wired with a single Close button in the footer for the
  # canonical "read-only details" dialog pattern (terms of service, help text,
  # informational panels). The caller supplies the body content as the block
  # body.

  # @group Examples
  # @label Default
  def default
    render ::Decor::Suite::Modals::Information.new(
      title: "Terms of Service",
      start_open: true
    ) do
      "<p>Body content here.</p>".html_safe
    end
  end

  # @label With description
  def with_description
    render ::Decor::Suite::Modals::Information.new(
      title: "Privacy Policy",
      description: "Last updated 1 January 2026.",
      start_open: true
    ) do
      "<p>We respect your privacy.</p>".html_safe
    end
  end

  # @label Info variant
  def info_variant
    render ::Decor::Suite::Modals::Information.new(
      title: "Heads up",
      description: "Here's something you should know.",
      variant: :info,
      start_open: true
    ) do
      "<p>Detailed information about the topic.</p>".html_safe
    end
  end

  # @label Warning variant
  def warning_variant
    render ::Decor::Suite::Modals::Information.new(
      title: "Be careful",
      description: "Read this before proceeding.",
      variant: :warning,
      start_open: true
    ) do
      "<p>Warning details here.</p>".html_safe
    end
  end

  # @label Wide size
  def wide
    render ::Decor::Suite::Modals::Information.new(
      title: "Documentation",
      size: :wide,
      start_open: true
    ) do
      "<p>A longer block of explanatory text.</p>".html_safe
    end
  end

  # @label Custom close label
  def custom_close_label
    render ::Decor::Suite::Modals::Information.new(
      title: "Welcome",
      close_label: "Got it",
      start_open: true
    ) do
      "<p>Thanks for trying us out.</p>".html_safe
    end
  end
  # @endgroup

  # @group Playground
  # @param title text
  # @param description text
  # @param variant [Symbol] select [neutral, info, success, warning, danger, destructive]
  # @param size [Symbol] select [default, wide, extra_wide, huge, narrow]
  # @param close_label text
  # @param start_open toggle
  def playground(
    title: "Information",
    description: nil,
    variant: :neutral,
    size: :default,
    close_label: "Close",
    start_open: true
  )
    render ::Decor::Suite::Modals::Information.new(
      title: title,
      description: description,
      variant: variant,
      size: size,
      close_label: close_label,
      start_open: start_open
    ) do
      "<p>Body content here.</p>".html_safe
    end
  end
  # @endgroup
end
