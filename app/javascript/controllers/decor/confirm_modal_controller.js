import ModalController from "./modal_controller.js";
import { safelySetInnerHTML } from "lib/util/safe_html";
export var ModalConfirmEvents;
(function (ModalConfirmEvents) {
    ModalConfirmEvents["Open"] = "components--decor--confirm-modal:open";
    ModalConfirmEvents["Opening"] = "components--decor--confirm-modal:opening";
    ModalConfirmEvents["Ready"] = "components--decor--confirm-modal:ready";
    ModalConfirmEvents["Opened"] = "components--decor--confirm-modal:opened";
    ModalConfirmEvents["Close"] = "components--decor--confirm-modal:close";
    ModalConfirmEvents["Closing"] = "components--decor--confirm-modal:closing";
    ModalConfirmEvents["Closed"] = "components--decor--confirm-modal:closed";
})(ModalConfirmEvents || (ModalConfirmEvents = {}));
class ConfirmModalController extends ModalController {
    negativeButton() {
        this.close(this.negativeButtonReason);
    }
    positiveButton() {
        this.close(this.positiveButtonReason);
    }
    // Open the modal and load its content if needed
    async open(showOptions) {
        this.dispatchLifecycleEvent(ModalConfirmEvents.Opening, {
            shownWith: showOptions,
        });
        await this.prepareConfirmModalAndLoad(showOptions);
        this.dispatchLifecycleEvent(ModalConfirmEvents.Opened, {
            shownWith: showOptions,
        });
    }
    prepareConfirmModalAndLoad(showOptions) {
        const { title, message, messageHTML, defaultReason, positiveButtonLabel, positiveButtonReason, negativeButtonLabel, negativeButtonReason, } = showOptions;
        // Setup buttons etc
        this.closeOnOverlayClick = !!showOptions.closeOnOverlayClick;
        if (title) {
            this.titleTarget.innerText = title;
        }
        if (messageHTML) {
            safelySetInnerHTML(this.messageTarget, messageHTML);
        }
        else if (message) {
            this.messageTarget.innerText = message;
        }
        if (positiveButtonLabel) {
            this.positiveButtonTarget.innerText = positiveButtonLabel;
        }
        if (negativeButtonLabel) {
            this.negativeButtonTarget.innerText = negativeButtonLabel;
        }
        this.negativeButtonReason = negativeButtonReason;
        this.positiveButtonReason = positiveButtonReason;
        if (defaultReason) {
            if (defaultReason == this.negativeButtonReason) {
                this.negativeButtonTarget.focus();
            }
            else if (defaultReason == this.positiveButtonReason) {
                this.positiveButtonTarget.focus();
            }
        }
        this.reveal();
    }
    // Close the modal
    close(closeReason) {
        this.dispatchLifecycleEvent(ModalConfirmEvents.Closing, { closeReason });
        this.hide();
        this.dispatchLifecycleEvent(ModalConfirmEvents.Closed, { closeReason });
    }
}
ConfirmModalController.targets = [
    "overlay",
    "modal",
    "title",
    "message",
    "negativeButton",
    "positiveButton",
];
export default ConfirmModalController;
