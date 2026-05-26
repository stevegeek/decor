import { Controller } from "@hotwired/stimulus";

// Demo helper: buttons dispatch the window events decor's NotificationManager
// listens for, so the harness can prove toasts render + land in the right
// viewport position from a realistic trigger (not just a raw scripted event).
export default class extends Controller {
  notify(event) {
    const { title, body, timeout } = event.params;
    window.dispatchEvent(
      new CustomEvent("decor--suite--notification-manager:show", {
        detail: { title, body, timeout },
      }),
    );
  }

  dismissAll() {
    window.dispatchEvent(
      new CustomEvent("decor--suite--notification-manager:dismissAll"),
    );
  }

  // Daisy variant: the Daisy NotificationManager has no toast <template> and
  // no title/body slots — its JS just sets innerHTML from `detail.content`.
  // The manager's createNotification feeds `options.content` straight into
  // safelySetInnerHTML, which requires the XSS-safe { __safe, content } shape,
  // so we build the toast markup and wrap it like markAsSafeHTML() does.
  notifyDaisy(event) {
    const { title, body, timeout } = event.params;
    const t = title ? `<h3 class="decor:font-bold">${title}</h3>` : "";
    const b = body ? `<span class="decor:text-sm">${body}</span>` : "";
    const html =
      `<div class="decor:d-alert decor:shadow-lg decor:max-w-md">` +
      `<div class="decor:flex decor:flex-col">${t}${b}</div></div>`;
    window.dispatchEvent(
      new CustomEvent("decor--daisy--notification-manager:show", {
        detail: { content: { __safe: true, content: html }, timeout },
      }),
    );
  }

  dismissAllDaisy() {
    window.dispatchEvent(
      new CustomEvent("decor--daisy--notification-manager:dismissAll"),
    );
  }

  // Generic: dispatch an arbitrary window CustomEvent (e.g. a component's
  // scoped open/toggle event). data-demo-triggers-event-param="<name>".
  fire(event) {
    const name = event.params.event;
    if (name) window.dispatchEvent(new CustomEvent(name));
  }
}
