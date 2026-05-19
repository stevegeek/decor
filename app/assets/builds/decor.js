// app/javascript/controllers/decor/daisy/button_controller.js
import { Controller } from "@hotwired/stimulus";
var button_controller_default = class extends Controller {
  set disabled(disabled) {
    if (disabled) {
      this.element.setAttribute("disabled", "disabled");
    } else {
      this.element.removeAttribute("disabled");
    }
  }
};

// app/javascript/controllers/decor/daisy/click_to_copy_controller.js
import { Controller as Controller2 } from "@hotwired/stimulus";
var click_to_copy_controller_default = class extends Controller2 {
  static targets = ["content"];
  static values = { toCopy: String };
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
    if (this.hasToCopyValue && this.toCopyValue) {
      return this.toCopyValue;
    }
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
      const textarea = document.createElement("textarea");
      textarea.value = this.#getTextContent();
      textarea.style.position = "fixed";
      textarea.style.left = "-999999px";
      textarea.style.top = "-999999px";
      document.body.appendChild(textarea);
      textarea.focus();
      textarea.select();
      textarea.setSelectionRange(0, textarea.value.length);
      const success = document.execCommand("copy");
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
  }
  #showError() {
    console.error("Failed to copy to clipboard");
  }
};

// app/javascript/controllers/decor/daisy/code_block_controller.js
import { Controller as Controller3 } from "@hotwired/stimulus";
var code_block_controller_default = class extends Controller3 {
  static targets = ["code"];
  static values = {
    highlight: { type: Boolean, default: false },
    language: { type: String, default: "ruby" }
  };
  connect() {
    this.highlightCode();
  }
  async highlightCode() {
    if (!this.highlightValue) return;
    const targets = this.codeTargets.filter(
      (el) => el.dataset.highlighted !== "yes"
    );
    if (targets.length === 0) return;
    let HighlightJS;
    try {
      HighlightJS = (await import("@highlightjs/cdn-assets/es/highlight.min.js")).default;
    } catch (error) {
      console.warn("Failed to load highlight.js for code block:", error);
      return;
    }
    targets.forEach((codeElement) => {
      try {
        let result;
        if (this.languageValue) {
          result = HighlightJS.highlight(codeElement.textContent, { language: this.languageValue });
        } else {
          result = HighlightJS.highlightAuto(codeElement.textContent);
          if (result.language) {
            codeElement.classList.add(`language-${result.language}`);
          }
        }
        codeElement.innerHTML = result.value;
        codeElement.classList.add("decor:hljs");
        codeElement.dataset.highlighted = "yes";
      } catch (error) {
        console.warn("Failed to highlight code block:", error);
      }
    });
  }
};

// app/javascript/controllers/decor/daisy/dropdown_controller.js
import { Controller as Controller4 } from "@hotwired/stimulus";

// app/javascript/controllers/decor/http.js
function getCSRFToken() {
  const csrfMetaTag = document.head.querySelector('[name="csrf-token"]');
  return csrfMetaTag && csrfMetaTag.getAttribute("content") || "";
}
function getDefaultHeaders() {
  return {
    "X-CSRF-TOKEN": getCSRFToken()
  };
}
async function request(url, options = {}) {
  const defaultOptions = {
    headers: {
      ...getDefaultHeaders(),
      ...options.headers
    },
    credentials: "same-origin"
    // Include cookies for same-origin requests
  };
  const fetchOptions = { ...defaultOptions, ...options };
  try {
    const response = await fetch(url, fetchOptions);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return response;
  } catch (error) {
    throw error;
  }
}
async function get(url, options = {}) {
  return request(url, {
    method: "GET",
    ...options
  });
}
async function post(url, data, options = {}) {
  const headers = { ...options.headers };
  let body = data;
  if (data && typeof data === "object" && !(data instanceof FormData)) {
    headers["Content-Type"] = "application/json";
    body = JSON.stringify(data);
  }
  return request(url, {
    method: "POST",
    body,
    headers,
    ...options
  });
}
function createHTTPClient() {
  return {
    get: (url, config = {}) => {
      const { headers = {}, ...otherConfig } = config;
      return get(url, { headers, ...otherConfig }).then((response) => ({
        data: null,
        // Will be populated based on response type
        status: response.status,
        statusText: response.statusText,
        headers: response.headers,
        config,
        request: response,
        // Handle response data based on content type
        _processResponse: async () => {
          const contentType = response.headers.get("content-type");
          if (contentType && contentType.includes("application/json")) {
            return { ...response, data: await response.json() };
          } else {
            return { ...response, data: await response.text() };
          }
        }
      })).then((result) => result._processResponse());
    },
    post: (url, data, config = {}) => {
      const { headers = {}, ...otherConfig } = config;
      return post(url, data, { headers, ...otherConfig }).then((response) => ({
        data: null,
        status: response.status,
        statusText: response.statusText,
        headers: response.headers,
        config,
        request: response,
        _processResponse: async () => {
          const contentType = response.headers.get("content-type");
          if (contentType && contentType.includes("application/json")) {
            return { ...response, data: await response.json() };
          } else {
            return { ...response, data: await response.text() };
          }
        }
      })).then((result) => result._processResponse());
    }
  };
}

// app/javascript/controllers/decor.js
function replaceContentsWithChildren(parent, children) {
  emptyNode(parent);
  const childrenArray = Array.isArray(children) ? children : [children];
  const fragment = document.createDocumentFragment();
  childrenArray.forEach((child) => {
    fragment.appendChild(child);
  });
  parent.appendChild(fragment);
  return parent;
}
function emptyNode(node) {
  while (node.firstChild) {
    node.removeChild(node.firstChild);
  }
}
function markAsSafeHTML(html) {
  return {
    __safe: true,
    content: html
  };
}
function safelySetInnerHTML(el, { __safe, content }) {
  if (!__safe) {
    throw new Error(
      "This content could not be displayed as it has not been marked as safe. Content must be explicitly marked as safe to try and reduce the likelihood of a XSS attack."
    );
  }
  el.innerHTML = content;
}

// app/javascript/controllers/decor/daisy/dropdown_controller.js
var dropdown_controller_default = class extends Controller4 {
  constructor() {
    super(...arguments);
    this.shown = false;
  }
  static targets = ["menu", "button"];
  static values = {
    leaveTimeout: Number,
    contentHref: { type: String, default: null },
    placeholder: { type: String, default: null }
  };
  static classes = [
    "entering",
    "enteringFrom",
    "enteringTo",
    "leaving",
    "leavingFrom",
    "leavingTo"
  ];
  toggle(event) {
    if (this.shown) {
      this.hide();
    } else {
      this.show();
    }
  }
  hideOnClickOutside(event) {
    if (!this.shown) {
      return;
    }
    if (event && this.element.contains(event.target)) {
      return;
    }
    if (event && this.hasButtonTarget && this.buttonTarget.contains(event.target)) {
      return;
    }
    this.hide();
  }
  hide() {
    this.displayMenu(false);
    this.shown = false;
  }
  show() {
    this.prepareContent();
    this.displayMenu(true);
    this.shown = true;
  }
  displayMenu(state) {
    if (state) {
      this.menuTarget.classList.remove("decor:hidden");
      this.menuTarget.classList.add(...this.enteringClasses);
      this.menuTarget.classList.add(...this.enteringFromClasses);
      setTimeout(() => {
        this.menuTarget.classList.remove(...this.enteringFromClasses);
        this.menuTarget.classList.add(...this.enteringToClasses);
      }, 10);
    } else {
      this.menuTarget.classList.add(...this.leavingClasses);
      this.menuTarget.classList.add(...this.leavingFromClasses);
      setTimeout(() => {
        this.menuTarget.classList.remove(...this.leavingFromClasses);
        this.menuTarget.classList.add(...this.leavingToClasses);
      }, 10);
      setTimeout(() => {
        this.menuTarget.classList.add("decor:hidden");
        this.menuTarget.classList.remove(...this.enteringClasses, ...this.enteringToClasses, ...this.leavingClasses, ...this.leavingToClasses);
      }, this.leaveTimeoutValue || 75);
    }
  }
  async prepareContent() {
    if (this.placeholderValue) {
      this.setContent(markAsSafeHTML(this.placeholderValue));
    }
    if (this.contentHrefValue) {
      this.getContent(this.contentHrefValue).then((c) => {
        this.setContent(c);
      }).catch((err) => {
        console.error("Could not fetch content for dropdown", this.contentHrefValue, err);
        const errorMessage = "Something went wrong while loading the content for this dropdown. Please try again later.";
        this.setContent(markAsSafeHTML(errorMessage));
      });
    }
  }
  async getContent(contentHref) {
    const httpClient = createHTTPClient();
    return httpClient.get(contentHref, {
      headers: {
        "Content-Type": "text/html"
      }
    }).then((response) => {
      return markAsSafeHTML(response.data);
    });
  }
  setContent(content) {
    replaceContentsWithChildren(this.menuTarget, this.createContent(content));
  }
  createContent(content) {
    const contentContainer = document.createElement("div");
    contentContainer.id = `${this.element.id}-content`;
    safelySetInnerHTML(contentContainer, content);
    return contentContainer;
  }
};

// app/javascript/controllers/decor/daisy/flash_controller.js
import { Controller as Controller5 } from "@hotwired/stimulus";
var INITIAL_CLASSES = "decor:invisible decor:opacity-0";
var VISIBLE_CLASSES = "decor:transition-opacity decor:duration-300 decor:opacity-100 decor:visible";
var COLLAPSED_CLASS = "decor:hidden";
var TEXT_CLASS = "decor:text-sm";
var flash_controller_default = class extends Controller5 {
  static values = {
    showInitial: Boolean
  };
  connect() {
    this.hidden = true;
    if (this.showInitialValue) {
      this.hidden = false;
      this.reveal();
    }
  }
  showFlashMessage(text, timeout) {
    this.text = text;
    this.reveal(timeout);
  }
  reveal(timeout) {
    this.removeInitialClass();
    this.addVisibleClasses();
    this.removeCollapsedClasses();
    if (timeout) {
      setTimeout(() => this.hide(), timeout);
    }
    this.hidden = false;
    this.element.removeAttribute("hidden");
  }
  hide() {
    this.removeVisibleClasses();
    this.addInitialClasses();
    this.hidden = true;
    this.element.setAttribute("hidden", "hidden");
  }
  toggle() {
    if (this.hidden) {
      this.reveal();
    } else {
      this.hide();
    }
  }
  handleCloseEvent() {
    this.hide();
  }
  // Reveal by calling:
  // window.dispatchEvent(new CustomEvent("decor-flash:show", { detail: { message } }));
  async handleShowEvent(evt) {
    const { detail: { message, timeout } } = evt;
    this.showFlashMessage(message, timeout);
  }
  get isRevealed() {
    return !this.hidden;
  }
  set text(text) {
    const p = document.createElement("p");
    TEXT_CLASS.split(" ").forEach((cl) => p.classList.add(cl));
    p.textContent = text;
    this.content = p;
  }
  renderHeadingWithListContent(heading, items) {
    const headingNode = this.createHeading(heading);
    const listNode = document.createElement("ul");
    items.forEach((item) => {
      const listItemNode = document.createElement("li");
      listItemNode.textContent = item;
      listNode.appendChild(listItemNode);
    });
    this.content = [headingNode, listNode];
  }
  removeVisibleClasses() {
    VISIBLE_CLASSES.split(" ").forEach((cl) => this.element.classList.remove(cl));
  }
  addVisibleClasses() {
    VISIBLE_CLASSES.split(" ").forEach((cl) => this.element.classList.add(cl));
  }
  removeCollapsedClasses() {
    COLLAPSED_CLASS.split(" ").forEach((cl) => this.element.classList.remove(cl));
  }
  removeInitialClass() {
    INITIAL_CLASSES.split(" ").forEach((cl) => this.element.classList.remove(cl));
  }
  addInitialClasses() {
    INITIAL_CLASSES.split(" ").forEach((cl) => this.element.classList.add(cl));
  }
  createHeading(content) {
    const heading = document.createElement("h2");
    heading.classList.add("decor:c-h7");
    heading.textContent = content;
    return heading;
  }
  set content(children) {
    replaceContentsWithChildren(this.element, children);
  }
};

