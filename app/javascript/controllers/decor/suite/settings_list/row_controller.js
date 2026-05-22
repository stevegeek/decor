import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["chevron", "detail", "summary"];

  static values = {
    open: { type: Boolean, default: false },
  };

  toggle() {
    this.openValue = !this.openValue;
  }

  openValueChanged(open) {
    this.detailTarget.hidden = !open;
    this.summaryTarget.setAttribute("aria-expanded", String(open));
    this.chevronTarget.classList.toggle("decor:rotate-90", open);
  }
}
