import DaisyController from "../../daisy/forms/searchable_select_controller";

// Suite SearchableSelect controller — inherits all behaviour from the Daisy
// controller and overrides only the row-render template + highlight chrome
// so the dropdown rows use Suite tokens (suite-body, suite-primary-50 hover).
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
}
