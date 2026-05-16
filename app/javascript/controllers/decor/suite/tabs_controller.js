import { Controller } from "@hotwired/stimulus";

/**
 * Toggles inset scroll-shadow classes on the strip wrapper based on the
 * scroll position of the inner overflow-x-auto element. The wrapper has
 * `position: relative; overflow: hidden` and the shared utility classes
 * `.inset-scroll-shadow-not-at-left` / `.inset-scroll-shadow-not-at-right`
 * paint a gradient fade on the appropriate edge.
 */
export default class extends Controller {
    static targets = ["wrapper", "scroll"];

    connect() {
        if (!this.hasWrapperTarget || !this.hasScrollTarget) return;

        this.updateShadows();

        this.resizeObserver = new ResizeObserver(() => this.updateShadows());
        this.resizeObserver.observe(this.scrollTarget);
        this.resizeObserver.observe(this.wrapperTarget);
    }

    disconnect() {
        if (this.resizeObserver) {
            this.resizeObserver.disconnect();
            this.resizeObserver = null;
        }
    }

    scrolled() {
        this.updateShadows();
    }

    updateShadows() {
        if (!this.hasWrapperTarget || !this.hasScrollTarget) return;

        const x = this.scrollTarget.scrollLeft;
        const max = this.scrollTarget.scrollWidth - this.scrollTarget.clientWidth;
        // Sub-pixel layout (zoom, fractional widths) can leave x ~0 even at the
        // edge; allow a small tolerance so the fade actually disappears.
        const epsilon = 1;

        this.wrapperTarget.classList.toggle(
            "inset-scroll-shadow-not-at-left",
            x > epsilon,
        );
        this.wrapperTarget.classList.toggle(
            "inset-scroll-shadow-not-at-right",
            x < max - epsilon,
        );
    }
}
