import { Controller } from "@hotwired/stimulus";

// Daisy Modals::Confirm — mounted directly on the confirm <button>.
//
// On click:
//   1. (optional) dispatches a named CustomEvent to window for listeners.
//   2. closes the nearest <dialog> ancestor directly.
export default class extends Controller {
    static values = {
        confirmEvent: { type: String, default: "" },
        modalId: { type: String, default: "" }
    };

    confirm(event) {
        event.preventDefault();

        if (this.confirmEventValue) {
            window.dispatchEvent(
                new CustomEvent(this.confirmEventValue, {
                    bubbles: false,
                    cancelable: false
                })
            );
        }

        const dialog = this.element.closest("dialog");
        if (dialog && typeof dialog.close === "function") {
            dialog.close();
        }
    }
}
