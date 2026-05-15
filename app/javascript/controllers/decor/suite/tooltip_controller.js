import { Controller } from "@hotwired/stimulus";
import {
  computePosition,
  autoUpdate,
  flip,
  shift,
  offset as offsetMiddleware,
  arrow,
} from "@floating-ui/dom";

// Auto-positioning tooltip. Uses Floating UI to keep the tooltip inside the
// viewport — if there is no room on the preferred side it flips to the
// opposite, and shifts along the cross axis to stay on screen. Equivalent
// to the CSS `position-try: flip-block, flip-inline` behaviour from the
// anchor-positioning spec, but cross-browser via JS.
export default class extends Controller {
  static targets = ["content", "arrow"];
  static values = {
    placement: { type: String, default: "top" },
    offset: { type: Number, default: 8 },
  };

  connect() {
    // Clear any stale transforms from a previous implementation.
    this.contentTarget.style.transform = "";
  }

  disconnect() {
    this.stopAutoUpdate();
    clearTimeout(this.showTimer);
    clearTimeout(this.hideTimer);
  }

  mouseOver() {
    clearTimeout(this.hideTimer);
    // Small delay so a mouse flying past the anchor doesn't flash the tip.
    this.showTimer = setTimeout(() => this.show(), 80);
  }

  mouseOut() {
    clearTimeout(this.showTimer);
    // Short grace period so users can move the cursor into the tip itself
    // without it snapping closed.
    this.hideTimer = setTimeout(() => this.hide(), 100);
  }

  handleClick() {
    if (this.contentTarget.classList.contains("decor:hidden")) {
      this.show();
    } else {
      this.hide();
    }
  }

  show() {
    this.contentTarget.classList.remove("decor:hidden");
    this.startAutoUpdate();
  }

  hide() {
    this.contentTarget.classList.add("decor:hidden");
    this.stopAutoUpdate();
  }

  get anchor() {
    return this.element;
  }

  startAutoUpdate() {
    this.stopAutoUpdate();
    this.cleanupAutoUpdate = autoUpdate(this.anchor, this.contentTarget, () =>
      this.updatePosition(),
    );
  }

  stopAutoUpdate() {
    if (this.cleanupAutoUpdate) {
      this.cleanupAutoUpdate();
      this.cleanupAutoUpdate = undefined;
    }
  }

  async updatePosition() {
    const middleware = [
      offsetMiddleware(this.offsetValue),
      flip({ padding: 8 }),
      shift({ padding: 8 }),
    ];
    if (this.hasArrowTarget) {
      middleware.push(arrow({ element: this.arrowTarget, padding: 4 }));
    }

    const { x, y, placement, middlewareData } = await computePosition(
      this.anchor,
      this.contentTarget,
      {
        placement: this.placementValue,
        strategy: "absolute",
        middleware,
      },
    );

    Object.assign(this.contentTarget.style, {
      left: `${x}px`,
      top: `${y}px`,
    });

    if (this.hasArrowTarget && middlewareData.arrow) {
      const { x: arrowX, y: arrowY } = middlewareData.arrow;
      // The arrow sits on the side OPPOSITE to the final placement (e.g.
      // if the tooltip ends up above the anchor, the arrow is on the
      // tooltip's bottom edge pointing down).
      const staticSide = {
        top: "bottom",
        right: "left",
        bottom: "top",
        left: "right",
      }[placement.split("-")[0]];

      Object.assign(this.arrowTarget.style, {
        left: arrowX != null ? `${arrowX}px` : "",
        top: arrowY != null ? `${arrowY}px` : "",
        right: "",
        bottom: "",
        [staticSide]: "-4px",
      });
    }
  }
}
