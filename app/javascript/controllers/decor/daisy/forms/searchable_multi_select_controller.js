import SingleController from "./searchable_select_controller";

// SearchableMultiSelect controller — multi-select typeahead. Inherits the
// XHR/debounce/keyboard/dropdown chassis from the single-select controller
// and overrides:
//   - connect(): seed selectedIds from `selected_items` JSON, render pre-
//     populated chips on mount.
//   - selectResult / _selectFromElement: append a chip + hidden input
//     instead of replacing a single chip; keep the dropdown open in browse
//     mode for further picks.
//   - handleKeydown: when the input is empty, Backspace pops the trailing
//     chip; Enter commits free-text when `allow_free_text` is on.
//   - removeItem: click handler for the chip's dismiss-X.
//   - handleBlur: when `allow_free_text` is on, commit any pending text as
//     a chip on blur.
//
// The parent uses bare "hidden" on classList operations while the markup
// uses the prefixed "decor:hidden". This port toggles both so the dropdown
// reliably opens/closes regardless of which the parent eventually settles on.
export default class extends SingleController {
  static targets = [
    "input",
    "dropdown",
    "selectedContainer",
    "hiddenInputsContainer",
  ];

  static values = {
    searchUrl: { type: String, default: "" },
    choices: { type: String, default: "[]" },
    extraSearchParams: { type: String, default: "" },
    minChars: { type: Number, default: 2 },
    debounceMs: { type: Number, default: 300 },
    pageSize: { type: Number, default: 15 },
    selectedItems: { type: String, default: "[]" },
    fieldName: { type: String, default: "" },
    allowFreeText: { type: Boolean, default: false },
    delimiter: { type: String, default: "," },
  };

  connect() {
    try {
      const items = JSON.parse(this.selectedItemsValue);
      if (Array.isArray(items)) {
        items.forEach((item) => {
          if (item && item.id != null) this.selectedIds.add(item.id);
        });
      }
    } catch {
      /* ignore */
    }

    this.handleClickOutside = this.handleClickOutside.bind(this);
    document.addEventListener("click", this.handleClickOutside);

    this.initialConnectDone = true;
  }

  // No single-selected-display chip in multi-select — every pick is a chip
  // in the selectedContainer. Drop the parent's programmatic-single-select
  // hook entirely.
  selectedItemValueChanged() {
    /* not used in multi-select */
  }

  handleBlur() {
    if (!this.allowFreeTextValue) return;
    setTimeout(() => {
      if (!this.element.contains(document.activeElement)) {
        this._addFreeTextFromInput();
      }
    }, 150);
  }

  search() {
    if (this.searchTimeout) clearTimeout(this.searchTimeout);

    if (this.allowFreeTextValue) {
      const raw = this.inputTarget.value;
      if (raw.includes(this.delimiterValue)) {
        const parts = raw.split(this.delimiterValue);
        parts.slice(0, -1).forEach((part) => {
          const trimmed = part.trim();
          if (trimmed) this._addFreeTextTag(trimmed);
        });
        this.inputTarget.value = parts[parts.length - 1];
        return;
      }
    }

    super.search();
  }

  handleKeydown(event) {
    if (event.key === "Backspace" && this.inputTarget.value === "") {
      this._removeLastItem();
      return;
    }

    if (event.key === "Enter" && this.allowFreeTextValue) {
      const items = this.dropdownTarget.querySelectorAll("[data-result-id]");
      const hasHighlight =
        this.highlightedIndex >= 0 && this.highlightedIndex < items.length;
      if (!hasHighlight) {
        event.preventDefault();
        this._addFreeTextFromInput();
        return;
      }
    }

    super.handleKeydown(event);
  }

  selectResult(event) {
    const target = event.target.closest("[data-result-id]");
    if (target) this._selectFromElement(target);
  }

  removeItem(event) {
    const button = event.target.closest("[data-item-id]");
    if (!button) return;
    const itemId = this._parseResultId(button.dataset.itemId);
    if (itemId === "") return;

    const escapedId = CSS.escape(String(itemId));
    const pill = this.selectedContainerTarget.querySelector(
      `[data-item-id="${escapedId}"]`,
    );
    if (pill) pill.remove();

    const hiddenInput = this.hiddenInputsContainerTarget.querySelector(
      `input[value="${escapedId}"]`,
    );
    if (hiddenInput) hiddenInput.remove();

    this.selectedIds.delete(itemId);
    this.inputTarget.focus();
    this.dispatch("removed", { detail: { id: itemId }, bubbles: true });
  }

