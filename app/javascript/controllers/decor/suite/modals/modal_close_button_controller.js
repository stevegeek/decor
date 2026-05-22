import { Controller } from "@hotwired/stimulus";

// Suite ModalCloseButton controller.
//
// Dispatches a window-scoped close event the Suite Modal listens for.
// The optional `closeReason` value is carried on the event detail so listeners
// can branch on intent. Standalone-capable: no companion modal need be present.
export default class extends Controller {
    static values = {
        closeReason: String
    };

    handleButtonClick(event) {
        const reason = this.closeReasonValue;

        window.dispatchEvent(new CustomEvent("decor--suite--modals--modal:close", {
            detail: { closeReason: reason ? reason : undefined }
        }));
    }
}
