import { Controller } from "@hotwired/stimulus";
import { markAsSafeHTML, safelySetInnerHTML, createHTTPClient } from "controllers/decor";

// Suite Modal — listens for the window-scoped open/close events the matching
// ModalOpenButton / ModalCloseButton dispatch, then drives the native <dialog>
// API (showModal / close, ::backdrop, top-layer, focus-trap).
//
// Event bus contract:
//   decor--suite--modals--modal:open  → detail: {
//       id?, content_href?, contentHref?, initial_content?, placeholder?,
//       title?, closeOnOverlayClick?
//   }
//   decor--suite--modals--modal:close → detail: { id?, closeReason? }
//
// Lifecycle events the modal dispatches up the DOM (bubbles: true):
//   decor--suite--modals--modal:opened → { ... }
//   decor--suite--modals--modal:closed → { reason, closeReason }
//
// If an open event carries an `id` it must match this dialog's id. Without an
// `id` only an already-open modal responds — treats the event as an in-place
// content update rather than spraying showModal() across every modal on the
// page.

const LOADING_SKELETON_HTML = `
  <div class="decor:space-y-2 decor:py-1" aria-hidden="true">
    <div class="decor:h-3 decor:bg-gray-100 decor:rounded-sm decor:animate-pulse"></div>
    <div class="decor:h-3 decor:bg-gray-100 decor:rounded-sm decor:animate-pulse decor:w-5/6"></div>
    <div class="decor:h-3 decor:bg-gray-100 decor:rounded-sm decor:animate-pulse decor:w-3/4"></div>
  </div>
`;

const OPEN_EVENT = "decor--suite--modals--modal:open";
const CLOSE_EVENT = "decor--suite--modals--modal:close";
const OPENED_EVENT = "decor--suite--modals--modal:opened";
const CLOSED_EVENT = "decor--suite--modals--modal:closed";

export default class extends Controller {
    static targets = ["body", "overlay", "modal"];

    static values = {
        startOpen: { type: Boolean, default: false },
        showInitial: { type: Boolean, default: false },
        closeable: { type: Boolean, default: true },
        contentHref: { type: String, default: "" },
        closeOnOverlayClick: { type: Boolean, default: false }
    };

    connect() {
        // If the dialog sits inside a <form>, fetched body content (parsed in
        // the dialog's DOM context) ends up form-associated with that outer
        // form — its inputs and submit button submit to the wrong endpoint.
        // Native <dialog> uses position: fixed via the UA stylesheet, so the
        // visual layout is unaffected by reparenting to <body>.
        if (this.dialog.closest("form")) {
            document.body.appendChild(this.dialog);
        }

        this.dialog.addEventListener("close", this.boundHandleClose);
        this.dialog.addEventListener("cancel", this.boundHandleCancel);

        // A Turbo form loaded into the modal body submits in place. On success
        // Turbo follows the redirect and re-renders/morphs the underlying page —
        // but the modal is still open in the native top layer, so its ::backdrop
        // would block every click on the morphed page. Close on a successful
        // submit (before the render) to release the top layer. A failed submit
        // (422 validation re-render) leaves the modal open so its form can show
        // the errors. `turbo:submit-end` bubbles from the form up through the
        // dialog, so listening on the dialog catches forms in its body.
        this.dialog.addEventListener("turbo:submit-end", this.boundHandleSubmitEnd);

        // Also catch Turbo form submissions whose `turbo:submit-end` event
        // doesn't bubble through this dialog. Turbo's confirm-driven
        // `<a data-turbo-method="…">` handler builds a hidden form on
        // `<body>` for the click, so a DELETE link inside a modal body
        // submits via a form the dialog never sees. The redirect-follow
        // then morphs the page WITH the modal still open in the top layer
        // — and morph mutates the dialog's `[open]` attribute via DOM
        // manipulation, which doesn't trigger the browser's top-layer
        // cleanup (only `.close()` does). Result: the next-rendered dialog
        // reports `:modal` true (stale top-layer slot), its invisible
        // backdrop covers the whole viewport, every subsequent click hits
        // <html>. Document-level listener catches the orphaned submission.
        document.addEventListener("turbo:submit-end", this.boundHandleDocumentSubmitEnd);

        if (this.startOpenValue || this.showInitialValue) {
            requestAnimationFrame(() => this.open());
        }
    }

