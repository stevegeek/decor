import { Controller } from "@hotwired/stimulus";

// Suite Modals::Confirm — mounted directly on the confirm <button>.
//
// On click:
//   1. (optional) dispatches a named CustomEvent to window so listeners can
//      react to the user's intent (e.g. "delete-order").
//   2. dispatches the Suite Modal close event scoped to this dialog's id so
//      the dialog closes through the standard event protocol.
//
// The native `close` event fires synchronously after dialog.close(), which the
// Suite Modal controller already handles and which dispatches the
// `:closed` lifecycle event.
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

        window.dispatchEvent(
            new CustomEvent("decor--suite--modals--modal:close", {
                detail: { id: this.modalIdValue || undefined }
            })
        );
    }
}
