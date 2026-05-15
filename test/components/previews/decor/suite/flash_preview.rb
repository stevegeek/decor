# @label Suite Flash
class ::Decor::Suite::FlashPreview < ::Lookbook::Preview
  # @group Examples
  # @label Info
  def example_info
    render ::Decor::Suite::Flash.new(title: "Heads up", text: "The form has unsaved changes.")
  end

  # @group Examples
  # @label Success
  def example_success
    render ::Decor::Suite::Flash.new(title: "Saved", text: "Your changes have been saved.", color: :success)
  end

  # @group Examples
  # @label Error
  def example_error
    render ::Decor::Suite::Flash.new(title: "Something went wrong", text: "Please fix the errors below.", color: :error)
  end

  # @group Examples
  # @label Warning
  def example_warning
    render ::Decor::Suite::Flash.new(title: "Attention", text: "This action cannot be undone.", color: :warning)
  end

  # @group States
  # @label Collapsed when empty
  def state_collapsed_when_empty
    render ::Decor::Suite::Flash.new(collapse_if_empty: true)
  end

  # @group States
  # @label Block fallback content
  def state_block_fallback
    render ::Decor::Suite::Flash.new(collapse_if_empty: false) { "Custom fallback body when no flash text is present.".html_safe }
  end

  # @group Playground
  # @param title text
  # @param text textarea
  # @param color [Symbol] select [~, primary, secondary, accent, neutral, success, error, warning, info]
  # @param collapse_if_empty toggle
  def playground(title: "Notice", text: "Body text", color: :info, collapse_if_empty: true)
    render ::Decor::Suite::Flash.new(title: title, text: text, color: color, collapse_if_empty: collapse_if_empty)
  end
end
