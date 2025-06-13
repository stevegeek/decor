import { Controller } from "@hotwired/stimulus";
import { markAsSafeHTML, safelySetInnerHTML, createAxiosInstance } from "controllers/decor";

export const NOTIFICATION_MANAGER_CLASS_NAME = "decor--notification-manager";
const NOTIFICATION_CLASSNAME = `${NOTIFICATION_MANAGER_CLASS_NAME}-notification`;
const DEFAULT_DISMISS_AFTER_MS = 3000;
const DISMISS_ALL_STAGGER_MS = 50;

export default class extends Controller {
    static targets = ["notificationContainer"];
    static values = {
        initialNotifications: { type: Array, default: [] },
    };

    connect() {
        this.currentNotificationId = 0;
        this.activeNotifications = new Map();

        // Process initial notifications if any
        this.initialNotificationsValue.forEach((notificationOptions) => {
            this.showNotification(notificationOptions);
        });

        console.log('NotificationManager connected');
        console.log(this.element);
        console.log(this.notificationContainerTarget);
        console.log(this.initialNotificationsValue);
        console.log('Active notifications:', this.activeNotifications);

    }

    disconnect() {
        this.clearAllTimeouts();
    }

    async handleShowEvent(evt) {
        console.log('NotificationManager: handleShowEvent', evt.detail);
        await this.showNotification(evt.detail);
    }

    async showNotification(options) {
        const { __safe, content, timeout, contentHref } = options;
        
        try {
            const notification = await this.createNotification(options, contentHref);
            const showTimeout = timeout !== undefined ? timeout : DEFAULT_DISMISS_AFTER_MS;
            
            // Track the notification
            let timerId = null;
            if (showTimeout !== Infinity && showTimeout > 0) {
                timerId = setTimeout(() => this.dismissNotification(notification.id), showTimeout);
            }
            
            this.activeNotifications.set(notification.id, { element: notification, timerId });

            // Add to DOM
            this.notificationContainerTarget.prepend(notification);

            // Set up click/touch handlers for dismissal
            this.setupDismissHandlers(notification);

        } catch (error) {
            console.error('Error showing notification:', error);
            this.showFallbackNotification();
        }
    }

    handleDismissAllEvent() {
        const notifications = Array.from(this.notificationContainerTarget.getElementsByClassName(NOTIFICATION_CLASSNAME));
        
        notifications.reverse().forEach((notification, idx) => {
            const notificationData = this.activeNotifications.get(notification.id);
            if (notificationData?.timerId) {
                clearTimeout(notificationData.timerId);
            }
            setTimeout(() => this.dismissNotification(notification.id), idx * DISMISS_ALL_STAGGER_MS);
        });
    }

    handleDismissSingleEvent(evt) {
        const { detail: { id } } = evt;
        this.dismissNotification(id);
    }

    nextNotificationId() {
        return `${NOTIFICATION_CLASSNAME}-${++this.currentNotificationId}`;
    }

    async createNotification(content, contentHref) {
        const notification = document.createElement("div");
        notification.id = this.nextNotificationId();
        notification.className = NOTIFICATION_CLASSNAME;
        
        if (contentHref) {
            const remoteContent = await this.getRemoteContent(`${contentHref}?notification_id=${notification.id}`);
            safelySetInnerHTML(notification, remoteContent);
        } else if (content) {
            safelySetInnerHTML(notification, content);
        }
        
        return notification;
    }

    async getRemoteContent(contentHref) {
        try {
            const axios = createAxiosInstance();
            const response = await axios.get(contentHref, {
                headers: { "Content-Type": "text/html" }
            });
            return markAsSafeHTML(response.data);
        } catch (error) {
            console.warn('Error fetching remote content:', error);
            throw new Error('Failed to load notification content');
        }
    }

    setupDismissHandlers(notification) {
        const dismissHandler = () => this.dismissNotification(notification.id);
        notification.addEventListener("click", dismissHandler);
        notification.addEventListener("touchend", dismissHandler);
    }

    dismissNotification(notificationId) {
        const notificationData = this.activeNotifications.get(notificationId);
        if (!notificationData) return;

        const { element, timerId } = notificationData;
        
        if (timerId) clearTimeout(timerId);

        if (element && this.notificationContainerTarget.contains(element) && !element.dataset.dismissing) {
            element.dataset.dismissing = 'true';
            element.style.opacity = '0';
            
            setTimeout(() => {
                this.removeNotification(element);
                this.activeNotifications.delete(notificationId);
            }, 150);
        }
    }

    removeNotification(element) {
        if (this.notificationContainerTarget.contains(element)) {
            element.remove();
        }
    }

    showFallbackNotification() {
        // Create a simple fallback notification without going through showNotification
        // to avoid infinite recursion if there's an error in showNotification itself
        try {
            const notification = document.createElement("div");
            notification.id = this.nextNotificationId();
            notification.className = NOTIFICATION_CLASSNAME;
            notification.textContent = "Something went wrong while loading the notification. Please try again later.";
            
            this.notificationContainerTarget.prepend(notification);
            
            const dismissHandler = () => {
                if (this.notificationContainerTarget.contains(notification)) {
                    notification.remove();
                }
            };
            
            notification.addEventListener("click", dismissHandler);
            notification.addEventListener("touchend", dismissHandler);
            
            setTimeout(dismissHandler, DEFAULT_DISMISS_AFTER_MS);
        } catch (error) {
            console.error('Failed to show fallback notification:', error);
        }
    }

    clearAllTimeouts() {
        this.activeNotifications.forEach(({ timerId }) => {
            if (timerId) clearTimeout(timerId);
        });
        this.activeNotifications.clear();
    }
}