import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    handleSelectTabOnMobile(event) {
        const select = event.target;
        const selected = select.options[select.selectedIndex];
        const href = selected.getAttribute("data-href");
        if (href) {
            window.location.href = href;
        }
    }
}
