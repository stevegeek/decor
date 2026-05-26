// app/javascript/controllers/decor/daisy/ai_chat/widget_controller.js
import { Controller } from "@hotwired/stimulus";

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

// app/javascript/controllers/decor/daisy/ai_chat/widget_controller.js
var PROCESSING_TIMEOUT_MS = 3e4;
var BROADCAST_EVENT = "decor-ai-chat:broadcast";
var widget_controller_default = class extends Controller {
  static targets = [
    "panel",
    "messages",
    "input",
    "thinking",
    "toggleButton",
    "chatIcon",
    "closeIcon",
    "welcome",
    "sendButton",
    "errorBanner"
  ];
  static values = {
    createUrl: String,
    threadsUrl: String,
    threadEncodedId: { type: String, default: "" },
    open: { type: Boolean, default: false }
  };
  connect() {
    this.streamingEl = null;
    this.processing = false;
    this.processingTimer = null;
    this.boundBroadcastHandler = (evt) => this.handleBroadcast(evt.detail);
    window.addEventListener(BROADCAST_EVENT, this.boundBroadcastHandler);
  }
  disconnect() {
    this.clearProcessingTimeout();
    if (this.boundBroadcastHandler) {
      window.removeEventListener(BROADCAST_EVENT, this.boundBroadcastHandler);
    }
  }
  toggle() {
    this.openValue = !this.openValue;
    this.updatePanel();
  }
  open(event) {
    if (event) event.preventDefault();
    if (!this.openValue) {
      this.openValue = true;
      this.updatePanel();
    }
  }
  updatePanel() {
    this.panelTarget.classList.toggle("decor:hidden", !this.openValue);
    this.panelTarget.classList.toggle("decor:flex", this.openValue);
    this.chatIconTarget.classList.toggle("decor:hidden", this.openValue);
    this.closeIconTarget.classList.toggle("decor:hidden", !this.openValue);
    if (this.openValue) {
      this.inputTarget.focus();
    }
  }
  newThread() {
    this.threadEncodedIdValue = "";
    this.clearMessages();
    if (this.hasWelcomeTarget) {
      this.welcomeTarget.classList.remove("decor:hidden");
    }
    this.inputTarget.focus();
  }
  async send(e) {
    e.preventDefault();
    const message = this.inputTarget.value.trim();
    if (!message || this.processing) return;
    this.processing = true;
    this.sendButtonTarget.disabled = true;
    this.hideError();
    this.hideWelcome();
    this.appendUserMessage(message);
    this.inputTarget.value = "";
    this.showThinking();
    this.startProcessingTimeout();
    try {
      const response = await fetch(this.createUrlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.csrfToken
        },
        body: JSON.stringify({
          message,
          thread_id: this.threadEncodedIdValue || null
        })
      });
      if (!response.ok) {
        this.clearProcessingTimeout();
        this.hideThinking();
        try {
          const body = await response.json();
          this.showError(
            body.error || "Failed to send message. Please try again."
          );
        } catch {
          this.showError("Failed to send message. Please try again.");
        }
        this.processing = false;
        this.sendButtonTarget.disabled = false;
      }
    } catch (error) {
      this.clearProcessingTimeout();
      console.error("[Decor AI Chat] Send failed:", error);
      this.hideThinking();
      this.showError("Network error. Please check your connection.");
      this.processing = false;
      this.sendButtonTarget.disabled = false;
    }
  }
  // Broadcast handler — invoked when a `decor-ai-chat:broadcast` window
  // event is dispatched. Expected shape: `{ai_chat: {type, ...}}`.
  handleBroadcast(data) {
    if (!data || !data.ai_chat) return;
    const msg = data.ai_chat;
    switch (msg.type) {
      case "thinking":
        this.showThinking();
        break;
      case "chunk":
        this.appendChunk(msg.text);
        break;
      case "complete":
        this.completeMessage(msg);
        break;
      case "error":
        this.handleError(msg);
        break;
    }
  }
  appendUserMessage(text) {
    const el = document.createElement("div");
    el.className = "decor:ml-12 decor:bg-suite-primary-100 decor:text-gray-900 decor:rounded-suite-control decor:px-3 decor:py-2 decor:suite-description";
    el.textContent = text;
    this.messagesTarget.appendChild(el);
    this.scrollToBottom();
  }
  appendChunk(text) {
    this.resetProcessingTimeout();
    this.hideThinking();
    if (!this.streamingEl) {
      this.streamingEl = document.createElement("div");
      this.streamingEl.className = "decor:mr-12 decor:bg-suite-gray-25 decor:text-gray-900 decor:rounded-suite-control decor:px-3 decor:py-2 decor:suite-description decor:whitespace-pre-wrap";
      this.streamingEl.textContent = "";
      this.messagesTarget.appendChild(this.streamingEl);
    }
    this.streamingEl.textContent += text;
    this.scrollToBottom();
  }
  completeMessage(msg) {
    this.clearProcessingTimeout();
    this.hideThinking();
    if (this.streamingEl) {
      if (msg.message && msg.message.html) {
        safelySetInnerHTML(this.streamingEl, markAsSafeHTML(msg.message.html));
        this.streamingEl.classList.remove("decor:whitespace-pre-wrap");
        this.streamingEl.classList.add("decor:prose", "decor:max-w-none");
      } else if (msg.message && msg.message.text) {
        this.streamingEl.textContent = msg.message.text;
      }
      if (msg.message && msg.message.actions && msg.message.actions.length) {
        this.appendActions(this.streamingEl, msg.message.actions);
      }
      this.streamingEl = null;
    } else if (msg.message && (msg.message.text || msg.message.html)) {
      const el = document.createElement("div");
      if (msg.message.html) {
        el.className = "decor:mr-12 decor:bg-suite-gray-25 decor:text-gray-900 decor:rounded-suite-control decor:px-3 decor:py-2 decor:suite-description decor:prose decor:max-w-none";
        safelySetInnerHTML(el, markAsSafeHTML(msg.message.html));
      } else {
        el.className = "decor:mr-12 decor:bg-suite-gray-25 decor:text-gray-900 decor:rounded-suite-control decor:px-3 decor:py-2 decor:suite-description decor:whitespace-pre-wrap";
        el.textContent = msg.message.text;
      }
      if (msg.message.actions && msg.message.actions.length) {
        this.appendActions(el, msg.message.actions);
      }
      this.messagesTarget.appendChild(el);
    }
    if (msg.thread_encoded_id) {
      this.threadEncodedIdValue = msg.thread_encoded_id;
    }
    if (msg.handed_off) {
      this.showHandoffBanner();
    }
    this.processing = false;
    this.sendButtonTarget.disabled = false;
    this.scrollToBottom();
    this.inputTarget.focus();
  }
  handleError(msg) {
    this.clearProcessingTimeout();
    this.hideThinking();
    this.streamingEl = null;
    this.processing = false;
    this.sendButtonTarget.disabled = false;
    if (msg.code === "thread_closed") {
      this.showError(
        "This conversation has been closed. Please start a new chat."
      );
      this.inputTarget.disabled = true;
    } else if (msg.code === "message_moderated") {
      this.showError(
        "Your message could not be processed. Please keep messages related to ordering."
      );
    } else {
      this.showError(msg.error || "Something went wrong. Please try again.");
    }
  }
  appendActions(parent, actions) {
    const container = document.createElement("div");
    container.className = "decor:flex decor:flex-wrap decor:gap-2 decor:mt-2";
    actions.forEach((action) => {
      if (action.type === "navigate" && action.path && action.path.startsWith("/")) {
        const link = document.createElement("a");
        link.href = action.path;
        link.textContent = action.label || "Go";
        link.className = "decor:inline-flex decor:items-center decor:px-3 decor:py-1 decor:suite-caption decor:font-medium decor:bg-suite-primary-50 decor:text-suite-primary-700 decor:rounded-suite-control decor:border decor:border-suite-primary-100 decor:hover:bg-suite-primary-100 decor:transition-colors";
        container.appendChild(link);
      }
    });
    if (container.children.length > 0) {
      parent.appendChild(container);
    }
  }
  showThinking() {
    this.thinkingTarget.classList.remove("decor:hidden");
    this.scrollToBottom();
  }
  hideThinking() {
    this.thinkingTarget.classList.add("decor:hidden");
  }
  hideWelcome() {
    if (this.hasWelcomeTarget) {
      this.welcomeTarget.classList.add("decor:hidden");
    }
  }
  showHandoffBanner() {
    const existing = this.messagesTarget.querySelector("[data-handoff-banner]");
    if (existing) return;
    const banner = document.createElement("div");
    banner.setAttribute("data-handoff-banner", "true");
    banner.className = "decor:text-center decor:py-2 decor:px-3 decor:suite-caption decor:text-suite-primary-600 decor:bg-suite-primary-50 decor:rounded-suite-control";
    banner.textContent = "You're now connected with our support team. Messages will be handled by a team member.";
    this.messagesTarget.appendChild(banner);
    this.scrollToBottom();
  }
  showError(message) {
    this.errorBannerTarget.textContent = message;
    this.errorBannerTarget.classList.remove("decor:hidden");
  }
  hideError() {
    this.errorBannerTarget.textContent = "";
    this.errorBannerTarget.classList.add("decor:hidden");
  }
  clearMessages() {
    const children = Array.from(this.messagesTarget.children);
    children.forEach((child) => {
      if (child !== this.welcomeTarget) {
        child.remove();
      }
    });
    this.streamingEl = null;
    this.hideError();
    this.inputTarget.disabled = false;
  }
  startProcessingTimeout() {
    this.clearProcessingTimeout();
    this.processingTimer = setTimeout(() => {
      if (this.processing) {
        this.hideThinking();
        this.streamingEl = null;
        this.processing = false;
        this.sendButtonTarget.disabled = false;
        this.showError("The response took too long. Please try again.");
      }
    }, PROCESSING_TIMEOUT_MS);
  }
  resetProcessingTimeout() {
    if (this.processing) {
      this.startProcessingTimeout();
    }
  }
  clearProcessingTimeout() {
    if (this.processingTimer) {
      clearTimeout(this.processingTimer);
      this.processingTimer = null;
    }
  }
  scrollToBottom() {
    requestAnimationFrame(() => {
      this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
    });
  }
  get csrfToken() {
    const meta = document.querySelector('meta[name="csrf-token"]');
    return meta && meta.getAttribute("content") || "";
  }
};

// app/javascript/controllers/decor/daisy/button_controller.js
import { Controller as Controller2 } from "@hotwired/stimulus";
var button_controller_default = class extends Controller2 {
  set disabled(disabled) {
    if (disabled) {
      this.element.setAttribute("disabled", "disabled");
    } else {
      this.element.removeAttribute("disabled");
    }
  }
};

