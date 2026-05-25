# @label Modal
class ::Decor::Daisy::Modals::ModalPreview < ::Lookbook::Preview
  # A modal is an overlay that blocks interaction, presenting necessary actions to the user.
  # Modals should be used sparingly for critical interactions that require user attention.
  # Generally, render only one modal at a time and reuse it by changing contents dynamically.

  # @label Example
  # A simple modal with text content
  def basic_modal
    render ::Decor::Daisy::Modals::Modal.new(
      initial_content: "This is a basic modal with simple text content.",
      start_shown: true
    )
  end

  # @label Example: Modal with Remote Content
  # Load content from a URL dynamically
  def remote_content
    render ::Decor::Daisy::Modals::Modal.new(
      content_href: "/lookbook/decor/button_preview/playground",
      start_shown: true
    )
  end

  # @label Example: Click Outside to Close
  # Allow closing the modal by clicking the overlay
  def click_outside_close
    render ::Decor::Daisy::Modals::Modal.new(
      initial_content: "Click outside this modal to close it.",
      start_shown: true,
      close_on_overlay_click: true
    )
  end

  # @label Example: Loading State
  # Shows spinner when no initial content is provided
  def loading_state
    render ::Decor::Daisy::Modals::Modal.new(
      start_shown: true
    )
  end

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
    render ::Decor::Daisy::Modals::Modal.new(
      initial_content: initial_content,
      content_href: content_href,
      start_shown: start_shown,
      close_on_overlay_click: close_on_overlay_click
    )
  end

  # @label With Open Button
  # Use ModalOpenButton to trigger modal display
  def with_open_button
    render_with_template
  end

  # @label With Close Button
  # Use ModalCloseButton inside modal content
  def with_close_button
    render_with_template
  end

  # @label Complete Example
  # Full modal implementation with open/close buttons and layout
  def complete_example
    render_with_template
  end

  # @label With Modal Layout
  # Using ModalLayout for structured content
  def with_modal_layout
    render_with_template
  end

  # @label Form in Modal
  # Display a form inside a modal
  def form_modal
    render_with_template
  end

  # @label Initially Hidden
  # Modal starts hidden and requires trigger to show
  def initially_hidden
    render ::Decor::Daisy::Modals::Modal.new(
      initial_content: "This modal started hidden and was opened via JavaScript.",
      start_shown: false
    )
  end

  # @label Overlay Click Behavior
  # Compare overlay click behavior
  def overlay_click_behavior
    render_with_template(
      locals: {
        modals: [
          {
            modal: ::Decor::Daisy::Modals::Modal.new(
              initial_content: "This modal stays open when clicking the overlay.",
              start_shown: true,
              close_on_overlay_click: false
            ),
            label: "Default (No close on overlay)"
          },
          {
            modal: ::Decor::Daisy::Modals::Modal.new(
              initial_content: "Click the dark overlay to close this modal.",
              start_shown: true,
              close_on_overlay_click: true
            ),
            label: "Close on overlay click enabled"
          }
        ]
      }
    )
  end
end
