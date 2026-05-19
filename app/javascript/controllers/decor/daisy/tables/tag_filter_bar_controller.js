import { Controller } from "@hotwired/stimulus";

/**
 * Suite TagFilterBar — tag-chip filter row for a table.
 *
 *  - Renders an OR/AND mode toggle that selects chip-match semantics.
 *  - Toggles individual chip selection on click; chip appearance is driven by
 *    `selectedClasses` / `unselectedClasses` payloads on each button so the
 *    server-rendered color palette survives client-side flips.
 *  - The Apply button is hidden until the selection (or mode) diverges from
 *    the initial server-rendered state.
 *  - Apply / clearAll / showAll all do a full-page navigation by mutating
 *    the URL query string — no XHR / no Turbo frame swap.
 */
export default class extends Controller {
  static targets = [
    "chip",
    "applyButton",
    "modeToggle",
    "overflowButton",
    "tagsContainer",
  ];

  static values = {
    selectedIds: String,
    tagMode: String,
    paramName: String,
    modeParamName: String,
  };

  connect() {
    const parsed = JSON.parse(this.selectedIdsValue || "[]");
    this.currentSelectedIds = new Set(parsed);
    this.initialSelectedIds = new Set(parsed);
    this.currentMode = this.tagModeValue || "or";
    this.initialMode = this.currentMode;
  }

  toggleTag(event) {
    const button = event.currentTarget;
    const tagId = button.dataset.tagId;

    if (this.currentSelectedIds.has(tagId)) {
      this.currentSelectedIds.delete(tagId);
    } else {
      this.currentSelectedIds.add(tagId);
    }

    this.updateChipAppearance(button, this.currentSelectedIds.has(tagId));
    this.updateApplyButton();
  }

  setMode(event) {
    const button = event.currentTarget;
    this.currentMode = button.dataset.mode;

    const buttons = this.modeToggleTarget.querySelectorAll("button");
    buttons.forEach((btn) => {
      const isActive = btn.dataset.mode === this.currentMode;
      btn.className = `decor:px-2.5 decor:py-1 decor:leading-none ${
        isActive
          ? "decor:bg-gray-800 decor:text-white"
          : "decor:bg-white decor:text-gray-600 decor:hover:bg-gray-50"
      }`;
    });

    this.updateApplyButton();
  }

  apply() {
    const url = new URL(window.location.href);

    url.searchParams.delete(this.paramNameValue);
    url.searchParams.delete(this.modeParamNameValue);

    if (this.currentSelectedIds.size > 0) {
      url.searchParams.set(
        this.paramNameValue,
        Array.from(this.currentSelectedIds).join(","),
      );
      url.searchParams.set(this.modeParamNameValue, this.currentMode);
    }

    window.location.href = url.toString();
  }

  clearAll() {
    this.currentSelectedIds.clear();
    this.chipTargets.forEach((chip) => {
      this.updateChipAppearance(chip, false);
    });

    const url = new URL(window.location.href);
    url.searchParams.delete(this.paramNameValue);
    url.searchParams.delete(this.modeParamNameValue);
    window.location.href = url.toString();
  }

  showAll() {
    if (this.hasOverflowButtonTarget) {
      this.overflowButtonTarget.classList.add("decor:hidden");
    }
    const url = new URL(window.location.href);
    url.searchParams.set("show_all_tags", "true");
    window.location.href = url.toString();
  }

  updateChipAppearance(button, selected) {
    const selectedClasses = (button.dataset.selectedClasses || "")
      .split(" ")
      .filter(Boolean);
    const unselectedClasses = (button.dataset.unselectedClasses || "")
      .split(" ")
      .filter(Boolean);

    if (selected) {
      unselectedClasses.forEach((cls) => button.classList.remove(cls));
      selectedClasses.forEach((cls) => button.classList.add(cls));
    } else {
      selectedClasses.forEach((cls) => button.classList.remove(cls));
      unselectedClasses.forEach((cls) => button.classList.add(cls));
    }
  }

  updateApplyButton() {
    const selectionChanged = !this.setsEqual(
      this.currentSelectedIds,
      this.initialSelectedIds,
    );
    const modeChanged = this.currentMode !== this.initialMode;

    if (selectionChanged || modeChanged) {
      this.applyButtonTarget.classList.remove("decor:hidden");
    } else {
      this.applyButtonTarget.classList.add("decor:hidden");
    }
  }

  setsEqual(a, b) {
    if (a.size !== b.size) return false;
    for (const item of a) {
      if (!b.has(item)) return false;
    }
    return true;
  }
}
