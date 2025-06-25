import { FormValidationEvent } from "lib/types";

import FlashController from "decor/flash_controller";
import BaseController from "decor/base_controller";
import { Decor__FlashControllerIdentifier } from "controllers/identifiers";

export default class FormExamplesFlashController extends BaseController {
  public static outlets = [Decor__FlashControllerIdentifier];
  private declare readonly decorFlashOutlet: FlashController;
  private get flashController() {
    return this.decorFlashOutlet;
  }

  public handleFormValidatedEvent(evt: FormValidationEvent) {
    const {
      detail: { valid, preamble, errors },
    } = evt;

    const fc = this.flashController;
    if (fc) {
      if (valid) {
        fc.hide();
      } else {
        // Show the flash box.
        // TODO this might be best wrapped up in a utility component.
        const errorMessages = errors.map((err) => err.message);
        fc.renderHeadingWithListContent(preamble, errorMessages);
        fc.reveal();
      }
    }
  }
}
