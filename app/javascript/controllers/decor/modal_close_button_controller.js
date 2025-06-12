import BaseController from "decor/base_controller.js";
import { closeModal } from "lib/overlay/modal";
class ModalCloseButtonController extends BaseController {
    handleButtonClick(event) {
        event.preventDefault();
        const reason = this.closeReasonValue;
        closeModal({
            closeReason: reason ? reason : undefined,
        });
    }
}
ModalCloseButtonController.values = {
    closeReason: String
};
export default ModalCloseButtonController;
