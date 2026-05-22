import { Controller } from "@hotwired/stimulus";
import { markAsSafeHTML, safelySetInnerHTML } from "controllers/decor";

// Floating AI-chat widget controller.
//
// Send flow: POST `{message, thread_id}` to `createUrl` with the page CSRF
// token. The server is responsible for emitting streaming responses via
// some out-of-band channel (Action Cable, SSE, etc.). Consumers wire that
// channel up themselves and forward each payload to this controller by
// dispatching a `decor-ai-chat:broadcast` window event whose detail is the
// raw broadcast object (`{ai_chat: {type, ...}}`).
//
// Open externally by dispatching `ai-chat:open` on the window (stable
// contract — declared on the Ruby `stimulus do` block).
const PROCESSING_TIMEOUT_MS = 30_000;
const BROADCAST_EVENT = "decor-ai-chat:broadcast";

export default class extends Controller {
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
    "errorBanner",
  ];

  static values = {
    createUrl: String,
    threadsUrl: String,
    threadEncodedId: { type: String, default: "" },
    open: { type: Boolean, default: false },
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
          "X-CSRF-Token": this.csrfToken,
        },
        body: JSON.stringify({
          message,
          thread_id: this.threadEncodedIdValue || null,
        }),
      });

      if (!response.ok) {
        this.clearProcessingTimeout();
        this.hideThinking();
        try {
          const body = await response.json();
          this.showError(
            body.error || "Failed to send message. Please try again.",
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
    el.className =
      "decor:ml-12 decor:bg-suite-primary-100 decor:text-gray-900 decor:rounded-suite-control decor:px-3 decor:py-2 decor:suite-description";
    el.textContent = text;
    this.messagesTarget.appendChild(el);
    this.scrollToBottom();
  }

  appendChunk(text) {
    this.resetProcessingTimeout();
    this.hideThinking();

    if (!this.streamingEl) {
      this.streamingEl = document.createElement("div");
      this.streamingEl.className =
        "decor:mr-12 decor:bg-suite-gray-25 decor:text-gray-900 decor:rounded-suite-control decor:px-3 decor:py-2 decor:suite-description decor:whitespace-pre-wrap";
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
        el.className =
          "decor:mr-12 decor:bg-suite-gray-25 decor:text-gray-900 decor:rounded-suite-control decor:px-3 decor:py-2 decor:suite-description decor:prose decor:max-w-none";
        safelySetInnerHTML(el, markAsSafeHTML(msg.message.html));
      } else {
        el.className =
          "decor:mr-12 decor:bg-suite-gray-25 decor:text-gray-900 decor:rounded-suite-control decor:px-3 decor:py-2 decor:suite-description decor:whitespace-pre-wrap";
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
        "This conversation has been closed. Please start a new chat.",
      );
      this.inputTarget.disabled = true;
    } else if (msg.code === "message_moderated") {
      this.showError(
        "Your message could not be processed. Please keep messages related to ordering.",
      );
    } else {
      this.showError(msg.error || "Something went wrong. Please try again.");
    }
  }

  appendActions(parent, actions) {
    const container = document.createElement("div");
    container.className = "decor:flex decor:flex-wrap decor:gap-2 decor:mt-2";

    actions.forEach((action) => {
      if (
        action.type === "navigate" &&
        action.path &&
        action.path.startsWith("/")
      ) {
        const link = document.createElement("a");
        link.href = action.path;
        link.textContent = action.label || "Go";
        link.className =
          "decor:inline-flex decor:items-center decor:px-3 decor:py-1 decor:suite-caption decor:font-medium decor:bg-suite-primary-50 decor:text-suite-primary-700 decor:rounded-suite-control decor:border decor:border-suite-primary-100 decor:hover:bg-suite-primary-100 decor:transition-colors";
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
    banner.className =
      "decor:text-center decor:py-2 decor:px-3 decor:suite-caption decor:text-suite-primary-600 decor:bg-suite-primary-50 decor:rounded-suite-control";
    banner.textContent =
      "You're now connected with our support team. Messages will be handled by a team member.";
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
    return (meta && meta.getAttribute("content")) || "";
  }
}
