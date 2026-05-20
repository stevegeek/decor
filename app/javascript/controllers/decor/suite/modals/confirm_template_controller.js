// Suite re-export of the Daisy confirm_template controller. The Suite Ruby
// component sets its stimulus_identifier to the Daisy path via DAISY_CTRL_PATH
// — keep both file paths in sync so Stimulus's auto-importer registers the
// controller under decor--daisy--modals--confirm-template, which the
// Suite::Modals::ConfirmTemplate template's data-controller attribute points
// at.
export { default } from "../../daisy/modals/confirm_template_controller";
