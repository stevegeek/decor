import { Controller } from "@hotwired/stimulus";
import { markAsSafeHTML } from "controllers/decor";

// Suite ModalTrigger — wraps any clickable content (link, card, custom
// element) in a span that, on click, dispatches the same window-scoped
// open event as Suite::Modals::ModalOpenButton. The receiving Modal
// matches its own id against detail.id to decide whether to act; omitting
// id broadcasts to every Suite Modal on the page.
export default class extends Controller {
    static values = {
        modalId: String,
        contentHref: String,
        initialContent: String,
        title: String,
        closeOnOverlayClick: Boolean
    };

    handleClick(event) {
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
