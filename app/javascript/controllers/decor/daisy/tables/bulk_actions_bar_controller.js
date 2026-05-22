import { Controller } from "@hotwired/stimulus";

/**
 * Decor BulkActionsBar Stimulus controller.
 *
 * Wired by the parent DataTable controller (which calls
 * `setDataTableController(this)` on connect). The bar:
 *   - tracks selection counts (including off-page when persistence is on)
 *   - toggles its own visibility based on selection count
 *   - mirrors all selected IDs into hidden `selected_ids[]` inputs in every
 *     action form (one per inline action + one per dropdown action)
 *   - intercepts inline-button + dropdown-item clicks to drive confirm/modal
 *     flows before calling `form.requestSubmit()`
 *
 * Selection-count display + visibility are owned here (not by the table) so
 * the bar can react to async selection events emitted by the parent.
 */
export default class extends Controller {
  static targets = [
    "selectionCount",
    "selectedIdsContainer",
    "dropdownForm",
  ];

  static values = {
    selectedIdsFieldName: { type: String, default: "selected_ids" },
  };

  initialize() {
    this.dataTableController = null;
    this.tableId = null;
    this.offPageSelectionCount = 0;
  }

  setDataTableController(controller) {
    this.dataTableController = controller;
    this.checkForExistingSelections();
  }

  setTableId(id) {
    this.tableId = id;
    this.checkForExistingSelections();
  }

  checkForExistingSelections() {
    if (this.tableId && this.dataTableController) {
      const selectedIds = this.dataTableController.getSelectedRowIds();
      if (selectedIds.length > 0) {
        this.handleSelectionChange(selectedIds);
      }
    }
  }

  handleSelectionChange(selectedIds) {
    const count = selectedIds.length;

    if (this.tableId && this.dataTableController) {
      const visibleCount =
        this.dataTableController.getVisibleSelectedRowIds().length;
      this.offPageSelectionCount = count - visibleCount;
    }

    let countText = `${count} ${count === 1 ? "item" : "items"} selected`;
    if (this.offPageSelectionCount > 0) {
      countText += ` (${this.offPageSelectionCount} from other pages)`;
    }
    this.selectionCountTarget.textContent = countText;

    // Inline `display: none` is the initial state so TailwindMerge can't
    // strip the `decor:flex` utility off the root; toggle the style here
    // rather than juggling a `hidden` class.
    this.element.style.display = count > 0 ? "" : "none";

    this.updateSelectedIdsInputs(selectedIds);
  }

  updateSelectedIdsInputs(selectedIds) {
    this.selectedIdsContainerTargets.forEach((container) => {
      const fieldName =
        container.dataset.fieldName || this.selectedIdsFieldNameValue;
      container.innerHTML = "";
      selectedIds.forEach((id) => {
        const input = document.createElement("input");
        input.type = "hidden";
        input.name = `${fieldName}[]`;
        input.value = id;
        container.appendChild(input);
      });
    });
  }

  clearSelection() {
    if (this.dataTableController) {
      this.dataTableController.clearSelection();
    }
  }

  async handleBulkAction(event) {
    event.preventDefault();

    const button = event.currentTarget;
    const form = button.closest("form");

    if (!form || !this.dataTableController) {
      return;
    }

    if (button.dataset.modal === "true") {
      this.openBulkActionModal(form);
      return;
    }

    await this.confirmAndSubmitForm(form, button.dataset.bulkConfirm);
  }

  async handleDropdownAction(event) {
    event.preventDefault();

    const menuItem = event.currentTarget;
    const actionName = menuItem.dataset.actionName;

    if (!this.dataTableController || !actionName) {
      return;
    }

    const form = this.findFormByActionName(actionName);
    if (!form) {
      return;
    }

    if (menuItem.dataset.modal === "true") {
      this.openBulkActionModal(form);
      return;
    }

    await this.confirmAndSubmitForm(form, menuItem.dataset.bulkConfirm);
  }

  findFormByActionName(actionName) {
    return this.dropdownFormTargets.find((f) => {
      const field = f.querySelector('input[name="action_name"]');
      return field && field.value === actionName;
    });
  }

  openBulkActionModal(form) {
    const selectedIds = this.dataTableController.getSelectedRowIds();
    const url = new URL(form.action, window.location.origin);
    selectedIds.forEach((id) => url.searchParams.append("selected_ids[]", id));

    // showModal is intentionally not imported here — the modal helper lives
    // in the consuming app's overlay module. Dispatch a window CustomEvent
    // that the app can listen for, falling back to a direct `<dialog>.showModal()`
    // on the placeholder modal when no helper is wired.
    const modalId = `${this.element.id}-bulk-modal`;
    const detail = { id: modalId, contentHref: url.toString() };
    const handled = window.dispatchEvent(
      new CustomEvent("decor:bulk-actions:show-modal", {
        detail,
        cancelable: true,
      }),
    );

    if (handled) {
      const dialog = document.getElementById(modalId);
      if (dialog && typeof dialog.showModal === "function") {
        dialog.showModal();
      }
    }
  }

  async confirmAndSubmitForm(form, confirmMessage) {
    if (confirmMessage && this.dataTableController) {
      const count = this.dataTableController.getSelectionCount();
      const message = this.interpolateCount(confirmMessage, count);

      const confirmed = await this.showConfirmModal(message);
      if (!confirmed) {
        return;
      }
    }

    // requestSubmit() (vs submit()) fires a `submit` event so Turbo's
    // formSubmitObserver can intercept when the form is inside a
    // data-turbo="true" region.
    form.requestSubmit();
  }

  interpolateCount(message, count) {
    return message
      .replace(/\{count\}/g, count.toString())
      .replace(/\{\{count\}\}/g, count.toString());
  }

  // Confirm dialog hook — apps wire a real modal helper by listening for
  // the dispatched event and calling `event.detail.resolve(true|false)`.
  // The default falls back to `window.confirm()`.
  showConfirmModal(message) {
    return new Promise((resolve) => {
      const event = new CustomEvent("decor:bulk-actions:show-confirm", {
        detail: {
          message,
          title: "Are you sure?",
          resolve,
        },
        cancelable: true,
      });

      const notCancelled = window.dispatchEvent(event);
      if (notCancelled) {
        resolve(window.confirm(message));
      }
    });
  }
}
