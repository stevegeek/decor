import SideNavbarBaseController from "../../nav/side_navbar_base";

// Daisy skin's SideNavbar controller. Behaviour lives in the shared,
// skin-neutral base so the Daisy and Suite controllers are independent classes
// (each registered under its own identifier) with no skin → skin dependency.
// Override here if the Daisy skin needs to diverge.
export default class extends SideNavbarBaseController {}
