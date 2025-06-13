import { Controller } from "@hotwired/stimulus";
import { markAsSafeHTML } from "controllers/decor";

export default class extends Controller {
    static values = {
        contentHref: String,
        initialContent: String,
        closeOnOverlayClick: Boolean
    };
    handleButtonClick(event) {
        event.preventDefault();
        
        // Dispatch event to open modal
        window.dispatchEvent(new CustomEvent('"decor--modal:open', {
            detail: {
                contentHref: this.contentHrefValue,
                closeOnOverlayClick: this.closeOnOverlayClickValue,
                placeholder: this.initialContentValue ? markAsSafeHTML(this.initialContentValue) : undefined,
            }
        }));
    }
}