    disconnect() {
        this.dialog.removeEventListener("close", this.boundHandleClose);
        this.dialog.removeEventListener("cancel", this.boundHandleCancel);
        this.dialog.removeEventListener("turbo:submit-end", this.boundHandleSubmitEnd);
        document.removeEventListener("turbo:submit-end", this.boundHandleDocumentSubmitEnd);
    }

    // ── Public API ────────────────────────────────────────────────────────

    open() {
        if (typeof this.dialog.showModal === "function") {
            this.dialog.showModal();
        } else {
            this.dialog.setAttribute("open", "");
        }
        requestAnimationFrame(() => {
            this.dispatchOnDialog(OPENED_EVENT);
        });
    }

    close(reason) {
        if (typeof this.dialog.close === "function") {
            this.dialog.close(reason || "");
        } else {
            this.dialog.removeAttribute("open");
            this.dispatchOnDialog(CLOSED_EVENT, { reason: reason || "" });
        }
        // The native 'close' event fires synchronously after dialog.close(),
        // so handleClose() will dispatch the `:closed` event for us.
    }

    // ── Window event handlers (auto-bound by Vident's stimulus actions) ───

    handleOpenEvent(evt) {
        const detail = (evt && evt.detail) || {};
        if (detail.id && detail.id !== this.element.id) return;
        if (!detail.id && !this.dialog.open) return;

        const href = detail.content_href || detail.contentHref || this.contentHrefValue || "";

        if (detail.title) {
            const titleEl = this.element.querySelector(".decor-modal__title");
            if (titleEl) titleEl.textContent = detail.title;
        }

        const bodyEl = this.resolveBodyElement();
        const placeholder = detail.initial_content || detail.placeholder;

        if (placeholder && bodyEl) {
            safelySetInnerHTML(bodyEl, placeholder);
        } else if (href && bodyEl) {
            this.showLoadingSkeleton(bodyEl);
        }

        this.resetFooterMarkers();

        this.open();

        if (href) {
            this.fetchAndInjectBody(href);
        }
    }

    handleCloseEvent(evt) {
        const detail = (evt && evt.detail) || {};
        if (detail.id && detail.id !== this.element.id) return;

        const reason = detail.close_reason || detail.closeReason || detail.action || "";
        this.close(reason);
    }

    // ── Native dialog event handlers ──────────────────────────────────────

    boundHandleClose = () => {
        const reason = this.dialog.returnValue || "";
        this.dispatchOnDialog(CLOSED_EVENT, { reason, closeReason: reason });
    };

    boundHandleCancel = (evt) => {
        if (!this.closeableValue) {
            evt.preventDefault();
        }
    };

    boundHandleSubmitEnd = (evt) => {
        if (this.dialog.open && evt.detail && evt.detail.success) {
            this.close("submit-success");
        }
    };

    boundHandleDocumentSubmitEnd = (evt) => {
        // Don't double-fire for forms inside this dialog (the dialog-level
        // listener already handled them).
        if (!this.dialog.open) return;
        if (!evt.detail || !evt.detail.success) return;
        const form = evt.target;
        if (form && this.dialog.contains(form)) return;
        this.close("orphan-submit-success");
    };

    // ── Content loading ───────────────────────────────────────────────────

    fetchAndInjectBody(href) {
        const httpClient = createHTTPClient();
        httpClient
            .get(href, { headers: { "Content-Type": "text/html" } })
            .then((response) => {
                this.setBodyContent(markAsSafeHTML(response.data));
            })
            .catch((err) => {
                console.error("Modal: could not fetch content", href, err);
                this.setBodyContent(
                    markAsSafeHTML("Something went wrong while loading the content. Please try again later.")
                );
            });
    }

