import { Controller } from "@hotwired/stimulus";
import SelectionPersistenceService from "../../../../services/selection_persistence_service";

/**
 * Suite DataTable Stimulus controller.
 *
 * Owns row selection directly via checkbox targets — no per-row or header-row
 * outlet controllers required:
 *   - `rowCheckbox` targets  → the individual row <input type="checkbox"> elements
 *   - `selectAllCheckbox` target → the "select all" header <input type="checkbox">
 *   - `rowChanged(event)` action → fired by each row checkbox on change
 *   - `toggleAll(event)` action  → fired by the header checkbox on change
 *   - Keeps bulk-actions-bar outlet wiring unchanged
 *   - Optionally persists selections to localStorage keyed by `tableIdValue`,
 *     restoring them on reconnect and synchronising across browser tabs
 *   - Paints inset-scroll-shadow fades on the horizontal scroll wrapper
 */
export default class extends Controller {
  static outlets = [
    "decor--suite--tables--bulk-actions-bar",
  ];

  static targets = [
    "tableContentContainer",
    "tableBody",
    "rowCheckbox",
    "selectAllCheckbox",
  ];

  static values = {
    tableId: { type: String, default: "" },
    persistSelections: { type: Boolean, default: false },
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
    this.selectionChangeListeners = new Set();
    this.storageListenerCleanup = null;
    this.persistedSelections = new Set();
    this.applySelectionsRetryCount = 0;
    this.selectionChangeDebounceTimer = null;
    this.resizeObserver = null;
    this.contentScrolled();
  }

  connect() {
    if (this.persistSelectionsValue && this.tableIdValue) {
      SelectionPersistenceService.onQuotaExceeded(
        this.handleQuotaExceeded.bind(this),
      );
      this.loadPersistedSelections();
      this.storageListenerCleanup = SelectionPersistenceService.addStorageListener(
        this.tableIdValue,
        this.handleStorageChange.bind(this),
      );
    }

    if (this.hasBulkActionsBarController) {
      if (typeof this.bulkActionsBarController.setDataTableController === "function") {
        this.bulkActionsBarController.setDataTableController(this);
      }
      if (
        this.persistSelectionsValue &&
        this.tableIdValue &&
        typeof this.bulkActionsBarController.setTableId === "function"
      ) {
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
    return this.rowCheckboxTargets
      .filter((cb) => cb.checked)
      .map((cb) => cb.value);
  }

  getVisibleSelectedRowIds() {
    return this.rowCheckboxTargets
      .filter((cb) => cb.checked)
      .map((cb) => cb.value);
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
      SelectionPersistenceService.clearSelections(this.tableIdValue);
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

    const persistedIds = SelectionPersistenceService.loadSelections(
      this.tableIdValue,
    );
    this.persistedSelections = new Set(persistedIds);
    this.applyPersistedSelections();
  }

  applyPersistedSelections() {
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        if (this.rowCheckboxTargets.length === 0) {
          this.applySelectionsRetryCount++;
          if (
            this.applySelectionsRetryCount <
            this.constructor.MAX_APPLY_SELECTIONS_RETRIES
          ) {
            requestAnimationFrame(() => this.applyPersistedSelections());
          } else {
            console.warn(
              `Failed to apply persisted selections after ${this.constructor.MAX_APPLY_SELECTIONS_RETRIES} retries. Row checkboxes may not be initialized.`,
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
      error,
    );

    this.element.dispatchEvent(
      new CustomEvent("data-table-storage-quota-exceeded", {
        bubbles: true,
        detail: {
          tableId,
          message:
            "Selection storage limit reached. Some selections may not be saved.",
          error,
        },
      }),
    );

    const visibleSelections = this.getVisibleSelectedRowIds();
    this.persistedSelections = new Set(visibleSelections);
    SelectionPersistenceService.saveSelections(tableId, visibleSelections);
  }

  updateHeaderCheckboxState() {
    if (!this.hasSelectAllCheckboxTarget) return;

    const checkboxes = this.rowCheckboxTargets;
    const allChecked = checkboxes.length > 0 && checkboxes.every((cb) => cb.checked);
    const someChecked = checkboxes.some((cb) => cb.checked);
    const hasPersistedSelections =
      this.persistSelectionsValue && this.persistedSelections.size > 0;

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
        SelectionPersistenceService.saveSelections(
          this.tableIdValue,
          selectedIds,
        );
      }

      this.selectionChangeListeners.forEach((listener) => listener(selectedIds));

      if (
        this.hasBulkActionsBarController &&
        typeof this.bulkActionsBarController.handleSelectionChange === "function"
      ) {
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
}
