import { Controller } from "@hotwired/stimulus";

// Shared, skin-neutral TopNavbar behaviour. Each skin's controller extends this
// and overrides `sideNavbarIdentifier` with its own side-navbar's Stimulus
// identifier — the hamburger then opens that navbar's drawer.
//
// The component declared this controller (it exposes instant_search_path as a
// Stimulus value + wires the hamburger/search actions) but no controller ever
// shipped, so the hamburger and search were dead.
export default class extends Controller {
  static targets = ["search", "searchInput", "searchDropdown"];

  // Override in the skin subclass, e.g. "decor--suite--nav--side-navbar".
  get sideNavbarIdentifier() {
    return null;
  }

  // Opens the (same-skin) side-navbar drawer by firing its scoped toggle event,
  // the one the side-navbar listens for on window.
  toggleMobileMenu() {
    const id = this.sideNavbarIdentifier;
    if (id) window.dispatchEvent(new CustomEvent(`${id}:toggleMobileMenu`));
  }

  // Instant search needs a backend the harness doesn't provide; safe no-ops so
  // the component's wired actions resolve cleanly.
  clickedSearchInput() {}
  search() {}
  gotSearchFocus() {}
  lostSearchFocus() {}
  clickedSearchContent() {}
}
