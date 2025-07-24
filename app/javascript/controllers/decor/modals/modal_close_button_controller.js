import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static values = {
        closeReason: String
    };
    handleButtonClick(event) {
        // Don't prevent default - let the form submission close the dialog
        const reason = this.closeReasonValue;
        
        // Dispatch event for tracking/logging purposes
        window.dispatchEvent(new CustomEvent('decor--modals--modal:close', {
            detail: { closeReason: reason ? reason : undefined }
        }));
    }
}
