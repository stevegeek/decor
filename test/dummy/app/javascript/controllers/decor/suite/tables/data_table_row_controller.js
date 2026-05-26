// Minimal DataTableRow Stimulus controller for the dummy app harness.
//
// The decor.js bundle registers the DataTable controller which expects
// `decor--suite--tables--data-table-row` outlet controllers. Those controllers
// are not yet part of the decor.js bundle, so we register a compatible shim
// here so row-selection → BulkActionsBar wiring works in the test harness.
//
// DataTable controller expectations for each row outlet:
//   - checkboxValue  : String  — the selectable value (checkbox value attr)
//   - checked        : Boolean getter/setter — selection state
//
// Rows must also dispatch `data-table-row-selection-changed` (bubbles: true)
// on the row element when selection changes, with detail:
//   { checkboxValue: <String>, checked: <Boolean> }

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Find the selection checkbox inside this row.  The Suite Checkbox
    // component renders the native <input type="checkbox"> with a
    // `data-decor--suite--forms--checkbox-target="input"` attribute.
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

  /** The selectable value encoded in the row's checkbox. */
  get checkboxValue() {
    return this._checkbox ? this._checkbox.value : ""
  }

  /** Whether this row's checkbox is currently checked. */
  get checked() {
    return this._checkbox ? this._checkbox.checked : false
  }

  set checked(state) {
    if (this._checkbox) {
      const was = this._checkbox.checked
      this._checkbox.checked = Boolean(state)
      if (was !== this._checkbox.checked) {
        this._dispatchSelectionChanged()
      }
    }
  }

  // ── Private ──────────────────────────────────────────────────────────────

  _onChange() {
    this._dispatchSelectionChanged()
  }

  _dispatchSelectionChanged() {
    this.element.dispatchEvent(
      new CustomEvent("data-table-row-selection-changed", {
        bubbles: true,
        detail: {
          checkboxValue: this.checkboxValue,
          checked: this.checked
        }
      })
    )
  }
}
