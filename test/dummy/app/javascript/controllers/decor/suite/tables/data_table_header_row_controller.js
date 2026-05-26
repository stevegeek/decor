// Minimal DataTableHeaderRow Stimulus controller for the dummy app harness.
//
// The decor.js bundle registers the DataTable controller which expects a
// `decor--suite--tables--data-table-header-row` outlet controller. This
// controller is not in decor.js, so we register a compatible shim here
// to prevent the outlet error that otherwise crashes the DataTable setup.
//
// DataTable controller expectations for the header row outlet:
//   - onCheckboxChange(callback) — registers a "select all" handler
//   - checked : Boolean  getter/setter
//   - indeterminate : Boolean getter/setter

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this._onCheckboxChange = null
    // Find the "select all" checkbox in this header row.
    this._checkbox = this.element.querySelector(
      '[data-decor--suite--forms--checkbox-target="input"][type="checkbox"]'
    )
    if (this._checkbox) {
      this._changeHandler = this._onChange.bind(this)
      this._checkbox.addEventListener("change", this._changeHandler)
    }
  }

  disconnect() {
    if (this._checkbox && this._changeHandler) {
      this._checkbox.removeEventListener("change", this._changeHandler)
    }
  }

  // ── Public API expected by DataTableController ───────────────────────────

  /** Register a callback invoked when the header "select all" checkbox changes. */
  onCheckboxChange(callback) {
    this._onCheckboxChange = callback
  }

  get checked() {
    return this._checkbox ? this._checkbox.checked : false
  }

  set checked(state) {
    if (this._checkbox) {
      this._checkbox.checked = Boolean(state)
      this._checkbox.indeterminate = false
    }
  }

  get indeterminate() {
    return this._checkbox ? this._checkbox.indeterminate : false
  }

  set indeterminate(state) {
    if (this._checkbox) {
      this._checkbox.indeterminate = Boolean(state)
    }
  }

  // ── Private ──────────────────────────────────────────────────────────────

  _onChange() {
    if (typeof this._onCheckboxChange === "function") {
      this._onCheckboxChange(this.checked)
    }
  }
}