    setBodyContent(content) {
        this.clearLoadingState();

        // When the AJAX response is itself a full Modal (a top-level
        // <dialog class="decor-modal">…</dialog>), unwrap it: the host modal
        // already owns the <dialog> container, so injecting another would
        // display:none. Take the inner header/body/footer and use them in
        // place of ours.
        const fragment = this.parseModalFragment(content);
        if (fragment) {
            this.replaceModalChildren(fragment);
            return;
        }

        const target = this.resolveBodyElement() || this.element;
        safelySetInnerHTML(target, content);
        this.applyFooterMarkers(target);
    }

    // ── Footer marker protocol ────────────────────────────────────────────
    //
    // Fragments that load into a Modal may emit <template> markers to
    // reconfigure the footer based on server-side state only knowable
    // after the body loads:
    //
    //   <template data-modal-destructive-action>…rendered button…</template>
    //     → cloned into .decor-modal__destructive-slot (left-pinned in footer)
    //
    //   <template data-modal-hide-submit></template>
    //     → footer Submit button gets display:none
    //
    // Markers are removed from the body after processing. The reset step on
    // every open ensures stale footer state from a previous row never lingers.

    resetFooterMarkers() {
        const slot = this.element.querySelector(".decor-modal__destructive-slot");
        if (slot) slot.replaceChildren();

        const submit = this.element.querySelector(".decor-modal__footer button[type=submit]");
        if (submit) submit.style.display = "";
    }

    applyFooterMarkers(bodyEl) {
        const slot = this.element.querySelector(".decor-modal__destructive-slot");
        if (slot) {
            const destrTpl = bodyEl.querySelector("template[data-modal-destructive-action]");
            if (destrTpl) {
                slot.replaceChildren(destrTpl.content.cloneNode(true));
                destrTpl.remove();
            } else {
                slot.replaceChildren();
            }
        }

        const submit = this.element.querySelector(".decor-modal__footer button[type=submit]");
        if (submit) {
            const hideTpl = bodyEl.querySelector("template[data-modal-hide-submit]");
            if (hideTpl) {
                // Inline display: none because Tailwind utility classes on
                // the button (inline-flex etc.) override the [hidden]
                // attribute's default rule.
                submit.style.display = "none";
                hideTpl.remove();
            } else {
                submit.style.display = "";
            }
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────

    resolveBodyElement() {
        if (this.hasBodyTarget) return this.bodyTarget;
        return this.element.querySelector(".decor-modal__body");
    }

    showLoadingSkeleton(bodyEl) {
        this.element.setAttribute("aria-busy", "true");
        this.element.classList.add("decor-modal--loading");
        safelySetInnerHTML(bodyEl, markAsSafeHTML(LOADING_SKELETON_HTML));
    }

    clearLoadingState() {
        this.element.removeAttribute("aria-busy");
        this.element.classList.remove("decor-modal--loading");
    }

    parseModalFragment(content) {
        if (!content.__safe) return null;
        const tpl = document.createElement("template");
        tpl.innerHTML = content.content;
        const topLevel = Array.from(tpl.content.children);
        if (topLevel.length !== 1) return null;
        const root = topLevel[0];
        if (root instanceof HTMLDialogElement && root.classList.contains("decor-modal")) {
            return root;
        }
        return null;
    }

    replaceModalChildren(innerDialog) {
        // Replace header/body/footer in-place. Keep the host <dialog> open and
        // its event listeners untouched.
        safelySetInnerHTML(this.element, {
            __safe: true,
            content: innerDialog.innerHTML
        });
    }

    get dialog() {
        return this.element;
    }

    dispatchOnDialog(type, detail) {
        this.element.dispatchEvent(
            new CustomEvent(type, { bubbles: true, cancelable: false, detail: detail || {} })
        );
    }
}
