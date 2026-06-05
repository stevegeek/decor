// TypeScript declarations for the prebuilt `decor` bundle
// (app/assets/builds/decor.js), referenced from package.json `types`.
//
// The bundle is built from plain JavaScript, so this file is hand-maintained to
// mirror the public surface exported by the package entry
// (app/javascript/decor/index.js). Keep them in sync: any `export` added to the
// entry should gain a matching declaration here.

import type { Application } from "@hotwired/stimulus";
import { Controller } from "@hotwired/stimulus";

// ── Registration ────────────────────────────────────────────────────────────

/** Map of Stimulus identifier → controller class for every Decor controller. */
export const CONTROLLERS: Record<string, typeof Controller>;

/** Registers every Decor controller on the host's Stimulus `Application`. */
export function register(application: Application): void;

// ── Controller base ──────────────────────────────────────────────────────────

/**
 * Shared base for the Decor controller classes host apps reuse or subclass.
 * Adds `setIdentifier` (used to register a subclass under a host-chosen
 * identifier) on top of the Stimulus `Controller` surface.
 */
declare class DecorController extends Controller {
  static setIdentifier(identifier: string): void;
  // Guarded initialize hook. A subclass that overrides it MUST call and return
  // `super.onInitialize()`.
  onInitialize(): unknown;
}

// ── Form-field controllers ────────────────────────────────────────────────────

/**
 * Abstract base for every Decor form-field controller. Owns the per-field
 * validation pipeline; `valid` and `value` are the surface host apps read.
 */
export declare class FormFieldController extends DecorController {
  /** The wrapped input's `name` attribute. */
  readonly name: string;
  /** Whether the field currently passes its validators. */
  valid: boolean;
  /** The field's current string value (readable and writable). */
  value: string;
  /** Present on fields exposing a writable required setter (e.g. NumberField). */
  required?: boolean;
}

export declare class TextFieldController extends FormFieldController {}
export declare class NumberFieldController extends FormFieldController {}

// ── Confirm template ───────────────────────────────────────────────────────────

// Host-provided option bag for the confirm template. All fields optional and no
// index signature, so a host's own (more specific, non-indexed) options
// interface stays structurally assignable.
export interface ConfirmTemplateOptions {
  title?: string;
  message?: string;
  /** Pre-rendered safe HTML body; decor calls `.toString()` on it. */
  messageHTML?: unknown;
  type?: string;
  positiveButtonLabel?: string;
  positiveButtonReason?: string;
  negativeButtonLabel?: string;
  negativeButtonReason?: string;
  // `any[]` (not `unknown[]`) so a host's strictly-typed close callback —
  // e.g. `(event: SomeLifecycleEvent) => void` — stays assignable here.
  onClosing?: (...args: any[]) => void;
}

/** Controller backing the Decor confirm-modal template. */
export declare class ConfirmTemplateController extends DecorController {
  fillSlots(options: ConfirmTemplateOptions): void;
  applyVariant(variantKey: string): void;
  wireCloseHandlers(options: ConfirmTemplateOptions): void;
}

// ── Data table ─────────────────────────────────────────────────────────────────

/** Controller backing the Decor data-table; exposes the row-selection API. */
export declare class DataTableController extends DecorController {
  getSelectedRowIds(): string[];
  getVisibleSelectedRowIds(): string[];
  getSelectionCount(): number;
  hasSelection(): boolean;
  clearSelection(): void;
  onSelectionChange(callback: (selectedIds: string[]) => void): void;
  appendRow(row: HTMLElement): void;
}

