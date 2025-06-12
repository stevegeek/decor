import axios from "lib/axios";
import BaseController from "decor/base_controller.js";
import { localeMessage } from "lib/i18n";
import { markAsSafeHTML, safelySetInnerHTML } from "lib/util/safe_html";
export const NOTIFICATION_MANAGER_CLASS_NAME = "components--decor--notification-manager";
const NOTIFICATION_CLASSNAME = `${NOTIFICATION_MANAGER_CLASS_NAME}-notification`;
const DEFAULT_DISMISS_AFTER_MS = 3000;
const DISMISS_ALL_STAGGER_MS = 50;
class NotificationManagerController extends BaseController {
    constructor() {
        super(...arguments);
        this.currentNotificationId = 0;
    }
    onInitialize() {
        this.onConnect(() => {
            if (this.initialNotificationsValue) {
                this.initialNotificationsValue.forEach((notificationOptions) => {
                    this.showNotification(notificationOptions);
                });
            }
        });
        return super.onInitialize();
    }
    async handleShowEvent(evt) {
        this.showNotification(evt.detail);
    }
    async showNotification(options) {
        const { content, timeout, contentHref } = options;
        const notification = await this.createNotification(content, contentHref);
        const showTimeout = timeout || DEFAULT_DISMISS_AFTER_MS;
        if (showTimeout !== Infinity) {
            const timerId = window.setTimeout(() => this.dismissNotification(notification.id), showTimeout);
            notification.dataset.dismissTimerId = timerId.toString();
        }
        // .prepend() not available in IE11
        // this.element.prepend(notification);
        this.notificationContainerTarget.insertBefore(notification, this.notificationContainerTarget.firstChild);
        notification.addEventListener("click", () => {
            this.dismissNotification(notification.id);
        });
        notification.addEventListener("touchend", () => {
            this.dismissNotification(notification.id);
        });
    }
    handleDismissAllEvent() {
        // This isn't exactly the 'stimulus way' - we should probably be using targets instead.
        // But, it works.
        Array.from(this.notificationContainerTarget.getElementsByClassName(NOTIFICATION_CLASSNAME))
            .reverse() // Bottom notification should disappear first
            .forEach((node, idx) => {
            const el = node;
            clearTimeout(+el.dataset.dismissTimerId);
            setTimeout(() => this.dismissNotification(el.id), idx * DISMISS_ALL_STAGGER_MS);
        });
    }
    handleDismissSingleEvent(evt) {
        const { detail: { id }, } = evt;
        this.dismissNotification(id);
    }
    nextNotificationId() {
        const next = this.currentNotificationId + 1;
        this.currentNotificationId = next;
        return `${NOTIFICATION_CLASSNAME}-${next}`;
    }
    async createNotification(content, contentHref) {
        const notification = document.createElement("div");
        notification.id = this.nextNotificationId();
        this.setTargetElementClasses(notification, [], [NOTIFICATION_CLASSNAME].concat(this.notificationBaseClasses));
        this.toggleTargetElementTransitionClasses(notification, true, this.enteringClasses, this.enteringFromClasses, this.enteringToClasses, this.leavingClasses, this.leavingFromClasses, this.leavingToClasses);
        if (contentHref) {
            // TODO: What if contentHref already has a query string parameters?
            const remoteContent = await this.getRemoteContent(`${contentHref}?notification_id=${notification.id}`);
            safelySetInnerHTML(notification, remoteContent);
        }
        else if (content) {
            safelySetInnerHTML(notification, content);
        }
        return notification;
    }
    getRemoteContent(contentHref) {
        return this.getContent(contentHref).catch((err) => {
            console.warn(err);
            const errorMessage = localeMessage("generic_server_error");
            return markAsSafeHTML(errorMessage);
        });
    }
    getContent(url) {
        return axios
            .get(url, {
            headers: {
                "Content-Type": "text/html",
            },
        })
            .then((response) => markAsSafeHTML(response.data));
    }
    dismissNotification(notificationId) {
        // Only try to dismiss the notification if it is still in the DOM,
        // and it is not being dismissed
        const notification = document.getElementById(notificationId);
        if (notification) {
            this.toggleTargetElementTransitionClasses(notification, false, this.enteringClasses, this.enteringFromClasses, this.enteringToClasses, this.leavingClasses, this.leavingFromClasses, this.leavingToClasses);
            setTimeout(() => {
                this.removeNotification(notification);
            }, 150);
        }
    }
    removeNotification(target) {
        // .remove() not available in IE11
        // target.remove();
        if (this.notificationContainerTarget.contains(target)) {
            this.notificationContainerTarget.removeChild(target);
        }
    }
}
NotificationManagerController.targets = ["notificationContainer"];
NotificationManagerController.values = {
    initialNotifications: Array
};
NotificationManagerController.classes = [
    "notificationBase",
    "entering",
    "enteringFrom",
    "enteringTo",
    "leaving",
    "leavingFrom",
    "leavingTo",
];
export default NotificationManagerController;
