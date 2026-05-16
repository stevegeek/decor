import { Controller } from "@hotwired/stimulus";
import { createHTTPClient } from "controllers/decor";

// SearchableSelect controller — typeahead single-select dropdown.
//
// Behaviour:
//   - Click/focus the input → "browse mode": opens dropdown and fetches the
//     first page (XHR) or shows all local choices.
//   - Type ≥ minChars → debounced XHR / live local filter.
//   - Pick a result → hides the input, shows the chip with the selected
//     label. The chip is click-to-reopen for re-selection.
//   - Optional clear-X clears the value (and may auto-submit the form).
//   - Backspace in the input does NOT remove the selection (single-select);
//     use the clear button or the chip click.
//   - Scroll the dropdown near the bottom → loads the next page (XHR mode).
//   - Click outside / Escape → closes the dropdown.
//   - External: setting `data-...-selected-item-value='{"id":"…","label":"…"}'`
//     selects an item programmatically; missing label is resolved from local
//     choices or via `?resolve_id=` on the search URL.
export default class extends Controller {
  static targets = [
    "input",
    "dropdown",
    "selectedDisplay",
    "selectedLabel",
    "hiddenInputsContainer",
  ];

  static values = {
    searchUrl: { type: String, default: "" },
    choices: { type: String, default: "[]" },
    minChars: { type: Number, default: 2 },
    debounceMs: { type: Number, default: 300 },
    pageSize: { type: Number, default: 15 },
    selectedItem: { type: String, default: "{}" },
    allowClear: { type: Boolean, default: true },
    autoSubmit: { type: Boolean, default: false },
    fieldName: { type: String, default: "" },
  };

  initialize() {
    this.searchTimeout = null;
    this.selectedIds = new Set();
    this.highlightedIndex = -1;
    this.currentPage = 0;
    this.hasMore = false;
    this.isLoading = false;
    this.currentQuery = "";
    this.browseMode = false;
    this.suppressBrowseOnNextFocus = false;
    this.currentSelectedId = null;
    this.initialConnectDone = false;
    this.resolveCounter = 0;
  }

