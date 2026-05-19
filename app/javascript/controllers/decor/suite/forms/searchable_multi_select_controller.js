import DaisyController from "../../daisy/forms/searchable_multi_select_controller";

// Suite SearchableMultiSelect controller — inherits the chip/backspace/
// free-text behaviour from the Daisy controller and overrides only the row-
// render template, the highlight chrome, the loading indicator, and the
// chip template so each renders with Suite tokens.
export default class extends DaisyController {
  _resultRowHtml(result) {
    const metadataAttr = result.metadata
      ? ` data-result-metadata="${this._escapeAttr(JSON.stringify(result.metadata))}"`
      : "";
    const sublabel = result.sublabel
      ? `<span class="decor:suite-description decor:text-gray-500 decor:ml-2">${this._escapeHtml(result.sublabel)}</span>`
      : "";
    const rightLabel = result.right_label
      ? `<span class="decor:suite-description decor:text-gray-400 decor:ml-3 decor:shrink-0">${this._escapeHtml(result.right_label)}</span>`
      : "";
    return (
      `<button type="button" ` +
      `class="decor:w-full decor:text-left decor:px-3 decor:py-2 decor:hover:bg-suite-gray-25 decor:border-b decor:border-suite-hairline decor:last:border-b-0 decor:flex decor:justify-between decor:items-center decor:cursor-pointer" ` +
      `data-result-id="${this._escapeAttr(String(result.id))}" ` +
      `data-result-label="${this._escapeAttr(result.label)}"${metadataAttr} ` +
      `data-action="click->${this.identifier}#selectResult" ` +
      `role="option">` +
      `<div class="decor:min-w-0"><span class="decor:suite-body decor:text-gray-900">${this._escapeHtml(result.label)}</span>${sublabel}</div>` +
      rightLabel +
      `</button>`
    );
  }

  _updateHighlight(items) {
    items.forEach((item, index) => {
      if (index === this.highlightedIndex) {
        item.classList.add("decor:bg-suite-primary-50");
        item.scrollIntoView({ block: "nearest" });
      } else {
        item.classList.remove("decor:bg-suite-primary-50");
      }
    });
  }

  _renderLoadingIndicator() {
    this._removeLoadingIndicator();
    const indicator = document.createElement("div");
    indicator.dataset.loadingIndicator = "true";
    indicator.className =
      "decor:p-3 decor:flex decor:items-center decor:justify-center decor:gap-2 decor:suite-description decor:text-gray-400";
    indicator.textContent = "Loading…";
    this.dropdownTarget.appendChild(indicator);
  }

  _addPill(id, label) {
    const pill = document.createElement("span");
    pill.className =
      "decor:inline-flex decor:items-center decor:gap-1 decor:rounded-full " +
      "decor:bg-suite-primary-50 decor:px-2 decor:py-px " +
      "decor:suite-description decor:font-medium";
    pill.dataset.itemId = String(id);
    pill.innerHTML =
      `<span class="decor:suite-body decor:text-suite-primary-700">${this._escapeHtml(label)}</span>` +
      `<button type="button" ` +
      `class="decor:text-suite-primary-600 decor:hover:text-suite-primary-700 decor:leading-none decor:transition-colors decor:duration-suite-fast" ` +
      `data-action="click->${this.identifier}#removeItem" ` +
      `data-item-id="${this._escapeAttr(String(id))}">` +
      `<svg xmlns="http://www.w3.org/2000/svg" class="decor:h-3 decor:w-3" viewBox="0 0 24 24" fill="none" ` +
      `stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">` +
      `<path d="M18 6L6 18M6 6l12 12"/></svg></button>`;
    this.selectedContainerTarget.appendChild(pill);
  }
}
