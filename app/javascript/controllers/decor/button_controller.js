import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  set disabled(disabled) {
    if (disabled) {
      this.element.setAttribute("disabled", "disabled");
    } else {
      this.element.removeAttribute("disabled");
    }
  }
}
