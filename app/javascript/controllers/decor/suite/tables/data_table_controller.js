import { Controller } from "@hotwired/stimulus";
import SelectionPersistenceService from "../../../../services/selection_persistence_service";

/**
 * Suite DataTable Stimulus controller.
 *
 * Coordinates header-row, body-row, and bulk-actions outlets:
 *   - propagates header-checkbox "select all" → individual row controllers
 *   - listens for individual row selection-change events → updates the header
 *     tri-state checkbox + the bulk-actions bar
 *   - optionally persists selections to localStorage keyed by `tableIdValue`,
 *     restoring them on reconnect and synchronising across browser tabs
 *   - paints inset-scroll-shadow fades on the horizontal scroll wrapper
 */
export default class extends Controller {
  static outlets = [
    "decor--suite--tables--data-table-header-row",
    "decor--suite--tables--data-table-row",
    "decor--suite--tables--bulk-actions-bar",
  ];

  static targets = ["tableContentContainer", "tableBody"];

  static values = {
    tableId: { type: String, default: "" },
    persistSelections: { type: Boolean, default: false },
  };

  static SELECTION_CHANGE_DEBOUNCE_MS = 150;
  static MAX_APPLY_SELECTIONS_RETRIES = 3;

  get headerRowController() {
    return this.decorSuiteTablesDataTableHeaderRowOutlet;
  }

  get hasHeaderRowController() {
    return this.hasDecorSuiteTablesDataTableHeaderRowOutlet;
  }

  get rowControllers() {
    return this.decorSuiteTablesDataTableRowOutlets;
  }

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
    this.rowSelectionChangeHandler = null;
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

    if (this.hasHeaderRowController && typeof this.headerRowController.onCheckboxChange === "function") {
      this.headerRowController.onCheckboxChange(this.toggleRows.bind(this));
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

    this.rowSelectionChangeHandler = this.handleRowSelectionChange.bind(this);
    this.element.addEventListener(
      "data-table-row-selection-changed",
      this.rowSelectionChangeHandler,
    );

    if (this.hasTableContentContainerTarget) {
      this.resizeObserver = new ResizeObserver(() => this.contentScrolled());
      this.resizeObserver.observe(this.tableContentContainerTarget);
    }
  }

  disconnect() {
    this.selectionChangeListeners.clear();
    if (this.rowSelectionChangeHandler) {
      this.element.removeEventListener(
        "data-table-row-selection-changed",
        this.rowSelectionChangeHandler,
      );
      this.rowSelectionChangeHandler = null;
    }
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
        if (this.rowControllers.length === 0) {
          this.applySelectionsRetryCount++;
          if (
            this.applySelectionsRetryCount <
            this.constructor.MAX_APPLY_SELECTIONS_RETRIES
          ) {
            requestAnimationFrame(() => this.applyPersistedSelections());
          } else {
            console.warn(
              `Failed to apply persisted selections after ${this.constructor.MAX_APPLY_SELECTIONS_RETRIES} retries. Row controllers may not be initialized.`,
            );
          }
          return;
        }

        this.applySelectionsRetryCount = 0;

        this.rowControllers.forEach((controller) => {
          const rowId = controller.checkboxValue;
          if (rowId && this.persistedSelections.has(rowId)) {
            controller.checked = true;
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
    this.rowControllers.forEach((controller) => {
      const rowId = controller.checkboxValue;
      if (rowId) {
        const shouldBeChecked = this.persistedSelections.has(rowId);
        if (controller.checked !== shouldBeChecked) {
          controller.checked = shouldBeChecked;
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

  handleRowSelectionChange(event) {
    const detail = event.detail;
    if (this.persistSelectionsValue && this.tableIdValue) {
      if (detail && detail.checkboxValue) {
        if (detail.checked) {
          this.persistedSelections.add(detail.checkboxValue);
        } else {
          this.persistedSelections.delete(detail.checkboxValue);
        }
      }
    }
    this.updateHeaderCheckboxState();
    this.notifySelectionChange();
  }

  updateHeaderCheckboxState() {
    if (!this.hasHeaderRowController) return;
    const allVisibleChecked = this.rowControllers.every((c) => c.checked);
    const someChecked = this.rowControllers.some((c) => c.checked);
    const hasPersistedSelections = this.persistedSelections.size > 0;

    if (allVisibleChecked && this.rowControllers.length > 0) {
      this.headerRowController.checked = true;
      this.headerRowController.indeterminate = false;
    } else if (someChecked || hasPersistedSelections) {
      this.headerRowController.checked = false;
      this.headerRowController.indeterminate = true;
    } else {
      this.headerRowController.checked = false;
      this.headerRowController.indeterminate = false;
    }
  }

  toggleRows(checked) {
    this.rowControllers.forEach((controller) => {
      controller.checked = checked;
    });
    if (this.persistSelectionsValue && this.tableIdValue) {
      if (checked) {
        this.rowControllers.forEach((controller) => {
          const rowId = controller.checkboxValue;
          if (rowId) this.persistedSelections.add(rowId);
        });
      } else {
        this.rowControllers.forEach((controller) => {
          const rowId = controller.checkboxValue;
          if (rowId) this.persistedSelections.delete(rowId);
        });
      }
    }
    this.notifySelectionChange();
  }

  getSelectedRowIds() {
    if (this.persistSelectionsValue && this.tableIdValue) {
      return Array.from(this.persistedSelections);
    }
    return this.rowControllers
      .filter((controller) => controller.checked)
      .map((controller) => controller.checkboxValue);
  }

  getVisibleSelectedRowIds() {
    return this.rowControllers
      .filter((controller) => controller.checked)
      .map((controller) => controller.checkboxValue);
  }

  getSelectedRows() {
    return this.rowControllers.filter((controller) => controller.checked);
  }

  getSelectionCount() {
    if (this.persistSelectionsValue && this.tableIdValue) {
      return this.persistedSelections.size;
    }
    return this.rowControllers.filter((controller) => controller.checked).length;
  }

  hasSelection() {
    return this.getSelectionCount() > 0;
  }

  clearSelection() {
    this.rowControllers.forEach((controller) => {
      controller.checked = false;
    });
    if (this.hasHeaderRowController) {
      this.headerRowController.checked = false;
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
