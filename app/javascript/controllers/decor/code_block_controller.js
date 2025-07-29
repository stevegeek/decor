import { Controller } from "@hotwired/stimulus"
import HighlightJS from "@highlightjs/cdn-assets/es/highlight.min.js"

export default class extends Controller {
  static targets = ["code"]
    static values = {
      highlight: {type: Boolean, default: false},
      language: {type: String, default: "ruby"}
    }

  connect() {
    this.highlightCode()
  }

  highlightCode() {
    console.log("Highlighting code blocks...")
    this.codeTargets.forEach(codeElement => {
      // Check if already highlighted
      if (codeElement.dataset.highlighted === "yes") return
      if (!this.highlightValue) return

      try {
        var result;
        if (this.languageValue) {
          result = HighlightJS.highlight(codeElement.textContent, {language: this.languageValue})
        } else {
          result = HighlightJS.highlightAuto(codeElement.textContent)
          // If language was detected, add it as a class
          if (result.language) {
            codeElement.classList.add(`language-${result.language}`)
          }
        }
        // Replace the content with highlighted version
        codeElement.innerHTML = result.value
        codeElement.classList.add('hljs')
        codeElement.dataset.highlighted = "yes"
      } catch (error) {
        console.warn("Failed to highlight code block:", error)
        // Leave the content as-is if highlighting fails
      }
    })
  }
}