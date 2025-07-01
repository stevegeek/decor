import ModalController from "controllers/decor/modals/modal_controller";
import { safelySetInnerHTML } from "controllers/decor";

export var ModalConfirmEvents;
(function (ModalConfirmEvents) {
    ModalConfirmEvents["Open"] = "decor--confirm-modal:open";
    ModalConfirmEvents["Opening"] = "decor--confirm-modal:opening";
    ModalConfirmEvents["Ready"] = "decor--confirm-modal:ready";
    ModalConfirmEvents["Opened"] = "decor--confirm-modal:opened";
    ModalConfirmEvents["Close"] = "decor--confirm-modal:close";
    ModalConfirmEvents["Closing"] = "decor--confirm-modal:closing";
    ModalConfirmEvents["Closed"] = "decor--confirm-modal:closed";
})(ModalConfirmEvents || (ModalConfirmEvents = {}));

export default class extends ModalController {
    static targets = [
        "overlay",
        "modal",
        "title",
        "message",
        "negativeButton",
        "positiveButton"
    ];

    negativeButton() {
        this.close(this.negativeButtonReason);
    }

    positiveButton() {
        this.close(this.positiveButtonReason);
    }

    // Override the base modal's open method to use confirm-specific events
    async open(showOptions) {
        this.dispatchLifecycleEvent(ModalConfirmEvents.Opening, {
            shownWith: showOptions,
        });
        await this.prepareConfirmModalAndLoad(showOptions);
        this.dispatchLifecycleEvent(ModalConfirmEvents.Opened, {
            shownWith: showOptions,
        });
    }

    // Override the base modal's close method to use confirm-specific events
    close(closeReason) {
        this.dispatchLifecycleEvent(ModalConfirmEvents.Closing, { closeReason });
        this.hide();
        this.dispatchLifecycleEvent(ModalConfirmEvents.Closed, { closeReason });
    }

    // Custom preparation method for confirm modals
    prepareConfirmModalAndLoad(showOptions) {
        const { 
            title, 
            message, 
            messageHTML, 
            defaultReason, 
            positiveButtonLabel, 
            positiveButtonReason, 
            negativeButtonLabel, 
            negativeButtonReason 
        } = showOptions;

        // Setup buttons etc
        this.closeOnOverlayClick = !!showOptions.closeOnOverlayClick;

        if (title) {
            this.titleTarget.innerText = title;
        }

        if (messageHTML) {
            safelySetInnerHTML(this.messageTarget, messageHTML);
        } else if (message) {
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
            } else if (defaultReason == this.positiveButtonReason) {
                this.positiveButtonTarget.focus();
            }
        }

        this.reveal();
    }
}