// app/javascript/controllers/decor/daisy/click_to_copy_controller.js
import { Controller as Controller3 } from "@hotwired/stimulus";
var click_to_copy_controller_default = class extends Controller3 {
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
import { Controller as Controller4 } from "@hotwired/stimulus";
var code_block_controller_default = class extends Controller4 {
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
import { Controller as Controller5 } from "@hotwired/stimulus";
var dropdown_controller_default = class extends Controller5 {
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
import { Controller as Controller6 } from "@hotwired/stimulus";
var INITIAL_CLASSES = "decor:invisible decor:opacity-0";
var VISIBLE_CLASSES = "decor:transition-opacity decor:duration-300 decor:opacity-100 decor:visible";
var COLLAPSED_CLASS = "decor:hidden";
var TEXT_CLASS = "decor:text-sm";
var flash_controller_default = class extends Controller6 {
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

// app/javascript/controllers/decor/base.js
import { Controller as Controller7 } from "@hotwired/stimulus";
var initializeReceipt = {};
var BaseController = class _BaseController extends Controller7 {
  static setIdentifier(id) {
    this.identifier = id;
  }
  initialize() {
    const receipt = this.onInitialize();
    if (receipt !== initializeReceipt) {
      throw new Error(
        `onInitialize was implemented in ${this.identifier} without a call to super.onInitialize.`
      );
    }
  }
  onInitialize() {
    return initializeReceipt;
  }
  findParentElementByTagName(el, tagName) {
    const lower = tagName.toLowerCase();
    let cur = el;
    while (cur && cur.parentElement) {
      cur = cur.parentElement;
      if (cur.tagName && cur.tagName.toLowerCase() === lower) {
        return cur;
      }
    }
    return null;
  }
  get disabled() {
    return this.element.hasAttribute("disabled");
  }
  set disabled(disabled) {
    if (disabled) {
      this.element.setAttribute("disabled", "disabled");
    } else {
      this.element.removeAttribute("disabled");
    }
  }
  findController(element, identifier) {
    const controller = this.application.getControllerForElementAndIdentifier(
      element,
      identifier
    );
    return controller instanceof _BaseController ? controller : null;
  }
  toggleTargetElementClasses(target, state, classesOff, classesOn) {
    if (state) {
      this.setTargetElementClasses(target, classesOff, classesOn);
    } else {
      this.setTargetElementClasses(target, classesOn, classesOff);
    }
  }
  setTargetElementClasses(target, classesToRemove, classesToAdd) {
    classesToRemove.forEach((c) => target.classList.remove(c));
    classesToAdd.forEach((c) => target.classList.add(c));
  }
  // Emit a Stimulus dispatch with an explicit prefix taken from another
  // controller class's static `identifier`. Used by sibling controllers to
  // publish events under a stable, well-known namespace.
  emitEvent(target, ControllerClass, eventName, detail = void 0, bubbles = true, cancelable = false) {
    this.dispatch(eventName, {
      target,
      detail,
      prefix: ControllerClass.identifier,
      bubbles,
      cancelable
    });
  }
};

// app/javascript/lib/util/form_validation_messages.js
var RAILS_I18N_MESSAGE_REGEX = /%{([\s\S]+?)}/g;
var DEFAULTS = {
  invalid: "is invalid",
  blank: "can't be blank",
  does_not_match: "doesn't match",
  generic_server_error: "Sorry, an error occurred.",
  form_invalid_preamble: "Please review the following:"
};
function localeMessage(key) {
  const fromConsumer = typeof window !== "undefined" && window.decorI18n ? window.decorI18n[key] : null;
  return fromConsumer || DEFAULTS[key] || key;
}
function generateFormValidationMessage(message, variables = {}) {
  return message.replace(
    RAILS_I18N_MESSAGE_REGEX,
    (_m, key) => variables[key] || ""
  );
}

// app/javascript/lib/util/form_validators.js
var PATTERNS = {
  color: /^#?([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$/,
  date: /(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))/,
  email: /^([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22))*\x40([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d))*(\.\w{2,})+$/,
  month: /^(?:(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])))$/,
  number: /^(?:[-+]?[0-9]*[.,]?[0-9]+)$/,
  time: /^(?:(0[0-9]|1[0-9]|2[0-3])(:[0-5][0-9]))$/,
  url: /^(?:(?:https?|HTTPS?|ftp|FTP):\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-zA-Z¡-￿0-9]-*)*[a-zA-Z¡-￿0-9]+)(?:\.(?:[a-zA-Z¡-￿0-9]-*)*[a-zA-Z¡-￿0-9]+)*(?:\.(?:[a-zA-Z¡-￿]{2,}))\.?)(?::\d{2,5})?(?:[/?#]\S*)?$/
};
function missingValue(attrs) {
  return attrs.required && !attrs.value.length;
}
function missingCheckboxValue(attrs) {
  return attrs.required && !attrs.checked;
}
function missingRadioValue(attrs) {
  return attrs.some((attr) => attr.required) && attrs.every((attr) => !attr.checked);
}
function patternMismatch(attrs) {
  const { pattern, type, value } = attrs;
  if (!value) {
    return false;
  }
  const chosenPattern = pattern ? new RegExp("^(?:" + pattern + ")$") : PATTERNS[type];
  if (!chosenPattern) {
    return false;
  }
  return !value.match(chosenPattern);
}
function outOfRange(attrs) {
  const { max, min, gt, lt, value } = attrs;
  if (!value) {
    return false;
  }
  if ((gt !== null || lt !== null || min !== null || max !== null) && !value.match(PATTERNS["number"])) {
    return "invalid";
  }
  const num = parseFloat(value);
  if (gt !== null && num <= parseFloat(gt)) {
    return "under";
  }
  if (lt !== null && num >= parseFloat(lt)) {
    return "over";
  }
  if (gt === null && min !== null && num < parseFloat(min)) {
    return "under";
  }
  if (lt === null && max !== null && num > parseFloat(max)) {
    return "over";
  }
  return false;
}
function wrongLength(attrs) {
  const { max, min, value } = attrs;
  if (!value) {
    return false;
  }
  const { length } = value;
  if (max !== null && length > parseFloat(max)) {
    return "over";
  }
  if (min !== null && length < parseFloat(min)) {
    return "under";
  }
  return false;
}
function equalTo(attrs) {
  const { value, equalToId } = attrs;
  if (!equalToId || !value) {
    return false;
  }
  let targetElement = document.getElementById(equalToId);
  if (!targetElement) {
    return false;
  }
  if (!(targetElement instanceof HTMLInputElement) && !(targetElement instanceof HTMLTextAreaElement)) {
    targetElement = targetElement.querySelector("input, textarea");
    if (!targetElement) {
      return false;
    }
  }
  return value !== targetElement.value;
}
function typeMismatch(attrs) {
  const { type, value } = attrs;
  if (!value) {
    return false;
  }
  switch (type) {
    case "number": {
      const parsed = parseFloat(value);
      return Number.isNaN(parsed);
    }
    case "boolean": {
      const normalised = value.toLowerCase().trim();
      return normalised !== "true" && normalised !== "false";
    }
    default:
      return false;
  }
}

// app/javascript/controllers/decor/daisy/forms/form_field.js
var NO_ERRORS = {
  missingValue: false,
  equalTo: false,
  outOfRange: false,
  patternMismatch: false,
  typeMismatch: false,
  wrongLength: false
};
var FormFieldController = class extends BaseController {
  static targets = [
    "input",
    "container",
    "label",
    "helperText",
    "errorText",
    "errorIcon",
    "errorIconText"
  ];
  static values = {
    label: String,
    validationMessageRequired: { type: String, default: "" },
    validationMessageLengthOver: { type: String, default: "" },
    validationMessageLengthUnder: { type: String, default: "" },
    validationMessageRangeOver: { type: String, default: "" },
    validationMessageRangeUnder: { type: String, default: "" },
    validationMessagePatternMismatch: { type: String, default: "" },
    validationMessageTypeMismatch: { type: String, default: "" },
    validationMessageEqualto: { type: String, default: "" },
    validateGt: { type: String, default: "" },
    validateLt: { type: String, default: "" },
    validateType: { type: String, default: "" },
    validateEqualTo: { type: String, default: "" }
  };
  static classes = [
    "valid",
    "invalid",
    "validInput",
    "invalidInput",
    "validContainer",
    "invalidContainer",
    "validLabel",
    "invalidLabel"
  ];
  // Override in subclasses if the field uses a different invalid class name.
  get invalidClassName() {
    return "invalid";
  }
  connect() {
    super.connect();
    this.listening = false;
    this.touched = false;
    if (this.isInsideForm()) {
      this.autoValidation = true;
    }
  }
  disconnect() {
    this.autoValidation = false;
    super.disconnect();
  }
  set autoValidation(shouldAutoValidate) {
    if (shouldAutoValidate) {
      this.setupEventListeners();
    } else {
      this.teardownEventListeners();
    }
  }
  handleControlValidatedEvent(evt) {
    const { target, detail: { errors, valid } } = evt;
    this.handleValidationResponse(target, valid, errors);
  }
  get valid() {
    return this.validate().valid;
  }
  // The orchestrator entry-point. Returns `{ valid, errors }` where errors is
  // an array of `{ code, message }`. Side-effects: sets custom validity on the
  // input, flips chrome classes, writes error text into the errorText target,
  // toggles the error icon, marks the field as touched, and dispatches a
  // `validated` event for higher controllers to observe.
  validate() {
    const errors = this.validationErrors;
    const valid = Object.values(errors).every((e) => e === false);
    if (!valid && this.hasInputTarget) {
      this.inputTarget.setCustomValidity("invalid");
    } else if (this.hasInputTarget) {
      this.inputTarget.setCustomValidity("");
    }
    this.touched = true;
    this.emitValidationEvent({ errors, valid });
    const parsedErrors = this.handleValidationResponse(
      this.inputTarget,
      valid,
      errors
    );
    return { errors: parsedErrors, valid };
  }
  focusControl() {
    if (this.hasInputTarget) {
      this.inputTarget.focus();
    }
  }
  get name() {
    return this.inputTarget.name;
  }
  get value() {
    return this.inputTarget.value;
  }
  set value(val) {
    this.inputTarget.value = val;
  }
  get disabled() {
    return this.hasInputTarget && this.inputTarget.hasAttribute("disabled");
  }
  set disabled(value) {
    if (!this.hasInputTarget) return;
    if (value) {
      this.inputTarget.setAttribute("disabled", "disabled");
    } else {
      this.inputTarget.removeAttribute("disabled");
    }
    this.toggleTargetElementClasses(this.element, value, [], ["disabled"]);
  }
  get required() {
    return this.hasInputTarget && this.inputTarget.hasAttribute("required");
  }
  set required(value) {
    if (!this.hasInputTarget) return;
    if (value) {
      this.inputTarget.setAttribute("required", "required");
    } else {
      this.inputTarget.removeAttribute("required");
    }
  }
  // Flips chrome classes for root/container/input/label, toggles helper/error
  // visibility and the error icon. Called by `handleValidationResponse`.
  set valid(isValid) {
    this.toggleTargetElementClasses(
      this.element,
      isValid,
      this.invalidClasses,
      this.validClasses
    );
    if (this.hasContainerTarget) {
      this.toggleTargetElementClasses(
        this.containerTarget,
        isValid,
        this.invalidContainerClasses,
        this.validContainerClasses
      );
    }
    if (this.hasInputTarget) {
      this.toggleTargetElementClasses(
        this.inputTarget,
        isValid,
        this.invalidInputClasses,
        this.validInputClasses
      );
    }
    this.updateLabelClasses(isValid);
    this.toggleHelperErrorVisibility(isValid);
    this.toggleErrorIcon(!isValid);
  }
  // Looks up a custom message by stimulus value key; falls back to the
  // default locale message keyed by `defaultMessageKey`. Variables are
  // interpolated Rails-style (`%{var}`).
  generateErrorMessage(customMessageKey, defaultMessageKey, values = {}) {
    let rawMessage;
    switch (customMessageKey) {
      case "validationMessageRequired":
        rawMessage = this.validationMessageRequiredValue;
        break;
      case "validationMessageLengthOver":
        rawMessage = this.validationMessageLengthOverValue;
        break;
      case "validationMessageLengthUnder":
        rawMessage = this.validationMessageLengthUnderValue;
        break;
      case "validationMessageRangeOver":
        rawMessage = this.validationMessageRangeOverValue;
        break;
      case "validationMessageRangeUnder":
        rawMessage = this.validationMessageRangeUnderValue;
        break;
      case "validationMessagePatternMismatch":
        rawMessage = this.validationMessagePatternMismatchValue;
        break;
      case "validationMessageTypeMismatch":
        rawMessage = this.validationMessageTypeMismatchValue;
        break;
      case "validationMessageEqualto":
        rawMessage = this.validationMessageEqualtoValue;
        break;
      default:
        rawMessage = null;
    }
    return generateFormValidationMessage(
      rawMessage || this.generateDefaultMessage(defaultMessageKey),
      values
    );
  }
  get validationErrors() {
    if (this.disabled) {
      return { ...NO_ERRORS };
    }
    return {
      missingValue: this.missingValueError,
      equalTo: this.equalToError,
      outOfRange: this.outOfRangeError,
      patternMismatch: this.patternMismatchError,
      typeMismatch: this.typeMismatchError,
      wrongLength: this.wrongLengthError
    };
  }
  emitValidationEvent({ errors, valid }) {
    this.dispatch("validated", {
      bubbles: true,
      cancelable: false,
      detail: { errors, valid }
    });
  }
  setupEventListeners() {
    if (this.listening || !this.hasInputTarget) return;
    this._boundHandleInput = this.handleInputEvent.bind(this);
    this._boundHandleFocus = this.handleFocusEvent.bind(this);
    this._boundHandleBlur = this.handleBlurEvent.bind(this);
    this._boundHandleEqualToTargetInput = this.handleEqualToTargetInput.bind(this);
    this.inputTarget.addEventListener("input", this._boundHandleInput);
    this.inputTarget.addEventListener("focus", this._boundHandleFocus);
    this.inputTarget.addEventListener("blur", this._boundHandleBlur);
    const equalToTarget = this.equalToTargetElement;
    if (equalToTarget) {
      equalToTarget.addEventListener("input", this._boundHandleEqualToTargetInput);
    }
    this.listening = true;
  }
  teardownEventListeners() {
    if (!this.listening || !this.hasInputTarget) return;
    this.inputTarget.removeEventListener("input", this._boundHandleInput);
    this.inputTarget.removeEventListener("focus", this._boundHandleFocus);
    this.inputTarget.removeEventListener("blur", this._boundHandleBlur);
    const equalToTarget = this.equalToTargetElement;
    if (equalToTarget) {
      equalToTarget.removeEventListener("input", this._boundHandleEqualToTargetInput);
    }
    this.listening = false;
  }
  handleInputEvent() {
    if (this.touched) this.validate();
  }
  handleFocusEvent() {
    if (this.inputTarget.value) this.touched = true;
  }
  handleBlurEvent() {
    this.validate();
  }
  handleEqualToTargetInput() {
    if (this.touched) this.validate();
  }
  get equalToTargetElement() {
    const id = this.validateEqualToValue || this.inputTarget.getAttribute("data-form-control-validate-equal-to-value");
    if (!id) return null;
    let el = document.getElementById(id);
    if (!el) return null;
    if (!(el instanceof HTMLInputElement)) {
      el = el.querySelector("input");
    }
    return el;
  }
  get missingValueError() {
    const el = this.inputTarget;
    switch (el.type) {
      case "radio": {
        const inputGroup = Array.from(document.getElementsByTagName("input"));
        const radioGroup = inputGroup.filter(
          (input) => input.getAttribute("name") === el.getAttribute("name")
        );
        const radioAttributes = radioGroup.map(this.mapCheckableAttributes);
        return missingRadioValue(radioAttributes);
      }
      case "checkbox": {
        const checkboxAttributes = this.mapCheckableAttributes(el);
        return missingCheckboxValue(checkboxAttributes);
      }
      default:
        return missingValue({
          required: el.hasAttribute("required"),
          value: el.value
        });
    }
  }
  get outOfRangeError() {
    const el = this.inputTarget;
    return outOfRange({
      gt: this.validateGtValue || null,
      lt: this.validateLtValue || null,
      max: el.getAttribute("max"),
      min: el.getAttribute("min"),
      value: el.value
    });
  }
  get patternMismatchError() {
    const el = this.inputTarget;
    return patternMismatch({
      pattern: el.getAttribute("pattern"),
      type: el.type,
      value: el.value
    });
  }
  get wrongLengthError() {
    const el = this.inputTarget;
    return wrongLength({
      max: el.getAttribute("maxlength"),
      min: el.getAttribute("minlength"),
      value: el.value
    });
  }
  get equalToError() {
    const el = this.inputTarget;
    return equalTo({
      value: el.value,
      equalToId: this.validateEqualToValue || el.getAttribute("data-form-control-validate-equal-to-value")
    });
  }
  get typeMismatchError() {
    const el = this.inputTarget;
    return typeMismatch({
      type: this.validateTypeValue || null,
      value: el.value
    });
  }
  mapCheckableAttributes(field) {
    return {
      checked: field.checked,
      required: field.hasAttribute("required")
    };
  }
  // Match against the Suite Form orchestrator's controller id. Daisy doesn't
  // ship its own Form controller — Suite is the only one with the validate
  // wiring, and field controllers under either skin route through it.
  isInsideForm() {
    return this.element.closest(
      'form[data-controller*="decor--suite--forms--form"]'
    ) !== null;
  }
  handleValidationResponse(fieldControlTarget, isValid, errors) {
    this.valid = isValid;
    const parsedErrors = this.parseErrorMessages(errors);
    const errorMessage = parsedErrors.length > 0 ? parsedErrors[0].message : null;
    this.setErrorText(errorMessage);
    this.toggleHelperErrorVisibility(errorMessage === null);
    this.toggleErrorIcon(errorMessage !== null);
    this.emitFormFieldValidatedEvent(fieldControlTarget, isValid, parsedErrors);
    return parsedErrors;
  }
  parseErrorMessages(errors) {
    const out = [];
    if (errors.missingValue) {
      out.push({
        code: "missingValue",
        message: this.generateErrorMessage("validationMessageRequired", "blank")
      });
    }
    if (errors.wrongLength === "over") {
      out.push({
        code: "lengthOver",
        message: this.generateErrorMessage("validationMessageLengthOver", "invalid")
      });
    }
    if (errors.wrongLength === "under") {
      out.push({
        code: "lengthUnder",
        message: this.generateErrorMessage("validationMessageLengthUnder", "invalid")
      });
    }
    if (errors.outOfRange === "over") {
      out.push({
        code: "rangeOver",
        message: this.generateErrorMessage("validationMessageRangeOver", "invalid")
      });
    }
    if (errors.outOfRange === "under") {
      out.push({
        code: "rangeUnder",
        message: this.generateErrorMessage("validationMessageRangeUnder", "invalid")
      });
    }
    if (errors.patternMismatch) {
      out.push({
        code: "patternMismatch",
        message: this.generateErrorMessage("validationMessagePatternMismatch", "invalid")
      });
    }
    if (errors.typeMismatch) {
      out.push({
        code: "typeMismatch",
        message: this.generateErrorMessage("validationMessageTypeMismatch", "invalid")
      });
    }
    if (errors.equalTo) {
      out.push({
        code: "equalTo",
        message: this.generateErrorMessage("validationMessageEqualto", "does_not_match")
      });
    }
    return out;
  }
  generateDefaultMessage(key) {
    return `${this.label} ${localeMessage(key)}`;
  }
  get label() {
    const label = this.labelValue;
    if (!label) {
      throw new Error(`${this.identifier} should define a label attribute`);
    }
    return label;
  }
  emitFormFieldValidatedEvent(target, valid, errors) {
    this.dispatch("validated", {
      target,
      bubbles: true,
      cancelable: false,
      detail: { errors, valid }
    });
  }
  updateLabelClasses(isValid) {
    if (this.hasLabelTarget) {
      this.toggleTargetElementClasses(
        this.labelTarget,
        isValid,
        this.invalidLabelClasses,
        this.validLabelClasses
      );
    }
  }
  // Writes the leading error message into the errorText / errorIconText
  // targets. Called from `handleValidationResponse` only.
  setErrorText(errorMessage) {
    if (this.hasErrorTextTarget && errorMessage) {
      this.errorTextTarget.textContent = errorMessage;
    }
    if (this.hasErrorIconTextTarget && errorMessage) {
      this.errorIconTextTarget.textContent = errorMessage;
    }
  }
  // Helper text and error text are mutually exclusive. Helper text only
  // surfaces if it has content — empty helper paragraphs stay hidden so we
  // don't reserve vertical space for nothing.
  toggleHelperErrorVisibility(showHelper) {
    if (this.hasHelperTextTarget) {
      const hasContent = this.helperTextTarget.textContent && this.helperTextTarget.textContent.trim() !== "";
      this.toggleTargetElementClasses(
        this.helperTextTarget,
        showHelper && !!hasContent,
        ["decor:hidden", "hidden"],
        []
      );
    }
    if (this.hasErrorTextTarget) {
      this.toggleTargetElementClasses(
        this.errorTextTarget,
        showHelper,
        [],
        ["decor:hidden", "hidden"]
      );
    }
  }
  toggleErrorIcon(show) {
    if (this.hasErrorIconTarget) {
      this.toggleTargetElementClasses(
        this.errorIconTarget,
        show,
        ["decor:hidden", "hidden"],
        []
      );
    }
  }
};

// app/javascript/controllers/decor/daisy/forms/button_radio_group_controller.js
var ButtonRadioGroupController = class extends FormFieldController {
  static targets = FormFieldController.targets;
};

// app/javascript/controllers/decor/daisy/forms/checkbox_controller.js
var CheckboxController = class extends FormFieldController {
  set checked(state) {
    this.inputTarget.checked = state;
    this.inputTarget.indeterminate = false;
  }
  get checked() {
    return this.inputTarget.checked;
  }
  set indeterminate(state) {
    this.inputTarget.indeterminate = state;
  }
  get indeterminate() {
    return this.inputTarget.indeterminate;
  }
};

// app/javascript/controllers/decor/daisy/forms/date_calendar_controller.js
import { Controller as Controller8 } from "@hotwired/stimulus";
import "cally";
var date_calendar_controller_default = class extends Controller8 {
  static targets = ["calendar", "hiddenInput", "popoverTrigger", "popoverPanel"];
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
    if (this.hasPopoverTriggerTarget) {
      this.popoverTriggerTarget.value = value || "";
      if (this.calendarTypeValue !== "range" && this.calendarTypeValue !== "multi") {
        this._closePopover();
      }
    }
    if (this.onChangeCallback) {
      this.onChangeCallback(value);
    }
  }
  openPopover() {
    if (!this.hasPopoverPanelTarget || !this.hasPopoverTriggerTarget) return;
    const panel = this.popoverPanelTarget;
    const trigger = this.popoverTriggerTarget;
    this._positionPopover();
    panel.showPopover();
    trigger.setAttribute("aria-expanded", "true");
    this._boundReposition = this._positionPopover.bind(this);
    window.addEventListener("scroll", this._boundReposition, true);
    window.addEventListener("resize", this._boundReposition);
    panel.addEventListener("toggle", (e) => {
      if (e.newState === "closed") {
        trigger.setAttribute("aria-expanded", "false");
        window.removeEventListener("scroll", this._boundReposition, true);
        window.removeEventListener("resize", this._boundReposition);
      }
    }, { once: true });
  }
  _positionPopover() {
    if (!this.hasPopoverPanelTarget || !this.hasPopoverTriggerTarget) return;
    const rect = this.popoverTriggerTarget.getBoundingClientRect();
    const panel = this.popoverPanelTarget;
    panel.style.position = "fixed";
    panel.style.top = `${rect.bottom + 4}px`;
    panel.style.left = `${rect.left}px`;
  }
  _closePopover() {
    if (this.hasPopoverPanelTarget && this.popoverPanelTarget.matches(":popover-open")) {
      this.popoverPanelTarget.hidePopover();
    }
  }
  handleRangeStart(event) {
    console.debug("Range selection started:", event.detail);
  }
  handleRangeEnd(event) {
    console.debug("Range selection completed:", event.detail);
    if (this.hasPopoverPanelTarget) this._closePopover();
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

// app/javascript/controllers/decor/daisy/forms/expanding_checkbox_collection_controller.js
import { Controller as Controller9 } from "@hotwired/stimulus";
var expanding_checkbox_collection_controller_default = class extends Controller9 {
  static targets = ["showMoreLink"];
  initialize() {
    this.showingMore = false;
  }
  showMore() {
    this.element.querySelectorAll(".hideable").forEach((el) => {
      el.classList.toggle("decor:hidden");
    });
    this.showingMore = !this.showingMore;
    if (this.hasShowMoreLinkTarget) {
      this.showMoreLinkTarget.textContent = this.showingMore ? "Show less..." : "Show more...";
    }
  }
};

// app/javascript/controllers/decor/daisy/forms/file_upload_controller.js
var FileUploadController = class extends FormFieldController {
  static classes = [...FormFieldController.classes, "image"];
  static targets = [
    ...FormFieldController.targets,
    "thumbnailWrapper",
    "thumbnailImage",
    "deleteField",
    "dropZone",
    "fileList"
  ];
  static values = {
    ...FormFieldController.values,
    maxSizeInMb: Number
  };
  // ── drop-zone drag-and-drop ────────────────────────────────────────────
  onDragOver(event) {
    event.preventDefault();
    if (this.hasDropZoneTarget) {
      this.dropZoneTarget.classList.add(
        "border-primary-500",
        "bg-primary-50",
        "border-primary-500!"
      );
      this.dropZoneTarget.classList.remove(
        "border-hairline-strong",
        "bg-gray-25"
      );
    }
  }
  onDragLeave(_event) {
    if (this.hasDropZoneTarget) {
      this.dropZoneTarget.classList.remove(
        "border-primary-500",
        "bg-primary-50",
        "border-primary-500!"
      );
      this.dropZoneTarget.classList.add(
        "border-hairline-strong",
        "bg-gray-25"
      );
    }
  }
  onDrop(event) {
    event.preventDefault();
    this.onDragLeave(event);
    const input = this.element.querySelector('input[type="file"]');
    if (!input || !event.dataTransfer) return;
    try {
      input.files = event.dataTransfer.files;
    } catch {
      return;
    }
    input.dispatchEvent(new Event("change", { bubbles: true }));
  }
  openFilePicker() {
    const input = this.element.querySelector('input[type="file"]');
    if (input) input.click();
  }
  removeImage() {
    if (this.hasDeleteFieldTarget) {
      this.deleteFieldTarget.value = "true";
    }
    const input = this.element.querySelector('input[type="file"]');
    if (input) input.value = "";
    if (this.hasThumbnailWrapperTarget) {
      this.thumbnailWrapperTarget.outerHTML = `
        <div class="border rounded-lg bg-gray-50 w-32 h-32 flex flex-col items-center justify-center text-gray-400"
             data-${this.identifier}-target="thumbnailWrapper">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 mb-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
            <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 15.75l5.159-5.159a2.25 2.25 0 013.182 0l5.159 5.159m-1.5-1.5l1.409-1.409a2.25 2.25 0 013.182 0l2.909 2.909M3.75 21h16.5A2.25 2.25 0 0022.5 18.75V5.25A2.25 2.25 0 0020.25 3H3.75A2.25 2.25 0 001.5 5.25v13.5A2.25 2.25 0 003.75 21z" />
          </svg>
          <span class="text-xs">No image</span>
        </div>`;
    }
  }
  // ── file selection / preview rendering ─────────────────────────────────
  fileSelected(event) {
    const input = event.target;
    if (!input.files || !input.files[0]) return;
    if (input.files[0].size / 1024 / 1024 > this.maxSize) {
      alert("Sorry that file is too large");
      input.value = "";
      return;
    }
    if (this.hasDeleteFieldTarget) {
      this.deleteFieldTarget.value = "false";
    }
    if (this.hasThumbnailWrapperTarget) {
      this._renderImagePreview(input);
    } else if (this.hasFileListTarget) {
      this._renderFileList(input.files);
    } else {
      this._renderLegacyAvatar(input);
    }
  }
  _renderImagePreview(input) {
    const reader = new FileReader();
    reader.onload = (e) => {
      if (!e.target || !e.target.result) return;
      this.thumbnailWrapperTarget.outerHTML = `
        <div class="relative group border rounded-lg overflow-hidden bg-gray-50 w-32 h-32"
             data-${this.identifier}-target="thumbnailWrapper">
          <img src="${e.target.result.toString()}"
               class="w-full h-full object-cover"
               data-${this.identifier}-target="thumbnailImage" />
          <div class="absolute inset-0 bg-black/0 group-hover:bg-black/20 transition-colors"></div>
          <div class="absolute top-1 right-1 flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
            <button type="button"
                    class="p-1 bg-white rounded-sm shadow-sm hover:bg-red-100 text-red-600"
                    data-action="${this.identifier}#removeImage"
                    title="Remove image">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
        </div>`;
    };
    reader.readAsDataURL(input.files[0]);
  }
  _renderFileList(files) {
    const items = [];
    for (let i = 0; i < files.length; i++) {
      const f = files[i];
      const kb = Math.round(f.size / 1024);
      const size = kb >= 1024 ? `${(kb / 1024).toFixed(1)} MB` : `${kb} KB`;
      items.push(
        `<div class="flex items-center gap-2 text-[12px] text-gray-700 bg-gray-50 border border-hairline rounded-[6px] px-3 py-1.5"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="w-4 h-4 text-gray-400 shrink-0"><path d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"/><polyline points="13 2 13 9 20 9"/></svg><span class="truncate font-medium">${escapeText(f.name)}</span><span class="text-gray-400 shrink-0">${size}</span></div>`
      );
    }
    this.fileListTarget.innerHTML = items.join("");
  }
  _renderLegacyAvatar(input) {
    const container = this.element.getElementsByClassName(
      "decor--image-upload--image-container"
    )[0];
    if (!container) return;
    const reader = new FileReader();
    reader.onload = (e) => {
      const image = document.createElement("img");
      if (this.hasImageClass) {
        image.classList.add(...this.imageClasses);
      }
      if (e.target && e.target.result) {
        image.src = e.target.result.toString();
        container.replaceChild(image, container.children[0]);
      }
    };
    reader.readAsDataURL(input.files[0]);
  }
  get maxSize() {
    return this.maxSizeInMbValue;
  }
};
function escapeText(s) {
  return String(s).replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[c]);
}

// app/javascript/controllers/decor/daisy/forms/multi_image_upload_controller.js
import { Controller as Controller10 } from "@hotwired/stimulus";
var multi_image_upload_controller_default = class extends Controller10 {
  static targets = [
    "sortableContainer",
    "thumbnail",
    "thumbnailImage",
    "fileInput",
    "hiddenFieldsContainer",
    "newFilesInput",
    "imageCount",
    "primaryBadge",
    "cropModal",
    "cropImage"
  ];
  static values = {
    maxSizeInMb: Number,
    maxImages: Number,
    enableCrop: Boolean,
    cropAspectW: Number,
    cropAspectH: Number,
    fileMimeTypes: String
  };
  initialize() {
    this.sortable = null;
    this.pendingFiles = /* @__PURE__ */ new Map();
    this.removedSignedIds = /* @__PURE__ */ new Set();
    this.cropper = null;
    this.croppingThumbnail = null;
    this.nextClientId = 0;
  }
  connect() {
    this.initSortable();
  }
  disconnect() {
    if (this.sortable) {
      this.sortable.destroy();
      this.sortable = null;
    }
    this.destroyCropper();
  }
  openFilePicker() {
    if (this.totalImageCount >= this.maxImagesValue) {
      alert(`Maximum of ${this.maxImagesValue} images allowed.`);
      return;
    }
    this.fileInputTarget.click();
  }
  filesSelected(event) {
    const input = event.target;
    if (!input.files || input.files.length === 0) return;
    const remaining = this.maxImagesValue - this.totalImageCount;
    if (remaining <= 0) {
      alert(`Maximum of ${this.maxImagesValue} images allowed.`);
      input.value = "";
      return;
    }
    const files = Array.from(input.files).slice(0, remaining);
    const maxBytes = this.maxSizeInMbValue * 1024 * 1024;
    for (const file of files) {
      if (file.size > maxBytes) {
        alert(`"${file.name}" is too large (max ${this.maxSizeInMbValue}MB).`);
        continue;
      }
      this.addPendingFile(file);
    }
    input.value = "";
    this.syncHiddenFields();
    this.updateImageCount();
    this.updatePrimaryBadge();
  }
  removeImage(event) {
    const button = event.target.closest("button");
    const thumbnail = button ? button.closest("[data-image-type]") : null;
    if (!thumbnail) return;
    this.removeThumbnail(thumbnail);
  }
  cropImage(event) {
    if (!this.enableCropValue || !this.hasCropModalTarget) return;
    const button = event.target.closest("button");
    const thumbnail = button ? button.closest("[data-image-type]") : null;
    if (!thumbnail) return;
    const img = thumbnail.querySelector("img");
    if (!img) return;
    this.croppingThumbnail = thumbnail;
    this.cropImageTarget.src = img.src;
    this.cropModalTarget.classList.remove("decor:hidden");
    this.cropModalTarget.classList.remove("hidden");
    this.cropImageTarget.onload = () => {
      this.destroyCropper();
      const aspectRatio = this.cropAspectWValue > 0 && this.cropAspectHValue > 0 ? this.cropAspectWValue / this.cropAspectHValue : NaN;
      const CropperCtor = window.Cropper || (typeof Cropper !== "undefined" ? Cropper : null);
      if (!CropperCtor) return;
      this.cropper = new CropperCtor(this.cropImageTarget, { aspectRatio });
    };
  }
  applyCrop() {
    if (!this.cropper || !this.croppingThumbnail) return;
    const canvas = this.cropper.getCroppedCanvas();
    if (!canvas) {
      this.cancelCrop();
      return;
    }
    const thumbnail = this.croppingThumbnail;
    const imageType = thumbnail.dataset.imageType;
    const clientId = thumbnail.dataset.clientId;
    const dataUrl = canvas.toDataURL("image/png");
    const img = thumbnail.querySelector("img");
    if (img) img.src = dataUrl;
    canvas.toBlob((blob) => {
      if (!blob) {
        this.cancelCrop();
        return;
      }
      if (imageType === "existing") {
        const signedId = thumbnail.dataset.signedId;
        if (signedId) this.removedSignedIds.add(signedId);
        const newClientId = this.generateClientId();
        const file = new File([blob], `cropped-${Date.now()}.png`, { type: "image/png" });
        this.pendingFiles.set(newClientId, file);
        thumbnail.dataset.imageType = "pending";
        thumbnail.dataset.clientId = newClientId;
        delete thumbnail.dataset.signedId;
        delete thumbnail.dataset.blobId;
      } else if (imageType === "pending" && clientId) {
        const file = new File([blob], `cropped-${Date.now()}.png`, { type: "image/png" });
        this.pendingFiles.set(clientId, file);
      }
      this.syncHiddenFields();
      this.cancelCrop();
    }, "image/png");
  }
  cancelCrop() {
    this.destroyCropper();
    if (this.hasCropModalTarget) {
      this.cropModalTarget.classList.add("decor:hidden");
      this.cropModalTarget.classList.add("hidden");
    }
    this.croppingThumbnail = null;
  }
  // ── private ────────────────────────────────────────────────────────────
  initSortable() {
    const SortableCtor = window.Sortable || (typeof Sortable !== "undefined" ? Sortable : null);
    if (!SortableCtor) return;
    this.sortable = SortableCtor.create(this.sortableContainerTarget, {
      animation: 150,
      ghostClass: "opacity-50",
      dragClass: "cursor-grabbing",
      onEnd: () => {
        this.syncHiddenFields();
        this.updatePrimaryBadge();
      }
    });
  }
  addPendingFile(file) {
    const clientId = this.generateClientId();
    this.pendingFiles.set(clientId, file);
    const thumb = document.createElement("div");
    thumb.className = "decor:relative decor:group decor:border decor:border-suite-hairline-strong decor:rounded-suite-control decor:overflow-hidden decor:bg-suite-gray-25 decor:aspect-square";
    thumb.setAttribute(`data-${this.identifier}-target`, "thumbnail");
    thumb.dataset.imageType = "pending";
    thumb.dataset.clientId = clientId;
    const img = document.createElement("img");
    img.className = "decor:w-full decor:h-full decor:object-cover";
    img.alt = file.name;
    thumb.appendChild(img);
    const reader = new FileReader();
    reader.onload = (e) => {
      if (e.target && e.target.result) {
        img.src = e.target.result.toString();
      }
    };
    reader.readAsDataURL(file);
    const overlay = document.createElement("div");
    overlay.className = "decor:absolute decor:inset-0 decor:bg-black/0 decor:group-hover:bg-black/20 decor:transition-colors decor:duration-suite-fast";
    thumb.appendChild(overlay);
    const actions = document.createElement("div");
    actions.className = "decor:absolute decor:top-1 decor:right-1 decor:flex decor:gap-1 decor:opacity-0 decor:group-hover:opacity-100 decor:transition-opacity decor:duration-suite-fast";
    if (this.enableCropValue) {
      const cropBtn = document.createElement("button");
      cropBtn.type = "button";
      cropBtn.className = "decor:p-1 decor:bg-white decor:rounded-suite-control decor:shadow decor:hover:bg-suite-gray-25 decor:text-gray-700 decor:transition-colors decor:duration-suite-fast";
      cropBtn.title = "Crop image";
      cropBtn.dataset.action = `click->${this.identifier}#cropImage`;
      cropBtn.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" class="decor:h-4 decor:w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M7 7V3m0 4H3m4 0l10 10m0 0v4m0-4h4M7 7l10 10"/></svg>`;
      actions.appendChild(cropBtn);
    }
    const removeBtn = document.createElement("button");
    removeBtn.type = "button";
    removeBtn.className = "decor:p-1 decor:bg-white decor:rounded-suite-control decor:shadow decor:hover:bg-suite-danger-50 decor:text-suite-danger-500 decor:transition-colors decor:duration-suite-fast";
    removeBtn.title = "Remove image";
    removeBtn.dataset.action = `click->${this.identifier}#removeImage`;
    removeBtn.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" class="decor:h-4 decor:w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>`;
    actions.appendChild(removeBtn);
    thumb.appendChild(actions);
    this.sortableContainerTarget.appendChild(thumb);
  }
  removeThumbnail(thumbnail) {
    const imageType = thumbnail.dataset.imageType;
    if (imageType === "existing") {
      const signedId = thumbnail.dataset.signedId;
      if (signedId) this.removedSignedIds.add(signedId);
    } else if (imageType === "pending") {
      const clientId = thumbnail.dataset.clientId;
      if (clientId) this.pendingFiles.delete(clientId);
    }
    thumbnail.remove();
    this.syncHiddenFields();
    this.updateImageCount();
    this.updatePrimaryBadge();
  }
  syncHiddenFields() {
    const container = this.hiddenFieldsContainerTarget;
    container.innerHTML = "";
    const objectName = this.newFilesInputTarget.name.replace(/\[new_images\]\[\]$/, "");
    this.removedSignedIds.forEach((signedId) => {
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = `${objectName}[remove_image_ids][]`;
      input.value = signedId;
      container.appendChild(input);
    });
    const thumbnails = this.sortableContainerTarget.querySelectorAll("[data-image-type]");
    const orderedPendingFiles = [];
    thumbnails.forEach((thumb) => {
      const imageType = thumb.dataset.imageType;
      if (imageType === "existing") {
        const signedId = thumb.dataset.signedId;
        if (signedId) {
          const orderInput = document.createElement("input");
          orderInput.type = "hidden";
          orderInput.name = `${objectName}[image_order][]`;
          orderInput.value = signedId;
          container.appendChild(orderInput);
        }
      } else if (imageType === "pending") {
        const clientId = thumb.dataset.clientId;
        if (clientId) {
          const file = this.pendingFiles.get(clientId);
          if (file) orderedPendingFiles.push(file);
          const orderInput = document.createElement("input");
          orderInput.type = "hidden";
          orderInput.name = `${objectName}[image_order][]`;
          orderInput.value = `new_${clientId}`;
          container.appendChild(orderInput);
        }
      }
    });
    this.setFilesOnInput(this.newFilesInputTarget, orderedPendingFiles);
  }
  setFilesOnInput(input, files) {
    const dt = new DataTransfer();
    files.forEach((f) => dt.items.add(f));
    input.files = dt.files;
  }
  updateImageCount() {
    if (!this.hasImageCountTarget) return;
    this.imageCountTarget.textContent = `${this.totalImageCount} / ${this.maxImagesValue} images`;
  }
  updatePrimaryBadge() {
    this.sortableContainerTarget.querySelectorAll("[data-primary-badge]").forEach((badge) => badge.remove());
    this.sortableContainerTarget.querySelectorAll(`[data-${this.identifier}-target="primaryBadge"]`).forEach((badge) => badge.remove());
    const first = this.sortableContainerTarget.querySelector("[data-image-type]");
    if (first) {
      const badge = document.createElement("span");
      badge.className = "decor:absolute decor:top-1 decor:left-1 decor:bg-suite-primary-500 decor:text-white decor:text-xs decor:px-1.5 decor:py-0.5 decor:rounded-suite-control decor:font-medium";
      badge.textContent = "Primary";
      badge.dataset.primaryBadge = "true";
      first.appendChild(badge);
    }
  }
  get totalImageCount() {
    return this.sortableContainerTarget.querySelectorAll("[data-image-type]").length;
  }
  generateClientId() {
    return `client_${this.nextClientId++}_${Date.now()}`;
  }
  destroyCropper() {
    if (this.cropper) {
      this.cropper.destroy();
      this.cropper = null;
    }
  }
};

// app/javascript/controllers/decor/daisy/forms/text_field_controller.js
var TextFieldController = class extends FormFieldController {
  static targets = ["leadingTextAddOn", "trailingTextAddOn"];
};

// app/javascript/controllers/decor/daisy/forms/number_field_controller.js
var NumberFieldController = class extends TextFieldController {
};

// app/javascript/controllers/decor/daisy/forms/radio_controller.js
var RadioController = class extends FormFieldController {
};

// app/javascript/controllers/decor/daisy/forms/searchable_select_controller.js
import { Controller as Controller11 } from "@hotwired/stimulus";
var searchable_select_controller_default = class extends Controller11 {
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
      if (!this.dropdownTarget.classList.contains("decor:hidden")) {
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
        if (this.dropdownTarget.classList.contains("decor:hidden")) {
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
        if (this.dropdownTarget.classList.contains("decor:hidden")) return;
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
    this.selectedDisplayTarget.classList.add("decor:hidden");
    this.inputTarget.classList.remove("decor:hidden");
    this.inputTarget.value = "";
    this.inputTarget.focus();
    this._openBrowseIfClosed();
  }
  clear(event) {
    if (event) event.stopPropagation();
    if (this.currentSelectedId) this.selectedIds.delete(this.currentSelectedId);
    this.currentSelectedId = null;
    this.selectedDisplayTarget.classList.add("decor:hidden");
    this.inputTarget.classList.remove("decor:hidden");
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
    if (this.dropdownTarget.classList.contains("decor:hidden") && this.inputTarget.value.trim() === "") {
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
    this.selectedDisplayTarget.classList.remove("decor:hidden");
    this.inputTarget.classList.add("decor:hidden");
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
    this.selectedDisplayTarget.classList.remove("decor:hidden");
    this.inputTarget.classList.add("decor:hidden");
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
    this.dropdownTarget.classList.remove("decor:hidden");
  }
  _closeDropdown() {
    this.dropdownTarget.classList.add("decor:hidden");
    this.highlightedIndex = -1;
    this.currentPage = 0;
    this.hasMore = false;
    this.browseMode = false;
    if (this.currentSelectedId) {
      this.selectedDisplayTarget.classList.remove("decor:hidden");
      this.inputTarget.classList.add("decor:hidden");
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

// app/javascript/controllers/decor/daisy/forms/select_controller.js
var SelectController = class _SelectController extends FormFieldController {
  static values = {
    ...FormFieldController.values,
    name: { type: String, default: "" },
    hasBlankOrPlaceholder: Boolean
  };
  connect() {
    super.connect();
    this._boundHandleChange = this.handleChangeEvent.bind(this);
    this.inputTarget.addEventListener("change", this._boundHandleChange);
    this.styleOption();
  }
  disconnect() {
    this.inputTarget.removeEventListener("change", this._boundHandleChange);
    super.disconnect();
  }
  styleOption() {
    let blankSelected = false;
    for (const option of this.inputTarget.children) {
      const isBlank = this.hasBlankOrPlaceholderValue && option.value === "";
      if (isBlank && this.value === option.value) {
        blankSelected = true;
      }
    }
    this.toggleTargetElementClasses(
      this.inputTarget,
      blankSelected,
      [],
      ["text-disabled"]
    );
  }
  get optionsHTML() {
    return this.inputTarget.innerHTML;
  }
  // Replace the <option> list. `optionsHTML` is treated as trusted markup —
  // callers must escape user-provided strings themselves before passing
  // them in. There's no DOM sanitiser in scope here.
  set options(optionsHTML) {
    this.inputTarget.innerHTML = optionsHTML;
  }
  empty(message) {
    this.options = `<option value="" selected>${escapeText2(message)}</option>`;
  }
  handleChangeEvent(evt) {
    const name = this.nameValue;
    const target = evt.target;
    this.styleOption();
    this.emitEvent(this.element, _SelectController, "change", {
      name,
      index: target.selectedIndex,
      value: target.value
    });
  }
};
function escapeText2(s) {
  return String(s).replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[c]);
}

// app/javascript/controllers/decor/daisy/forms/switch_controller.js
import { Controller as Controller12 } from "@hotwired/stimulus";
var switch_controller_default = class extends Controller12 {
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

// app/javascript/controllers/decor/daisy/forms/text_area_controller.js
var TextAreaController = class extends FormFieldController {
};

// app/javascript/controllers/decor/daisy/map_controller.js
import { Controller as Controller13 } from "@hotwired/stimulus";
var map_controller_default = class extends Controller13 {
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
import { Controller as Controller14 } from "@hotwired/stimulus";
var confirm_controller_default = class extends Controller14 {
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
import { Controller as Controller15 } from "@hotwired/stimulus";
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
var modal_controller_default = class extends Controller15 {
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
    this.element.addEventListener("turbo:submit-end", this.boundHandleSubmitEnd);
    if (this.showInitialValue) {
      this.open({
        contentHref: this.contentHrefValue
      });
    }
  }
  disconnect() {
    this.element.removeEventListener("turbo:submit-end", this.boundHandleSubmitEnd);
  }
  boundHandleSubmitEnd = (evt) => {
    if (this.element.open && evt.detail && evt.detail.success) {
      this.close("submit-success");
    }
  };
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

// app/javascript/controllers/decor/daisy/modals/confirm_template_controller.js
import { Controller as Controller16 } from "@hotwired/stimulus";
var confirm_template_controller_default = class extends Controller16 {
  static targets = [
    "accent",
    "iconInfo",
    "iconSuccess",
    "iconWarning",
    "iconDanger",
    "iconDestructive",
    "iconNeutral",
    "title",
    "message",
    "cancelButton",
    "confirmButton",
    "header"
  ];
  static classes = [
    "accentInfo",
    "accentSuccess",
    "accentWarning",
    "accentDanger",
    "accentDestructive",
    "accentNeutral",
    "iconColorInfo",
    "iconColorSuccess",
    "iconColorWarning",
    "iconColorDanger",
    "iconColorDestructive",
    "destructiveHeader",
    "destructiveTitle"
  ];
  // Populate user-visible slots from caller options.
  // Recognises options: { title?, message?, messageHTML?,
  //                       negativeButtonLabel?, positiveButtonLabel? }
  fillSlots(options) {
    if (options.title != null && this.hasTitleTarget) {
      this.titleTarget.textContent = options.title;
    }
    if (this.hasMessageTarget) {
      if (options.messageHTML != null) {
        safelySetInnerHTML(this.messageTarget, markAsSafeHTML(options.messageHTML.toString()));
      } else if (options.message != null) {
        this.messageTarget.textContent = options.message;
      }
    }
    if (options.negativeButtonLabel != null && this.cancelButtonTargets.length > 1) {
      this.cancelButtonTargets[1].textContent = options.negativeButtonLabel;
    }
    if (options.positiveButtonLabel != null && this.hasConfirmButtonTarget) {
      this.confirmButtonTarget.textContent = options.positiveButtonLabel;
    }
  }
  // Show the icon for the chosen variant, paint the accent bar, and for
  // :destructive apply the destructive header + title class lists.
  applyVariant(variantKey) {
    const variant = variantKey || "info";
    const accentMap = {
      info: this.accentInfoClasses,
      success: this.accentSuccessClasses,
      warning: this.accentWarningClasses,
      danger: this.accentDangerClasses,
      destructive: this.accentDestructiveClasses,
      neutral: this.accentNeutralClasses
    };
    const iconColorMap = {
      info: this.iconColorInfoClasses,
      success: this.iconColorSuccessClasses,
      warning: this.iconColorWarningClasses,
      danger: this.iconColorDangerClasses,
      destructive: this.iconColorDestructiveClasses
    };
    const iconTargetMap = {
      info: this.hasIconInfoTarget ? this.iconInfoTarget : null,
      success: this.hasIconSuccessTarget ? this.iconSuccessTarget : null,
      warning: this.hasIconWarningTarget ? this.iconWarningTarget : null,
      danger: this.hasIconDangerTarget ? this.iconDangerTarget : null,
      destructive: this.hasIconDestructiveTarget ? this.iconDestructiveTarget : null,
      neutral: this.hasIconNeutralTarget ? this.iconNeutralTarget : null
    };
    if (this.hasAccentTarget) {
      this.accentTarget.hidden = false;
      const accentClasses = accentMap[variant] ?? this.accentInfoClasses;
      if (accentClasses) this.accentTarget.classList.add(...accentClasses);
    }
    Object.values(iconTargetMap).forEach((el) => {
      if (el) el.hidden = true;
    });
    const iconEl = iconTargetMap[variant];
    if (iconEl) {
      iconEl.hidden = false;
      const tint = iconColorMap[variant];
      if (tint) iconEl.classList.add(...tint);
    }
    if (variant === "destructive") {
      if (this.hasHeaderTarget && this.destructiveHeaderClasses) {
        this.headerTarget.classList.add(...this.destructiveHeaderClasses);
      }
      if (this.hasTitleTarget && this.destructiveTitleClasses) {
        this.titleTarget.classList.add(...this.destructiveTitleClasses);
      }
      if (this.hasConfirmButtonTarget) {
        this.confirmButtonTarget.classList.remove(
          "decor:bg-suite-primary-500",
          "decor:hover:bg-suite-primary-700"
        );
        this.confirmButtonTarget.classList.add(
          "decor:bg-suite-danger-500",
          "decor:hover:bg-suite-danger-700"
        );
      }
    }
  }
  // Bind click handlers on cancel/confirm buttons that close the dialog with
  // the caller-specified reasons. The cloned dialog is owned by spawn-flow —
  // wireCloseHandlers also wires the `close` event to remove it from <body>
  // so we never leak DOM nodes across spawns.
  wireCloseHandlers(options) {
    const dialog = this.element;
    const negativeReason = options.negativeButtonReason ?? "cancelled";
    const positiveReason = options.positiveButtonReason ?? "confirmed";
    const defaultReason = options.defaultReason ?? negativeReason;
    this.cancelButtonTargets.forEach((btn) => {
      btn.addEventListener("click", (e) => {
        e.preventDefault();
        dialog.close(negativeReason);
      });
    });
    if (this.hasConfirmButtonTarget) {
      this.confirmButtonTarget.addEventListener("click", (e) => {
        e.preventDefault();
        dialog.close(positiveReason);
      });
    }
    dialog.addEventListener("cancel", (e) => {
      e.preventDefault();
      dialog.close(defaultReason);
    }, { once: true });
    dialog.addEventListener("close", () => {
      const reason = dialog.returnValue || defaultReason;
      dialog.dispatchEvent(new CustomEvent("decor--suite--modals--modal:closing", {
        bubbles: true,
        cancelable: false,
        detail: { reason, closeReason: reason }
      }));
      dialog.remove();
    }, { once: true });
  }
};

// app/javascript/controllers/decor/daisy/modals/modal_close_button_controller.js
import { Controller as Controller17 } from "@hotwired/stimulus";
var modal_close_button_controller_default = class extends Controller17 {
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
import { Controller as Controller18 } from "@hotwired/stimulus";
var modal_open_button_controller_default = class extends Controller18 {
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
import { Controller as Controller19 } from "@hotwired/stimulus";
var modal_trigger_controller_default = class extends Controller19 {
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

// app/javascript/controllers/decor/daisy/nav/side_navbar_controller.js
import { Controller as Controller20 } from "@hotwired/stimulus";
var side_navbar_controller_default = class extends Controller20 {
  static targets = [
    "mobileMenu",
    "desktopMenu",
    "desktopAvatarLogo",
    "desktopLogo",
    "desktopCollapseIcon",
    "desktopExpandIcon",
    "mobileSearchNavigation",
    "searchNavigation"
  ];
  static values = { collapsed: { type: Boolean, default: false } };
  // Cookie that persists the collapsed state across reloads. Read on connect so
  // client-side state restores; written on every toggle.
  static collapsedCookieName = "decor_side_navbar_collapsed";
  connect() {
    const stored = this.readCollapsedCookie();
    if (stored !== null) this.collapsedValue = stored;
  }
  readCollapsedCookie() {
    const match = document.cookie.match(
      new RegExp("(?:^|; )" + this.constructor.collapsedCookieName + "=([^;]*)")
    );
    if (!match) return null;
    return match[1] === "true";
  }
  writeCollapsedCookie(value) {
    document.cookie = this.constructor.collapsedCookieName + "=" + value + "; path=/; max-age=31536000; samesite=lax";
  }
  // ── Mobile drawer ──────────────────────────────────────────────────────
  toggleMobileMenu(event) {
    if (event && typeof event.preventDefault === "function") event.preventDefault();
    if (this.hasMobileMenuTarget) {
      this.mobileMenuTarget.classList.toggle("decor:hidden");
    }
  }
  // ── Desktop collapse / expand ──────────────────────────────────────────
  toggleCollapseDesktopMenu() {
    this.collapsedValue = !this.collapsedValue;
    this.writeCollapsedCookie(this.collapsedValue);
  }
  collapsedValueChanged() {
    this.applyCollapsed(this.collapsedValue);
  }
  applyCollapsed(collapsed) {
    if (this.hasDesktopMenuTarget) {
      this.desktopMenuTarget.classList.toggle("decor:lg:w-20", collapsed);
      this.desktopMenuTarget.classList.toggle("decor:lg:w-72", !collapsed);
      this.desktopMenuTarget.classList.toggle("collapsed", collapsed);
      if (!collapsed) this.desktopMenuTarget.classList.remove("hover-open");
    }
    document.body.classList.toggle("decor-side-navbar-collapsed", collapsed);
    this.setHidden(this.desktopCollapseIconTarget, this.hasDesktopCollapseIconTarget, collapsed);
    this.setHidden(this.desktopExpandIconTarget, this.hasDesktopExpandIconTarget, !collapsed);
    this.setHidden(this.desktopLogoTarget, this.hasDesktopLogoTarget, collapsed);
    this.setHidden(this.desktopAvatarLogoTarget, this.hasDesktopAvatarLogoTarget, !collapsed);
  }
  setHidden(el, present, hidden) {
    if (!present || !el) return;
    el.classList.toggle("decor:hidden", hidden);
  }
  // ── Hover-to-peek while collapsed ──────────────────────────────────────
  handleMouseOver() {
    if (this.collapsedValue) {
      this.setRailWidth(false);
      if (this.hasDesktopMenuTarget) this.desktopMenuTarget.classList.add("hover-open");
    }
  }
  handleMouseAway() {
    if (this.collapsedValue) this.setRailWidth(true);
    if (this.hasDesktopMenuTarget) this.desktopMenuTarget.classList.remove("hover-open");
  }
  setRailWidth(narrow) {
    if (!this.hasDesktopMenuTarget) return;
    this.desktopMenuTarget.classList.toggle("decor:lg:w-20", narrow);
    this.desktopMenuTarget.classList.toggle("decor:lg:w-72", !narrow);
  }
  // ── Client-side nav filter ─────────────────────────────────────────────
  search(event) {
    const query = (event.target.value || "").trim().toLowerCase();
    this.element.querySelectorAll("nav a").forEach((link) => {
      const match = query === "" || link.textContent.toLowerCase().includes(query);
      link.classList.toggle("decor:hidden", !match);
    });
  }
};

// app/javascript/controllers/decor/daisy/nav/top_navbar_controller.js
import { Controller as Controller21 } from "@hotwired/stimulus";
var top_navbar_controller_default = class extends Controller21 {
  static targets = ["search", "searchInput", "searchDropdown"];
  toggleMobileMenu() {
    const sidebar = document.querySelector(
      "[data-controller~='decor--suite--nav--side-navbar'],[data-controller~='decor--daisy--nav--side-navbar']"
    );
    if (!sidebar) return;
    const identifier = (sidebar.getAttribute("data-controller") || "").split(/\s+/).find((c) => /nav--side-navbar$/.test(c));
    if (identifier) {
      window.dispatchEvent(new CustomEvent(`${identifier}:toggleMobileMenu`));
    }
  }
  // Instant search needs a backend that the harness doesn't provide; keep these
  // as safe no-ops so the component's wired actions resolve.
  clickedSearchInput() {
  }
  search() {
  }
  gotSearchFocus() {
  }
  lostSearchFocus() {
  }
  clickedSearchContent() {
  }
};

// app/javascript/controllers/decor/daisy/notification_manager_controller.js
import { Controller as Controller22 } from "@hotwired/stimulus";
var NOTIFICATION_MANAGER_CLASS_NAME = "decor--daisy--notification-manager";
var DEFAULT_DISMISS_AFTER_MS = 3e3;
var DISMISS_ALL_STAGGER_MS = 50;
var notification_manager_controller_default = class extends Controller22 {
  static targets = ["notificationContainer"];
  static values = {
    initialNotifications: { type: Array, default: [] }
  };
  // Subclasses override to emit a different CSS class on each notification node.
  get notificationClassName() {
    return `${NOTIFICATION_MANAGER_CLASS_NAME}-notification`;
  }
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
    const notifications = Array.from(this.notificationContainerTarget.getElementsByClassName(this.notificationClassName));
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
    return `${this.notificationClassName}-${++this.currentNotificationId}`;
  }
  async createNotification(options, contentHref) {
    const notification = document.createElement("div");
    notification.id = this.nextNotificationId();
    notification.className = this.notificationClassName;
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
      element.style.pointerEvents = "none";
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
      notification.className = this.notificationClassName;
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

// app/javascript/controllers/decor/daisy/polygon_editor_controller.js
import { Controller as Controller23 } from "@hotwired/stimulus";
var polygon_editor_controller_default = class extends Controller23 {
  static targets = ["mapContainer", "geoJsonInput"];
  static values = {
    apiKey: String,
    zoom: { type: Number, default: 10 },
    center: { type: String, default: null },
    initialPolygon: { type: String, default: null }
  };
  initialize() {
    this.googleMap = null;
    this.drawingManager = null;
    this.currentPolygon = null;
    this.attachMapScript();
  }
  connect() {
    this.onMapReady(() => {
      this.createMap();
      this.initializeDrawingManager();
      this.loadInitialPolygon();
    });
  }
  disconnect() {
    this.cleanup();
  }
  attachMapScript() {
    if (document.getElementById("google-maps-script-tag")) {
      return;
    }
    window.__decorPolygonMapInitialised = this.mapInitialised.bind(this);
    const key = this.apiKeyValue;
    const src = `https://maps.googleapis.com/maps/api/js?key=${encodeURIComponent(key)}&libraries=drawing&callback=__decorPolygonMapInitialised`;
    const script = document.createElement("script");
    script.type = "text/javascript";
    script.async = true;
    script.defer = true;
    script.id = "google-maps-script-tag";
    script.src = src;
    document.head.appendChild(script);
  }
  mapInitialised() {
    window.__decorMapHasLoaded = true;
    const evt = new CustomEvent("google-maps-script:ready", {
      bubbles: true,
      cancelable: false
    });
    document.dispatchEvent(evt);
  }
  onMapReady(callback) {
    if (window.__decorMapHasLoaded && window.google && window.google.maps) {
      return callback();
    }
    const readyListener = () => {
      callback();
      document.removeEventListener("google-maps-script:ready", readyListener);
    };
    document.addEventListener("google-maps-script:ready", readyListener);
  }
  createMap() {
    this.googleMap = new google.maps.Map(this.mapContainerTarget, {
      center: this.mapCenter,
      zoom: this.zoomValue,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });
  }
  initializeDrawingManager() {
    if (!this.googleMap) {
      return;
    }
    this.drawingManager = new google.maps.drawing.DrawingManager({
      drawingMode: null,
      drawingControl: true,
      drawingControlOptions: {
        position: google.maps.ControlPosition.TOP_CENTER,
        drawingModes: [google.maps.drawing.OverlayType.POLYGON]
      },
      polygonOptions: {
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35,
        editable: true,
        draggable: false
      }
    });
    this.drawingManager.setMap(this.googleMap);
    google.maps.event.addListener(
      this.drawingManager,
      "overlaycomplete",
      (event) => {
        if (event.type === google.maps.drawing.OverlayType.POLYGON) {
          this.handlePolygonComplete(event.overlay);
        }
      }
    );
  }
  handlePolygonComplete(polygon) {
    this.clearPolygon();
    this.currentPolygon = polygon;
    if (this.drawingManager) {
      this.drawingManager.setDrawingMode(null);
    }
    polygon.setEditable(true);
    this.updateGeoJsonField();
    this.addPolygonEditListeners(polygon);
  }
  addPolygonEditListeners(polygon) {
    const path = polygon.getPath();
    google.maps.event.addListener(path, "set_at", () => {
      this.updateGeoJsonField();
    });
    google.maps.event.addListener(path, "insert_at", () => {
      this.updateGeoJsonField();
    });
    google.maps.event.addListener(path, "remove_at", () => {
      this.updateGeoJsonField();
    });
  }
  loadInitialPolygon() {
    if (!this.initialPolygonValue || !this.googleMap) {
      return;
    }
    try {
      const polygon = this.geoJsonToPolygon(this.initialPolygonValue);
      if (polygon) {
        this.currentPolygon = polygon;
        polygon.setMap(this.googleMap);
        polygon.setEditable(true);
        this.fitBoundsToPolygon(polygon);
        this.addPolygonEditListeners(polygon);
      }
    } catch (error) {
      console.error("Failed to load initial polygon:", error);
    }
  }
  geoJsonToPolygon(geoJsonString) {
    try {
      const geoJson = JSON.parse(geoJsonString);
      let coordinates;
      if (geoJson.type === "MultiPolygon") {
        coordinates = geoJson.coordinates[0];
      } else if (geoJson.type === "Polygon") {
        coordinates = geoJson.coordinates;
      } else {
        console.error("Unsupported GeoJSON type:", geoJson.type);
        return null;
      }
      const paths = coordinates.map(
        (ring) => ring.map((coord) => new google.maps.LatLng(coord[1], coord[0]))
      );
      return new google.maps.Polygon({
        paths,
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35,
        editable: true,
        draggable: false
      });
    } catch (error) {
      console.error("Error parsing GeoJSON:", error);
      return null;
    }
  }
  polygonToGeoJson(polygon) {
    const path = polygon.getPath();
    const coordinates = [];
    for (let i = 0; i < path.getLength(); i++) {
      const latLng = path.getAt(i);
      coordinates.push([latLng.lng(), latLng.lat()]);
    }
    if (coordinates.length > 0) {
      const firstCoord = coordinates[0];
      coordinates.push([firstCoord[0], firstCoord[1]]);
    }
    const geoJson = {
      type: "MultiPolygon",
      coordinates: [[coordinates]]
    };
    return JSON.stringify(geoJson);
  }
  updateGeoJsonField() {
    if (!this.currentPolygon) {
      this.geoJsonInputTarget.value = "";
      return;
    }
    this.geoJsonInputTarget.value = this.polygonToGeoJson(this.currentPolygon);
  }
  fitBoundsToPolygon(polygon) {
    if (!this.googleMap) {
      return;
    }
    const bounds = new google.maps.LatLngBounds();
    const path = polygon.getPath();
    for (let i = 0; i < path.getLength(); i++) {
      bounds.extend(path.getAt(i));
    }
    this.googleMap.fitBounds(bounds);
  }
  clearPolygon() {
    if (this.currentPolygon) {
      this.currentPolygon.setMap(null);
      this.currentPolygon = null;
      this.updateGeoJsonField();
    }
    if (this.drawingManager) {
      this.drawingManager.setDrawingMode(
        google.maps.drawing.OverlayType.POLYGON
      );
    }
  }
  get mapCenter() {
    if (this.centerValue) {
      try {
        const center = JSON.parse(this.centerValue);
        return { lat: center.lat, lng: center.lng };
      } catch (error) {
        console.error("Error parsing center value:", error);
      }
    }
    return { lat: 33.6265064, lng: -84.5319427 };
  }
  cleanup() {
    if (this.currentPolygon) {
      this.currentPolygon.setMap(null);
      this.currentPolygon = null;
    }
    if (this.drawingManager) {
      this.drawingManager.setMap(null);
      this.drawingManager = null;
    }
    this.googleMap = null;
  }
};

// app/javascript/controllers/decor/daisy/progress_controller.js
import { Controller as Controller24 } from "@hotwired/stimulus";
var progress_controller_default = class extends Controller24 {
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

// app/javascript/controllers/decor/daisy/tables/bulk_actions_bar_controller.js
import { Controller as Controller25 } from "@hotwired/stimulus";
var bulk_actions_bar_controller_default = class extends Controller25 {
  static targets = [
    "selectionCount",
    "selectedIdsContainer",
    "dropdownForm"
  ];
  static values = {
    selectedIdsFieldName: { type: String, default: "selected_ids" }
  };
  initialize() {
    this.dataTableController = null;
    this.tableId = null;
    this.offPageSelectionCount = 0;
  }
  connect() {
    this.boundHandleBulkSubmitEnd = this.handleBulkSubmitEnd.bind(this);
    window.addEventListener("turbo:submit-end", this.boundHandleBulkSubmitEnd);
  }
  disconnect() {
    window.removeEventListener("turbo:submit-end", this.boundHandleBulkSubmitEnd);
  }
  // A bulk action consumes the current selection. When the action's Turbo form
  // submits successfully, clear the selection (and its localStorage
  // persistence) so it doesn't silently resurrect on the next page load — the
  // morph that redraws the table only unchecks the rows visually, it doesn't
  // touch persistence. Scoped to forms belonging to this bar (inline/dropdown
  // action forms) or to this bar's modal (the modal action form, wherever the
  // modal currently lives in the DOM), so the page's other forms (e.g. a create
  // form) never clear the selection. A failed submit leaves the selection
  // intact.
  handleBulkSubmitEnd(event) {
    if (!event.detail || !event.detail.success) return;
    const form = event.target;
    if (!(form instanceof HTMLFormElement)) return;
    const fromBar = this.element.contains(form);
    const modal = document.getElementById(`${this.element.id}-bulk-modal`);
    const fromModal = modal ? modal.contains(form) : false;
    if (fromBar || fromModal) {
      this.clearSelection();
    }
  }
  setDataTableController(controller) {
    this.dataTableController = controller;
    this.checkForExistingSelections();
  }
  setTableId(id) {
    this.tableId = id;
    this.checkForExistingSelections();
  }
  checkForExistingSelections() {
    if (this.tableId && this.dataTableController) {
      const selectedIds = this.dataTableController.getSelectedRowIds();
      if (selectedIds.length > 0) {
        this.handleSelectionChange(selectedIds);
      }
    }
  }
  handleSelectionChange(selectedIds) {
    const count = selectedIds.length;
    if (this.tableId && this.dataTableController) {
      const visibleCount = this.dataTableController.getVisibleSelectedRowIds().length;
      this.offPageSelectionCount = count - visibleCount;
    }
    let countText = `${count} ${count === 1 ? "item" : "items"} selected`;
    if (this.offPageSelectionCount > 0) {
      countText += ` (${this.offPageSelectionCount} from other pages)`;
    }
    this.selectionCountTarget.textContent = countText;
    this.element.style.display = count > 0 ? "" : "none";
    this.updateSelectedIdsInputs(selectedIds);
  }
  updateSelectedIdsInputs(selectedIds) {
    this.selectedIdsContainerTargets.forEach((container) => {
      const fieldName = container.dataset.fieldName || this.selectedIdsFieldNameValue;
      container.innerHTML = "";
      selectedIds.forEach((id) => {
        const input = document.createElement("input");
        input.type = "hidden";
        input.name = `${fieldName}[]`;
        input.value = id;
        container.appendChild(input);
      });
    });
  }
  clearSelection() {
    if (this.dataTableController) {
      this.dataTableController.clearSelection();
    }
  }
  async handleBulkAction(event) {
    event.preventDefault();
    const button = event.currentTarget;
    const form = button.closest("form");
    if (!form || !this.dataTableController) {
      return;
    }
    if (button.dataset.modal === "true") {
      this.openBulkActionModal(form);
      return;
    }
    await this.confirmAndSubmitForm(form, button.dataset.bulkConfirm);
  }
  async handleDropdownAction(event) {
    event.preventDefault();
    const menuItem = event.currentTarget;
    const actionName = menuItem.dataset.actionName;
    if (!this.dataTableController || !actionName) {
      return;
    }
    const form = this.findFormByActionName(actionName);
    if (!form) {
      return;
    }
    if (menuItem.dataset.modal === "true") {
      this.openBulkActionModal(form);
      return;
    }
    await this.confirmAndSubmitForm(form, menuItem.dataset.bulkConfirm);
  }
  findFormByActionName(actionName) {
    return this.dropdownFormTargets.find((f) => {
      const field = f.querySelector('input[name="action_name"]');
      return field && field.value === actionName;
    });
  }
  openBulkActionModal(form) {
    const selectedIds = this.dataTableController.getSelectedRowIds();
    const url = new URL(form.action, window.location.origin);
    selectedIds.forEach((id) => url.searchParams.append("selected_ids[]", id));
    const modalId = `${this.element.id}-bulk-modal`;
    const detail = { id: modalId, contentHref: url.toString() };
    const handled = window.dispatchEvent(
      new CustomEvent("decor:bulk-actions:show-modal", {
        detail,
        cancelable: true
      })
    );
    if (handled) {
      const dialog = document.getElementById(modalId);
      if (dialog && typeof dialog.showModal === "function") {
        dialog.showModal();
      }
    }
  }
  async confirmAndSubmitForm(form, confirmMessage) {
    if (confirmMessage && this.dataTableController) {
      const count = this.dataTableController.getSelectionCount();
      const message = this.interpolateCount(confirmMessage, count);
      const confirmed = await this.showConfirmModal(message);
      if (!confirmed) {
        return;
      }
    }
    form.requestSubmit();
  }
  interpolateCount(message, count) {
    return message.replace(/\{count\}/g, count.toString()).replace(/\{\{count\}\}/g, count.toString());
  }
  // Confirm dialog hook — apps wire a real modal helper by listening for
  // the dispatched event and calling `event.detail.resolve(true|false)`.
  // The default falls back to `window.confirm()`.
  showConfirmModal(message) {
    return new Promise((resolve) => {
      const event = new CustomEvent("decor:bulk-actions:show-confirm", {
        detail: {
          message,
          title: "Are you sure?",
          resolve
        },
        cancelable: true
      });
      const notCancelled = window.dispatchEvent(event);
      if (notCancelled) {
        resolve(window.confirm(message));
      }
    });
  }
};

// app/javascript/controllers/decor/daisy/tables/tag_filter_bar_controller.js
import { Controller as Controller26 } from "@hotwired/stimulus";
var tag_filter_bar_controller_default = class extends Controller26 {
  static targets = [
    "chip",
    "applyButton",
    "modeToggle",
    "overflowButton",
    "tagsContainer"
  ];
  static values = {
    selectedIds: String,
    tagMode: String,
    paramName: String,
    modeParamName: String
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
      btn.className = `decor:px-2.5 decor:py-1 decor:leading-none ${isActive ? "decor:bg-gray-800 decor:text-white" : "decor:bg-white decor:text-gray-600 decor:hover:bg-gray-50"}`;
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
        Array.from(this.currentSelectedIds).join(",")
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
    const selectedClasses = (button.dataset.selectedClasses || "").split(" ").filter(Boolean);
    const unselectedClasses = (button.dataset.unselectedClasses || "").split(" ").filter(Boolean);
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
      this.initialSelectedIds
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
};

// app/javascript/controllers/decor/daisy/tabs_controller.js
import { Controller as Controller27 } from "@hotwired/stimulus";
var tabs_controller_default = class extends Controller27 {
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
import { Controller as Controller28 } from "@hotwired/stimulus";
var progress_animation_controller_default = class extends Controller28 {
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
import { Controller as Controller29 } from "@hotwired/stimulus";
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
var carousel_controller_default = class extends Controller29 {
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

// app/javascript/controllers/decor/suite/code_block_controller.js
var SuiteCodeBlockController = class extends code_block_controller_default {
};

// app/javascript/controllers/decor/suite/dropdown_controller.js
import { Controller as Controller30 } from "@hotwired/stimulus";
var dropdown_controller_default2 = class extends Controller30 {
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

// app/javascript/controllers/decor/suite/forms/file_upload_controller.js
var SuiteFormsFileUploadController = class extends FileUploadController {
};

// app/javascript/controllers/decor/suite/forms/form_controller.js
import { Controller as Controller31 } from "@hotwired/stimulus";
var form_controller_default = class extends Controller31 {
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

// app/javascript/controllers/decor/suite/forms/multi_image_upload_controller.js
var SuiteFormsMultiImageUploadController = class extends multi_image_upload_controller_default {
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
import { Controller as Controller32 } from "@hotwired/stimulus";
var confirm_controller_default2 = class extends Controller32 {
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
import { Controller as Controller33 } from "@hotwired/stimulus";
var modal_close_button_controller_default2 = class extends Controller33 {
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
import { Controller as Controller34 } from "@hotwired/stimulus";
var LOADING_SKELETON_HTML = `
  <div class="decor:space-y-2 decor:py-1" aria-hidden="true">
    <div class="decor:h-3 decor:bg-gray-100 decor:rounded-sm decor:animate-pulse"></div>
    <div class="decor:h-3 decor:bg-gray-100 decor:rounded-sm decor:animate-pulse decor:w-5/6"></div>
    <div class="decor:h-3 decor:bg-gray-100 decor:rounded-sm decor:animate-pulse decor:w-3/4"></div>
  </div>
`;
var OPENED_EVENT = "decor--suite--modals--modal:opened";
var CLOSED_EVENT = "decor--suite--modals--modal:closed";
var modal_controller_default2 = class extends Controller34 {
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
    this.dialog.addEventListener("turbo:submit-end", this.boundHandleSubmitEnd);
    if (this.startOpenValue || this.showInitialValue) {
      requestAnimationFrame(() => this.open());
    }
  }
  disconnect() {
    this.dialog.removeEventListener("close", this.boundHandleClose);
    this.dialog.removeEventListener("cancel", this.boundHandleCancel);
    this.dialog.removeEventListener("turbo:submit-end", this.boundHandleSubmitEnd);
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
      const titleEl = this.element.querySelector(".decor-modal__title");
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
  boundHandleSubmitEnd = (evt) => {
    if (this.dialog.open && evt.detail && evt.detail.success) {
      this.close("submit-success");
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
  //     → cloned into .decor-modal__destructive-slot (left-pinned in footer)
  //
  //   <template data-modal-hide-submit></template>
  //     → footer Submit button gets display:none
  //
  // Markers are removed from the body after processing. The reset step on
  // every open ensures stale footer state from a previous row never lingers.
  resetFooterMarkers() {
    const slot = this.element.querySelector(".decor-modal__destructive-slot");
    if (slot) slot.replaceChildren();
    const submit = this.element.querySelector(".decor-modal__footer button[type=submit]");
    if (submit) submit.style.display = "";
  }
  applyFooterMarkers(bodyEl) {
    const slot = this.element.querySelector(".decor-modal__destructive-slot");
    if (slot) {
      const destrTpl = bodyEl.querySelector("template[data-modal-destructive-action]");
      if (destrTpl) {
        slot.replaceChildren(destrTpl.content.cloneNode(true));
        destrTpl.remove();
      } else {
        slot.replaceChildren();
      }
    }
    const submit = this.element.querySelector(".decor-modal__footer button[type=submit]");
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
    return this.element.querySelector(".decor-modal__body");
  }
  showLoadingSkeleton(bodyEl) {
    this.element.setAttribute("aria-busy", "true");
    this.element.classList.add("decor-modal--loading");
    safelySetInnerHTML(bodyEl, markAsSafeHTML(LOADING_SKELETON_HTML));
  }
  clearLoadingState() {
    this.element.removeAttribute("aria-busy");
    this.element.classList.remove("decor-modal--loading");
  }
  parseModalFragment(content) {
    if (!content.__safe) return null;
    const tpl = document.createElement("template");
    tpl.innerHTML = content.content;
    const topLevel = Array.from(tpl.content.children);
    if (topLevel.length !== 1) return null;
    const root = topLevel[0];
    if (root instanceof HTMLDialogElement && root.classList.contains("decor-modal")) {
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
import { Controller as Controller35 } from "@hotwired/stimulus";
var modal_open_button_controller_default2 = class extends Controller35 {
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
import { Controller as Controller36 } from "@hotwired/stimulus";
var modal_trigger_controller_default2 = class extends Controller36 {
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

// app/javascript/controllers/decor/suite/notification_manager_controller.js
var SuiteNotificationManagerController = class extends notification_manager_controller_default {
  get notificationClassName() {
    return "decor--suite--notification";
  }
  async createNotification(options, contentHref) {
    const template = document.getElementById(`${this.element.id}-toast-template`);
    if (!template || !("content" in template)) {
      return super.createNotification(options, contentHref);
    }
    const frag = template.content.firstElementChild;
    if (!frag) return super.createNotification(options, contentHref);
    const node = frag.cloneNode(true);
    node.id = this.nextNotificationId();
    node.classList.add(this.notificationClassName);
    const body = options.body ?? options.content;
    const title = options.title;
    const titleEl = node.querySelector('[data-notification-slot="title"]');
    if (titleEl) titleEl.textContent = title ?? "";
    const headerEl = node.querySelector('[data-notification-slot="header"]');
    if (headerEl) this._toggleSlotHidden(headerEl, !title);
    const bodyTextEl = node.querySelector('[data-notification-slot="body-text"]');
    if (bodyTextEl) {
      if (body && typeof body === "object" && body.__safe) {
        safelySetInnerHTML(bodyTextEl, body);
      } else {
        bodyTextEl.textContent = typeof body === "string" ? body : "";
      }
    }
    const bodyEl = node.querySelector('[data-notification-slot="body"]');
    if (bodyEl) this._toggleSlotHidden(bodyEl, !body && !options.destination);
    return node;
  }
  _toggleSlotHidden(el, shouldHide) {
    if (shouldHide) {
      el.setAttribute("hidden", "");
    } else {
      el.removeAttribute("hidden");
    }
  }
};

// app/javascript/controllers/decor/suite/search_and_filter_controller.js
import { Controller as Controller37 } from "@hotwired/stimulus";
var search_and_filter_controller_default = class extends Controller37 {
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
import { Controller as Controller38 } from "@hotwired/stimulus";
var row_controller_default = class extends Controller38 {
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
import { Controller as Controller39 } from "@hotwired/stimulus";
var data_table_cell_controller_default = class extends Controller39 {
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
import { Controller as Controller40 } from "@hotwired/stimulus";

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
var data_table_controller_default = class extends Controller40 {
  static outlets = [
    "decor--suite--tables--bulk-actions-bar"
  ];
  static targets = [
    "tableContentContainer",
    "tableBody",
    "rowCheckbox",
    "selectAllCheckbox"
  ];
  static values = {
    tableId: { type: String, default: "" },
    persistSelections: { type: Boolean, default: false }
  };
  static SELECTION_CHANGE_DEBOUNCE_MS = 150;
  static MAX_APPLY_SELECTIONS_RETRIES = 3;
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
    if (this.hasBulkActionsBarController) {
      if (typeof this.bulkActionsBarController.setDataTableController === "function") {
        this.bulkActionsBarController.setDataTableController(this);
      }
      if (this.persistSelectionsValue && this.tableIdValue && typeof this.bulkActionsBarController.setTableId === "function") {
        this.bulkActionsBarController.setTableId(this.tableIdValue);
      }
    }
    if (this.hasTableContentContainerTarget) {
      this.resizeObserver = new ResizeObserver(() => this.contentScrolled());
      this.resizeObserver.observe(this.tableContentContainerTarget);
    }
  }
  disconnect() {
    this.selectionChangeListeners.clear();
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
  // ── Target lifecycle callbacks ──────────────────────────────────────────────
  rowCheckboxTargetConnected(checkbox) {
    if (this.persistSelectionsValue && this.tableIdValue) {
      if (this.persistedSelections.has(checkbox.value)) {
        checkbox.checked = true;
      }
    }
    this.updateHeaderCheckboxState();
  }
  rowCheckboxTargetDisconnected(_checkbox) {
    this.updateHeaderCheckboxState();
  }
  // ── Actions ────────────────────────────────────────────────────────────────
  /**
   * Called when an individual row checkbox changes.
   * Updates persistence, header tri-state, and notifies listeners.
   */
  rowChanged(event) {
    const checkbox = event.target;
    if (this.persistSelectionsValue && this.tableIdValue) {
      if (checkbox.checked) {
        this.persistedSelections.add(checkbox.value);
      } else {
        this.persistedSelections.delete(checkbox.value);
      }
    }
    this.updateHeaderCheckboxState();
    this.notifySelectionChange();
  }
  /**
   * Called when the "select all" header checkbox changes.
   * Sets every row checkbox to match and updates persistence.
   */
  toggleAll(event) {
    const checked = event.target.checked;
    this.rowCheckboxTargets.forEach((cb) => {
      cb.checked = checked;
    });
    if (this.persistSelectionsValue && this.tableIdValue) {
      if (checked) {
        this.rowCheckboxTargets.forEach((cb) => {
          if (cb.value) this.persistedSelections.add(cb.value);
        });
      } else {
        this.rowCheckboxTargets.forEach((cb) => {
          if (cb.value) this.persistedSelections.delete(cb.value);
        });
      }
    }
    this.notifySelectionChange();
  }
  // ── Selection API ───────────────────────────────────────────────────────────
  getSelectedRowIds() {
    if (this.persistSelectionsValue && this.tableIdValue) {
      return Array.from(this.persistedSelections);
    }
    return this.rowCheckboxTargets.filter((cb) => cb.checked).map((cb) => cb.value);
  }
  getVisibleSelectedRowIds() {
    return this.rowCheckboxTargets.filter((cb) => cb.checked).map((cb) => cb.value);
  }
  getSelectionCount() {
    if (this.persistSelectionsValue && this.tableIdValue) {
      return this.persistedSelections.size;
    }
    return this.rowCheckboxTargets.filter((cb) => cb.checked).length;
  }
  hasSelection() {
    return this.getSelectionCount() > 0;
  }
  clearSelection() {
    this.rowCheckboxTargets.forEach((cb) => {
      cb.checked = false;
    });
    if (this.hasSelectAllCheckboxTarget) {
      this.selectAllCheckboxTarget.checked = false;
      this.selectAllCheckboxTarget.indeterminate = false;
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
  // ── Internal helpers ────────────────────────────────────────────────────────
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
        if (this.rowCheckboxTargets.length === 0) {
          this.applySelectionsRetryCount++;
          if (this.applySelectionsRetryCount < this.constructor.MAX_APPLY_SELECTIONS_RETRIES) {
            requestAnimationFrame(() => this.applyPersistedSelections());
          } else {
            console.warn(
              `Failed to apply persisted selections after ${this.constructor.MAX_APPLY_SELECTIONS_RETRIES} retries. Row checkboxes may not be initialized.`
            );
          }
          return;
        }
        this.applySelectionsRetryCount = 0;
        this.rowCheckboxTargets.forEach((cb) => {
          if (cb.value && this.persistedSelections.has(cb.value)) {
            cb.checked = true;
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
    this.rowCheckboxTargets.forEach((cb) => {
      if (cb.value) {
        const shouldBeChecked = this.persistedSelections.has(cb.value);
        if (cb.checked !== shouldBeChecked) {
          cb.checked = shouldBeChecked;
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
  updateHeaderCheckboxState() {
    if (!this.hasSelectAllCheckboxTarget) return;
    const checkboxes = this.rowCheckboxTargets;
    const allChecked = checkboxes.length > 0 && checkboxes.every((cb) => cb.checked);
    const someChecked = checkboxes.some((cb) => cb.checked);
    const hasPersistedSelections = this.persistSelectionsValue && this.persistedSelections.size > 0;
    const header = this.selectAllCheckboxTarget;
    if (allChecked) {
      header.checked = true;
      header.indeterminate = false;
    } else if (someChecked || hasPersistedSelections) {
      header.checked = false;
      header.indeterminate = true;
    } else {
      header.checked = false;
      header.indeterminate = false;
    }
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
  // ── Table DOM helpers ───────────────────────────────────────────────────────
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
import { Controller as Controller41 } from "@hotwired/stimulus";
var tabs_controller_default2 = class extends Controller41 {
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
import { Controller as Controller42 } from "@hotwired/stimulus";
import {
  computePosition,
  autoUpdate,
  flip,
  shift,
  offset as offsetMiddleware,
  arrow
} from "@floating-ui/dom";
var tooltip_controller_default = class extends Controller42 {
  static targets = ["content", "arrow"];
  static values = {
    placement: { type: String, default: "top" },
    offset: { type: Number, default: 8 }
  };
  connect() {
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
    this.showTimer = setTimeout(() => this.show(), 80);
  }
  mouseOut() {
    clearTimeout(this.showTimer);
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
        strategy: "fixed",
        middleware
      }
    );
    Object.assign(this.contentTarget.style, {
      position: "fixed",
      margin: "0",
      inset: "auto",
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
  "decor--daisy--ai-chat--widget": widget_controller_default,
  "decor--daisy--button": button_controller_default,
  "decor--daisy--click-to-copy": click_to_copy_controller_default,
  "decor--daisy--code-block": code_block_controller_default,
  "decor--daisy--dropdown": dropdown_controller_default,
  "decor--daisy--flash": flash_controller_default,
  "decor--daisy--forms--button-radio-group": ButtonRadioGroupController,
  "decor--daisy--forms--checkbox": CheckboxController,
  "decor--daisy--forms--date-calendar": date_calendar_controller_default,
  "decor--daisy--forms--expanding-checkbox-collection": expanding_checkbox_collection_controller_default,
  "decor--daisy--forms--file-upload": FileUploadController,
  "decor--daisy--forms--multi-image-upload": multi_image_upload_controller_default,
  "decor--daisy--forms--number-field": NumberFieldController,
  "decor--daisy--forms--radio": RadioController,
  "decor--daisy--forms--searchable-multi-select": searchable_multi_select_controller_default,
  "decor--daisy--forms--searchable-select": searchable_select_controller_default,
  "decor--daisy--forms--select": SelectController,
  "decor--daisy--forms--switch": switch_controller_default,
  "decor--daisy--forms--text-area": TextAreaController,
  "decor--daisy--forms--text-field": TextFieldController,
  "decor--daisy--map": map_controller_default,
  "decor--daisy--modals--confirm": confirm_controller_default,
  "decor--daisy--modals--confirm-modal": confirm_modal_controller_default,
  "decor--daisy--modals--confirm-template": confirm_template_controller_default,
  "decor--daisy--modals--modal-close-button": modal_close_button_controller_default,
  "decor--daisy--modals--modal": modal_controller_default,
  "decor--daisy--modals--modal-open-button": modal_open_button_controller_default,
  "decor--daisy--modals--modal-trigger": modal_trigger_controller_default,
  "decor--daisy--nav--side-navbar": side_navbar_controller_default,
  "decor--daisy--nav--top-navbar": top_navbar_controller_default,
  "decor--daisy--notification-manager": notification_manager_controller_default,
  "decor--daisy--polygon-editor": polygon_editor_controller_default,
  "decor--daisy--progress": progress_controller_default,
  "decor--daisy--tables--bulk-actions-bar": bulk_actions_bar_controller_default,
  "decor--daisy--tables--tag-filter-bar": tag_filter_bar_controller_default,
  "decor--daisy--tabs": tabs_controller_default,
  "decor--progress-animation": progress_animation_controller_default,
  "decor--suite--ai-chat--widget": widget_controller_default,
  "decor--suite--button": button_controller_default,
  "decor--suite--carousel": carousel_controller_default,
  "decor--suite--click-to-copy": click_to_copy_controller_default,
  "decor--suite--code-block": SuiteCodeBlockController,
  "decor--suite--dropdown": dropdown_controller_default2,
  "decor--suite--flash": flash_controller_default,
  "decor--suite--forms--button-radio-group": ButtonRadioGroupController,
  "decor--suite--forms--checkbox": CheckboxController,
  "decor--suite--forms--date-calendar": date_calendar_controller_default,
  "decor--suite--forms--expanding-checkbox-collection": expanding_checkbox_collection_controller_default,
  "decor--suite--forms--file-upload": SuiteFormsFileUploadController,
  "decor--suite--forms--form": form_controller_default,
  "decor--suite--forms--multi-image-upload": SuiteFormsMultiImageUploadController,
  "decor--suite--forms--number-field": NumberFieldController,
  "decor--suite--forms--radio": RadioController,
  "decor--suite--forms--searchable-multi-select": searchable_multi_select_controller_default2,
  "decor--suite--forms--searchable-select": searchable_select_controller_default2,
  "decor--suite--forms--select": SelectController,
  "decor--suite--forms--switch": switch_controller_default,
  "decor--suite--forms--text-area": TextAreaController,
  "decor--suite--forms--text-field": TextFieldController,
  "decor--suite--map": map_controller_default,
  "decor--suite--modals--confirm": confirm_controller_default2,
  "decor--suite--modals--confirm-modal": confirm_modal_controller_default,
  "decor--suite--modals--confirm-template": confirm_template_controller_default,
  "decor--suite--modals--modal-close-button": modal_close_button_controller_default2,
  "decor--suite--modals--modal": modal_controller_default2,
  "decor--suite--modals--modal-open-button": modal_open_button_controller_default2,
  "decor--suite--modals--modal-trigger": modal_trigger_controller_default2,
  "decor--suite--nav--side-navbar": side_navbar_controller_default,
  "decor--suite--nav--top-navbar": top_navbar_controller_default,
  "decor--suite--notification-manager": SuiteNotificationManagerController,
  "decor--suite--polygon-editor": polygon_editor_controller_default,
  "decor--suite--progress": progress_controller_default,
  "decor--suite--search-and-filter": search_and_filter_controller_default,
  "decor--suite--settings-list--row": row_controller_default,
  "decor--suite--tables--bulk-actions-bar": bulk_actions_bar_controller_default,
  "decor--suite--tables--data-table-cell": data_table_cell_controller_default,
  "decor--suite--tables--data-table": data_table_controller_default,
  "decor--suite--tables--tag-filter-bar": tag_filter_bar_controller_default,
  "decor--suite--tabs": tabs_controller_default2,
  "decor--suite--tooltip": tooltip_controller_default
};

// app/javascript/decor/index.js
function register(application) {
  for (const [identifier, Controller43] of Object.entries(CONTROLLERS)) {
    application.register(identifier, Controller43);
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
