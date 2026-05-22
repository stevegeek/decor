import { Controller } from "@hotwired/stimulus";
import { markAsSafeHTML } from "controllers/decor";

// Daisy ModalTrigger — wraps any clickable content in a span that, on click,
// dispatches the window-scoped open event the matching Modal listens for.
export default class extends Controller {
    static values = {
        modalId: String,
        contentHref: String,
        initialContent: String,
        title: String,
        closeOnOverlayClick: Boolean
    };

    handleClick(event) {
        // Activate on Enter / Space when the wrapper has keyboard focus.
        if (event.type === "keydown" && event.key !== "Enter" && event.key !== " ") return;
        event.preventDefault();

        window.dispatchEvent(new CustomEvent("decor--daisy--modals--modal:open", {
            detail: {
                id: this.modalIdValue || undefined,
                contentHref: this.contentHrefValue || undefined,
                closeOnOverlayClick: this.closeOnOverlayClickValue,
                placeholder: this.initialContentValue
                    ? markAsSafeHTML(this.initialContentValue)
                    : undefined,
                title: this.titleValue || undefined
            }
        }));
    }
}