  // ── Internals ──

  _selectFromElement(element) {
    const id = this._parseResultId(element.dataset.resultId);
    const label = element.dataset.resultLabel || "";
    if (!id || this.selectedIds.has(id)) return;

    this.selectedIds.add(id);
    this._addPill(id, label);
    this._addHiddenInput(id);
    this.inputTarget.value = "";

    // Keep keyboard focus on the input, but suppress the focus handler from
    // racing the just-issued closeDropdown when we're NOT in browse mode.
    this.suppressBrowseOnNextFocus = true;

    if (this.browseMode) {
      element.remove();
      const remaining =
        this.dropdownTarget.querySelectorAll("[data-result-id]");
      if (remaining.length === 0 && !this.hasMore) {
        this.dropdownTarget.innerHTML =
          '<p class="p-3 text-sm text-gray-500">No more items</p>';
      }
      this.highlightedIndex = -1;
    } else {
      this._closeDropdown();
    }

    this.inputTarget.focus();

    let metadata = {};
    if (element.dataset.resultMetadata) {
      try {
        metadata = JSON.parse(element.dataset.resultMetadata);
      } catch {
        /* ignore */
      }
    }
    this.dispatch("selected", {
      detail: { id, label, metadata },
      bubbles: true,
    });
  }

  _addFreeTextFromInput() {
    const text = this.inputTarget.value.trim();
    if (!text) return;
    this._addFreeTextTag(text);
    this.inputTarget.value = "";
    this._closeDropdown();
  }

  _addFreeTextTag(text) {
    const id = this._parseResultId(text);
    if (this.selectedIds.has(id)) return;
    this.selectedIds.add(id);
    this._addPill(id, text);
    this._addHiddenInput(id);
  }

  _removeLastItem() {
    const pills =
      this.selectedContainerTarget.querySelectorAll("[data-item-id]");
    if (pills.length === 0) return;
    const lastPill = pills[pills.length - 1];
    const itemId = this._parseResultId(lastPill.dataset.itemId);
    if (itemId === "") return;

    lastPill.remove();
    const escapedId = CSS.escape(String(itemId));
    const hiddenInput = this.hiddenInputsContainerTarget.querySelector(
      `input[value="${escapedId}"]`,
    );
    if (hiddenInput) hiddenInput.remove();
    this.selectedIds.delete(itemId);
    this.dispatch("removed", { detail: { id: itemId }, bubbles: true });
  }

  _addPill(id, label) {
    const pill = document.createElement("span");
    pill.className =
      "decor:inline-flex decor:items-center decor:gap-1 decor:rounded-full decor:bg-primary/10 decor:text-primary decor:px-2 decor:py-px decor:text-xs decor:font-medium";
    pill.dataset.itemId = String(id);
    pill.innerHTML =
      `<span>${this._escapeHtml(label)}</span>` +
      `<button type="button" class="decor:text-primary decor:hover:opacity-70 decor:leading-none" ` +
      `data-action="click->${this.identifier}#removeItem" ` +
      `data-item-id="${this._escapeAttr(String(id))}">` +
      `<svg xmlns="http://www.w3.org/2000/svg" class="decor:h-3 decor:w-3" viewBox="0 0 24 24" fill="none" ` +
      `stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">` +
      `<path d="M18 6L6 18M6 6l12 12"/></svg></button>`;
    this.selectedContainerTarget.appendChild(pill);
  }

  _addHiddenInput(id) {
    const hidden = document.createElement("input");
    hidden.type = "hidden";
    hidden.name = this.fieldNameValue;
    hidden.value = String(id);
    this.hiddenInputsContainerTarget.appendChild(hidden);
  }

  // Toggle both prefixed and unprefixed so the dropdown actually opens/closes
  // (parent uses bare "hidden", markup uses "decor:hidden").
  _openDropdown() {
    this.dropdownTarget.classList.remove("decor:hidden");
    this.dropdownTarget.classList.remove("hidden");
  }

  _closeDropdown() {
    this.dropdownTarget.classList.add("decor:hidden");
    this.dropdownTarget.classList.add("hidden");
    this.highlightedIndex = -1;
    this.currentPage = 0;
    this.hasMore = false;
    this.browseMode = false;
  }
}
