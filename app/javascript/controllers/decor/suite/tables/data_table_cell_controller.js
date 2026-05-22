import { Controller } from "@hotwired/stimulus";

// Companion JS for Decor::Suite::Tables::DataTableCell.
// Two responsibilities:
//   1. When the cell sets `stop_propagation`, swallow click bubbling so the
//      parent row's link-overlay doesn't navigate away.
//   2. When the cell renders its own `.cell-row-link-overlay <a>`, swallow
//      that anchor's click bubbling so a real navigation happens (preserving
//      ctrl/meta-click + middle-click) instead of being intercepted by the
//      row controller.
export default class extends Controller {
  static values = {
    noPathNavigation: { type: Boolean, default: false },
  };

  handleCellClickToStopPropagation(e) {
    e.stopPropagation();
  }

  handleLinkClick(e) {
    e.stopPropagation();
  }
}
