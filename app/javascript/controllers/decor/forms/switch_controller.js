import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="decor--switch"
export default class extends Controller {
  static targets = ["checkbox"];
  static values = {
    label: { type: String, default: null },
    confirmOnSubmit: { type: String, default: null },
    confirmOnSubmitYes: { type: String, default: null },
    confirmOnSubmitNo: { type: String, default: null },
    submitOnChange: Boolean
  };

  connect() {
    // Set up the checkbox change listener
    if (this.hasCheckboxTarget) {
      this.checkboxTarget.addEventListener('change', this.handleChange.bind(this));
    }
  }

  disconnect() {
    // Clean up event listeners
    if (this.hasCheckboxTarget) {
      this.checkboxTarget.removeEventListener('change', this.handleChange.bind(this));
    }
  }

  handleChange(event) {
    if (this.submitOnChangeValue) {
      if (!this.confirmOnSubmitValue) {
        // Submit the form right away
        this.submitForm();
        return;
      }

      // Show confirmation dialog before submitting
      this.showConfirmationDialog();
    }
  }

  showConfirmationDialog() {
    const confirmMessage = this.confirmOnSubmitValue;
    const confirmLabel = this.confirmOnSubmitYesValue || "Confirm";
    const cancelLabel = this.confirmOnSubmitNoValue || "Cancel";

    if (window.confirm(`${confirmMessage}\n\nClick OK to ${confirmLabel} or Cancel to ${cancelLabel}.`)) {
      this.submitForm();
    } else {
      this.revertSwitchState();
    }
  }

  submitForm() {
    // Find the closest form and submit it
    const form = this.element.closest('form');
    if (form) {
      // Dispatch a custom event before submitting
      const submitEvent = new CustomEvent('decor:switch:beforesubmit', {
        bubbles: true,
        cancelable: true,
        detail: { 
          switchElement: this.element,
          checked: this.hasCheckboxTarget ? this.checkboxTarget.checked : false
        }
      });

      if (this.element.dispatchEvent(submitEvent)) {
        // If event wasn't cancelled, submit the form
        form.submit();
      } else {
        // Event was cancelled, revert the switch state
        this.revertSwitchState();
      }
    }
  }

  revertSwitchState() {
    if (this.hasCheckboxTarget) {
      // Temporarily remove the change listener to avoid infinite loop
      this.checkboxTarget.removeEventListener('change', this.handleChange.bind(this));
      
      // Toggle the checkbox back
      this.checkboxTarget.checked = !this.checkboxTarget.checked;
      
      // Re-add the change listener
      this.checkboxTarget.addEventListener('change', this.handleChange.bind(this));
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
}