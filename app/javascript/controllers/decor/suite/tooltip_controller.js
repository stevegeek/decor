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

  // Anchor to the TRIGGER element, never `this.element`: the root can be
  // blockified + stretched full-width by a flex/grid parent, which would drag
  // the tip to the middle of that box. The trigger content renders before the
  // popover, so it's the first element child that isn't the tip itself.
  get anchor() {
    const first = this.element.firstElementChild;
    if (first && first !== this.contentTarget) return first;
    return this.element;
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
    if (this.isOpen) {
      this.hide();
    } else {
      this.show();
    }
  }

  get isOpen() {
    return this.contentTarget.matches(":popover-open");
  }

  show() {
    if (!this.isOpen && this.contentTarget.isConnected) {
      this.contentTarget.showPopover();
    }
    this.startAutoUpdate();
  }

  hide() {
    this.stopAutoUpdate();
    if (this.isOpen) {
      this.contentTarget.hidePopover();
    }
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
        strategy: "fixed",
        middleware,
      },
    );

    // The popover lives in the top layer; position it in the viewport with
    // `fixed`. Reset the UA popover's default `inset:0; margin:auto` (which
    // would otherwise centre it) so our left/top win.
    Object.assign(this.contentTarget.style, {
      position: "fixed",
      margin: "0",
      inset: "auto",
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
