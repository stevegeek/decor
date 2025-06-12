import BaseController from "decor/base_controller.js";
export default class TabsController extends BaseController {
    handleSelectTabOnMobile(event) {
        const select = event.target;
        const selected = select.options[select.selectedIndex];
        const href = selected.getAttribute("data-href");
        if (href) {
            window.location.href = href;
        }
    }
}
