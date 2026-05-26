import DaisyNotificationManagerController from "../daisy/notification_manager_controller";
import { safelySetInnerHTML } from "controllers/decor";

// Suite sidecar — registers its own identifier so Suite::NotificationManager
// roots actually get a controller attached. Renders by cloning the
// `<template id="<id>-toast-template">` that NotificationManager embeds
// alongside its container, so each toast comes out as a real
// Decor::Suite::Notification structure (accent + header + body + footer)
// with its base classes intact. The plain-div fallback the Daisy controller
// builds is invisible under Suite styling because the toast classes are
// scoped to the Notification component.
export default class SuiteNotificationManagerController extends DaisyNotificationManagerController {
    get notificationClassName() {
        return "decor--suite--notification";
    }

    async createNotification(options, contentHref) {
        const template = document.getElementById(`${this.element.id}-toast-template`);
        if (!template || !("content" in template)) {
            return super.createNotification(options, contentHref);
        }

        const frag = template.content.firstElementChild;
        if (!frag) return super.createNotification(options, contentHref);

        const node = frag.cloneNode(true);
        node.id = this.nextNotificationId();
        node.classList.add(this.notificationClassName);

        const body = options.body ?? options.content;
        const title = options.title;

        const titleEl = node.querySelector('[data-notification-slot="title"]');
        if (titleEl) titleEl.textContent = title ?? "";
        const headerEl = node.querySelector('[data-notification-slot="header"]');
        if (headerEl) this._toggleSlotHidden(headerEl, !title);

        const bodyTextEl = node.querySelector('[data-notification-slot="body-text"]');
        if (bodyTextEl) {
            if (body && typeof body === "object" && body.__safe) {
                // SafeHTMLContent payload (markAsSafeHTML) — render as HTML,
                // sanitised by safelySetInnerHTML.
                safelySetInnerHTML(bodyTextEl, body);
            } else {
                bodyTextEl.textContent = (typeof body === "string") ? body : "";
            }
        }
        const bodyEl = node.querySelector('[data-notification-slot="body"]');
        if (bodyEl) this._toggleSlotHidden(bodyEl, !body && !options.destination);

        return node;
    }

    _toggleSlotHidden(el, shouldHide) {
        if (shouldHide) {
            el.setAttribute("hidden", "");
        } else {
            el.removeAttribute("hidden");
        }
    }
}
