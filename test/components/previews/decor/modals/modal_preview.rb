# @label Modal
class ::Decor::Modals::ModalPreview < ::Lookbook::Preview
  # Modal
  # -------
  #
  # A modal is an overlay that is designed to block interaction.
  # It should be used when there is an action to present to the user,
  # that is necessary to proceed.
  #
  # In general we may render only 1 Modal at a time & then reuse it at runtime by changing contents
  # via the JS part of the component.
  #
  # @label Playground
  # @param initial_content text
  # @param content_href select [~, "https://www.example.com", "/lookbook/decor/button_preview/playground"]
  # @param start_shown toggle
  # @param close_on_overlay_click toggle
  def playground(
    initial_content: "Testing the modal",
    start_shown: true,
    close_on_overlay_click: false,
    content_href: nil
  )
    render ::Decor::Modals::Modal.new(
      initial_content: initial_content,
      content_href: content_href,
      start_shown: start_shown,
      close_on_overlay_click: close_on_overlay_click
    )
  end
end
