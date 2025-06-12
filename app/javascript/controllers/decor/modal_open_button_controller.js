import BaseController from "decor/base_controller.js";
import { showModal } from "lib/overlay/modal";
import { markAsSafeHTML } from "lib/util/safe_html";
class ModalOpenButtonController extends BaseController {
    handleButtonClick(event) {
        event.preventDefault();
        showModal({
            contentHref: this.contentHrefValue,
            closeOnOverlayClick: this.closeOnOverlayClickValue,
            placeholder: this.initialContentValue ? markAsSafeHTML(this.initialContentValue) : undefined,
        });
    }
}
ModalOpenButtonController.values = {
    contentHref: String,
    initialContent: String,
    closeOnOverlayClick: Boolean
};
export default ModalOpenButtonController;
