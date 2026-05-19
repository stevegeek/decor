import BaseController from "../../base";
import { generateFormValidationMessage, localeMessage } from "../../../../lib/util/form_validation_messages";
import {
  equalTo,
  missingCheckboxValue,
  missingRadioValue,
  missingValue,
  outOfRange,
  patternMismatch,
  typeMismatch,
  wrongLength,
} from "../../../../lib/util/form_validators";

// Abstract base for every Decor form-field Stimulus controller.
//
// Owns the per-field validation pipeline (`validate()`), the touched/listening
// state machine that gates auto-validate on input/blur, and the DOM mutations
// that show/hide the helper text, error text and error icon. The Suite Form
// controller calls `validate()` on every descendant field controller during
// submit; this base is what makes that call meaningful.
//
// Subclasses are typically tiny — they re-declare `static targets` /
// `static values` to add field-specific bits and override DOM lifecycle if
// they need to wire extra listeners. They MUST keep the parent's targets in
// scope (Stimulus does not merge across the prototype chain).
//
// Auto-validation is opt-in. The controller enables it when it detects a
// Decor::Suite::Forms::Form ancestor (the only orchestrator that runs JS-side
// validation). Standalone fields validate only when `validate()` is invoked
// explicitly.

const NO_ERRORS = {
  missingValue: false,
  equalTo: false,
  outOfRange: false,
  patternMismatch: false,
  typeMismatch: false,
  wrongLength: false,
};

export default class FormFieldController extends BaseController {
  static targets = [
    "input",
    "container",
    "label",
    "helperText",
    "errorText",
    "errorIcon",
    "errorIconText",
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
    validateEqualTo: { type: String, default: "" },
  };

  static classes = [
    "valid",
    "invalid",
    "validInput",
    "invalidInput",
    "validContainer",
    "invalidContainer",
    "validLabel",
    "invalidLabel",
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
      errors,
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
      this.validClasses,
    );
    if (this.hasContainerTarget) {
      this.toggleTargetElementClasses(
        this.containerTarget,
        isValid,
        this.invalidContainerClasses,
        this.validContainerClasses,
      );
    }
    if (this.hasInputTarget) {
      this.toggleTargetElementClasses(
        this.inputTarget,
        isValid,
        this.invalidInputClasses,
        this.validInputClasses,
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
      values,
    );
  }

  get validationErrors() {
    if (this.disabled) {
      // Disabled fields are not submitted, so we don't validate them.
      return { ...NO_ERRORS };
    }

    return {
      missingValue: this.missingValueError,
      equalTo: this.equalToError,
      outOfRange: this.outOfRangeError,
      patternMismatch: this.patternMismatchError,
      typeMismatch: this.typeMismatchError,
      wrongLength: this.wrongLengthError,
    };
  }

  emitValidationEvent({ errors, valid }) {
    this.dispatch("validated", {
      bubbles: true,
      cancelable: false,
      detail: { errors, valid },
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
    const id =
      this.validateEqualToValue ||
      this.inputTarget.getAttribute("data-form-control-validate-equal-to-value");
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
          (input) => input.getAttribute("name") === el.getAttribute("name"),
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
          value: el.value,
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
      value: el.value,
    });
  }

  get patternMismatchError() {
    const el = this.inputTarget;
    return patternMismatch({
      pattern: el.getAttribute("pattern"),
      type: el.type,
      value: el.value,
    });
  }

  get wrongLengthError() {
    const el = this.inputTarget;
    return wrongLength({
      max: el.getAttribute("maxlength"),
      min: el.getAttribute("minlength"),
      value: el.value,
    });
  }

  get equalToError() {
    const el = this.inputTarget;
    return equalTo({
      value: el.value,
      equalToId:
        this.validateEqualToValue ||
        el.getAttribute("data-form-control-validate-equal-to-value"),
    });
  }

  get typeMismatchError() {
    const el = this.inputTarget;
    return typeMismatch({
      type: this.validateTypeValue || null,
      value: el.value,
    });
  }

  mapCheckableAttributes(field) {
    return {
      checked: field.checked,
      required: field.hasAttribute("required"),
    };
  }

  // Match against the Suite Form orchestrator's controller id. Daisy doesn't
  // ship its own Form controller — Suite is the only one with the validate
  // wiring, and field controllers under either skin route through it.
  isInsideForm() {
    return (
      this.element.closest(
        'form[data-controller*="decor--suite--forms--form"]',
      ) !== null
    );
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
        message: this.generateErrorMessage("validationMessageRequired", "blank"),
      });
    }
    if (errors.wrongLength === "over") {
      out.push({
        code: "lengthOver",
        message: this.generateErrorMessage("validationMessageLengthOver", "invalid"),
      });
    }
    if (errors.wrongLength === "under") {
      out.push({
        code: "lengthUnder",
        message: this.generateErrorMessage("validationMessageLengthUnder", "invalid"),
      });
    }
    if (errors.outOfRange === "over") {
      out.push({
        code: "rangeOver",
        message: this.generateErrorMessage("validationMessageRangeOver", "invalid"),
      });
    }
    if (errors.outOfRange === "under") {
      out.push({
        code: "rangeUnder",
        message: this.generateErrorMessage("validationMessageRangeUnder", "invalid"),
      });
    }
    // Pattern matching comes last. Numerical values often have a `pattern`
    // for the on-screen keyboard, but the more-specific range message should
    // win when both fire.
    if (errors.patternMismatch) {
      out.push({
        code: "patternMismatch",
        message: this.generateErrorMessage("validationMessagePatternMismatch", "invalid"),
      });
    }
    if (errors.typeMismatch) {
      out.push({
        code: "typeMismatch",
        message: this.generateErrorMessage("validationMessageTypeMismatch", "invalid"),
      });
    }
    if (errors.equalTo) {
      out.push({
        code: "equalTo",
        message: this.generateErrorMessage("validationMessageEqualto", "does_not_match"),
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
      detail: { errors, valid },
    });
  }

  updateLabelClasses(isValid) {
    if (this.hasLabelTarget) {
      this.toggleTargetElementClasses(
        this.labelTarget,
        isValid,
        this.invalidLabelClasses,
        this.validLabelClasses,
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
      const hasContent =
        this.helperTextTarget.textContent &&
        this.helperTextTarget.textContent.trim() !== "";
      this.toggleTargetElementClasses(
        this.helperTextTarget,
        showHelper && !!hasContent,
        ["decor:hidden", "hidden"],
        [],
      );
    }

    if (this.hasErrorTextTarget) {
      this.toggleTargetElementClasses(
        this.errorTextTarget,
        showHelper,
        [],
        ["decor:hidden", "hidden"],
      );
    }
  }

  toggleErrorIcon(show) {
    if (this.hasErrorIconTarget) {
      this.toggleTargetElementClasses(
        this.errorIconTarget,
        show,
        ["decor:hidden", "hidden"],
        [],
      );
    }
  }
}
