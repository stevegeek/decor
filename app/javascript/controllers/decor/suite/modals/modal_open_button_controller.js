import { Controller } from "@hotwired/stimulus";
import { markAsSafeHTML } from "controllers/decor";

// Suite ModalOpenButton — dispatches a window-scoped open event consumed by
// the matching Suite Modal. The detail mirrors the values set on the button:
//   id, content_href, initial_content (as a SafeHTMLContent placeholder),
//   title (override), close_on_overlay_click.
//
// The receiving Modal compares its own id against detail.id to decide whether
// to act; omitting id broadcasts to every Suite Modal on the page.
export default class extends Controller {
    static values = {
        modalId: String,
        contentHref: String,
        initialContent: String,
        title: String,
        closeOnOverlayClick: Boolean
    };

    handleButtonClick(event) {
        event.preventDefault();

        window.dispatchEvent(new CustomEvent("decor--suite--modals--modal:open", {
            detail: {
                id: this.modalIdValue || undefined,
                content_href: this.contentHrefValue || undefined,
                contentHref: this.contentHrefValue || undefined,
                initial_content: this.initialContentValue
                    ? markAsSafeHTML(this.initialContentValue)
                    : undefined,
                placeholder: this.initialContentValue
                    ? markAsSafeHTML(this.initialContentValue)
                    : undefined,
                title: this.titleValue || undefined,
                closeOnOverlayClick: this.closeOnOverlayClickValue
            }
        }));
    }
}
