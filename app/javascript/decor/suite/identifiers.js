// Stimulus controller identifier constants for the Decor Suite skin.
//
// Single source of truth for `decor--suite--*` identifier strings used by
// consumers that need to dispatch/listen to controller events, build
// `data-<controller>-<value>-value` attributes, target outlets, or wire
// Stimulus actions across controllers.
//
// Auto-aligned with the controllers under
// `app/javascript/controllers/decor/suite/**/*.js`. Path → identifier:
// `decor/suite/forms/select_controller.js` → `decor--suite--forms--select`.
//
// Note: the ConfirmTemplate identifier is `decor--daisy--modals--confirm-template`
// because Suite re-exports the Daisy controller — see `decor/daisy/identifiers.js`.

// ── Top-level Suite controllers ───────────────────────────────────────────────
export const DecorSuiteAiChatWidgetIdentifier = "decor--suite--ai-chat--widget";
export const DecorSuiteButtonIdentifier = "decor--suite--button";
export const DecorSuiteCarouselIdentifier = "decor--suite--carousel";
export const DecorSuiteClickToCopyIdentifier = "decor--suite--click-to-copy";
export const DecorSuiteDropdownIdentifier = "decor--suite--dropdown";
export const DecorSuiteFlashIdentifier = "decor--suite--flash";
export const DecorSuiteMapIdentifier = "decor--suite--map";
export const DecorSuitePolygonEditorIdentifier = "decor--suite--polygon-editor";
export const DecorSuiteProgressIdentifier = "decor--suite--progress";
export const DecorSuiteSearchAndFilterIdentifier = "decor--suite--search-and-filter";
export const DecorSuiteTabsIdentifier = "decor--suite--tabs";
export const DecorSuiteTooltipIdentifier = "decor--suite--tooltip";

// ── Forms ─────────────────────────────────────────────────────────────────────
export const DecorSuiteFormsButtonRadioGroupIdentifier = "decor--suite--forms--button-radio-group";
export const DecorSuiteFormsCheckboxIdentifier = "decor--suite--forms--checkbox";
export const DecorSuiteFormsDateCalendarIdentifier = "decor--suite--forms--date-calendar";
export const DecorSuiteFormsExpandingCheckboxCollectionIdentifier = "decor--suite--forms--expanding-checkbox-collection";
export const DecorSuiteFormsFileUploadIdentifier = "decor--suite--forms--file-upload";
export const DecorSuiteFormsFormIdentifier = "decor--suite--forms--form";
export const DecorSuiteFormsMultiImageUploadIdentifier = "decor--suite--forms--multi-image-upload";
export const DecorSuiteFormsNumberFieldIdentifier = "decor--suite--forms--number-field";
export const DecorSuiteFormsRadioIdentifier = "decor--suite--forms--radio";
export const DecorSuiteFormsSearchableMultiSelectIdentifier = "decor--suite--forms--searchable-multi-select";
export const DecorSuiteFormsSearchableSelectIdentifier = "decor--suite--forms--searchable-select";
export const DecorSuiteFormsSelectIdentifier = "decor--suite--forms--select";
export const DecorSuiteFormsSwitchIdentifier = "decor--suite--forms--switch";
export const DecorSuiteFormsTextAreaIdentifier = "decor--suite--forms--text-area";
export const DecorSuiteFormsTextFieldIdentifier = "decor--suite--forms--text-field";

// ── Modals ────────────────────────────────────────────────────────────────────
export const DecorSuiteModalsConfirmIdentifier = "decor--suite--modals--confirm";
export const DecorSuiteModalsConfirmTemplateIdentifier = "decor--suite--modals--confirm-template";
export const DecorSuiteModalsModalCloseButtonIdentifier = "decor--suite--modals--modal-close-button";
export const DecorSuiteModalsModalIdentifier = "decor--suite--modals--modal";
export const DecorSuiteModalsModalOpenButtonIdentifier = "decor--suite--modals--modal-open-button";
export const DecorSuiteModalsModalTriggerIdentifier = "decor--suite--modals--modal-trigger";

// ── Settings list ─────────────────────────────────────────────────────────────
export const DecorSuiteSettingsListRowIdentifier = "decor--suite--settings-list--row";

// ── Tables ────────────────────────────────────────────────────────────────────
export const DecorSuiteTablesBulkActionsBarIdentifier = "decor--suite--tables--bulk-actions-bar";
export const DecorSuiteTablesDataTableCellIdentifier = "decor--suite--tables--data-table-cell";
export const DecorSuiteTablesDataTableIdentifier = "decor--suite--tables--data-table";
// DataTableRow has no Stimulus controller class but the Ruby
// ::Decor::Suite::Tables::DataTableRow component renders elements with this
// identifier in their `data-controller` attribute (via Vident's class-name
// derivation), so outlet selectors targeting rows need the string.
export const DecorSuiteTablesDataTableRowIdentifier = "decor--suite--tables--data-table-row";
export const DecorSuiteTablesTagFilterBarIdentifier = "decor--suite--tables--tag-filter-bar";