// app/javascript/controllers/decor/daisy/forms/date_calendar_controller.js
import { Controller as Controller6 } from "@hotwired/stimulus";
var date_calendar_controller_default = class extends Controller6 {
  static targets = ["calendar", "hiddenInput"];
  static values = {
    calendarType: { type: String, default: null },
    locale: { type: String, default: null },
    months: Number,
    disabledDates: Array,
    disabledDaysOfWeek: Array,
    enabledDates: Array,
    enabledDaysOfWeek: Array
  };
  connect() {
    this.setupCalendar();
  }
  setupCalendar() {
    if (!this.hasCalendarTarget) return;
    const calendar = this.calendarTarget;
    if (this.disabledDatesValue.length > 0 || this.disabledDaysOfWeekValue.length > 0) {
      calendar.isDateDisallowed = this.isDateDisallowed.bind(this);
    }
    calendar.addEventListener("change", this.handleChange.bind(this));
    if (this.calendarTypeValue === "range") {
      calendar.addEventListener("rangestart", this.handleRangeStart.bind(this));
      calendar.addEventListener("rangeend", this.handleRangeEnd.bind(this));
    }
    if (this.calendarTypeValue === "multi") {
      calendar.addEventListener("focusday", this.handleFocusDay.bind(this));
    }
  }
  handleChange(event) {
    if (!this.hasHiddenInputTarget) return;
    const calendar = event.target;
    const value = calendar.value;
    this.hiddenInputTarget.value = value || "";
    this.hiddenInputTarget.dispatchEvent(new Event("change", { bubbles: true }));
    if (this.onChangeCallback) {
      this.onChangeCallback(value);
    }
  }
  handleRangeStart(event) {
    console.debug("Range selection started:", event.detail);
  }
  handleRangeEnd(event) {
    console.debug("Range selection completed:", event.detail);
  }
  handleFocusDay(event) {
    console.debug("Focus day changed:", event.detail);
  }
  isDateDisallowed(date) {
    const dateObj = new Date(date);
    const dateString = dateObj.toISOString().split("T")[0];
    const dayOfWeek = dateObj.getDay();
    if (this.disabledDatesValue.length > 0) {
      if (this.disabledDatesValue.includes(dateString)) {
        return true;
      }
    }
    if (this.disabledDaysOfWeekValue.length > 0) {
      if (this.disabledDaysOfWeekValue.includes(dayOfWeek)) {
        return true;
      }
    }
    if (this.enabledDatesValue.length > 0) {
      if (!this.enabledDatesValue.includes(dateString)) {
        return true;
      }
    }
    if (this.enabledDaysOfWeekValue.length > 0 && this.enabledDaysOfWeekValue.length < 7) {
      if (!this.enabledDaysOfWeekValue.includes(dayOfWeek)) {
        return true;
      }
    }
    return false;
  }
  // Allow external code to set change callbacks
  setOnChangeCallback(callback) {
    this.onChangeCallback = callback;
  }
  // Programmatically set the calendar value
  setValue(value) {
    if (!this.hasCalendarTarget) return;
    this.calendarTarget.value = value;
    if (this.hasHiddenInputTarget) {
      this.hiddenInputTarget.value = value || "";
    }
  }
  // Get the current calendar value
  getValue() {
    if (!this.hasCalendarTarget) return null;
    return this.calendarTarget.value;
  }
  // Clear the calendar selection
  clear() {
    this.setValue("");
  }
  // Enable/disable the calendar
  setDisabled(disabled) {
    if (!this.hasCalendarTarget) return;
    if (disabled) {
      this.calendarTarget.setAttribute("disabled", "");
    } else {
      this.calendarTarget.removeAttribute("disabled");
    }
  }
};

