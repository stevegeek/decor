import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="decor--suite--forms--form"
//
// Top-level form orchestrator. Sets `novalidate` on the <form> on connect so
// the browser doesn't fire native validation alongside the per-field validators,
// intercepts native submit + the scoped custom-submit / validate events, runs
// validation across all form field controllers, and dispatches a `validated`
// event for higher-level listeners (overall error summaries, etc.).
//
// Field controllers are discovered dynamically via DOM query for descendants
// of the form root whose `data-controller` references a known form-field
// identifier. This avoids hardcoding a static list of outlets that has to be
// updated every time a new field type ships.
export default class extends Controller {
  static targets = ["form"];

  connect() {
    // Eager novalidate — the per-field controllers now own validation, so
    // native browser popups would fight the JS-rendered error captions.
    this.element.setAttribute("novalidate", "true");
  }

  disconnect() {
    this.element.removeAttribute("novalidate");
  }

  handleSubmitEvent(evt) {
    // Only handle submits that actually originated from this form. Defensive
    // against bubbled submits from other forms on the same page.
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
        // Field controller without a validate() — skip rather than blow up
        // the whole submit path.
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
        if (id.endsWith("--form")) return; // skip top-level form controller itself
        const ctrl = this.application.getControllerForElementAndIdentifier(el, id);
        if (ctrl && typeof ctrl.validate === "function") out.push(ctrl);
      });
    });
    return out;
  }
}
