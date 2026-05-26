import { Controller } from "@hotwired/stimulus";

// TopNavbar controller.
//
// The TopNavbar component declared this controller (the abstract base exposes
// instant_search_path as a Stimulus value, and the skins wire the hamburger +
// search actions) but no controller JS ever shipped — so the mobile-menu
// hamburger and the search field were dead in both skins. This implements the
// essential behaviour with no external deps:
//   - toggleMobileMenu opens whichever side-navbar is present (skin-agnostic:
//     it reads that navbar's controller identifier and fires its scoped
//     toggle event, the same one the side-navbar listens for on window)
//   - the search actions are safe no-ops here (instant search needs a backend);
//     they exist so the wired actions resolve cleanly.
export default class extends Controller {
  static targets = ["search", "searchInput", "searchDropdown"];

  toggleMobileMenu() {
    const sidebar = document.querySelector(
      "[data-controller~='decor--suite--nav--side-navbar']," +
        "[data-controller~='decor--daisy--nav--side-navbar']",
    );
    if (!sidebar) return;
    const identifier = (sidebar.getAttribute("data-controller") || "")
      .split(/\s+/)
      .find((c) => /nav--side-navbar$/.test(c));
    if (identifier) {
      window.dispatchEvent(new CustomEvent(`${identifier}:toggleMobileMenu`));
    }
  }

  // Instant search needs a backend that the harness doesn't provide; keep these
  // as safe no-ops so the component's wired actions resolve.
  clickedSearchInput() {}
  search() {}
  gotSearchFocus() {}
  lostSearchFocus() {}
  clickedSearchContent() {}
}