// app/javascript/controllers/decor/daisy/forms/searchable_select_controller.js
import { Controller as Controller7 } from "@hotwired/stimulus";
var searchable_select_controller_default = class extends Controller7 {
  static targets = [
    "input",
    "dropdown",
    "selectedDisplay",
    "selectedLabel",
    "hiddenInputsContainer"
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
    fieldName: { type: String, default: "" }
  };
  initialize() {
    this.searchTimeout = null;
    this.selectedIds = /* @__PURE__ */ new Set();
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
      (c) => String(c.id) === String(id)
    );
    if (localMatch) {
      this._applySelectedDisplay(String(id), localMatch.label);
    } else if (this.searchUrlValue) {
      this._applySelectedDisplay(String(id), "");
      this.selectedLabelTarget.textContent = "Loading\u2026";
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
          items.length - 1
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
        if (this.highlightedIndex >= 0 && this.highlightedIndex < items.length) {
          this._selectFromElement(items[this.highlightedIndex]);
        }
        break;
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
    if (this.dropdownTarget.classList.contains("hidden") && this.inputTarget.value.trim() === "") {
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
        `${this.searchUrlValue}?${params.toString()}`
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
        this.dropdownTarget.innerHTML = '<p class="p-3 text-sm text-red-600">Search failed</p>';
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
      return choice.label.toLowerCase().includes(q) || choice.sublabel && choice.sublabel.toLowerCase().includes(q);
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
        this.dropdownTarget.innerHTML = '<p class="p-3 text-sm text-gray-500">No results found</p>';
        this._openDropdown();
        return;
      }
      this.dropdownTarget.innerHTML = "";
    }
    const html = filtered.map((r) => this._resultRowHtml(r)).join("");
    this.dropdownTarget.insertAdjacentHTML("beforeend", html);
    this._openDropdown();
  }
  _resultRowHtml(result) {
    const metadataAttr = result.metadata ? ` data-result-metadata="${this._escapeAttr(JSON.stringify(result.metadata))}"` : "";
    const sublabel = result.sublabel ? `<span class="text-xs text-gray-500 ml-2">${this._escapeHtml(result.sublabel)}</span>` : "";
    const rightLabel = result.right_label ? `<span class="text-xs text-gray-400 font-mono ml-3 shrink-0">${this._escapeHtml(result.right_label)}</span>` : "";
    return `<button type="button" class="w-full text-left px-4 py-2 hover:bg-gray-50 border-b last:border-b-0 flex justify-between items-center" data-result-id="${this._escapeAttr(String(result.id))}" data-result-label="${this._escapeAttr(result.label)}"${metadataAttr} data-action="click->${this.identifier}#selectResult"><div class="min-w-0"><span class="text-sm font-medium">${this._escapeHtml(result.label)}</span>${sublabel}</div>` + rightLabel + `</button>`;
  }
  _renderLoadingIndicator() {
    this._removeLoadingIndicator();
    const indicator = document.createElement("div");
    indicator.dataset.loadingIndicator = "true";
    indicator.className = "p-3 flex items-center justify-center gap-2 text-sm text-gray-400";
    indicator.textContent = "Loading\u2026";
    this.dropdownTarget.appendChild(indicator);
  }
  _removeLoadingIndicator() {
    const indicator = this.dropdownTarget.querySelector(
      "[data-loading-indicator]"
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
    return String(str).replace(/&/g, "&amp;").replace(/"/g, "&quot;").replace(/'/g, "&#39;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  }
};

// app/javascript/controllers/decor/daisy/forms/searchable_multi_select_controller.js
var searchable_multi_select_controller_default = class extends searchable_select_controller_default {
  static targets = [
    "input",
    "dropdown",
    "selectedContainer",
    "hiddenInputsContainer"
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
    delimiter: { type: String, default: "," }
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
    }
    this.handleClickOutside = this.handleClickOutside.bind(this);
    document.addEventListener("click", this.handleClickOutside);
    this.initialConnectDone = true;
  }
  // No single-selected-display chip in multi-select — every pick is a chip
  // in the selectedContainer. Drop the parent's programmatic-single-select
  // hook entirely.
  selectedItemValueChanged() {
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
      const hasHighlight = this.highlightedIndex >= 0 && this.highlightedIndex < items.length;
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
      `[data-item-id="${escapedId}"]`
    );
    if (pill) pill.remove();
    const hiddenInput = this.hiddenInputsContainerTarget.querySelector(
      `input[value="${escapedId}"]`
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
    this.suppressBrowseOnNextFocus = true;
    if (this.browseMode) {
      element.remove();
      const remaining = this.dropdownTarget.querySelectorAll("[data-result-id]");
      if (remaining.length === 0 && !this.hasMore) {
        this.dropdownTarget.innerHTML = '<p class="p-3 text-sm text-gray-500">No more items</p>';
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
      }
    }
    this.dispatch("selected", {
      detail: { id, label, metadata },
      bubbles: true
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
    const pills = this.selectedContainerTarget.querySelectorAll("[data-item-id]");
    if (pills.length === 0) return;
    const lastPill = pills[pills.length - 1];
    const itemId = this._parseResultId(lastPill.dataset.itemId);
    if (itemId === "") return;
    lastPill.remove();
    const escapedId = CSS.escape(String(itemId));
    const hiddenInput = this.hiddenInputsContainerTarget.querySelector(
      `input[value="${escapedId}"]`
    );
    if (hiddenInput) hiddenInput.remove();
    this.selectedIds.delete(itemId);
    this.dispatch("removed", { detail: { id: itemId }, bubbles: true });
  }
  _addPill(id, label) {
    const pill = document.createElement("span");
    pill.className = "decor:inline-flex decor:items-center decor:gap-1 decor:rounded-full decor:bg-primary/10 decor:text-primary decor:px-2 decor:py-px decor:text-xs decor:font-medium";
    pill.dataset.itemId = String(id);
    pill.innerHTML = `<span>${this._escapeHtml(label)}</span><button type="button" class="decor:text-primary decor:hover:opacity-70 decor:leading-none" data-action="click->${this.identifier}#removeItem" data-item-id="${this._escapeAttr(String(id))}"><svg xmlns="http://www.w3.org/2000/svg" class="decor:h-3 decor:w-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M18 6L6 18M6 6l12 12"/></svg></button>`;
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
};

// app/javascript/controllers/decor/daisy/forms/switch_controller.js
import { Controller as Controller8 } from "@hotwired/stimulus";
var switch_controller_default = class extends Controller8 {
  static targets = ["checkbox"];
  static values = {
    label: { type: String, default: null },
    confirmOnSubmit: { type: String, default: null },
    confirmOnSubmitYes: { type: String, default: null },
    confirmOnSubmitNo: { type: String, default: null },
    submitOnChange: Boolean
  };
  connect() {
    if (this.hasCheckboxTarget) {
      this.checkboxTarget.addEventListener("change", this.handleChange.bind(this));
    }
  }
  disconnect() {
    if (this.hasCheckboxTarget) {
      this.checkboxTarget.removeEventListener("change", this.handleChange.bind(this));
    }
  }
  handleChange(event) {
    if (this.submitOnChangeValue) {
      if (!this.confirmOnSubmitValue) {
        this.submitForm();
        return;
      }
      this.showConfirmationDialog();
    }
  }
  showConfirmationDialog() {
    const confirmMessage = this.confirmOnSubmitValue;
    const confirmLabel = this.confirmOnSubmitYesValue || "Confirm";
    const cancelLabel = this.confirmOnSubmitNoValue || "Cancel";
    if (window.confirm(`${confirmMessage}

Click OK to ${confirmLabel} or Cancel to ${cancelLabel}.`)) {
      this.submitForm();
    } else {
      this.revertSwitchState();
    }
  }
  submitForm() {
    const form = this.element.closest("form");
    if (form) {
      const submitEvent = new CustomEvent("decor:switch:beforesubmit", {
        bubbles: true,
        cancelable: true,
        detail: {
          switchElement: this.element,
          checked: this.hasCheckboxTarget ? this.checkboxTarget.checked : false
        }
      });
      if (this.element.dispatchEvent(submitEvent)) {
        form.submit();
      } else {
        this.revertSwitchState();
      }
    }
  }
  revertSwitchState() {
    if (this.hasCheckboxTarget) {
      this.checkboxTarget.removeEventListener("change", this.handleChange.bind(this));
      this.checkboxTarget.checked = !this.checkboxTarget.checked;
      this.checkboxTarget.addEventListener("change", this.handleChange.bind(this));
    }
  }
  // Public API methods
  get checked() {
    return this.hasCheckboxTarget ? this.checkboxTarget.checked : false;
  }
  set checked(value) {
    if (this.hasCheckboxTarget) {
      this.checkboxTarget.checked = Boolean(value);
    }
  }
  get disabled() {
    return this.hasCheckboxTarget ? this.checkboxTarget.disabled : false;
  }
  set disabled(value) {
    if (this.hasCheckboxTarget) {
      this.checkboxTarget.disabled = Boolean(value);
    }
  }
};

// app/javascript/controllers/decor/daisy/map_controller.js
import { Controller as Controller9 } from "@hotwired/stimulus";
var map_controller_default = class extends Controller9 {
  static targets = ["mapContainer"];
  static values = {
    apiKey: String,
    zoom: { type: String, default: null },
    points: Array,
    overlays: { type: String, default: null },
    center: { type: String, default: null },
    interactive: { type: Boolean, default: true },
    showControls: { type: Boolean, default: true },
    mapType: { type: String, default: "roadmap" }
  };
  connect() {
    this.loadingState = false;
    this.errorState = false;
    this.markers = [];
    this.overlays = [];
    this.mapsLibrary = null;
    this.markerLibrary = null;
    this.initializeGoogleMaps();
  }
  disconnect() {
    this.cleanup();
  }
  async initializeGoogleMaps() {
    try {
      console.log("Initializing Google Maps with modern API loading...");
      this.showLoadingState();
      const apiKey = this.apiKeyValue;
      if (!apiKey) {
        throw new Error("Google Maps API key is required");
      }
      await this.loadGoogleMapsAPI(apiKey);
      await this.loadRequiredLibraries();
      console.log("Google Maps libraries loaded successfully, proceeding to create map...");
      await this.createMap();
      await this.addOverlays();
      await this.addPoints();
      this.hideLoadingState();
    } catch (error) {
      this.handleError("Failed to initialize Google Maps", error);
    }
  }
  async loadGoogleMapsAPI(apiKey) {
    console.log("\u{1F50D} Checking if Google Maps is already loaded...");
    if (window.google && window.google.maps) {
      console.log("\u2705 Google Maps already loaded, skipping");
      return;
    }
    console.log("\u{1F4E5} Google Maps not loaded, initializing with modern approach...");
    return new Promise((resolve, reject) => {
      if (document.getElementById("google-maps-api-script")) {
        console.log("\u23F3 Script already loading, waiting...");
        const checkLoaded = () => {
          if (window.google && window.google.maps) {
            resolve();
          } else {
            setTimeout(checkLoaded, 100);
          }
        };
        checkLoaded();
        return;
      }
      const callbackName = `initGoogleMaps_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
      console.log(`\u{1F517} Setting up callback: ${callbackName}`);
      window[callbackName] = () => {
        console.log("\u2705 Google Maps bootstrap loaded via callback");
        delete window[callbackName];
        resolve();
      };
      const script = document.createElement("script");
      script.type = "text/javascript";
      script.async = true;
      script.defer = true;
      script.id = "google-maps-api-script";
      script.src = `https://maps.googleapis.com/maps/api/js?key=${encodeURIComponent(apiKey)}&callback=${callbackName}&v=weekly`;
      console.log("\u{1F4E1} Loading Google Maps bootstrap from:", script.src);
      script.onerror = (error) => {
        console.error("\u274C Failed to load Google Maps script:", error);
        delete window[callbackName];
        reject(new Error("Failed to load Google Maps API script"));
      };
      const timeout = setTimeout(() => {
        console.error("\u23F0 Timeout loading Google Maps API");
        delete window[callbackName];
        reject(new Error("Timeout loading Google Maps API"));
      }, 15e3);
      const originalCallback = window[callbackName];
      window[callbackName] = () => {
        clearTimeout(timeout);
        originalCallback();
      };
      const head = document.head || document.getElementsByTagName("head")[0];
      console.log("\u{1F4CE} Adding script to document head");
      head.appendChild(script);
    });
  }
  async loadRequiredLibraries() {
    try {
      this.mapsLibrary = await google.maps.importLibrary("maps");
      this.markerLibrary = await google.maps.importLibrary("marker");
    } catch (error) {
      throw new Error(`Failed to load Google Maps libraries: ${error.message}`);
    }
  }
  async createMap() {
    if (!this.mapContainerTarget) {
      throw new Error("Map container not found");
    }
    if (!this.mapsLibrary) {
      throw new Error("Maps library not loaded");
    }
    try {
      const mapOptions = {
        center: this.mapCenter,
        zoom: parseInt(this.zoomValue || "10", 10),
        disableDefaultUI: !this.showControlsValue,
        gestureHandling: this.interactiveValue ? "auto" : "none",
        mapTypeId: this.mapTypeIdValue || "roadmap"
      };
      this.googleMap = new this.mapsLibrary.Map(this.mapContainerTarget, mapOptions);
      this.googleMap.addListener("tilesloaded", () => {
        this.hideLoadingState();
      });
      this.googleMap.addListener("error", (error) => {
        this.handleError("Map tiles failed to load", error);
      });
    } catch (error) {
      throw new Error(`Failed to create map: ${error.message}`);
    }
  }
  async addPoints() {
    const pointsData = this.pointsValue;
    if (!pointsData || !Array.isArray(pointsData)) {
      return;
    }
    if (!this.markerLibrary) {
      console.warn("Marker library not loaded, skipping markers");
      return;
    }
    this.clearMarkers();
    for (const location of pointsData) {
      try {
        if (!this.isValidLocation(location)) {
          console.warn("Invalid location data:", location);
          continue;
        }
        const marker = new google.maps.Marker({
          position: {
            lat: parseFloat(location.lat),
            lng: parseFloat(location.lng)
          },
          title: this.sanitizeText(`${location.description || ""} (${location.name || ""})`),
          map: this.googleMap
        });
        if (location.description || location.name) {
          const infoWindow = new google.maps.InfoWindow({
            content: this.createInfoWindowContent(location)
          });
          marker.addListener("click", () => {
            this.closeAllInfoWindows();
            infoWindow.open(this.googleMap, marker);
            this.currentInfoWindow = infoWindow;
          });
        }
        this.markers.push(marker);
      } catch (error) {
        console.error("Failed to add marker:", error);
      }
    }
  }
  async addOverlays() {
    const overlaysData = this.overlaysValue;
    if (!overlaysData) {
      return;
    }
    this.clearOverlays();
    try {
      const regions = Array.isArray(overlaysData) ? overlaysData : JSON.parse(overlaysData);
      for (const region of regions) {
        try {
          if (!region.coordinates) {
            console.warn("Region missing coordinates:", region);
            continue;
          }
          const paths = region.coordinates.flatMap((polygon) => {
            return polygon.flatMap((path) => {
              return path.map((point) => {
                return new google.maps.LatLng(
                  parseFloat(point[1]),
                  parseFloat(point[0])
                );
              });
            });
          });
          const mapPolygon = new google.maps.Polygon({
            paths,
            strokeColor: "#FF0000",
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: "#FF0000",
            fillOpacity: 0.35
          });
          mapPolygon.setMap(this.googleMap);
          this.overlays.push(mapPolygon);
        } catch (error) {
          console.error("Failed to add overlay:", error);
        }
      }
    } catch (error) {
      console.error("Could not render the map overlays", error.message);
      this.handleError("Failed to render map overlays", error);
    }
  }
  get mapCenter() {
    const centerData = this.centerValue;
    if (!centerData) {
      return this.getDefaultCenter();
    }
    try {
      const center = typeof centerData === "string" ? JSON.parse(centerData) : centerData;
      if (!this.isValidLocation(center)) {
        console.warn("Invalid center coordinates, using default");
        return this.getDefaultCenter();
      }
      return {
        lat: parseFloat(center.lat),
        lng: parseFloat(center.lng)
      };
    } catch (error) {
      console.warn("Failed to parse center coordinates, using default:", error);
      return this.getDefaultCenter();
    }
  }
  getDefaultCenter() {
    return { lat: 37.7749, lng: -122.4194 };
  }
  // Security: Sanitize user input to prevent XSS
  sanitizeText(text) {
    if (!text || typeof text !== "string") return "";
    const div = document.createElement("div");
    div.textContent = text;
    return div.innerHTML;
  }
  // Create safe info window content
  createInfoWindowContent(location) {
    const content = document.createElement("div");
    content.className = "decor:map-info-window";
    if (location.name) {
      const title = document.createElement("h3");
      title.textContent = location.name;
      title.className = "decor:text-lg decor:font-semibold decor:mb-2";
      content.appendChild(title);
    }
    if (location.description) {
      const description = document.createElement("p");
      description.textContent = location.description;
      description.className = "decor:text-sm decor:text-gray-600";
      content.appendChild(description);
    }
    return content;
  }
  // Validation helper
  isValidLocation(location) {
    return location && typeof location.lat !== "undefined" && typeof location.lng !== "undefined" && !isNaN(parseFloat(location.lat)) && !isNaN(parseFloat(location.lng)) && isFinite(location.lat) && isFinite(location.lng);
  }
  // Loading state management
  showLoadingState() {
    this.loadingState = true;
    this.mapContainerTarget.classList.add("decor:map-loading");
    this.mapContainerTarget.setAttribute("aria-busy", "true");
  }
  hideLoadingState() {
    this.loadingState = false;
    this.mapContainerTarget.classList.remove("decor:map-loading");
    this.mapContainerTarget.removeAttribute("aria-busy");
  }
  // Enhanced error handling for modern API
  handleError(message, error = null) {
    this.errorState = true;
    this.hideLoadingState();
    console.error(message, error);
    let userMessage = "Failed to load map";
    if (error && error.message) {
      if (error.message.includes("API key")) {
        userMessage = "Invalid or missing API key";
      } else if (error.message.includes("quota") || error.message.includes("billing")) {
        userMessage = "API quota exceeded or billing issue";
      } else if (error.message.includes("network") || error.message.includes("load")) {
        userMessage = "Network error - please check connection";
      }
    }
    if (this.mapContainerTarget) {
      this.mapContainerTarget.classList.add("decor:map-error");
      this.mapContainerTarget.innerHTML = `
        <div class="decor:flex decor:items-center decor:justify-center decor:h-full decor:bg-gray-50 decor:text-gray-600">
          <div class="decor:text-center decor:p-4">
            <svg class="decor:mx-auto decor:h-12 decor:w-12 decor:text-gray-300 decor:mb-4" fill="none" stroke="currentColor" viewBox="0 0 48 48">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
            <p class="decor:text-sm decor:font-medium">${userMessage}</p>
            <p class="decor:text-xs decor:text-gray-500 decor:mt-2">Please check console for details</p>
          </div>
        </div>
      `;
    }
    this.dispatch("error", { detail: { message, error, userMessage } });
  }
  // Info window management
  closeAllInfoWindows() {
    if (this.currentInfoWindow) {
      this.currentInfoWindow.close();
      this.currentInfoWindow = null;
    }
  }
  // Cleanup helpers
  clearMarkers() {
    this.markers.forEach((marker) => {
      marker.setMap(null);
    });
    this.markers = [];
  }
  clearOverlays() {
    this.overlays.forEach((overlay) => {
      overlay.setMap(null);
    });
    this.overlays = [];
  }
  cleanup() {
    this.closeAllInfoWindows();
    this.clearMarkers();
    this.clearOverlays();
    if (this.googleMap) {
      this.googleMap = null;
    }
    this.mapsLibrary = null;
    this.markerLibrary = null;
    this.loadingState = false;
    this.errorState = false;
  }
  // Map type conversion helper
  get mapTypeIdValue() {
    const mapType = this.mapTypeValue || "roadmap";
    const typeMap = {
      "roadmap": "roadmap",
      "satellite": "satellite",
      "hybrid": "hybrid",
      "terrain": "terrain"
    };
    return typeMap[mapType] || "roadmap";
  }
};

// app/javascript/controllers/decor/daisy/modals/confirm_controller.js
import { Controller as Controller10 } from "@hotwired/stimulus";
var confirm_controller_default = class extends Controller10 {
  static values = {
    confirmEvent: { type: String, default: "" },
    modalId: { type: String, default: "" }
  };
  confirm(event) {
    event.preventDefault();
    if (this.confirmEventValue) {
      window.dispatchEvent(
        new CustomEvent(this.confirmEventValue, {
          bubbles: false,
          cancelable: false
        })
      );
    }
    const dialog = this.element.closest("dialog");
    if (dialog && typeof dialog.close === "function") {
      dialog.close();
    }
  }
};

// app/javascript/controllers/decor/daisy/modals/modal_controller.js
import { Controller as Controller11 } from "@hotwired/stimulus";
var ModalEvents;
(function(ModalEvents2) {
  ModalEvents2["Open"] = "decor--daisy--modals--modal:open";
  ModalEvents2["Opening"] = "decor--daisy--modals--modal:opening";
  ModalEvents2["Loading"] = "decor--daisy--modals--modal:loading";
  ModalEvents2["Loaded"] = "decor--daisy--modals--modal:loaded";
  ModalEvents2["Ready"] = "decor--daisy--modals--modal:ready";
  ModalEvents2["Opened"] = "decor--daisy--modals--modal:opened";
  ModalEvents2["Close"] = "decor--daisy--modals--modal:close";
  ModalEvents2["Closing"] = "decor--daisy--modals--modal:closing";
  ModalEvents2["Closed"] = "decor--daisy--modals--modal:closed";
})(ModalEvents || (ModalEvents = {}));
var modal_controller_default = class extends Controller11 {
  static targets = ["overlay", "modal"];
  static values = {
    showInitial: { type: Boolean, default: false },
    contentHref: { type: String, default: null },
    closeOnOverlayClick: { type: Boolean, default: false }
  };
  connect() {
    this.modalVisible = false;
    this.closeOnOverlayClick = false;
    this.pendingCloseReason = null;
    this.element.addEventListener("close", () => {
      if (this.modalVisible) {
        this.modalVisible = false;
        this.dispatchLifecycleEvent(ModalEvents.Closed, {
          closeReason: this.pendingCloseReason || "dialog-closed"
        });
        this.pendingCloseReason = null;
      }
    });
    if (this.showInitialValue) {
      this.open({
        contentHref: this.contentHrefValue
      });
    }
  }
  // Handle click on overlay to optionally close modal
  overlayClicked(event) {
    if (!this.closeOnOverlayClick && !this.closeOnOverlayClickValue) {
      event.preventDefault();
    }
    this.handleCloseEvent(event);
  }
  // Reveal the dialog by triggering event (with stimulus or directly) on window
  // > window.dispatchEvent(new CustomEvent('decor-modal:open', { detail: { message } }));
  handleCloseEvent(evt) {
    const action = evt.detail?.closeReason || evt.detail?.action;
    this.close(action);
  }
  // Reveal the dialog by calling:
  // window.dispatchEvent(new CustomEvent('decor-modal:show', { detail: { message } }));
  async handleOpenEvent(evt) {
    await this.open(evt.detail);
  }
  // Open the modal and load its content if needed
  async open(showOptions) {
    this.dispatchLifecycleEvent(ModalEvents.Opening, {
      shownWith: showOptions
    });
    await this.prepareModalAndLoad(showOptions);
    this.dispatchLifecycleEvent(ModalEvents.Opened, { shownWith: showOptions });
  }
  // Close the modal
  close(closeReason) {
    this.dispatchLifecycleEvent(ModalEvents.Closing, { closeReason });
    this.pendingCloseReason = closeReason;
    this.hide();
  }
  get isVisible() {
    return this.modalVisible;
  }
  async prepareModalAndLoad(shownWith) {
    const { contentHref, placeholder, closeOnOverlayClick } = shownWith;
    if (placeholder) {
      this.setContent(placeholder);
    }
    this.closeOnOverlayClick = !!closeOnOverlayClick;
    if (contentHref) {
      this.getContent(shownWith).then((c) => {
        this.setContent(c);
      }).catch((err) => {
        console.error("Could not fetch content for modal", contentHref, err);
        const errorMessage = "Something went wrong while loading the content. Please try again later.";
        this.closeOnOverlayClick = true;
        this.setContent(markAsSafeHTML(errorMessage));
      });
    }
    this.reveal();
  }
  reveal() {
    this.modalVisible = true;
    this.element.showModal();
  }
  hide() {
    this.modalVisible = false;
    this.element.close();
  }
  setContent(content) {
    this.replaceContents(this.modalTarget, this.createContent(content));
  }
  createContent(content) {
    const contentContainer = document.createElement("div");
    contentContainer.id = `${this.element.id}-content`;
    safelySetInnerHTML(contentContainer, content);
    return contentContainer;
  }
  replaceContents(target, content) {
    replaceContentsWithChildren(target, content);
  }
  async getContent(shownWith) {
    this.dispatchLifecycleEvent(ModalEvents.Loading, { shownWith });
    const httpClient = createHTTPClient();
    return httpClient.get(shownWith.contentHref, {
      headers: {
        "Content-Type": "text/html"
      }
    }).then((response) => {
      this.dispatchLifecycleEvent(ModalEvents.Loaded, { shownWith });
      return markAsSafeHTML(response.data);
    });
  }
  dispatchLifecycleEvent(type, detail) {
    const evt = new CustomEvent(type, {
      bubbles: true,
      cancelable: false,
      detail
    });
    console.debug(`Modal: dispatching ${type} event:`, detail);
    window.dispatchEvent(evt);
  }
};

// app/javascript/controllers/decor/daisy/modals/confirm_modal_controller.js
var ModalConfirmEvents;
(function(ModalConfirmEvents2) {
  ModalConfirmEvents2["Open"] = "decor--confirm-modal:open";
  ModalConfirmEvents2["Opening"] = "decor--confirm-modal:opening";
  ModalConfirmEvents2["Ready"] = "decor--confirm-modal:ready";
  ModalConfirmEvents2["Opened"] = "decor--confirm-modal:opened";
  ModalConfirmEvents2["Close"] = "decor--confirm-modal:close";
  ModalConfirmEvents2["Closing"] = "decor--confirm-modal:closing";
  ModalConfirmEvents2["Closed"] = "decor--confirm-modal:closed";
})(ModalConfirmEvents || (ModalConfirmEvents = {}));
var confirm_modal_controller_default = class extends modal_controller_default {
  static targets = [
    "overlay",
    "modal",
    "title",
    "message",
    "negativeButton",
    "positiveButton"
  ];
  negativeButton() {
    this.close(this.negativeButtonReason);
  }
  positiveButton() {
    this.close(this.positiveButtonReason);
  }
  // Override the base modal's open method to use confirm-specific events
  async open(showOptions) {
    this.dispatchLifecycleEvent(ModalConfirmEvents.Opening, {
      shownWith: showOptions
    });
    await this.prepareConfirmModalAndLoad(showOptions);
    this.dispatchLifecycleEvent(ModalConfirmEvents.Opened, {
      shownWith: showOptions
    });
  }
  // Override the base modal's close method to use confirm-specific events
  close(closeReason) {
    this.dispatchLifecycleEvent(ModalConfirmEvents.Closing, { closeReason });
    this.hide();
    this.dispatchLifecycleEvent(ModalConfirmEvents.Closed, { closeReason });
  }
  // Custom preparation method for confirm modals
  prepareConfirmModalAndLoad(showOptions) {
    const {
      title,
      message,
      messageHTML,
      defaultReason,
      positiveButtonLabel,
      positiveButtonReason,
      negativeButtonLabel,
      negativeButtonReason
    } = showOptions;
    this.closeOnOverlayClick = !!showOptions.closeOnOverlayClick;
    if (title) {
      this.titleTarget.innerText = title;
    }
    if (messageHTML) {
      safelySetInnerHTML(this.messageTarget, messageHTML);
    } else if (message) {
      this.messageTarget.innerText = message;
    }
    if (positiveButtonLabel) {
      this.positiveButtonTarget.innerText = positiveButtonLabel;
    }
    if (negativeButtonLabel) {
      this.negativeButtonTarget.innerText = negativeButtonLabel;
    }
    this.negativeButtonReason = negativeButtonReason;
    this.positiveButtonReason = positiveButtonReason;
    if (defaultReason) {
      if (defaultReason == this.negativeButtonReason) {
        this.negativeButtonTarget.focus();
      } else if (defaultReason == this.positiveButtonReason) {
        this.positiveButtonTarget.focus();
      }
    }
    this.reveal();
  }
};

// app/javascript/controllers/decor/daisy/modals/modal_close_button_controller.js
import { Controller as Controller12 } from "@hotwired/stimulus";
var modal_close_button_controller_default = class extends Controller12 {
  static values = {
    closeReason: String
  };
  handleButtonClick(event) {
    const reason = this.closeReasonValue;
    window.dispatchEvent(new CustomEvent("decor--daisy--modals--modal:close", {
      detail: { closeReason: reason ? reason : void 0 }
    }));
  }
};

// app/javascript/controllers/decor/daisy/modals/modal_open_button_controller.js
import { Controller as Controller13 } from "@hotwired/stimulus";
var modal_open_button_controller_default = class extends Controller13 {
  static values = {
    contentHref: String,
    initialContent: String,
    closeOnOverlayClick: Boolean
  };
  handleButtonClick(event) {
    event.preventDefault();
    window.dispatchEvent(new CustomEvent("decor--daisy--modals--modal:open", {
      detail: {
        contentHref: this.contentHrefValue,
        closeOnOverlayClick: this.closeOnOverlayClickValue,
        placeholder: this.initialContentValue ? markAsSafeHTML(this.initialContentValue) : void 0
      }
    }));
  }
};

// app/javascript/controllers/decor/daisy/modals/modal_trigger_controller.js
import { Controller as Controller14 } from "@hotwired/stimulus";
var modal_trigger_controller_default = class extends Controller14 {
  static values = {
    modalId: String,
    contentHref: String,
    initialContent: String,
    title: String,
    closeOnOverlayClick: Boolean
  };
  handleClick(event) {
    if (event.type === "keydown" && event.key !== "Enter" && event.key !== " ") return;
    event.preventDefault();
    window.dispatchEvent(new CustomEvent("decor--daisy--modals--modal:open", {
      detail: {
        id: this.modalIdValue || void 0,
        contentHref: this.contentHrefValue || void 0,
        closeOnOverlayClick: this.closeOnOverlayClickValue,
        placeholder: this.initialContentValue ? markAsSafeHTML(this.initialContentValue) : void 0,
        title: this.titleValue || void 0
      }
    }));
  }
};

// app/javascript/controllers/decor/daisy/notification_manager_controller.js
import { Controller as Controller15 } from "@hotwired/stimulus";
var NOTIFICATION_MANAGER_CLASS_NAME = "decor--daisy--notification-manager";
var NOTIFICATION_CLASSNAME = `${NOTIFICATION_MANAGER_CLASS_NAME}-notification`;
var DEFAULT_DISMISS_AFTER_MS = 3e3;
var DISMISS_ALL_STAGGER_MS = 50;
var notification_manager_controller_default = class extends Controller15 {
  static targets = ["notificationContainer"];
  static values = {
    initialNotifications: { type: Array, default: [] }
  };
  connect() {
    this.currentNotificationId = 0;
    this.activeNotifications = /* @__PURE__ */ new Map();
    this.initialNotificationsValue.forEach((notificationOptions) => {
      this.showNotification(notificationOptions);
    });
  }
  disconnect() {
    this.clearAllTimeouts();
  }
  async handleShowEvent(evt) {
    await this.showNotification(evt.detail);
  }
  async showNotification(options) {
    const { __safe, content, timeout, contentHref } = options;
    try {
      const notification = await this.createNotification(options, contentHref);
      const showTimeout = timeout !== void 0 ? timeout : DEFAULT_DISMISS_AFTER_MS;
      let timerId = null;
      if (showTimeout !== Infinity && showTimeout > 0) {
        timerId = setTimeout(() => this.dismissNotification(notification.id), showTimeout);
      }
      this.activeNotifications.set(notification.id, { element: notification, timerId });
      this.notificationContainerTarget.prepend(notification);
      this.setupDismissHandlers(notification);
    } catch (error) {
      console.error("Error showing notification:", error);
      this.showFallbackNotification();
    }
  }
  handleDismissAllEvent() {
    const notifications = Array.from(this.notificationContainerTarget.getElementsByClassName(NOTIFICATION_CLASSNAME));
    notifications.reverse().forEach((notification, idx) => {
      const notificationData = this.activeNotifications.get(notification.id);
      if (notificationData?.timerId) {
        clearTimeout(notificationData.timerId);
      }
      setTimeout(() => this.dismissNotification(notification.id), idx * DISMISS_ALL_STAGGER_MS);
    });
  }
  handleDismissSingleEvent(evt) {
    const { detail: { id } } = evt;
    this.dismissNotification(id);
  }
  nextNotificationId() {
    return `${NOTIFICATION_CLASSNAME}-${++this.currentNotificationId}`;
  }
  async createNotification(options, contentHref) {
    const notification = document.createElement("div");
    notification.id = this.nextNotificationId();
    notification.className = NOTIFICATION_CLASSNAME;
    if (contentHref) {
      const remoteContent = await this.getRemoteContent(`${contentHref}?notification_id=${notification.id}`);
      safelySetInnerHTML(notification, remoteContent);
    } else if (options.content) {
      safelySetInnerHTML(notification, options.content);
    } else if (options.__safe && options.content) {
      safelySetInnerHTML(notification, { __safe: options.__safe, content: options.content });
    }
    return notification;
  }
  async getRemoteContent(contentHref) {
    try {
      const httpClient = createHTTPClient();
      const response = await httpClient.get(contentHref, {
        headers: { "Content-Type": "text/html" }
      });
      return markAsSafeHTML(response.data);
    } catch (error) {
      console.warn("Error fetching remote content:", error);
      throw new Error("Failed to load notification content");
    }
  }
  setupDismissHandlers(notification) {
    const dismissHandler = () => this.dismissNotification(notification.id);
    notification.addEventListener("click", dismissHandler);
    notification.addEventListener("touchend", dismissHandler);
  }
  dismissNotification(notificationId) {
    const notificationData = this.activeNotifications.get(notificationId);
    if (!notificationData) return;
    const { element, timerId } = notificationData;
    if (timerId) clearTimeout(timerId);
    if (element && this.notificationContainerTarget.contains(element) && !element.dataset.dismissing) {
      element.dataset.dismissing = "true";
      element.style.opacity = "0";
      setTimeout(() => {
        this.removeNotification(element);
        this.activeNotifications.delete(notificationId);
      }, 150);
    }
  }
  removeNotification(element) {
    if (this.notificationContainerTarget.contains(element)) {
      element.remove();
    }
  }
  showFallbackNotification() {
    try {
      const notification = document.createElement("div");
      notification.id = this.nextNotificationId();
      notification.className = NOTIFICATION_CLASSNAME;
      notification.textContent = "Something went wrong while loading the notification. Please try again later.";
      this.notificationContainerTarget.prepend(notification);
      const dismissHandler = () => {
        if (this.notificationContainerTarget.contains(notification)) {
          notification.remove();
        }
      };
      notification.addEventListener("click", dismissHandler);
      notification.addEventListener("touchend", dismissHandler);
      setTimeout(dismissHandler, DEFAULT_DISMISS_AFTER_MS);
    } catch (error) {
      console.error("Failed to show fallback notification:", error);
    }
  }
  clearAllTimeouts() {
    this.activeNotifications.forEach(({ timerId }) => {
      if (timerId) clearTimeout(timerId);
    });
    this.activeNotifications.clear();
  }
};

// app/javascript/controllers/decor/daisy/progress_controller.js
import { Controller as Controller16 } from "@hotwired/stimulus";
var progress_controller_default = class extends Controller16 {
  static targets = ["progress", "step"];
  static values = {
    currentStep: { type: Number, default: 1 },
    totalSteps: Number,
    color: { type: String, default: "primary" }
  };
  connect() {
    this.updateProgress();
  }
  handleStepChanged(event) {
    const { currentStep, totalSteps } = event.detail;
    this.currentStepValue = currentStep;
    if (totalSteps) {
      this.totalStepsValue = totalSteps;
    }
    this.updateProgress();
  }
  // Update the progress based on current step
  updateProgress() {
    const progressPercentage = this.calculateProgressPercentage();
    if (this.hasProgressTarget) {
      this.updateProgressBar(progressPercentage);
    }
    if (this.hasStepTarget) {
      this.updateStepIndicators();
    }
    this.dispatch("updated", {
      detail: {
        currentStep: this.currentStepValue,
        percentage: progressPercentage,
        totalSteps: this.totalStepsValue
      }
    });
  }
  updateProgressBar(progressPercentage) {
    const progressBar = this.progressTarget;
    if (progressBar) {
      progressBar.value = progressPercentage;
      progressBar.setAttribute("aria-label", `Progress: ${progressPercentage}% complete`);
      progressBar.classList.add("decor:transition-all", "decor:duration-300");
    }
  }
  // Update step visual states
  updateStepIndicators() {
    const steps = this.stepTargets;
    steps.forEach((step, index) => {
      const stepNumber = index + 1;
      step.classList.remove(
        "decor:d-step-primary",
        "decor:d-step-secondary",
        "decor:d-step-accent",
        "decor:d-step-success",
        "decor:d-step-error",
        "decor:d-step-warning",
        "decor:d-step-info"
      );
      if (stepNumber <= this.currentStepValue) {
        step.classList.add(`step-${this.colorValue}`);
      }
      if (stepNumber < this.currentStepValue) {
        step.setAttribute("data-content", "\u2713");
      } else if (step.hasAttribute("data-content") && step.getAttribute("data-content") === "\u2713") {
        step.setAttribute("data-content", stepNumber.toString());
      }
    });
  }
  // Calculate progress percentage
  calculateProgressPercentage() {
    if (this.currentStepValue <= 0) return 0;
    if (this.currentStepValue > this.totalStepsValue) return 100;
    return Math.round(this.currentStepValue / this.totalStepsValue * 100);
  }
  // Public methods for external control
  setStep(step) {
    this.currentStepValue = Math.max(0, Math.min(step, this.totalStepsValue + 1));
    this.updateProgress();
  }
  nextStep() {
    if (this.currentStepValue < this.totalStepsValue + 1) {
      this.currentStepValue++;
      this.updateProgress();
    }
  }
  previousStep() {
    if (this.currentStepValue > 0) {
      this.currentStepValue--;
      this.updateProgress();
    }
  }
  reset() {
    this.currentStepValue = 1;
    this.updateProgress();
  }
  complete() {
    this.currentStepValue = this.totalStepsValue + 1;
    this.updateProgress();
  }
};

// app/javascript/controllers/decor/daisy/tabs_controller.js
import { Controller as Controller17 } from "@hotwired/stimulus";
var tabs_controller_default = class extends Controller17 {
  handleSelectTabOnMobile(event) {
    const select = event.target;
    const selected = select.options[select.selectedIndex];
    const href = selected.getAttribute("data-href");
    if (href) {
      window.location.href = href;
    }
  }
};

// app/javascript/controllers/decor/progress_animation_controller.js
import { Controller as Controller18 } from "@hotwired/stimulus";
var progress_animation_controller_default = class extends Controller18 {
  static values = {
    currentStep: { type: Number, default: 2 },
    steps: { type: Number, default: 5 },
    speed: { type: Number, default: 2e3 },
    // milliseconds between steps
    direction: { type: String, default: "forward" }
    // "forward" or "reverse"
  };
  connect() {
    this.currentStep = this.currentStepValue;
    this.isForward = this.directionValue === "forward";
    this.startAnimation();
  }
  disconnect() {
    this.stopAnimation();
  }
  startAnimation() {
    this.stopAnimation();
    this.interval = setInterval(() => {
      this.updateProgress();
    }, this.speedValue);
  }
  stopAnimation() {
    if (this.interval) {
      clearInterval(this.interval);
      this.interval = null;
    }
  }
  updateProgress() {
    if (this.isForward) {
      this.currentStep++;
      if (this.currentStep > this.stepsValue) {
        this.currentStep = this.stepsValue;
        this.isForward = false;
      }
    } else {
      this.currentStep--;
      if (this.currentStep < 1) {
        this.currentStep = 1;
        this.isForward = true;
      }
    }
    console.log(`Dispatch: Current Step: ${this.currentStep}, Total Steps: ${this.stepsValue}`);
    this.dispatch("changed", {
      detail: {
        prefix: "decor--progress-animation",
        currentStep: this.currentStep,
        totalSteps: this.stepsValue
      }
    });
  }
  // Allow manual control
  pause() {
    this.stopAnimation();
  }
  resume() {
    this.startAnimation();
  }
  reset() {
    this.currentStep = 1;
    this.isForward = true;
    this.updateProgress();
  }
};

// app/javascript/controllers/decor/suite/carousel_controller.js
import { Controller as Controller19 } from "@hotwired/stimulus";
import Swiper from "swiper";
import { Navigation, Pagination, Keyboard, A11y, Autoplay } from "swiper/modules";
var BREAKPOINT_PX = {
  base: 0,
  sm: 640,
  md: 768,
  lg: 1024,
  xl: 1280,
  "2xl": 1536
};
var carousel_controller_default = class extends Controller19 {
  static values = {
    slidesPerView: { type: Object, default: {} },
    spaceBetween: { type: Number, default: 16 },
    loop: { type: Boolean, default: false },
    showPagination: { type: Boolean, default: true },
    showArrows: { type: Boolean, default: true },
    autoplayDelay: { type: Number, default: 0 }
  };
  connect() {
    this.element.classList.remove("decor:hidden");
    this.element.classList.remove("hidden");
    const config = {
      modules: [Navigation, Pagination, Keyboard, A11y, Autoplay],
      spaceBetween: this.spaceBetweenValue,
      centeredSlides: true,
      loop: this.loopValue,
      keyboard: { enabled: true, onlyInViewport: true },
      a11y: {
        enabled: true,
        prevSlideMessage: "Previous slide",
        nextSlideMessage: "Next slide",
        paginationBulletMessage: "Go to slide {{index}}"
      },
      ...this.#slidesPerViewConfig()
    };
    if (this.showArrowsValue) {
      config.navigation = {
        prevEl: this.element.querySelector(".swiper-button-prev"),
        nextEl: this.element.querySelector(".swiper-button-next"),
        disabledClass: "swiper-button-disabled"
      };
    }
    if (this.showPaginationValue) {
      config.pagination = {
        el: this.element.querySelector(".swiper-pagination"),
        clickable: true
      };
    }
    if (this.autoplayDelayValue > 0) {
      config.autoplay = {
        delay: this.autoplayDelayValue,
        pauseOnMouseEnter: true,
        disableOnInteraction: false
      };
    }
    this.carousel = new Swiper(this.element, config);
  }
  disconnect() {
    if (this.carousel) {
      this.carousel.destroy();
      this.carousel = void 0;
    }
  }
  // Translates the `slidesPerView` value into a Swiper-compatible config:
  // - Number → { slidesPerView: N }
  // - Hash { base: 1, md: 2 } → { slidesPerView: 1, breakpoints: { 768: { slidesPerView: 2 } } }
  // - Empty/missing → sensible default
  #slidesPerViewConfig() {
    const val = this.slidesPerViewValue;
    if (typeof val === "number" && val > 0) {
      return { slidesPerView: val };
    }
    if (val && typeof val === "object" && !Array.isArray(val)) {
      const entries = Object.entries(val);
      if (entries.length === 0) {
        return { slidesPerView: window.innerWidth > 600 ? 3 : 1.25 };
      }
      const base = val.base ?? val.sm ?? Object.values(val)[0];
      const breakpoints = {};
      for (const [key, count] of entries) {
        if (key === "base") continue;
        const px = BREAKPOINT_PX[key];
        if (typeof px === "number" && px > 0) {
          breakpoints[px] = { slidesPerView: count };
        }
      }
      return { slidesPerView: base, breakpoints };
    }
    return { slidesPerView: window.innerWidth > 600 ? 3 : 1.25 };
  }
};

// app/javascript/controllers/decor/suite/dropdown_controller.js
import { Controller as Controller20 } from "@hotwired/stimulus";
var dropdown_controller_default2 = class extends Controller20 {
  static targets = ["menu", "button"];
  static values = {
    contentHref: { type: String, default: "" },
    placeholder: { type: String, default: "" }
  };
  toggle() {
    if (this.hasMenuTarget) this.menuTarget.togglePopover();
  }
  show() {
    if (this.hasMenuTarget) this.menuTarget.showPopover();
  }
  hide() {
    if (this.hasMenuTarget) this.menuTarget.hidePopover();
  }
  // ── Lazy-load: fires on every open (matches current behavior) ──
  handleBeforeToggle(event) {
    if (event.newState !== "open") return;
    this.prepareContent();
  }
  async prepareContent() {
    if (this.placeholderValue) {
      this.setContent(markAsSafeHTML(this.placeholderValue));
    }
    if (this.contentHrefValue) {
      try {
        const c = await this.getContent(this.contentHrefValue);
        this.setContent(c);
      } catch (err) {
        console.error("Could not fetch content for dropdown", this.contentHrefValue, err);
        const errorMessage = "Something went wrong while loading the content for this dropdown. Please try again later.";
        this.setContent(markAsSafeHTML(errorMessage));
      }
    }
  }
  async getContent(href) {
    const httpClient = createHTTPClient();
    return httpClient.get(href, { headers: { "Content-Type": "text/html" } }).then((response) => markAsSafeHTML(response.data));
  }
  setContent(content) {
    replaceContentsWithChildren(this.menuTarget, this.createContent(content));
  }
  createContent(content) {
    const container = document.createElement("div");
    container.id = `${this.element.id}-content`;
    safelySetInnerHTML(container, content);
    return container;
  }
};

// app/javascript/controllers/decor/suite/forms/form_controller.js
import { Controller as Controller21 } from "@hotwired/stimulus";
var form_controller_default = class extends Controller21 {
  static targets = ["form"];
  connect() {
    this.element.setAttribute("novalidate", "true");
  }
  disconnect() {
    this.element.removeAttribute("novalidate");
  }
  handleSubmitEvent(evt) {
    const submitter = evt.submitter;
    if (submitter) {
      if (!this.element.contains(submitter)) return;
    } else {
      const target = evt.target;
      if (target !== this.element && !this.element.contains(target)) return;
    }
    if (this.performValidation()) {
      evt.preventDefault();
      evt.stopPropagation();
      evt.stopImmediatePropagation();
    }
  }
  handleCustomSubmitEvent(evt) {
    evt.stopPropagation();
    const onPrevented = evt.detail && evt.detail.onSubmissionPrevented;
    if (this.performValidation()) {
      if (typeof onPrevented === "function") onPrevented();
    } else {
      this.element.submit();
    }
  }
  handleValidateFieldsEvent(evt) {
    evt.stopPropagation();
    const onValidated = evt.detail && evt.detail.onValidated;
    const invalid = this.performValidation();
    if (typeof onValidated === "function") onValidated(!invalid);
  }
  // Returns true if at least one field is invalid.
  performValidation() {
    const fields = this.fieldControllers();
    const invalidFields = [];
    const errorMessages = [];
    fields.forEach((fc) => {
      if (fc.disabled) return;
      let result;
      try {
        result = fc.validate();
      } catch (e) {
        return;
      }
      if (!result || result.valid) return;
      invalidFields.push(fc);
      if (Array.isArray(result.errors)) {
        result.errors.forEach((err) => errorMessages.push(err));
      }
    });
    const hasInvalid = invalidFields.length > 0;
    this.dispatch("validated", {
      bubbles: true,
      cancelable: false,
      detail: { errors: errorMessages, valid: !hasInvalid }
    });
    if (hasInvalid && typeof invalidFields[0].focusControl === "function") {
      invalidFields[0].focusControl();
    }
    return hasInvalid;
  }
  // Discover all form-field Stimulus controllers inside this form by walking
  // descendants and consulting the Stimulus application for each matching
  // controller identifier on the element. Skips anything outside this form.
  fieldControllers() {
    const out = [];
    const elements = this.element.querySelectorAll("[data-controller]");
    elements.forEach((el) => {
      const ids = (el.getAttribute("data-controller") || "").split(/\s+/);
      ids.forEach((id) => {
        if (!/forms--/.test(id)) return;
        if (id.endsWith("--form")) return;
        const ctrl = this.application.getControllerForElementAndIdentifier(el, id);
        if (ctrl && typeof ctrl.validate === "function") out.push(ctrl);
      });
    });
    return out;
  }
};

// app/javascript/controllers/decor/suite/forms/searchable_multi_select_controller.js
var searchable_multi_select_controller_default2 = class extends searchable_multi_select_controller_default {
  _resultRowHtml(result) {
    const metadataAttr = result.metadata ? ` data-result-metadata="${this._escapeAttr(JSON.stringify(result.metadata))}"` : "";
    const sublabel = result.sublabel ? `<span class="decor:suite-description decor:text-gray-500 decor:ml-2">${this._escapeHtml(result.sublabel)}</span>` : "";
    const rightLabel = result.right_label ? `<span class="decor:suite-description decor:text-gray-400 decor:ml-3 decor:shrink-0">${this._escapeHtml(result.right_label)}</span>` : "";
    return `<button type="button" class="decor:w-full decor:text-left decor:px-3 decor:py-2 decor:hover:bg-suite-gray-25 decor:border-b decor:border-suite-hairline decor:last:border-b-0 decor:flex decor:justify-between decor:items-center decor:cursor-pointer" data-result-id="${this._escapeAttr(String(result.id))}" data-result-label="${this._escapeAttr(result.label)}"${metadataAttr} data-action="click->${this.identifier}#selectResult" role="option"><div class="decor:min-w-0"><span class="decor:suite-body decor:text-gray-900">${this._escapeHtml(result.label)}</span>${sublabel}</div>` + rightLabel + `</button>`;
  }
  _updateHighlight(items) {
    items.forEach((item, index) => {
      if (index === this.highlightedIndex) {
        item.classList.add("decor:bg-suite-primary-50");
        item.scrollIntoView({ block: "nearest" });
      } else {
        item.classList.remove("decor:bg-suite-primary-50");
      }
    });
  }
  _renderLoadingIndicator() {
    this._removeLoadingIndicator();
    const indicator = document.createElement("div");
    indicator.dataset.loadingIndicator = "true";
    indicator.className = "decor:p-3 decor:flex decor:items-center decor:justify-center decor:gap-2 decor:suite-description decor:text-gray-400";
    indicator.textContent = "Loading\u2026";
    this.dropdownTarget.appendChild(indicator);
  }
  _addPill(id, label) {
    const pill = document.createElement("span");
    pill.className = "decor:inline-flex decor:items-center decor:gap-1 decor:rounded-full decor:bg-suite-primary-50 decor:px-2 decor:py-px decor:suite-description decor:font-medium";
    pill.dataset.itemId = String(id);
    pill.innerHTML = `<span class="decor:suite-body decor:text-suite-primary-700">${this._escapeHtml(label)}</span><button type="button" class="decor:text-suite-primary-600 decor:hover:text-suite-primary-700 decor:leading-none decor:transition-colors decor:duration-suite-fast" data-action="click->${this.identifier}#removeItem" data-item-id="${this._escapeAttr(String(id))}"><svg xmlns="http://www.w3.org/2000/svg" class="decor:h-3 decor:w-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M18 6L6 18M6 6l12 12"/></svg></button>`;
    this.selectedContainerTarget.appendChild(pill);
  }
};

// app/javascript/controllers/decor/suite/forms/searchable_select_controller.js
var searchable_select_controller_default2 = class extends searchable_select_controller_default {
  _resultRowHtml(result) {
    const metadataAttr = result.metadata ? ` data-result-metadata="${this._escapeAttr(JSON.stringify(result.metadata))}"` : "";
    const sublabel = result.sublabel ? `<span class="decor:suite-description decor:text-gray-500 decor:ml-2">${this._escapeHtml(result.sublabel)}</span>` : "";
    const rightLabel = result.right_label ? `<span class="decor:suite-description decor:text-gray-400 decor:ml-3 decor:shrink-0">${this._escapeHtml(result.right_label)}</span>` : "";
    return `<button type="button" class="decor:w-full decor:text-left decor:px-3 decor:py-2 decor:hover:bg-suite-gray-25 decor:border-b decor:border-suite-hairline decor:last:border-b-0 decor:flex decor:justify-between decor:items-center decor:cursor-pointer" data-result-id="${this._escapeAttr(String(result.id))}" data-result-label="${this._escapeAttr(result.label)}"${metadataAttr} data-action="click->${this.identifier}#selectResult" role="option"><div class="decor:min-w-0"><span class="decor:suite-body decor:text-gray-900">${this._escapeHtml(result.label)}</span>${sublabel}</div>` + rightLabel + `</button>`;
  }
  _updateHighlight(items) {
    items.forEach((item, index) => {
      if (index === this.highlightedIndex) {
        item.classList.add("decor:bg-suite-primary-50");
        item.scrollIntoView({ block: "nearest" });
      } else {
        item.classList.remove("decor:bg-suite-primary-50");
      }
    });
  }
  _renderLoadingIndicator() {
    this._removeLoadingIndicator();
    const indicator = document.createElement("div");
    indicator.dataset.loadingIndicator = "true";
    indicator.className = "decor:p-3 decor:flex decor:items-center decor:justify-center decor:gap-2 decor:suite-description decor:text-gray-400";
    indicator.textContent = "Loading\u2026";
    this.dropdownTarget.appendChild(indicator);
  }
};

// app/javascript/controllers/decor/suite/modals/confirm_controller.js
import { Controller as Controller22 } from "@hotwired/stimulus";
var confirm_controller_default2 = class extends Controller22 {
  static values = {
    confirmEvent: { type: String, default: "" },
    modalId: { type: String, default: "" }
  };
  confirm(event) {
    event.preventDefault();
    if (this.confirmEventValue) {
      window.dispatchEvent(
        new CustomEvent(this.confirmEventValue, {
          bubbles: false,
          cancelable: false
        })
      );
    }
    window.dispatchEvent(
      new CustomEvent("decor--suite--modals--modal:close", {
        detail: { id: this.modalIdValue || void 0 }
      })
    );
  }
};

// app/javascript/controllers/decor/suite/modals/modal_close_button_controller.js
import { Controller as Controller23 } from "@hotwired/stimulus";
var modal_close_button_controller_default2 = class extends Controller23 {
  static values = {
    closeReason: String
  };
  handleButtonClick(event) {
    const reason = this.closeReasonValue;
    window.dispatchEvent(new CustomEvent("decor--suite--modals--modal:close", {
      detail: { closeReason: reason ? reason : void 0 }
    }));
  }
};

// app/javascript/controllers/decor/suite/modals/modal_controller.js
import { Controller as Controller24 } from "@hotwired/stimulus";
var LOADING_SKELETON_HTML = `
  <div class="decor:space-y-2 decor:py-1" aria-hidden="true">
    <div class="decor:h-3 decor:bg-gray-100 decor:rounded-sm decor:animate-pulse"></div>
    <div class="decor:h-3 decor:bg-gray-100 decor:rounded-sm decor:animate-pulse decor:w-5/6"></div>
    <div class="decor:h-3 decor:bg-gray-100 decor:rounded-sm decor:animate-pulse decor:w-3/4"></div>
  </div>
`;
var OPENED_EVENT = "decor--suite--modals--modal:opened";
var CLOSED_EVENT = "decor--suite--modals--modal:closed";
var modal_controller_default2 = class extends Controller24 {
  static targets = ["body", "overlay", "modal"];
  static values = {
    startOpen: { type: Boolean, default: false },
    showInitial: { type: Boolean, default: false },
    closeable: { type: Boolean, default: true },
    contentHref: { type: String, default: "" },
    closeOnOverlayClick: { type: Boolean, default: false }
  };
  connect() {
    if (this.dialog.closest("form")) {
      document.body.appendChild(this.dialog);
    }
    this.dialog.addEventListener("close", this.boundHandleClose);
    this.dialog.addEventListener("cancel", this.boundHandleCancel);
    if (this.startOpenValue || this.showInitialValue) {
      requestAnimationFrame(() => this.open());
    }
  }
  disconnect() {
    this.dialog.removeEventListener("close", this.boundHandleClose);
    this.dialog.removeEventListener("cancel", this.boundHandleCancel);
  }
  // ── Public API ────────────────────────────────────────────────────────
  open() {
    if (typeof this.dialog.showModal === "function") {
      this.dialog.showModal();
    } else {
      this.dialog.setAttribute("open", "");
    }
    requestAnimationFrame(() => {
      this.dispatchOnDialog(OPENED_EVENT);
    });
  }
  close(reason) {
    if (typeof this.dialog.close === "function") {
      this.dialog.close(reason || "");
    } else {
      this.dialog.removeAttribute("open");
      this.dispatchOnDialog(CLOSED_EVENT, { reason: reason || "" });
    }
  }
  // ── Window event handlers (auto-bound by Vident's stimulus actions) ───
  handleOpenEvent(evt) {
    const detail = evt && evt.detail || {};
    if (detail.id && detail.id !== this.element.id) return;
    if (!detail.id && !this.dialog.open) return;
    const href = detail.content_href || detail.contentHref || this.contentHrefValue || "";
    if (detail.title) {
      const titleEl = this.element.querySelector(".cf-modal__title");
      if (titleEl) titleEl.textContent = detail.title;
    }
    const bodyEl = this.resolveBodyElement();
    const placeholder = detail.initial_content || detail.placeholder;
    if (placeholder && bodyEl) {
      safelySetInnerHTML(bodyEl, placeholder);
    } else if (href && bodyEl) {
      this.showLoadingSkeleton(bodyEl);
    }
    this.resetFooterMarkers();
    this.open();
    if (href) {
      this.fetchAndInjectBody(href);
    }
  }
  handleCloseEvent(evt) {
    const detail = evt && evt.detail || {};
    if (detail.id && detail.id !== this.element.id) return;
    const reason = detail.close_reason || detail.closeReason || detail.action || "";
    this.close(reason);
  }
  // ── Native dialog event handlers ──────────────────────────────────────
  boundHandleClose = () => {
    const reason = this.dialog.returnValue || "";
    this.dispatchOnDialog(CLOSED_EVENT, { reason, closeReason: reason });
  };
  boundHandleCancel = (evt) => {
    if (!this.closeableValue) {
      evt.preventDefault();
    }
  };
  // ── Content loading ───────────────────────────────────────────────────
  fetchAndInjectBody(href) {
    const httpClient = createHTTPClient();
    httpClient.get(href, { headers: { "Content-Type": "text/html" } }).then((response) => {
      this.setBodyContent(markAsSafeHTML(response.data));
    }).catch((err) => {
      console.error("Modal: could not fetch content", href, err);
      this.setBodyContent(
        markAsSafeHTML("Something went wrong while loading the content. Please try again later.")
      );
    });
  }
  setBodyContent(content) {
    this.clearLoadingState();
    const fragment = this.parseModalFragment(content);
    if (fragment) {
      this.replaceModalChildren(fragment);
      return;
    }
    const target = this.resolveBodyElement() || this.element;
    safelySetInnerHTML(target, content);
    this.applyFooterMarkers(target);
  }
  // ── Footer marker protocol ────────────────────────────────────────────
  //
  // Fragments that load into a Modal may emit <template> markers to
  // reconfigure the footer based on server-side state only knowable
  // after the body loads:
  //
  //   <template data-modal-destructive-action>…rendered button…</template>
  //     → cloned into .cf-modal__destructive-slot (left-pinned in footer)
  //
  //   <template data-modal-hide-submit></template>
  //     → footer Submit button gets display:none
  //
  // Markers are removed from the body after processing. The reset step on
  // every open ensures stale footer state from a previous row never lingers.
  resetFooterMarkers() {
    const slot = this.element.querySelector(".cf-modal__destructive-slot");
    if (slot) slot.replaceChildren();
    const submit = this.element.querySelector(".cf-modal__footer button[type=submit]");
    if (submit) submit.style.display = "";
  }
  applyFooterMarkers(bodyEl) {
    const slot = this.element.querySelector(".cf-modal__destructive-slot");
    if (slot) {
      const destrTpl = bodyEl.querySelector("template[data-modal-destructive-action]");
      if (destrTpl) {
        slot.replaceChildren(destrTpl.content.cloneNode(true));
        destrTpl.remove();
      } else {
        slot.replaceChildren();
      }
    }
    const submit = this.element.querySelector(".cf-modal__footer button[type=submit]");
    if (submit) {
      const hideTpl = bodyEl.querySelector("template[data-modal-hide-submit]");
      if (hideTpl) {
        submit.style.display = "none";
        hideTpl.remove();
      } else {
        submit.style.display = "";
      }
    }
  }
  // ── Helpers ───────────────────────────────────────────────────────────
  resolveBodyElement() {
    if (this.hasBodyTarget) return this.bodyTarget;
    return this.element.querySelector(".cf-modal__body");
  }
  showLoadingSkeleton(bodyEl) {
    this.element.setAttribute("aria-busy", "true");
    this.element.classList.add("cf-modal--loading");
    safelySetInnerHTML(bodyEl, markAsSafeHTML(LOADING_SKELETON_HTML));
  }
  clearLoadingState() {
    this.element.removeAttribute("aria-busy");
    this.element.classList.remove("cf-modal--loading");
  }
  parseModalFragment(content) {
    if (!content.__safe) return null;
    const tpl = document.createElement("template");
    tpl.innerHTML = content.content;
    const topLevel = Array.from(tpl.content.children);
    if (topLevel.length !== 1) return null;
    const root = topLevel[0];
    if (root instanceof HTMLDialogElement && root.classList.contains("cf-modal")) {
      return root;
    }
    return null;
  }
  replaceModalChildren(innerDialog) {
    safelySetInnerHTML(this.element, {
      __safe: true,
      content: innerDialog.innerHTML
    });
  }
  get dialog() {
    return this.element;
  }
  dispatchOnDialog(type, detail) {
    this.element.dispatchEvent(
      new CustomEvent(type, { bubbles: true, cancelable: false, detail: detail || {} })
    );
  }
};

// app/javascript/controllers/decor/suite/modals/modal_open_button_controller.js
import { Controller as Controller25 } from "@hotwired/stimulus";
var modal_open_button_controller_default2 = class extends Controller25 {
  static values = {
    modalId: String,
    contentHref: String,
    initialContent: String,
    title: String,
    closeOnOverlayClick: Boolean
  };
  handleButtonClick(event) {
    event.preventDefault();
    window.dispatchEvent(new CustomEvent("decor--suite--modals--modal:open", {
      detail: {
        id: this.modalIdValue || void 0,
        content_href: this.contentHrefValue || void 0,
        contentHref: this.contentHrefValue || void 0,
        initial_content: this.initialContentValue ? markAsSafeHTML(this.initialContentValue) : void 0,
        placeholder: this.initialContentValue ? markAsSafeHTML(this.initialContentValue) : void 0,
        title: this.titleValue || void 0,
        closeOnOverlayClick: this.closeOnOverlayClickValue
      }
    }));
  }
};

// app/javascript/controllers/decor/suite/modals/modal_trigger_controller.js
import { Controller as Controller26 } from "@hotwired/stimulus";
var modal_trigger_controller_default2 = class extends Controller26 {
  static values = {
    modalId: String,
    contentHref: String,
    initialContent: String,
    title: String,
    closeOnOverlayClick: Boolean
  };
  handleClick(event) {
    event.preventDefault();
    window.dispatchEvent(new CustomEvent("decor--suite--modals--modal:open", {
      detail: {
        id: this.modalIdValue || void 0,
        content_href: this.contentHrefValue || void 0,
        contentHref: this.contentHrefValue || void 0,
        initial_content: this.initialContentValue ? markAsSafeHTML(this.initialContentValue) : void 0,
        placeholder: this.initialContentValue ? markAsSafeHTML(this.initialContentValue) : void 0,
        title: this.titleValue || void 0,
        closeOnOverlayClick: this.closeOnOverlayClickValue
      }
    }));
  }
};

// app/javascript/controllers/decor/suite/search_and_filter_controller.js
import { Controller as Controller27 } from "@hotwired/stimulus";
var search_and_filter_controller_default = class extends Controller27 {
  static targets = [
    "searchInput",
    "applyButton",
    "clearFiltersButton"
  ];
  toggle(event) {
    const menu = this.dropdownMenu();
    if (menu && typeof menu.togglePopover === "function") {
      menu.togglePopover();
    }
    if (event) event.stopPropagation();
  }
  hide() {
    const menu = this.dropdownMenu();
    if (menu && typeof menu.hidePopover === "function") {
      menu.hidePopover();
    }
  }
  hideOnClickOutside() {
    this.hide();
  }
  handleApply() {
    const filters = this.collectFilterValues();
    if (this.hasApplyButtonTarget) {
      this.applyButtonTarget.disabled = true;
    }
    this.reloadWith(filters);
  }
  handleClearFilters() {
    const filters = this.collectFilterValues();
    if (this.hasClearFiltersButtonTarget) {
      this.clearFiltersButtonTarget.disabled = true;
    }
    const cleared = Object.keys(filters).reduce((acc, key) => {
      acc[key] = void 0;
      return acc;
    }, {});
    this.reloadWith(cleared);
  }
  handleSearchInputKeydown(event) {
    if (event.defaultPrevented) return;
    if (event.key !== "Enter") return;
    event.preventDefault();
    if (this.hasSearchInputTarget) {
      this.searchInputTarget.disabled = true;
    }
    this.handleApply();
  }
  handleRangePicker(event) {
    const input = event.target;
    if (!input) return;
    const fp = typeof window !== "undefined" ? window.flatpickr : void 0;
    if (typeof fp !== "function") return;
    const picker = fp(input, {
      mode: "range",
      onClose: (selectedDates, _dateStr, instance) => {
        if (selectedDates.length !== 2) return;
        const value = selectedDates.map((d) => instance.formatDate(new Date(d), "Y-m-d")).join("_");
        const name = input.name || "custom_range";
        input.value = value;
        input.dataset.customRangeName = name;
      }
    });
    picker.open();
  }
  // ── private ─────────────────────────────────────────────────────────────
  dropdownMenu() {
    return this.element.querySelector(".decor--suite--dropdown-menu");
  }
  collectFilterValues() {
    const out = {};
    if (this.hasSearchInputTarget && this.searchInputTarget.value) {
      out[this.searchInputTarget.name] = this.searchInputTarget.value;
    }
    const menu = this.dropdownMenu();
    if (!menu) return out;
    menu.querySelectorAll('input[type="text"], input[type="search"], input[type="date"], input[type="number"], input:not([type])').forEach((el) => {
      if (!el.name) return;
      if (el === this.searchInputTarget) return;
      out[el.name] = el.value || void 0;
    });
    menu.querySelectorAll('input[type="checkbox"]').forEach((el) => {
      if (!el.name) return;
      out[el.name] = el.checked ? "true" : void 0;
    });
    menu.querySelectorAll("select").forEach((el) => {
      if (!el.name) return;
      out[el.name] = el.value || void 0;
    });
    return out;
  }
  reloadWith(filters) {
    const merged = Object.assign({}, filters, { page: void 0 });
    const params = new URLSearchParams(window.location.search);
    Object.entries(merged).forEach(([name, value]) => {
      if (value === void 0 || value === null || value === "") {
        params.delete(name);
      } else {
        params.set(name, value);
      }
    });
    const qs = params.toString();
    window.location.search = qs ? `?${qs}` : "";
  }
};

// app/javascript/controllers/decor/suite/settings_list/row_controller.js
import { Controller as Controller28 } from "@hotwired/stimulus";
var row_controller_default = class extends Controller28 {
  static targets = ["chevron", "detail", "summary"];
  static values = {
    open: { type: Boolean, default: false }
  };
  toggle() {
    this.openValue = !this.openValue;
  }
  openValueChanged(open) {
    this.detailTarget.hidden = !open;
    this.summaryTarget.setAttribute("aria-expanded", String(open));
    this.chevronTarget.classList.toggle("decor:rotate-90", open);
  }
};

// app/javascript/controllers/decor/suite/tables/data_table_cell_controller.js
import { Controller as Controller29 } from "@hotwired/stimulus";
var data_table_cell_controller_default = class extends Controller29 {
  static values = {
    noPathNavigation: { type: Boolean, default: false }
  };
  handleCellClickToStopPropagation(e) {
    e.stopPropagation();
  }
  handleLinkClick(e) {
    e.stopPropagation();
  }
};

// app/javascript/controllers/decor/suite/tables/data_table_controller.js
import { Controller as Controller30 } from "@hotwired/stimulus";

// app/javascript/services/selection_persistence_service.js
var SelectionPersistenceService = class {
  static CONFIG = {
    STORAGE_PREFIX: "dataTable",
    STORAGE_SEPARATOR: ":",
    TTL_HOURS: 24,
    MAX_SELECTION_SIZE: 1e3
  };
  static quotaExceededCallback = null;
  static getStorageKey(tableId) {
    return `${this.CONFIG.STORAGE_PREFIX}${this.CONFIG.STORAGE_SEPARATOR}${tableId}${this.CONFIG.STORAGE_SEPARATOR}selections`;
  }
  static getMetadataKey(tableId) {
    return `${this.CONFIG.STORAGE_PREFIX}${this.CONFIG.STORAGE_SEPARATOR}${tableId}${this.CONFIG.STORAGE_SEPARATOR}metadata`;
  }
  static saveSelections(tableId, selectedIds) {
    if (!tableId) return false;
    if (!this.validateSelections(selectedIds)) {
      console.warn(
        `Invalid selections for table ${tableId}: Too many selections or invalid IDs`
      );
      return false;
    }
    try {
      const key = this.getStorageKey(tableId);
      const metadataKey = this.getMetadataKey(tableId);
      if (selectedIds.length === 0) {
        localStorage.removeItem(key);
        localStorage.removeItem(metadataKey);
      } else {
        const metadata = { timestamp: Date.now(), count: selectedIds.length };
        localStorage.setItem(key, JSON.stringify(selectedIds));
        localStorage.setItem(metadataKey, JSON.stringify(metadata));
      }
      return true;
    } catch (error) {
      this.handleStorageError(tableId, error);
      return false;
    }
  }
  static loadSelections(tableId) {
    if (!tableId) return [];
    try {
      const key = this.getStorageKey(tableId);
      const metadataKey = this.getMetadataKey(tableId);
      const selectionsJson = localStorage.getItem(key);
      const metadataJson = localStorage.getItem(metadataKey);
      if (!selectionsJson) return [];
      if (metadataJson) {
        const metadata = JSON.parse(metadataJson);
        const ageInHours = (Date.now() - metadata.timestamp) / (1e3 * 60 * 60);
        if (ageInHours > this.CONFIG.TTL_HOURS) {
          this.clearSelections(tableId);
          return [];
        }
      }
      return JSON.parse(selectionsJson);
    } catch (error) {
      console.warn(`Failed to load selections for table ${tableId}:`, error);
      return [];
    }
  }
  static clearSelections(tableId) {
    if (!tableId) return;
    try {
      localStorage.removeItem(this.getStorageKey(tableId));
      localStorage.removeItem(this.getMetadataKey(tableId));
    } catch (error) {
      console.warn(`Failed to clear selections for table ${tableId}:`, error);
    }
  }
  static getPersistedCount(tableId) {
    if (!tableId) return 0;
    try {
      const metadataJson = localStorage.getItem(this.getMetadataKey(tableId));
      if (metadataJson) {
        const metadata = JSON.parse(metadataJson);
        return metadata.count || 0;
      }
      return this.loadSelections(tableId).length;
    } catch (error) {
      console.warn(
        `Failed to get persisted count for table ${tableId}:`,
        error
      );
      return 0;
    }
  }
  static addSelection(tableId, itemId) {
    if (!tableId || !itemId) return;
    try {
      const selectionSet = new Set(this.loadSelections(tableId));
      if (!selectionSet.has(itemId)) {
        selectionSet.add(itemId);
        this.saveSelections(tableId, Array.from(selectionSet));
      }
    } catch (error) {
      console.warn(`Failed to add selection for table ${tableId}:`, error);
    }
  }
  static removeSelection(tableId, itemId) {
    if (!tableId || !itemId) return;
    try {
      const selectionSet = new Set(this.loadSelections(tableId));
      if (selectionSet.has(itemId)) {
        selectionSet.delete(itemId);
        this.saveSelections(tableId, Array.from(selectionSet));
      }
    } catch (error) {
      console.warn(`Failed to remove selection for table ${tableId}:`, error);
    }
  }
  static isSelected(tableId, itemId) {
    if (!tableId || !itemId) return false;
    return this.loadSelections(tableId).includes(itemId);
  }
  static validateSelections(selectedIds) {
    if (selectedIds.length > this.CONFIG.MAX_SELECTION_SIZE) return false;
    return selectedIds.every((id) => {
      if (typeof id !== "string" || id.length === 0 || id.length > 200) return false;
      const xssPatterns = [
        /<script/i,
        /<iframe/i,
        /javascript:/i,
        /on[a-z]{1,20}\s{0,10}=/i,
        /<\s*\w+/
      ];
      if (xssPatterns.some((pattern) => pattern.test(id))) {
        console.warn("Potential XSS attempt detected in selection ID:", id);
        return false;
      }
      if (/[\0\x00-\x1F\x7F\n\r]/.test(id)) return false;
      if (!/^[a-zA-Z0-9_\-\.]+$/.test(id)) {
        console.warn(
          "Invalid ID format (must be alphanumeric with -_. only):",
          id
        );
        return false;
      }
      return true;
    });
  }
  static handleStorageError(tableId, error) {
    const errorMessage = (error.message || "").toLowerCase();
    const isQuotaError = errorMessage.includes("quota") || errorMessage.includes("exceeded") || error.name === "QuotaExceededError";
    if (isQuotaError) {
      console.error(`localStorage quota exceeded for table ${tableId}`);
      this.cleanupExpiredSelections();
      if (this.quotaExceededCallback) {
        this.quotaExceededCallback(tableId, error);
      }
    } else {
      console.warn(`Failed to save selections for table ${tableId}:`, error);
    }
  }
  static onQuotaExceeded(callback) {
    this.quotaExceededCallback = callback;
  }
  static cleanupExpiredSelections() {
    try {
      const keys = Object.keys(localStorage);
      const prefix = this.CONFIG.STORAGE_PREFIX + this.CONFIG.STORAGE_SEPARATOR;
      keys.forEach((key) => {
        if (key.startsWith(prefix) && key.endsWith(":metadata")) {
          try {
            const metadata = JSON.parse(localStorage.getItem(key) || "{}");
            const ageInHours = (Date.now() - (metadata.timestamp || 0)) / (1e3 * 60 * 60);
            if (ageInHours > this.CONFIG.TTL_HOURS) {
              localStorage.removeItem(key);
              localStorage.removeItem(key.replace(":metadata", ":selections"));
            }
          } catch (e) {
            localStorage.removeItem(key);
          }
        }
      });
    } catch (error) {
      console.warn("Failed to cleanup expired selections:", error);
    }
  }
  static addStorageListener(tableId, callback) {
    const key = this.getStorageKey(tableId);
    const handler = (event) => {
      if (event.key === key && event.newValue !== event.oldValue) {
        try {
          const selectedIds = event.newValue ? JSON.parse(event.newValue) : [];
          callback(selectedIds);
        } catch (error) {
          console.warn("Failed to parse storage event:", error);
        }
      }
    };
    window.addEventListener("storage", handler);
    return () => window.removeEventListener("storage", handler);
  }
};
if (typeof window !== "undefined") {
  SelectionPersistenceService.cleanupExpiredSelections();
}
var selection_persistence_service_default = SelectionPersistenceService;

// app/javascript/controllers/decor/suite/tables/data_table_controller.js
var data_table_controller_default = class extends Controller30 {
  static outlets = [
    "decor--suite--tables--data-table-header-row",
    "decor--suite--tables--data-table-row",
    "decor--suite--tables--bulk-actions-bar"
  ];
  static targets = ["tableContentContainer", "tableBody"];
  static values = {
    tableId: { type: String, default: "" },
    persistSelections: { type: Boolean, default: false }
  };
  static SELECTION_CHANGE_DEBOUNCE_MS = 150;
  static MAX_APPLY_SELECTIONS_RETRIES = 3;
  get headerRowController() {
    return this.decorSuiteTablesDataTableHeaderRowOutlet;
  }
  get hasHeaderRowController() {
    return this.hasDecorSuiteTablesDataTableHeaderRowOutlet;
  }
  get rowControllers() {
    return this.decorSuiteTablesDataTableRowOutlets;
  }
  get bulkActionsBarController() {
    return this.decorSuiteTablesBulkActionsBarOutlet;
  }
  get hasBulkActionsBarController() {
    return this.hasDecorSuiteTablesBulkActionsBarOutlet;
  }
  initialize() {
    this.selectionChangeListeners = /* @__PURE__ */ new Set();
    this.storageListenerCleanup = null;
    this.persistedSelections = /* @__PURE__ */ new Set();
    this.rowSelectionChangeHandler = null;
    this.applySelectionsRetryCount = 0;
    this.selectionChangeDebounceTimer = null;
    this.resizeObserver = null;
    this.contentScrolled();
  }
  connect() {
    if (this.persistSelectionsValue && this.tableIdValue) {
      selection_persistence_service_default.onQuotaExceeded(
        this.handleQuotaExceeded.bind(this)
      );
      this.loadPersistedSelections();
      this.storageListenerCleanup = selection_persistence_service_default.addStorageListener(
        this.tableIdValue,
        this.handleStorageChange.bind(this)
      );
    }
    if (this.hasHeaderRowController && typeof this.headerRowController.onCheckboxChange === "function") {
      this.headerRowController.onCheckboxChange(this.toggleRows.bind(this));
    }
    if (this.hasBulkActionsBarController) {
      if (typeof this.bulkActionsBarController.setDataTableController === "function") {
        this.bulkActionsBarController.setDataTableController(this);
      }
      if (this.persistSelectionsValue && this.tableIdValue && typeof this.bulkActionsBarController.setTableId === "function") {
        this.bulkActionsBarController.setTableId(this.tableIdValue);
      }
    }
    this.rowSelectionChangeHandler = this.handleRowSelectionChange.bind(this);
    this.element.addEventListener(
      "data-table-row-selection-changed",
      this.rowSelectionChangeHandler
    );
    if (this.hasTableContentContainerTarget) {
      this.resizeObserver = new ResizeObserver(() => this.contentScrolled());
      this.resizeObserver.observe(this.tableContentContainerTarget);
    }
  }
  disconnect() {
    this.selectionChangeListeners.clear();
    if (this.rowSelectionChangeHandler) {
      this.element.removeEventListener(
        "data-table-row-selection-changed",
        this.rowSelectionChangeHandler
      );
      this.rowSelectionChangeHandler = null;
    }
    if (this.storageListenerCleanup) {
      this.storageListenerCleanup();
      this.storageListenerCleanup = null;
    }
    if (this.selectionChangeDebounceTimer !== null) {
      clearTimeout(this.selectionChangeDebounceTimer);
      this.selectionChangeDebounceTimer = null;
    }
    if (this.resizeObserver) {
      this.resizeObserver.disconnect();
      this.resizeObserver = null;
    }
  }
  loadPersistedSelections() {
    if (!this.persistSelectionsValue || !this.tableIdValue) return;
    const persistedIds = selection_persistence_service_default.loadSelections(
      this.tableIdValue
    );
    this.persistedSelections = new Set(persistedIds);
    this.applyPersistedSelections();
  }
  applyPersistedSelections() {
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        if (this.rowControllers.length === 0) {
          this.applySelectionsRetryCount++;
          if (this.applySelectionsRetryCount < this.constructor.MAX_APPLY_SELECTIONS_RETRIES) {
            requestAnimationFrame(() => this.applyPersistedSelections());
          } else {
            console.warn(
              `Failed to apply persisted selections after ${this.constructor.MAX_APPLY_SELECTIONS_RETRIES} retries. Row controllers may not be initialized.`
            );
          }
          return;
        }
        this.applySelectionsRetryCount = 0;
        this.rowControllers.forEach((controller) => {
          const rowId = controller.checkboxValue;
          if (rowId && this.persistedSelections.has(rowId)) {
            controller.checked = true;
          }
        });
        this.updateHeaderCheckboxState();
        if (this.persistedSelections.size > 0) {
          this.notifySelectionChange();
        }
      });
    });
  }
  handleStorageChange(selectedIds) {
    this.persistedSelections = new Set(selectedIds);
    this.rowControllers.forEach((controller) => {
      const rowId = controller.checkboxValue;
      if (rowId) {
        const shouldBeChecked = this.persistedSelections.has(rowId);
        if (controller.checked !== shouldBeChecked) {
          controller.checked = shouldBeChecked;
        }
      }
    });
    this.updateHeaderCheckboxState();
    this.notifySelectionChange();
  }
  handleQuotaExceeded(tableId, error) {
    if (tableId !== this.tableIdValue) return;
    console.error(
      `Storage quota exceeded for table ${tableId}. Clearing old selections.`,
      error
    );
    this.element.dispatchEvent(
      new CustomEvent("data-table-storage-quota-exceeded", {
        bubbles: true,
        detail: {
          tableId,
          message: "Selection storage limit reached. Some selections may not be saved.",
          error
        }
      })
    );
    const visibleSelections = this.getVisibleSelectedRowIds();
    this.persistedSelections = new Set(visibleSelections);
    selection_persistence_service_default.saveSelections(tableId, visibleSelections);
  }
  handleRowSelectionChange(event) {
    const detail = event.detail;
    if (this.persistSelectionsValue && this.tableIdValue) {
      if (detail && detail.checkboxValue) {
        if (detail.checked) {
          this.persistedSelections.add(detail.checkboxValue);
        } else {
          this.persistedSelections.delete(detail.checkboxValue);
        }
      }
    }
    this.updateHeaderCheckboxState();
    this.notifySelectionChange();
  }
  updateHeaderCheckboxState() {
    if (!this.hasHeaderRowController) return;
    const allVisibleChecked = this.rowControllers.every((c) => c.checked);
    const someChecked = this.rowControllers.some((c) => c.checked);
    const hasPersistedSelections = this.persistedSelections.size > 0;
    if (allVisibleChecked && this.rowControllers.length > 0) {
      this.headerRowController.checked = true;
      this.headerRowController.indeterminate = false;
    } else if (someChecked || hasPersistedSelections) {
      this.headerRowController.checked = false;
      this.headerRowController.indeterminate = true;
    } else {
      this.headerRowController.checked = false;
      this.headerRowController.indeterminate = false;
    }
  }
  toggleRows(checked) {
    this.rowControllers.forEach((controller) => {
      controller.checked = checked;
    });
    if (this.persistSelectionsValue && this.tableIdValue) {
      if (checked) {
        this.rowControllers.forEach((controller) => {
          const rowId = controller.checkboxValue;
          if (rowId) this.persistedSelections.add(rowId);
        });
      } else {
        this.rowControllers.forEach((controller) => {
          const rowId = controller.checkboxValue;
          if (rowId) this.persistedSelections.delete(rowId);
        });
      }
    }
    this.notifySelectionChange();
  }
  getSelectedRowIds() {
    if (this.persistSelectionsValue && this.tableIdValue) {
      return Array.from(this.persistedSelections);
    }
    return this.rowControllers.filter((controller) => controller.checked).map((controller) => controller.checkboxValue);
  }
  getVisibleSelectedRowIds() {
    return this.rowControllers.filter((controller) => controller.checked).map((controller) => controller.checkboxValue);
  }
  getSelectedRows() {
    return this.rowControllers.filter((controller) => controller.checked);
  }
  getSelectionCount() {
    if (this.persistSelectionsValue && this.tableIdValue) {
      return this.persistedSelections.size;
    }
    return this.rowControllers.filter((controller) => controller.checked).length;
  }
  hasSelection() {
    return this.getSelectionCount() > 0;
  }
  clearSelection() {
    this.rowControllers.forEach((controller) => {
      controller.checked = false;
    });
    if (this.hasHeaderRowController) {
      this.headerRowController.checked = false;
    }
    if (this.persistSelectionsValue && this.tableIdValue) {
      this.persistedSelections.clear();
      selection_persistence_service_default.clearSelections(this.tableIdValue);
    }
    this.notifySelectionChange();
  }
  onSelectionChange(callback) {
    this.selectionChangeListeners.add(callback);
    return () => this.selectionChangeListeners.delete(callback);
  }
  notifySelectionChange() {
    if (this.selectionChangeDebounceTimer !== null) {
      clearTimeout(this.selectionChangeDebounceTimer);
    }
    this.selectionChangeDebounceTimer = window.setTimeout(() => {
      this.selectionChangeDebounceTimer = null;
      const selectedIds = this.getSelectedRowIds();
      if (this.persistSelectionsValue && this.tableIdValue) {
        selection_persistence_service_default.saveSelections(
          this.tableIdValue,
          selectedIds
        );
      }
      this.selectionChangeListeners.forEach((listener) => listener(selectedIds));
      if (this.hasBulkActionsBarController && typeof this.bulkActionsBarController.handleSelectionChange === "function") {
        this.bulkActionsBarController.handleSelectionChange(selectedIds);
      }
    }, this.constructor.SELECTION_CHANGE_DEBOUNCE_MS);
  }
  appendRow(row) {
    if (this.hasTableBodyTarget) {
      this.tableBodyTarget.appendChild(row);
      this.contentScrolled();
    }
  }
  contentScrolled() {
    if (!this.hasTableContentContainerTarget) return;
    const scrollContainer = this.tableContentContainerTarget;
    const shadowTarget = scrollContainer.parentElement;
    if (!shadowTarget) return;
    const x = scrollContainer.scrollLeft;
    const divWidth = scrollContainer.scrollWidth - scrollContainer.clientWidth;
    if (x === 0) {
      shadowTarget.classList.remove("inset-scroll-shadow-not-at-left");
    } else {
      shadowTarget.classList.add("inset-scroll-shadow-not-at-left");
    }
    if (x < divWidth) {
      shadowTarget.classList.add("inset-scroll-shadow-not-at-right");
    } else {
      shadowTarget.classList.remove("inset-scroll-shadow-not-at-right");
    }
  }
};

