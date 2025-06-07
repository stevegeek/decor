import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static targets = ["content"];

  copy() {
    this.#selectText();
    // showNotification({
    //   content: markAsSafeHTML("<p class='p-4'>Copied!</p>"),
    //   timeout: 1000,
    // });
  }

  #selectText() {
    const range = document.createRange();
    range.selectNodeContents(this.contentTarget);

    const selection = window.getSelection();
    if (selection) {
      selection.removeAllRanges();
      selection.addRange(range);

      document.execCommand("copy");
      selection.removeAllRanges();
    }
  }
}
