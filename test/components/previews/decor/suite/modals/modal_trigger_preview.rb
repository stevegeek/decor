# @label ModalTrigger
class ::Decor::Suite::Modals::ModalTriggerPreview < ::Lookbook::Preview
  # Wraps any clickable content in a transparent container that, when clicked,
  # dispatches the window-scoped Suite modal-open event. Use when the trigger
  # is not a button (custom card, avatar, link, table row, etc.). The detail
  # carries `id`, optional `content_href`, `initial_content`, `title` override
  # and `closeOnOverlayClick`.

  # @group Examples
  def default
    render ::Decor::Suite::Modals::ModalTrigger.new(modal_id: "example-modal") do
      "<a class=\"decor:text-suite-primary-700 decor:underline\">Open the example modal</a>".html_safe
    end
  end

  def wraps_custom_card
    render ::Decor::Suite::Modals::ModalTrigger.new(modal_id: "card-modal") do
      <<~HTML.html_safe
        <div class="decor:p-3 decor:border decor:border-suite-hairline decor:rounded-suite-card decor:bg-white">
          <div class="decor:suite-section-title decor:text-gray-700">Card title</div>
          <div class="decor:suite-description decor:text-gray-500">Click anywhere on this card to open the modal.</div>
        </div>
      HTML
    end
  end

  def with_initial_content
    render ::Decor::Suite::Modals::ModalTrigger.new(
      modal_id: "content-modal",
      initial_content: "<p>This content appears immediately when the modal opens.</p>"
    ) do
      "<span class=\"decor:underline decor:text-suite-primary-700\">Show initial content</span>".html_safe
    end
  end

  def with_remote_content
    render ::Decor::Suite::Modals::ModalTrigger.new(
      modal_id: "remote-modal",
      content_href: "/lookbook/preview/decor/suite/button_preview/playground"
    ) do
      "<span class=\"decor:underline decor:text-suite-primary-700\">Load remote content</span>".html_safe
    end
  end

  def with_title_override
    render ::Decor::Suite::Modals::ModalTrigger.new(
      modal_id: "shared-modal",
      title: "Edit row 42",
      content_href: "/rows/42/edit"
    ) do
      "<span class=\"decor:underline decor:text-suite-primary-700\">Edit row 42</span>".html_safe
    end
  end
  # @endgroup

  # @group Playground
  # @param modal_id text
  # @param initial_content text
  # @param content_href select [~, "https://www.example.com", "/lookbook/preview/decor/suite/button_preview/playground"]
  # @param title text
  # @param close_on_overlay_click toggle
  def playground(
    modal_id: "example-modal",
    initial_content: nil,
    content_href: nil,
    title: nil,
    close_on_overlay_click: false
  )
    render ::Decor::Suite::Modals::ModalTrigger.new(
      modal_id: modal_id,
      initial_content: initial_content,
      content_href: content_href,
      title: title,
      close_on_overlay_click: close_on_overlay_click
    ) do
      "<span class=\"decor:underline decor:text-suite-primary-700\">Trigger</span>".html_safe
    end
  end
  # @endgroup
end
