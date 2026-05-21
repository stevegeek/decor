import { Controller } from "@hotwired/stimulus";
import { markAsSafeHTML, safelySetInnerHTML } from "controllers/decor";

// Controller for the Decor::Suite::Modals::ConfirmTemplate singleton dialog.
//
// The template is rendered once into an overlays partial inside a <template>
// element. A page-level helper (typically spawnConfirmDialog in
// lib/overlay/modal.ts) clones the template, appends the cloned <dialog> to
// <body>, and on the next animation frame asks Stimulus for THIS controller
// instance — calling fillSlots / applyVariant / wireCloseHandlers to populate
// the cloned dialog with caller-supplied content and behaviour before
// showModal()ing it.
//
// The classes API below is the JS-side mirror of the Suite Ruby component's
// `stimulus do ... classes ...` block — accent-bar, icon-colour, and
// destructive header/title class lists all flow through Stimulus's
// data-classes attributes rather than being hardcoded here, so the
// JS-spawned path stays byte-identical with the server-rendered modal.
export default class extends Controller {
  static targets = [
    "accent",
    "iconInfo",
    "iconSuccess",
    "iconWarning",
    "iconDanger",
    "iconDestructive",
    "iconNeutral",
    "title",
    "message",
    "cancelButton",
    "confirmButton",
    "header",
  ];

  static classes = [
    "accentInfo",
    "accentSuccess",
    "accentWarning",
    "accentDanger",
    "accentDestructive",
    "accentNeutral",
    "iconColorInfo",
    "iconColorSuccess",
    "iconColorWarning",
    "iconColorDanger",
    "iconColorDestructive",
    "destructiveHeader",
    "destructiveTitle",
  ];

  // Populate user-visible slots from caller options.
  // Recognises options: { title?, message?, messageHTML?,
  //                       negativeButtonLabel?, positiveButtonLabel? }
  fillSlots(options) {
    if (options.title != null && this.hasTitleTarget) {
      this.titleTarget.textContent = options.title;
    }
    if (this.hasMessageTarget) {
      if (options.messageHTML != null) {
        safelySetInnerHTML(this.messageTarget, markAsSafeHTML(options.messageHTML.toString()));
      } else if (options.message != null) {
        this.messageTarget.textContent = options.message;
      }
    }
    // cancelButtonTargets is an array (header X + footer Cancel). Footer
    // button is index 1; the header X (icon-only) keeps its existing label.
    if (options.negativeButtonLabel != null && this.cancelButtonTargets.length > 1) {
      this.cancelButtonTargets[1].textContent = options.negativeButtonLabel;
    }
    if (options.positiveButtonLabel != null && this.hasConfirmButtonTarget) {
      this.confirmButtonTarget.textContent = options.positiveButtonLabel;
    }
  }

  // Show the icon for the chosen variant, paint the accent bar, and for
  // :destructive apply the destructive header + title class lists.
  applyVariant(variantKey) {
    const variant = variantKey || "info";
    const accentMap = {
      info: this.accentInfoClasses,
      success: this.accentSuccessClasses,
      warning: this.accentWarningClasses,
      danger: this.accentDangerClasses,
      destructive: this.accentDestructiveClasses,
      neutral: this.accentNeutralClasses,
    };
    const iconColorMap = {
      info: this.iconColorInfoClasses,
      success: this.iconColorSuccessClasses,
      warning: this.iconColorWarningClasses,
      danger: this.iconColorDangerClasses,
      destructive: this.iconColorDestructiveClasses,
    };
    const iconTargetMap = {
      info: this.hasIconInfoTarget ? this.iconInfoTarget : null,
      success: this.hasIconSuccessTarget ? this.iconSuccessTarget : null,
      warning: this.hasIconWarningTarget ? this.iconWarningTarget : null,
      danger: this.hasIconDangerTarget ? this.iconDangerTarget : null,
      destructive: this.hasIconDestructiveTarget ? this.iconDestructiveTarget : null,
      neutral: this.hasIconNeutralTarget ? this.iconNeutralTarget : null,
    };

    // Accent bar.
    if (this.hasAccentTarget) {
      this.accentTarget.hidden = false;
      const accentClasses = accentMap[variant] ?? this.accentInfoClasses;
      if (accentClasses) this.accentTarget.classList.add(...accentClasses);
    }

    // Hide every icon, then un-hide the matching variant + tint it.
    Object.values(iconTargetMap).forEach((el) => {
      if (el) el.hidden = true;
    });
    const iconEl = iconTargetMap[variant];
    if (iconEl) {
      iconEl.hidden = false;
      const tint = iconColorMap[variant];
      if (tint) iconEl.classList.add(...tint);
    }

    // Destructive treatment of header + title.
    if (variant === "destructive") {
      if (this.hasHeaderTarget && this.destructiveHeaderClasses) {
        this.headerTarget.classList.add(...this.destructiveHeaderClasses);
      }
      if (this.hasTitleTarget && this.destructiveTitleClasses) {
        this.titleTarget.classList.add(...this.destructiveTitleClasses);
      }
      // Destructive uses the danger button chrome instead of primary.
      if (this.hasConfirmButtonTarget) {
        this.confirmButtonTarget.classList.remove(
          "decor:bg-suite-primary-500",
          "decor:hover:bg-suite-primary-700",
        );
        this.confirmButtonTarget.classList.add(
          "decor:bg-suite-danger-500",
          "decor:hover:bg-suite-danger-700",
        );
      }
    }
  }

  // Bind click handlers on cancel/confirm buttons that close the dialog with
  // the caller-specified reasons. The cloned dialog is owned by spawn-flow —
  // wireCloseHandlers also wires the `close` event to remove it from <body>
  // so we never leak DOM nodes across spawns.
  wireCloseHandlers(options) {
    const dialog = this.element;
    const negativeReason = options.negativeButtonReason ?? "cancelled";
    const positiveReason = options.positiveButtonReason ?? "confirmed";
    const defaultReason = options.defaultReason ?? negativeReason;

    this.cancelButtonTargets.forEach((btn) => {
      btn.addEventListener("click", (e) => {
        e.preventDefault();
        dialog.close(negativeReason);
      });
    });
    if (this.hasConfirmButtonTarget) {
      this.confirmButtonTarget.addEventListener("click", (e) => {
        e.preventDefault();
        dialog.close(positiveReason);
      });
    }

    // ESC / overlay-click — the browser fires `cancel` then `close` with the
    // dialog's current returnValue (empty by default). Substitute the
    // configured default reason when that happens.
    dialog.addEventListener("cancel", (e) => {
      e.preventDefault();
      dialog.close(defaultReason);
    }, { once: true });

    dialog.addEventListener("close", () => {
      // Dispatch a lifecycle event with the close reason for the caller's
      // onClosing handler to react to.
      const reason = dialog.returnValue || defaultReason;
      dialog.dispatchEvent(new CustomEvent("decor--suite--modals--modal:closing", {
        bubbles: true,
        cancelable: false,
        detail: { reason, closeReason: reason },
      }));
      // Cleanup — remove the cloned dialog from <body> so spawnConfirmDialog's
      // re-entrancy guard works on the next spawn.
      dialog.remove();
    }, { once: true });
  }
}