// app/javascript/controllers/decor/suite/tabs_controller.js
import { Controller as Controller31 } from "@hotwired/stimulus";
var tabs_controller_default2 = class extends Controller31 {
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
    const epsilon = 1;
    this.wrapperTarget.classList.toggle(
      "inset-scroll-shadow-not-at-left",
      x > epsilon
    );
    this.wrapperTarget.classList.toggle(
      "inset-scroll-shadow-not-at-right",
      x < max - epsilon
    );
  }
};

// app/javascript/controllers/decor/suite/tooltip_controller.js
import { Controller as Controller32 } from "@hotwired/stimulus";
import {
  computePosition,
  autoUpdate,
  flip,
  shift,
  offset as offsetMiddleware,
  arrow
} from "@floating-ui/dom";
var tooltip_controller_default = class extends Controller32 {
  static targets = ["content", "arrow"];
  static values = {
    placement: { type: String, default: "top" },
    offset: { type: Number, default: 8 }
  };
  connect() {
    this.contentTarget.style.transform = "";
  }
  disconnect() {
    this.stopAutoUpdate();
    clearTimeout(this.showTimer);
    clearTimeout(this.hideTimer);
  }
  mouseOver() {
    clearTimeout(this.hideTimer);
    this.showTimer = setTimeout(() => this.show(), 80);
  }
  mouseOut() {
    clearTimeout(this.showTimer);
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
    this.cleanupAutoUpdate = autoUpdate(
      this.anchor,
      this.contentTarget,
      () => this.updatePosition()
    );
  }
  stopAutoUpdate() {
    if (this.cleanupAutoUpdate) {
      this.cleanupAutoUpdate();
      this.cleanupAutoUpdate = void 0;
    }
  }
  async updatePosition() {
    const middleware = [
      offsetMiddleware(this.offsetValue),
      flip({ padding: 8 }),
      shift({ padding: 8 })
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
        middleware
      }
    );
    Object.assign(this.contentTarget.style, {
      left: `${x}px`,
      top: `${y}px`
    });
    if (this.hasArrowTarget && middlewareData.arrow) {
      const { x: arrowX, y: arrowY } = middlewareData.arrow;
      const staticSide = {
        top: "bottom",
        right: "left",
        bottom: "top",
        left: "right"
      }[placement.split("-")[0]];
      Object.assign(this.arrowTarget.style, {
        left: arrowX != null ? `${arrowX}px` : "",
        top: arrowY != null ? `${arrowY}px` : "",
        right: "",
        bottom: "",
        [staticSide]: "-4px"
      });
    }
  }
};

