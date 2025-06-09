import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content"];

  async copy() {
    try {
      const text = this.#getTextContent();
      await this.#copyToClipboard(text);
      this.#showSuccess();
    } catch (error) {
      console.error("Failed to copy to clipboard:", error);
      this.#fallbackCopy();
    }
  }

  #getTextContent() {
    return this.contentTarget.textContent || this.contentTarget.innerText || "";
  }

  async #copyToClipboard(text) {
    if (navigator.clipboard && window.isSecureContext) {
      try {
        await navigator.clipboard.writeText(text);
        return;
      } catch (clipboardError) {
        console.warn("Clipboard API failed, falling back to execCommand:", clipboardError);
      }
    }
    throw new Error("Using execCommand fallback");
  }

  #fallbackCopy() {
    try {
      // Create a temporary textarea element for better browser compatibility
      const textarea = document.createElement("textarea");
      textarea.value = this.#getTextContent();
      textarea.style.position = "fixed";
      textarea.style.left = "-999999px";
      textarea.style.top = "-999999px";
      document.body.appendChild(textarea);
      
      // Focus and select the text
      textarea.focus();
      textarea.select();
      textarea.setSelectionRange(0, textarea.value.length);

      // Try to copy using execCommand
      const success = document.execCommand("copy");
      
      // Clean up
      document.body.removeChild(textarea);

      if (success) {
        this.#showSuccess();
      } else {
        throw new Error("execCommand returned false");
      }
    } catch (error) {
      console.error("Fallback copy failed:", error);
      this.#showError();
    }
  }

  #showSuccess() {
    console.log("Copied to clipboard!");
    // FIXME: Port notification system
    // showNotification({
    //   content: markAsSafeHTML("<p class='p-4'>Copied!</p>"),
    //   timeout: 1000,
    // });
  }

  #showError() {
    console.error("Failed to copy to clipboard");
    // FIXME: Port notification system
  }
}
