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
}
