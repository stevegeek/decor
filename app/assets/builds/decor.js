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

// app/javascript/controllers/decor/daisy/forms/switch_controller.js
import { Controller as Controller7 } from "@hotwired/stimulus";
var switch_controller_default = class extends Controller7 {
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
import { Controller as Controller8 } from "@hotwired/stimulus";
var map_controller_default = class extends Controller8 {
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

// app/javascript/controllers/decor/daisy/modals/modal_controller.js
import { Controller as Controller9 } from "@hotwired/stimulus";
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
var modal_controller_default = class extends Controller9 {
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
import { Controller as Controller10 } from "@hotwired/stimulus";
var modal_close_button_controller_default = class extends Controller10 {
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
import { Controller as Controller11 } from "@hotwired/stimulus";
var modal_open_button_controller_default = class extends Controller11 {
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

// app/javascript/controllers/decor/daisy/notification_manager_controller.js
import { Controller as Controller12 } from "@hotwired/stimulus";
var NOTIFICATION_MANAGER_CLASS_NAME = "decor--daisy--notification-manager";
var NOTIFICATION_CLASSNAME = `${NOTIFICATION_MANAGER_CLASS_NAME}-notification`;
var DEFAULT_DISMISS_AFTER_MS = 3e3;
var DISMISS_ALL_STAGGER_MS = 50;
var notification_manager_controller_default = class extends Controller12 {
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
import { Controller as Controller13 } from "@hotwired/stimulus";
var progress_controller_default = class extends Controller13 {
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
import { Controller as Controller14 } from "@hotwired/stimulus";
var tabs_controller_default = class extends Controller14 {
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
import { Controller as Controller15 } from "@hotwired/stimulus";
var progress_animation_controller_default = class extends Controller15 {
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
import { Controller as Controller16 } from "@hotwired/stimulus";
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
var carousel_controller_default = class extends Controller16 {
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
import { Controller as Controller17 } from "@hotwired/stimulus";
var dropdown_controller_default2 = class extends Controller17 {
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

// app/javascript/controllers/decor/suite/modals/modal_close_button_controller.js
import { Controller as Controller18 } from "@hotwired/stimulus";
var modal_close_button_controller_default2 = class extends Controller18 {
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

// app/javascript/controllers/decor/suite/modals/modal_open_button_controller.js
import { Controller as Controller19 } from "@hotwired/stimulus";
var modal_open_button_controller_default2 = class extends Controller19 {
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

// app/javascript/controllers/decor/suite/search_and_filter_controller.js
import { Controller as Controller20 } from "@hotwired/stimulus";
var search_and_filter_controller_default = class extends Controller20 {
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
import { Controller as Controller21 } from "@hotwired/stimulus";
var row_controller_default = class extends Controller21 {
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

// app/javascript/controllers/decor/suite/tabs_controller.js
import { Controller as Controller22 } from "@hotwired/stimulus";
var tabs_controller_default2 = class extends Controller22 {
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
import { Controller as Controller23 } from "@hotwired/stimulus";
import {
  computePosition,
  autoUpdate,
  flip,
  shift,
  offset as offsetMiddleware,
  arrow
} from "@floating-ui/dom";
var tooltip_controller_default = class extends Controller23 {
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
  "decor--daisy--forms--switch": switch_controller_default,
  "decor--daisy--map": map_controller_default,
  "decor--daisy--modals--confirm-modal": confirm_modal_controller_default,
  "decor--daisy--modals--modal-close-button": modal_close_button_controller_default,
  "decor--daisy--modals--modal": modal_controller_default,
  "decor--daisy--modals--modal-open-button": modal_open_button_controller_default,
  "decor--daisy--notification-manager": notification_manager_controller_default,
  "decor--daisy--progress": progress_controller_default,
  "decor--daisy--tabs": tabs_controller_default,
  "decor--progress-animation": progress_animation_controller_default,
  "decor--suite--button": button_controller_default,
  "decor--suite--carousel": carousel_controller_default,
  "decor--suite--click-to-copy": click_to_copy_controller_default,
  "decor--suite--dropdown": dropdown_controller_default2,
  "decor--suite--flash": flash_controller_default,
  "decor--suite--map": map_controller_default,
  "decor--suite--modals--modal-close-button": modal_close_button_controller_default2,
  "decor--suite--modals--modal-open-button": modal_open_button_controller_default2,
  "decor--suite--progress": progress_controller_default,
  "decor--suite--search-and-filter": search_and_filter_controller_default,
  "decor--suite--settings-list--row": row_controller_default,
  "decor--suite--tabs": tabs_controller_default2,
  "decor--suite--tooltip": tooltip_controller_default
};

// app/javascript/decor/index.js
function register(application) {
  for (const [identifier, Controller24] of Object.entries(CONTROLLERS)) {
    application.register(identifier, Controller24);
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