// app/javascript/decor/controllers.js
var CONTROLLERS = {
  "decor--daisy--button": button_controller_default,
  "decor--daisy--click-to-copy": click_to_copy_controller_default,
  "decor--daisy--code-block": code_block_controller_default,
  "decor--daisy--dropdown": dropdown_controller_default,
  "decor--daisy--flash": flash_controller_default,
  "decor--daisy--forms--date-calendar": date_calendar_controller_default,
  "decor--daisy--forms--searchable-multi-select": searchable_multi_select_controller_default,
  "decor--daisy--forms--searchable-select": searchable_select_controller_default,
  "decor--daisy--forms--switch": switch_controller_default,
  "decor--daisy--map": map_controller_default,
  "decor--daisy--modals--confirm": confirm_controller_default,
  "decor--daisy--modals--confirm-modal": confirm_modal_controller_default,
  "decor--daisy--modals--modal-close-button": modal_close_button_controller_default,
  "decor--daisy--modals--modal": modal_controller_default,
  "decor--daisy--modals--modal-open-button": modal_open_button_controller_default,
  "decor--daisy--modals--modal-trigger": modal_trigger_controller_default,
  "decor--daisy--notification-manager": notification_manager_controller_default,
  "decor--daisy--progress": progress_controller_default,
  "decor--daisy--tabs": tabs_controller_default,
  "decor--progress-animation": progress_animation_controller_default,
  "decor--suite--button": button_controller_default,
  "decor--suite--carousel": carousel_controller_default,
  "decor--suite--click-to-copy": click_to_copy_controller_default,
  "decor--suite--dropdown": dropdown_controller_default2,
  "decor--suite--flash": flash_controller_default,
  "decor--suite--forms--date-calendar": date_calendar_controller_default,
  "decor--suite--forms--form": form_controller_default,
  "decor--suite--forms--searchable-multi-select": searchable_multi_select_controller_default2,
  "decor--suite--forms--searchable-select": searchable_select_controller_default2,
  "decor--suite--forms--switch": switch_controller_default,
  "decor--suite--map": map_controller_default,
  "decor--suite--modals--confirm": confirm_controller_default2,
  "decor--suite--modals--modal-close-button": modal_close_button_controller_default2,
  "decor--suite--modals--modal": modal_controller_default2,
  "decor--suite--modals--modal-open-button": modal_open_button_controller_default2,
  "decor--suite--modals--modal-trigger": modal_trigger_controller_default2,
  "decor--suite--progress": progress_controller_default,
  "decor--suite--search-and-filter": search_and_filter_controller_default,
  "decor--suite--settings-list--row": row_controller_default,
  "decor--suite--tables--data-table-cell": data_table_cell_controller_default,
  "decor--suite--tables--data-table": data_table_controller_default,
  "decor--suite--tabs": tabs_controller_default2,
  "decor--suite--tooltip": tooltip_controller_default
};

// app/javascript/decor/index.js
function register(application) {
  for (const [identifier, Controller33] of Object.entries(CONTROLLERS)) {
    application.register(identifier, Controller33);
  }
}
if (typeof window !== "undefined" && window.Stimulus) {
  register(window.Stimulus);
}
export {
  CONTROLLERS,
  register
};
//# sourceMappingURL=decor.js.map
