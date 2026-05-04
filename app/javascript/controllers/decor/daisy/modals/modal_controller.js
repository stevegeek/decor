import { Controller } from "@hotwired/stimulus";
import { markAsSafeHTML, safelySetInnerHTML, replaceContentsWithChildren, createHTTPClient } from "controllers/decor";
export var ModalEvents;
(function (ModalEvents) {
    ModalEvents["Open"] = "decor--modals--modal:open";
    ModalEvents["Opening"] = "decor--modals--modal:opening";
    ModalEvents["Loading"] = "decor--modals--modal:loading";
    ModalEvents["Loaded"] = "decor--modals--modal:loaded";
    ModalEvents["Ready"] = "decor--modals--modal:ready";
    ModalEvents["Opened"] = "decor--modals--modal:opened";
    ModalEvents["Close"] = "decor--modals--modal:close";
    ModalEvents["Closing"] = "decor--modals--modal:closing";
    ModalEvents["Closed"] = "decor--modals--modal:closed";
})(ModalEvents || (ModalEvents = {}));
export default class extends Controller {
    static targets = ["overlay", "modal"];
    static values = {
        showInitial: {type: Boolean, default: false},
        contentHref: {type: String, default: null},
        closeOnOverlayClick: {type: Boolean, default: false}
    };

    connect() {
        this.modalVisible = false;
        this.closeOnOverlayClick = false;
        this.pendingCloseReason = null;
        
        // Listen for the dialog's native close event
        this.element.addEventListener('close', () => {
            if (this.modalVisible) {
                this.modalVisible = false;
                this.dispatchLifecycleEvent(ModalEvents.Closed, { 
                    closeReason: this.pendingCloseReason || 'dialog-closed' 
                });
                this.pendingCloseReason = null;
            }
        });
        
        if (this.showInitialValue) {
            this.open({
                contentHref: this.contentHrefValue,
            });
        }
    }
    // Handle click on overlay to optionally close modal
    overlayClicked(event) {
        // The form with method="dialog" will automatically close the dialog
        // We only need to prevent it if closeOnOverlayClick is false
        if (!this.closeOnOverlayClick && !this.closeOnOverlayClickValue) {
            event.preventDefault();
        }
        this.handleCloseEvent(event);

    }
    // Reveal the dialog by triggering event (with stimulus or directly) on window
    // > window.dispatchEvent(new CustomEvent('decor-modal:open', { detail: { message } }));
    handleCloseEvent(evt) {
        const action = evt.detail?.closeReason || evt.detail?.action;
        this.close(action);
    }

    // Reveal the dialog by calling:
    // window.dispatchEvent(new CustomEvent('decor-modal:show', { detail: { message } }));
    async handleOpenEvent(evt) {
        await this.open(evt.detail);
    }

    // Open the modal and load its content if needed
    async open(showOptions) {
        this.dispatchLifecycleEvent(ModalEvents.Opening, {
            shownWith: showOptions,
        });
        await this.prepareModalAndLoad(showOptions);
        this.dispatchLifecycleEvent(ModalEvents.Opened, { shownWith: showOptions });
    }

    // Close the modal
    close(closeReason) {
        this.dispatchLifecycleEvent(ModalEvents.Closing, { closeReason });
        this.pendingCloseReason = closeReason;
        this.hide();
        // The 'close' event listener will dispatch the Closed event
    }

    get isVisible() {
        return this.modalVisible;
    }

    async prepareModalAndLoad(shownWith) {
        const { contentHref, placeholder, closeOnOverlayClick } = shownWith;
        if (placeholder) {
            this.setContent(placeholder);
        }
        this.closeOnOverlayClick = !!closeOnOverlayClick;
        if (contentHref) {
            this.getContent(shownWith)
                .then((c) => {
                this.setContent(c);
            })
                .catch((err) => {
                console.error("Could not fetch content for modal", contentHref, err);
                const errorMessage = "Something went wrong while loading the content. Please try again later.";
                // To prevent user being blocked, make sure they can exit the modal
                this.closeOnOverlayClick = true;
                this.setContent(markAsSafeHTML(errorMessage));
            });
        }
        this.reveal();
    }
    reveal() {
        this.modalVisible = true;
        this.element.showModal();
    }
    hide() {
        this.modalVisible = false;
        this.element.close();
    }
    setContent(content) {
        this.replaceContents(this.modalTarget, this.createContent(content));
    }
    createContent(content) {
        const contentContainer = document.createElement("div");
        contentContainer.id = `${this.element.id}-content`;
        // We likely want to allow arbitrary HTML here so that the dialog content can be formatted appropriately, and allow things like other MDC components to be rendered inside.
        // The problem with allowing arbitrary HTML to be rendered is that it opens the possibility of a XSS attack.
        // To try and mitigate this issue, we ask that the developer explicitly wraps the content inside an object with a `__safe` property.
        // Of course, this can't guarantee that a developer is passing safe content, but it at least gets them thinking about the dangers of XSS when pushing content to be displayed.
        // https://www.owasp.org/index.php/Cross-site_Scripting_(XSS)
        safelySetInnerHTML(contentContainer, content);
        return contentContainer;
    }
    replaceContents(target, content) {
        replaceContentsWithChildren(target, content);
    }
    async getContent(shownWith) {
        this.dispatchLifecycleEvent(ModalEvents.Loading, { shownWith });
        const httpClient = createHTTPClient();
        return httpClient
            .get(shownWith.contentHref, {
            headers: {
                "Content-Type": "text/html",
            },
        })
            .then((response) => {
            this.dispatchLifecycleEvent(ModalEvents.Loaded, { shownWith });
            return markAsSafeHTML(response.data);
        });
    }
    dispatchLifecycleEvent(type, detail) {
        const evt = new CustomEvent(type, {
            bubbles: true,
            cancelable: false,
            detail: detail,
        });
        console.debug(`Modal: dispatching ${type} event:`, detail);
        window.dispatchEvent(evt);
    }
}
