# @label ConfirmModal
class ::Decor::Modals::ConfirmModalPreview < ::Lookbook::Preview
  # ConfirmModal
  # -------
  #
  # A confirm modal is an overlay that is designed request a negative or positive response from the user.
  # In general we may render only 1 ConfirmModal at a time & then use it at runtime by using
  # the relevant JS events to trigger the modal to open.
  #
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
    close_on_overlay_click: false,
    title: "Confirm",
    default_reason: "yes",
    positive_reason: "yes",
    positive_text: "Yes",
    negative_reason: "no",
    negative_text: "No"
  )
    render_with_template(
      locals: {
        message: message,
        close_on_overlay_click: close_on_overlay_click,
        title: title,
        default_reason: default_reason,
        positive_text: positive_text,
        positive_reason: positive_reason,
        negative_text: negative_text,
        negative_reason: negative_reason
      }
    )
  end
end