  connect() {
    try {
      const item = JSON.parse(this.selectedItemValue);
      if (item && item.id) {
        this.currentSelectedId = item.id;
        this.selectedIds.add(item.id);
      }
    } catch {
      /* ignore */
    }

    this.handleClickOutside = this.handleClickOutside.bind(this);
    document.addEventListener("click", this.handleClickOutside);

    this.initialConnectDone = true;
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside);
    if (this.searchTimeout) clearTimeout(this.searchTimeout);
  }

  // ── Programmatic selection via value change ──
  selectedItemValueChanged() {
    if (!this.initialConnectDone) return;
    let item;
    try {
      item = JSON.parse(this.selectedItemValue);
    } catch {
      return;
    }
    if (!item || !item.id) return;
    const id = item.id;

    if (this.currentSelectedId) this.selectedIds.delete(this.currentSelectedId);
    this.currentSelectedId = id;
    this.selectedIds.add(id);

    this.hiddenInputsContainerTarget.innerHTML = "";
    const hidden = document.createElement("input");
    hidden.type = "hidden";
    hidden.name = this.fieldNameValue;
    hidden.value = String(id);
    this.hiddenInputsContainerTarget.appendChild(hidden);

    if (item.label) {
      this._applySelectedDisplay(String(id), item.label);
      return;
    }
    const localMatch = this._parsedChoices().find(
      (c) => String(c.id) === String(id),
    );
    if (localMatch) {
      this._applySelectedDisplay(String(id), localMatch.label);
    } else if (this.searchUrlValue) {
      this._applySelectedDisplay(String(id), "");
      this.selectedLabelTarget.textContent = "Loading…";
      this._resolveLabelFromSearch(String(id));
    } else {
      this._applySelectedDisplay(String(id), String(id));
    }
  }

  // ── User interactions ──

  handleFocus() {
    if (this.suppressBrowseOnNextFocus) {
      this.suppressBrowseOnNextFocus = false;
      return;
    }
    this._openBrowseIfClosed();
  }

  handleInputClick() {
    this._openBrowseIfClosed();
  }

  search() {
    if (this.searchTimeout) clearTimeout(this.searchTimeout);
    const query = this.inputTarget.value.trim();

    if (query.length === 0) {
      if (!this.dropdownTarget.classList.contains("hidden")) {
        this.browseMode = true;
        this.currentQuery = "";
        this.currentPage = 0;
        this.hasMore = false;
        this._fetchResults("", 1, false);
      }
      return;
    }

    if (query.length < this.minCharsValue) {
      if (!this.browseMode) this._closeDropdown();
      return;
    }

    this.browseMode = false;
    this.currentQuery = query;
    this.currentPage = 0;
    this.hasMore = false;
    this.searchTimeout = setTimeout(() => {
      this._fetchResults(query, 1, false);
    }, this.debounceMsValue);
  }

  handleDropdownScroll() {
    if (!this.hasMore || this.isLoading) return;
    const el = this.dropdownTarget;
    if (el.scrollHeight - el.scrollTop - el.clientHeight < 50) {
      this._fetchResults(this.currentQuery, this.currentPage + 1, true);
    }
  }

  handleKeydown(event) {
    const items = this.dropdownTarget.querySelectorAll("[data-result-id]");
    switch (event.key) {
      case "Escape":
        this._closeDropdown();
        this.inputTarget.blur();
        break;
      case "ArrowDown":
        event.preventDefault();
        if (this.dropdownTarget.classList.contains("hidden")) {
          this.handleFocus();
          return;
        }
        this.highlightedIndex = Math.min(
          this.highlightedIndex + 1,
          items.length - 1,
        );
        this._updateHighlight(items);
        break;
      case "ArrowUp":
        event.preventDefault();
        if (this.dropdownTarget.classList.contains("hidden")) return;
        this.highlightedIndex = Math.max(this.highlightedIndex - 1, 0);
        this._updateHighlight(items);
        break;
      case "Enter":
        event.preventDefault();
        if (
          this.highlightedIndex >= 0 &&
          this.highlightedIndex < items.length
        ) {
          this._selectFromElement(items[this.highlightedIndex]);
        }
        break;
      // No Backspace handler — single-select doesn't auto-remove the value.
    }
  }

  selectResult(event) {
    const target = event.target.closest("[data-result-id]");
    if (target) this._selectFromElement(target);
  }

  // Click on the chip — reopen the dropdown for re-selection without losing
  // the existing value.
  reopenForReselect() {
    this.selectedDisplayTarget.classList.add("hidden");
    this.inputTarget.classList.remove("hidden");
    this.inputTarget.value = "";
    this.inputTarget.focus();
    this._openBrowseIfClosed();
  }

  clear(event) {
    if (event) event.stopPropagation();
    if (this.currentSelectedId) this.selectedIds.delete(this.currentSelectedId);
    this.currentSelectedId = null;

    this.selectedDisplayTarget.classList.add("hidden");
    this.inputTarget.classList.remove("hidden");
    this.inputTarget.value = "";
    this.inputTarget.focus();

    this.hiddenInputsContainerTarget.innerHTML = "";

    this.dispatch("cleared", { bubbles: true });
    if (this.autoSubmitValue) {
      this.element.closest("form")?.requestSubmit();
    }
  }

  // ── Internals ──

  _openBrowseIfClosed() {
    if (
      this.dropdownTarget.classList.contains("hidden") &&
      this.inputTarget.value.trim() === ""
    ) {
      this.browseMode = true;
      this.currentQuery = "";
      this.currentPage = 0;
      this.hasMore = false;
      this._fetchResults("", 1, false);
    }
  }

  _selectFromElement(element) {
    const id = this._parseResultId(element.dataset.resultId);
    const label = element.dataset.resultLabel || "";
    if (!id) return;

    if (this.currentSelectedId) this.selectedIds.delete(this.currentSelectedId);
    this.currentSelectedId = id;
    this.selectedIds.add(id);

    this.selectedLabelTarget.textContent = label;
    this.selectedDisplayTarget.classList.remove("hidden");
    this.inputTarget.classList.add("hidden");
    this.inputTarget.value = "";

    this.hiddenInputsContainerTarget.innerHTML = "";
    const hidden = document.createElement("input");
    hidden.type = "hidden";
    hidden.name = this.fieldNameValue;
    hidden.value = String(id);
    this.hiddenInputsContainerTarget.appendChild(hidden);

    this._closeDropdown();

    let metadata = {};
    if (element.dataset.resultMetadata) {
      try {
        metadata = JSON.parse(element.dataset.resultMetadata);
      } catch {
        /* ignore */
      }
    }
    this.dispatch("selected", { detail: { id, label, metadata }, bubbles: true });

    if (this.autoSubmitValue) {
      this.element.closest("form")?.requestSubmit();
    }
  }

  _applySelectedDisplay(id, label) {
    this.selectedLabelTarget.textContent = label;
    this.selectedDisplayTarget.classList.remove("hidden");
    this.inputTarget.classList.add("hidden");
    this.inputTarget.value = "";
    this._closeDropdown();
    this.dispatch("selected", { detail: { id, label }, bubbles: true });
  }

  async _resolveLabelFromSearch(id) {
    const requestId = ++this.resolveCounter;
    let label = String(id);
    try {
      const http = createHTTPClient();
      const params = new URLSearchParams({ resolve_id: id });
      const response = await http.get(
        `${this.searchUrlValue}?${params.toString()}`,
      );
      if (requestId !== this.resolveCounter) return;
      const results = response.data?.results;
      if (results) {
        const match = results.find((r) => String(r.id) === id);
        if (match) label = match.label;
      }
    } catch {
      if (requestId !== this.resolveCounter) return;
    }
    this.selectedLabelTarget.textContent = label;
    this.dispatch("resolved", { detail: { id, label }, bubbles: true });
  }

  _parsedChoices() {
    try {
      return JSON.parse(this.choicesValue);
    } catch {
      return [];
    }
  }

  _parseResultId(raw) {
    const str = raw || "";
    const num = Number(str);
    return Number.isFinite(num) && str !== "" ? num : str;
  }

  _isLocalMode() {
    return !this.searchUrlValue && this.choicesValue !== "[]";
  }

  async _fetchResults(query, page, append) {
    if (this.isLoading) return;
    if (this._isLocalMode()) {
      this._fetchLocalResults(query);
      return;
    }

    this.isLoading = true;
    if (!append) this.dropdownTarget.innerHTML = "";
    this._renderLoadingIndicator();
    this._openDropdown();

    try {
      const http = createHTTPClient();
      const params = new URLSearchParams();
      if (query) params.set("q", query);
      params.set("page", String(page));
      const url = `${this.searchUrlValue}${this.searchUrlValue.includes("?") ? "&" : "?"}${params.toString()}`;
      const response = await http.get(url);
      const data = response.data;
      this.currentPage = page;
      this.hasMore = !!data.has_more;
      this.currentQuery = query;
      this._renderResults(data.results || [], append);
    } catch {
      if (!append) {
        this.dropdownTarget.innerHTML =
          '<p class="p-3 text-sm text-red-600">Search failed</p>';
        this._openDropdown();
      }
    } finally {
      this.isLoading = false;
      this._removeLoadingIndicator();
    }
  }

  _fetchLocalResults(query) {
    const q = query.toLowerCase();
    const filtered = this._parsedChoices().filter((choice) => {
      if (this.selectedIds.has(choice.id)) return false;
      if (!q) return true;
      return (
        choice.label.toLowerCase().includes(q) ||
        (choice.sublabel && choice.sublabel.toLowerCase().includes(q))
      );
    });
    this.currentPage = 1;
    this.hasMore = false;
    this.currentQuery = query;
    this._renderResults(filtered, false);
  }

  _renderResults(results, append) {
    const filtered = results.filter((r) => !this.selectedIds.has(r.id));

    if (!append) {
      this.highlightedIndex = -1;
      if (filtered.length === 0 && !this.hasMore) {
        this.dropdownTarget.innerHTML =
          '<p class="p-3 text-sm text-gray-500">No results found</p>';
        this._openDropdown();
        return;
      }
      this.dropdownTarget.innerHTML = "";
    }

    const html = filtered
      .map((r) => this._resultRowHtml(r))
      .join("");
    this.dropdownTarget.insertAdjacentHTML("beforeend", html);
    this._openDropdown();
  }

  _resultRowHtml(result) {
    const metadataAttr = result.metadata
      ? ` data-result-metadata="${this._escapeAttr(JSON.stringify(result.metadata))}"`
      : "";
    const sublabel = result.sublabel
      ? `<span class="text-xs text-gray-500 ml-2">${this._escapeHtml(result.sublabel)}</span>`
      : "";
    const rightLabel = result.right_label
      ? `<span class="text-xs text-gray-400 font-mono ml-3 shrink-0">${this._escapeHtml(result.right_label)}</span>`
      : "";
    return (
      `<button type="button" ` +
      `class="w-full text-left px-4 py-2 hover:bg-gray-50 border-b last:border-b-0 flex justify-between items-center" ` +
      `data-result-id="${this._escapeAttr(String(result.id))}" ` +
      `data-result-label="${this._escapeAttr(result.label)}"${metadataAttr} ` +
      `data-action="click->${this.identifier}#selectResult">` +
      `<div class="min-w-0"><span class="text-sm font-medium">${this._escapeHtml(result.label)}</span>${sublabel}</div>` +
      rightLabel +
      `</button>`
    );
  }

  _renderLoadingIndicator() {
    this._removeLoadingIndicator();
    const indicator = document.createElement("div");
    indicator.dataset.loadingIndicator = "true";
    indicator.className =
      "p-3 flex items-center justify-center gap-2 text-sm text-gray-400";
    indicator.textContent = "Loading…";
    this.dropdownTarget.appendChild(indicator);
  }

  _removeLoadingIndicator() {
    const indicator = this.dropdownTarget.querySelector(
      "[data-loading-indicator]",
    );
    if (indicator) indicator.remove();
  }

  _updateHighlight(items) {
    items.forEach((item, index) => {
      if (index === this.highlightedIndex) {
        item.classList.add("bg-gray-100");
        item.scrollIntoView({ block: "nearest" });
      } else {
        item.classList.remove("bg-gray-100");
      }
    });
  }

  _openDropdown() {
    this.dropdownTarget.classList.remove("hidden");
  }

  _closeDropdown() {
    this.dropdownTarget.classList.add("hidden");
    this.highlightedIndex = -1;
    this.currentPage = 0;
    this.hasMore = false;
    this.browseMode = false;
    if (this.currentSelectedId) {
      this.selectedDisplayTarget.classList.remove("hidden");
      this.inputTarget.classList.add("hidden");
      this.inputTarget.value = "";
    }
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) this._closeDropdown();
  }

  _escapeHtml(str) {
    const div = document.createElement("div");
    div.textContent = str;
    return div.innerHTML;
  }

  _escapeAttr(str) {
    return String(str)
      .replace(/&/g, "&amp;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
  }
}
