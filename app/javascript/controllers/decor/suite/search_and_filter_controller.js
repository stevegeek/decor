import { Controller } from "@hotwired/stimulus";

// Suite SearchAndFilter controller.
//
// Drives the search-input + filter pill UI:
//   - toggle:                    opens/closes the popover dropdown panel
//   - handleApply:               collects filter values from inputs in the
//                                panel + the search input, rewrites the URL
//                                query-string and reloads the page
//   - handleClearFilters:        clears all collected values and reloads
//   - handleSearchInputKeydown:  on Enter, prevents form submission and
//                                triggers handleApply
//   - handleRangePicker:         best-effort flatpickr integration when the
//                                consumer has it on window; otherwise no-op
//
// The dropdown panel is rendered as a sibling element (the Suite::Dropdown
// inside this component's root). We locate it via querySelector against
// this.element rather than via an outlet to keep the controller self-
// contained on the gem side.
export default class extends Controller {
  static targets = [
    "searchInput",
    "applyButton",
    "clearFiltersButton",
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
    // Set all collected keys to undefined → removed from query string
    const cleared = Object.keys(filters).reduce((acc, key) => {
      acc[key] = undefined;
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
    // Best-effort flatpickr integration: if a global flatpickr is present
    // the consumer can wire range selection. Without it we no-op gracefully
    // — the native input still functions as a plain text field.
    const fp = typeof window !== "undefined" ? window.flatpickr : undefined;
    if (typeof fp !== "function") return;

    const picker = fp(input, {
      mode: "range",
      onClose: (selectedDates, _dateStr, instance) => {
        if (selectedDates.length !== 2) return;
        const value = selectedDates
          .map((d) => instance.formatDate(new Date(d), "Y-m-d"))
          .join("_");
        const name = input.name || "custom_range";
        // Stash on input so handleApply will pick it up
        input.value = value;
        input.dataset.customRangeName = name;
      },
    });
    picker.open();
  }

  // ── private ─────────────────────────────────────────────────────────────

  dropdownMenu() {
    // The Suite::Dropdown inside this component renders a popover-API div
    // with the `decor--suite--dropdown-menu` class hook.
    return this.element.querySelector(".decor--suite--dropdown-menu");
  }

  collectFilterValues() {
    const out = {};
    if (this.hasSearchInputTarget && this.searchInputTarget.value) {
      out[this.searchInputTarget.name] = this.searchInputTarget.value;
    }

    const menu = this.dropdownMenu();
    if (!menu) return out;

    // Inputs (text + date + range)
    menu.querySelectorAll('input[type="text"], input[type="search"], input[type="date"], input[type="number"], input:not([type])').forEach((el) => {
      if (!el.name) return;
      // Avoid double-counting the search input which lives outside the menu
      if (el === this.searchInputTarget) return;
      out[el.name] = el.value || undefined;
    });

    // Checkboxes (true / undefined)
    menu.querySelectorAll('input[type="checkbox"]').forEach((el) => {
      if (!el.name) return;
      out[el.name] = el.checked ? "true" : undefined;
    });

    // Selects
    menu.querySelectorAll("select").forEach((el) => {
      if (!el.name) return;
      out[el.name] = el.value || undefined;
    });

    return out;
  }

  reloadWith(filters) {
    // Reset to page 1 whenever filters change
    const merged = Object.assign({}, filters, { page: undefined });
    const params = new URLSearchParams(window.location.search);
    Object.entries(merged).forEach(([name, value]) => {
      if (value === undefined || value === null || value === "") {
        params.delete(name);
      } else {
        params.set(name, value);
      }
    });
    const qs = params.toString();
    window.location.search = qs ? `?${qs}` : "";
  }
}
