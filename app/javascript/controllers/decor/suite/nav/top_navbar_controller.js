import TopNavbarBaseController from "../../nav/top_navbar_base";

// Suite skin's TopNavbar controller (own class), extending the shared base.
export default class extends TopNavbarBaseController {
  get sideNavbarIdentifier() {
    return "decor--suite--nav--side-navbar";
  }
}
