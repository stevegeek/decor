import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static values = {
        closeReason: String
    };
    handleButtonClick(event) {
        event.preventDefault();
        const reason = this.closeReasonValue;
        
        // Dispatch event to close modal
        window.dispatchEvent(new CustomEvent('"decor--modal:close', {
            detail: { closeReason: reason ? reason : undefined }
        }));
    }
}