// ── Suite identifier constants ─────────────────────────────────────────────
export const DecorSuiteAiChatWidgetIdentifier: "decor--suite--ai-chat--widget";
export const DecorSuiteButtonIdentifier: "decor--suite--button";
export const DecorSuiteCarouselIdentifier: "decor--suite--carousel";
export const DecorSuiteClickToCopyIdentifier: "decor--suite--click-to-copy";
export const DecorSuiteCodeBlockIdentifier: "decor--suite--code-block";
export const DecorSuiteDropdownIdentifier: "decor--suite--dropdown";
export const DecorSuiteFlashIdentifier: "decor--suite--flash";
export const DecorSuiteMapIdentifier: "decor--suite--map";
export const DecorSuiteNotificationManagerIdentifier: "decor--suite--notification-manager";
export const DecorSuitePolygonEditorIdentifier: "decor--suite--polygon-editor";
export const DecorSuiteProgressIdentifier: "decor--suite--progress";
export const DecorSuiteSearchAndFilterIdentifier: "decor--suite--search-and-filter";
export const DecorSuiteTabsIdentifier: "decor--suite--tabs";
export const DecorSuiteTooltipIdentifier: "decor--suite--tooltip";
export const DecorSuiteFormsButtonRadioGroupIdentifier: "decor--suite--forms--button-radio-group";
export const DecorSuiteFormsCheckboxIdentifier: "decor--suite--forms--checkbox";
export const DecorSuiteFormsDateCalendarIdentifier: "decor--suite--forms--date-calendar";
export const DecorSuiteFormsExpandingCheckboxCollectionIdentifier: "decor--suite--forms--expanding-checkbox-collection";
export const DecorSuiteFormsFileUploadIdentifier: "decor--suite--forms--file-upload";
export const DecorSuiteFormsFormIdentifier: "decor--suite--forms--form";
export const DecorSuiteFormsMultiImageUploadIdentifier: "decor--suite--forms--multi-image-upload";
export const DecorSuiteFormsNumberFieldIdentifier: "decor--suite--forms--number-field";
export const DecorSuiteFormsRadioIdentifier: "decor--suite--forms--radio";
export const DecorSuiteFormsSearchableMultiSelectIdentifier: "decor--suite--forms--searchable-multi-select";
export const DecorSuiteFormsSearchableSelectIdentifier: "decor--suite--forms--searchable-select";
export const DecorSuiteFormsSelectIdentifier: "decor--suite--forms--select";
export const DecorSuiteFormsSwitchIdentifier: "decor--suite--forms--switch";
export const DecorSuiteFormsTextAreaIdentifier: "decor--suite--forms--text-area";
export const DecorSuiteFormsTextFieldIdentifier: "decor--suite--forms--text-field";
export const DecorSuiteModalsConfirmIdentifier: "decor--suite--modals--confirm";
export const DecorSuiteModalsConfirmTemplateIdentifier: "decor--suite--modals--confirm-template";
export const DecorSuiteModalsModalCloseButtonIdentifier: "decor--suite--modals--modal-close-button";
export const DecorSuiteModalsModalIdentifier: "decor--suite--modals--modal";
export const DecorSuiteModalsModalOpenButtonIdentifier: "decor--suite--modals--modal-open-button";
export const DecorSuiteModalsModalTriggerIdentifier: "decor--suite--modals--modal-trigger";
export const DecorSuiteSettingsListRowIdentifier: "decor--suite--settings-list--row";
export const DecorSuiteTablesBulkActionsBarIdentifier: "decor--suite--tables--bulk-actions-bar";
export const DecorSuiteTablesDataTableCellIdentifier: "decor--suite--tables--data-table-cell";
export const DecorSuiteTablesDataTableIdentifier: "decor--suite--tables--data-table";
export const DecorSuiteTablesDataTableRowIdentifier: "decor--suite--tables--data-table-row";
export const DecorSuiteTablesTagFilterBarIdentifier: "decor--suite--tables--tag-filter-bar";

// ── Daisy identifier constants ─────────────────────────────────────────────
export const DecorDaisyAiChatWidgetIdentifier: "decor--daisy--ai-chat--widget";
export const DecorDaisyButtonIdentifier: "decor--daisy--button";
export const DecorDaisyClickToCopyIdentifier: "decor--daisy--click-to-copy";
export const DecorDaisyCodeBlockIdentifier: "decor--daisy--code-block";
export const DecorDaisyDropdownIdentifier: "decor--daisy--dropdown";
export const DecorDaisyFlashIdentifier: "decor--daisy--flash";
export const DecorDaisyMapIdentifier: "decor--daisy--map";
export const DecorDaisyNotificationManagerIdentifier: "decor--daisy--notification-manager";
export const DecorDaisyPolygonEditorIdentifier: "decor--daisy--polygon-editor";
export const DecorDaisyProgressIdentifier: "decor--daisy--progress";
export const DecorDaisyTabsIdentifier: "decor--daisy--tabs";
export const DecorDaisyFormsButtonRadioGroupIdentifier: "decor--daisy--forms--button-radio-group";
export const DecorDaisyFormsCheckboxIdentifier: "decor--daisy--forms--checkbox";
export const DecorDaisyFormsDateCalendarIdentifier: "decor--daisy--forms--date-calendar";
export const DecorDaisyFormsExpandingCheckboxCollectionIdentifier: "decor--daisy--forms--expanding-checkbox-collection";
export const DecorDaisyFormsFileUploadIdentifier: "decor--daisy--forms--file-upload";
export const DecorDaisyFormsMultiImageUploadIdentifier: "decor--daisy--forms--multi-image-upload";
export const DecorDaisyFormsNumberFieldIdentifier: "decor--daisy--forms--number-field";
export const DecorDaisyFormsRadioIdentifier: "decor--daisy--forms--radio";
export const DecorDaisyFormsSearchableMultiSelectIdentifier: "decor--daisy--forms--searchable-multi-select";
export const DecorDaisyFormsSearchableSelectIdentifier: "decor--daisy--forms--searchable-select";
export const DecorDaisyFormsSelectIdentifier: "decor--daisy--forms--select";
export const DecorDaisyFormsSwitchIdentifier: "decor--daisy--forms--switch";
export const DecorDaisyFormsTextAreaIdentifier: "decor--daisy--forms--text-area";
export const DecorDaisyFormsTextFieldIdentifier: "decor--daisy--forms--text-field";
export const DecorDaisyModalsConfirmIdentifier: "decor--daisy--modals--confirm";
export const DecorDaisyModalsConfirmModalIdentifier: "decor--daisy--modals--confirm-modal";
export const DecorDaisyModalsConfirmTemplateIdentifier: "decor--daisy--modals--confirm-template";
export const DecorDaisyModalsModalCloseButtonIdentifier: "decor--daisy--modals--modal-close-button";
export const DecorDaisyModalsModalIdentifier: "decor--daisy--modals--modal";
export const DecorDaisyModalsModalOpenButtonIdentifier: "decor--daisy--modals--modal-open-button";
export const DecorDaisyModalsModalTriggerIdentifier: "decor--daisy--modals--modal-trigger";
export const DecorDaisyTablesBulkActionsBarIdentifier: "decor--daisy--tables--bulk-actions-bar";
export const DecorDaisyTablesTagFilterBarIdentifier: "decor--daisy--tables--tag-filter-bar";
