# @label ConfirmModal
# An overlay modal designed to request a negative or positive response from the user.
# Typically rendered once and controlled via JavaScript events at runtime.
class ::Decor::Modals::ConfirmModalPreview < ::Lookbook::Preview
  # @!group Examples

  # @label Default
  def default
    render_with_template(
      locals: {
        message: "Are you sure you want to continue?",
        title: "Confirm Action",
        positive_text: "Continue",
        negative_text: "Cancel"
      }
    )
  end

  # @label Delete Confirmation
  def delete_confirmation
    render_with_template(
      locals: {
        message: "This action cannot be undone. Are you sure you want to delete this item?",
        title: "Delete Item",
        positive_text: "Delete",
        positive_reason: "delete",
        negative_text: "Keep",
        negative_reason: "keep"
      }
    )
  end

  # @label Save Changes
  def save_changes
    render_with_template(
      locals: {
        message: "You have unsaved changes. Would you like to save before leaving?",
        title: "Unsaved Changes",
        positive_text: "Save & Leave",
        positive_reason: "save",
        negative_text: "Discard",
        negative_reason: "discard"
      }
    )
  end

  # @label Terms Agreement
  def terms_agreement
    render_with_template(
      locals: {
        message: "By proceeding, you agree to our terms of service and privacy policy.",
        title: "Terms & Conditions",
        positive_text: "I Agree",
        positive_reason: "accept",
        negative_text: "Decline",
        negative_reason: "decline",
        close_on_overlay_click: false
      }
    )
  end

  # @!endgroup

  # @!group Playground

  # @label Playground
  # @param message text
  # @param title text
  # @param positive_text text
  # @param positive_reason text
  # @param negative_text text
  # @param negative_reason text
  # @param default_reason text
  # @param close_on_overlay_click toggle
  def playground(
    message: "Testing the modal?",
    title: "Confirm",
    positive_text: "Yes",
    positive_reason: "yes",
    negative_text: "No",
    negative_reason: "no",
    default_reason: "yes",
    close_on_overlay_click: false
  )
    render_with_template(
      locals: {
        message: message,
        title: title,
        positive_text: positive_text,
        positive_reason: positive_reason,
        negative_text: negative_text,
        negative_reason: negative_reason,
        default_reason: default_reason,
        close_on_overlay_click: close_on_overlay_click
      }
    )
  end

  # @!endgroup
end
