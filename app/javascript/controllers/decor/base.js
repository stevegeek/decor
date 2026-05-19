import { Controller } from "@hotwired/stimulus";

// Optional shared base for Decor Stimulus controllers. Existing Decor
// controllers extend `@hotwired/stimulus`'s Controller directly; this base
// class is for the form-field subsystem where every concrete field shares
// a handful of DOM/class helpers and a guarded `initialize` chain so that
// subclasses are forced to walk down the prototype chain.

// Sentinel returned by the default `onInitialize`. A concrete subclass that
// overrides `onInitialize` must call `super.onInitialize()` and return its
// receipt; the guard in `initialize` throws otherwise. Object identity
// (`===`) is the check — keep this as a module-local object.
const initializeReceipt = {};

export default class BaseController extends Controller {
  static setIdentifier(id) {
    this.identifier = id;
  }

  initialize() {
    const receipt = this.onInitialize();
    if (receipt !== initializeReceipt) {
      throw new Error(
        `onInitialize was implemented in ${this.identifier} without a call to super.onInitialize.`,
      );
    }
  }

  onInitialize() {
    return initializeReceipt;
  }

  findParentElementByTagName(el, tagName) {
    const lower = tagName.toLowerCase();
    let cur = el;
    while (cur && cur.parentElement) {
      cur = cur.parentElement;
      if (cur.tagName && cur.tagName.toLowerCase() === lower) {
        return cur;
      }
    }
    return null;
  }

  get disabled() {
    return this.element.hasAttribute("disabled");
  }

  set disabled(disabled) {
    if (disabled) {
      this.element.setAttribute("disabled", "disabled");
    } else {
      this.element.removeAttribute("disabled");
    }
  }

  findController(element, identifier) {
    const controller = this.application.getControllerForElementAndIdentifier(
      element,
      identifier,
    );
    return controller instanceof BaseController ? controller : null;
  }

  toggleTargetElementClasses(target, state, classesOff, classesOn) {
    if (state) {
      this.setTargetElementClasses(target, classesOff, classesOn);
    } else {
      this.setTargetElementClasses(target, classesOn, classesOff);
    }
  }

  setTargetElementClasses(target, classesToRemove, classesToAdd) {
    classesToRemove.forEach((c) => target.classList.remove(c));
    classesToAdd.forEach((c) => target.classList.add(c));
  }

  // Emit a Stimulus dispatch with an explicit prefix taken from another
  // controller class's static `identifier`. Used by sibling controllers to
  // publish events under a stable, well-known namespace.
  emitEvent(
    target,
    ControllerClass,
    eventName,
    detail = undefined,
    bubbles = true,
    cancelable = false,
  ) {
    this.dispatch(eventName, {
      target,
      detail,
      prefix: ControllerClass.identifier,
      bubbles,
      cancelable,
    });
  }
}
