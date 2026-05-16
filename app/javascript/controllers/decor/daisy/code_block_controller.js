import { Controller } from "@hotwired/stimulus"

// HighlightJS is loaded lazily via dynamic import inside `highlightCode()`.
// A top-level static import compiles to a dynamic `require()` call when the
// consumer's bundler (e.g. Confinus's esbuild IIFE build) marks
// `@highlightjs/cdn-assets` as external — and dynamic require is unsupported
// in browser environments, which throws and halts subsequent JS execution.
// Lazy loading keeps the controller's static import surface clean.
export default class extends Controller {
  static targets = ["code"]
  static values = {
    highlight: { type: Boolean, default: false },
    language: { type: String, default: "ruby" },
  }

  connect() {
    this.highlightCode()
  }

  async highlightCode() {
    if (!this.highlightValue) return

    const targets = this.codeTargets.filter(
      (el) => el.dataset.highlighted !== "yes",
    )
    if (targets.length === 0) return

    let HighlightJS
    try {
      HighlightJS = (await import("@highlightjs/cdn-assets/es/highlight.min.js")).default
    } catch (error) {
      console.warn("Failed to load highlight.js for code block:", error)
      return
    }

    targets.forEach((codeElement) => {
      try {
        let result
        if (this.languageValue) {
          result = HighlightJS.highlight(codeElement.textContent, { language: this.languageValue })
        } else {
          result = HighlightJS.highlightAuto(codeElement.textContent)
          if (result.language) {
            codeElement.classList.add(`language-${result.language}`)
          }
        }
        codeElement.innerHTML = result.value
        codeElement.classList.add("decor:hljs")
        codeElement.dataset.highlighted = "yes"
      } catch (error) {
        console.warn("Failed to highlight code block:", error)
      }
    })
  }
}
