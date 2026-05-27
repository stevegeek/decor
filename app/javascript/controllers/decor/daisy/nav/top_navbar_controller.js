import TopNavbarBaseController from "../../nav/top_navbar_base";

// Daisy skin's TopNavbar controller (own class), extending the shared base.
export default class extends TopNavbarBaseController {
  get sideNavbarIdentifier() {
    return "decor--daisy--nav--side-navbar";
  }
}
