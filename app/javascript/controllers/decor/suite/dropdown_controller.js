import { Controller } from "@hotwired/stimulus";
import { markAsSafeHTML, safelySetInnerHTML, replaceContentsWithChildren, createHTTPClient } from "controllers/decor";

// Suite Dropdown controller.
//
// The menu uses the native Popover API, so the browser owns open/close,
// aria-expanded toggling, light-dismiss, and Escape-to-close. This controller
// only:
//   - exposes toggle/show/hide methods that delegate to the native popover API
//   - listens for `beforetoggle` and lazy-loads remote content on first open
//
// Any consumer-supplied `data-action` like
//   beforetoggle->decor--suite--dropdown#handleBeforeToggle
// is wired automatically via the abstract base's stimulus block.
export default class extends Controller {
  static targets = ["menu", "button"];

  static values = {
    contentHref: { type: String, default: "" },
    placeholder: { type: String, default: "" },
  };

  toggle() {
    if (this.hasMenuTarget) this.menuTarget.togglePopover();
  }

  show() {
    if (this.hasMenuTarget) this.menuTarget.showPopover();
  }

  hide() {
    if (this.hasMenuTarget) this.menuTarget.hidePopover();
  }

  // ── Lazy-load: fires on every open (matches current behavior) ──
  handleBeforeToggle(event) {
    if (event.newState !== "open") return;
    this.prepareContent();
  }

  async prepareContent() {
    if (this.placeholderValue) {
      this.setContent(markAsSafeHTML(this.placeholderValue));
    }
    if (this.contentHrefValue) {
      try {
        const c = await this.getContent(this.contentHrefValue);
        this.setContent(c);
      } catch (err) {
        console.error("Could not fetch content for dropdown", this.contentHrefValue, err);
        const errorMessage = "Something went wrong while loading the content for this dropdown. Please try again later.";
        this.setContent(markAsSafeHTML(errorMessage));
      }
    }
  }

  async getContent(href) {
    const httpClient = createHTTPClient();
    return httpClient
      .get(href, { headers: { "Content-Type": "text/html" } })
      .then((response) => markAsSafeHTML(response.data));
  }

  setContent(content) {
    replaceContentsWithChildren(this.menuTarget, this.createContent(content));
  }

  createContent(content) {
    const container = document.createElement("div");
    container.id = `${this.element.id}-content`;
    safelySetInnerHTML(container, content);
    return container;
  }
}
