import { Controller } from "@hotwired/stimulus";

// Records Turbo + UJS lifecycle events into #event-log for system tests, and
// performs the old-school UJS DOM updates for the suite page (append created
// row on ajax:success, render errors on ajax:error).
//
// Listeners are bound on `document` exactly once (guarded by a window flag) so
// they survive Turbo morphs. The host element is data-turbo-permanent, so its
// children — including the appended <li> log entries — persist across a morph.
const TURBO_EVENTS = [
  "turbo:submit-start",
  "turbo:before-fetch-request",
  "turbo:before-fetch-response",
  "turbo:submit-end",
  "turbo:before-render",
  "turbo:render",
  "turbo:before-morph-element",
  "turbo:morph-element",
  "turbo:morph",
  "turbo:load",
];
const UJS_EVENTS = [
  "ajax:before",
  "ajax:beforeSend",
  "ajax:send",
  "ajax:stopped",
  "ajax:success",
  "ajax:error",
  "ajax:complete",
];

export default class extends Controller {
  static targets = ["sentinel"];

  connect() {
    this.stamp();
    if (window.__eventLoggerBound) return;
    window.__eventLoggerBound = true;

    [...TURBO_EVENTS, ...UJS_EVENTS].forEach((type) => {
      document.addEventListener(type, (e) => this.record(type, e));
    });
    document.addEventListener("ajax:success", (e) => this.onSuiteSuccess(e));
    document.addEventListener("ajax:error", (e) => this.onSuiteError(e));
  }

  // Stamp a token onto the permanent sentinel. A full page reload recreates the
  // element (no token -> fresh token); a morph preserves it (token unchanged).
  stamp() {
    if (this.hasSentinelTarget && !this.sentinelTarget.dataset.token) {
      this.sentinelTarget.dataset.token = Math.random().toString(36).slice(2);
    }
  }

  record(type, e) {
    const log = document.getElementById("event-log");
    if (!log) return;
    const li = document.createElement("li");
    li.dataset.event = type;
    if (e.detail && typeof e.detail.success !== "undefined") {
      li.dataset.success = String(e.detail.success);
    }
    li.textContent = type;
    log.appendChild(li);
  }

  parse(data) {
    if (typeof data === "string") {
      try { return JSON.parse(data); } catch (_) { return {}; }
    }
    return data || {};
  }

  onSuiteSuccess(e) {
    const list = document.getElementById("suite-todos");
    if (!list) return;
    const body = this.parse(e.detail[0]);
    if (body.html) list.insertAdjacentHTML("beforeend", body.html);
    const errors = document.getElementById("suite-errors");
    if (errors) errors.textContent = "";
  }

  onSuiteError(e) {
    const errors = document.getElementById("suite-errors");
    if (!errors) return;
    const body = this.parse(e.detail[0]);
    errors.textContent = (body.errors || []).join(", ");
  }
}
