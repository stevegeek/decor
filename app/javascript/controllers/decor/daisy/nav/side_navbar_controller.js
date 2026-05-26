import { Controller } from "@hotwired/stimulus";

// SideNavbar controller.
//
// The SideNavbar component declared this controller's targets/actions/values
// but NO controller ever shipped, so the mobile drawer, the desktop
// collapse/expand, the hover-to-peek and the nav search were all dead. This
// implements them with no external dependencies:
//
//   - toggleMobileMenu        → show/hide the mobile drawer overlay
//   - toggleCollapseDesktopMenu → collapse/expand the desktop rail (width +
//                                 collapse/expand icon + wordmark/avatar swap)
//   - handleMouseOver/Away     → peek-expand the rail while hovered when collapsed
//   - search                   → hide nav items whose label doesn't match
export default class extends Controller {
  static targets = [
    "mobileMenu",
    "desktopMenu",
    "desktopAvatarLogo",
    "desktopLogo",
    "desktopCollapseIcon",
    "desktopExpandIcon",
    "mobileSearchNavigation",
    "searchNavigation",
  ];

  static values = { collapsed: { type: Boolean, default: false } };

  // Cookie that persists the collapsed state across reloads. Read on connect so
  // client-side state restores; written on every toggle.
  static collapsedCookieName = "decor_side_navbar_collapsed";

  connect() {
    const stored = this.readCollapsedCookie();
    if (stored !== null) this.collapsedValue = stored;
  }

  readCollapsedCookie() {
    const match = document.cookie.match(
      new RegExp("(?:^|; )" + this.constructor.collapsedCookieName + "=([^;]*)"),
    );
    if (!match) return null;
    return match[1] === "true";
  }

  writeCollapsedCookie(value) {
    document.cookie =
      this.constructor.collapsedCookieName +
      "=" +
      value +
      "; path=/; max-age=31536000; samesite=lax";
  }

  // ── Mobile drawer ──────────────────────────────────────────────────────
  toggleMobileMenu(event) {
    if (event && typeof event.preventDefault === "function") event.preventDefault();
    if (this.hasMobileMenuTarget) {
      this.mobileMenuTarget.classList.toggle("decor:hidden");
    }
  }

  // ── Desktop collapse / expand ──────────────────────────────────────────
  toggleCollapseDesktopMenu() {
    this.collapsedValue = !this.collapsedValue;
    this.writeCollapsedCookie(this.collapsedValue);
  }

  collapsedValueChanged() {
    this.applyCollapsed(this.collapsedValue);
  }

  applyCollapsed(collapsed) {
    if (this.hasDesktopMenuTarget) {
      this.desktopMenuTarget.classList.toggle("decor:lg:w-20", collapsed);
      this.desktopMenuTarget.classList.toggle("decor:lg:w-72", !collapsed);
      // Plain marker class the Suite skin's CSS keys off to turn the rail
      // icon-only (text/labels/arrows hidden, items centered). Harmless on the
      // Daisy skin, whose components lack the Suite class names the rules scope to.
      this.desktopMenuTarget.classList.toggle("collapsed", collapsed);
      // Leaving collapsed clears any stale hover-open marker.
      if (!collapsed) this.desktopMenuTarget.classList.remove("hover-open");
    }
    // Drive the page content's left padding: the `.decor--side-navbar-content`
    // wrapper shrinks its padding to the collapsed rail width via this body class.
    document.body.classList.toggle("decor-side-navbar-collapsed", collapsed);
    // Collapse shows the chevron-right (expand) icon; expanded shows the menu icon.
    this.setHidden(this.desktopCollapseIconTarget, this.hasDesktopCollapseIconTarget, collapsed);
    this.setHidden(this.desktopExpandIconTarget, this.hasDesktopExpandIconTarget, !collapsed);
    // Collapse hides the wordmark logo and reveals the compact avatar.
    this.setHidden(this.desktopLogoTarget, this.hasDesktopLogoTarget, collapsed);
    this.setHidden(this.desktopAvatarLogoTarget, this.hasDesktopAvatarLogoTarget, !collapsed);
  }

  setHidden(el, present, hidden) {
    if (!present || !el) return;
    el.classList.toggle("decor:hidden", hidden);
  }

  // ── Hover-to-peek while collapsed ──────────────────────────────────────
  handleMouseOver() {
    if (this.collapsedValue) {
      this.setRailWidth(false);
      // While collapsed, hovering re-expands: the Suite CSS stops hiding things
      // once both `collapsed` and `hover-open` are present.
      if (this.hasDesktopMenuTarget) this.desktopMenuTarget.classList.add("hover-open");
    }
  }

  handleMouseAway() {
    if (this.collapsedValue) this.setRailWidth(true);
    if (this.hasDesktopMenuTarget) this.desktopMenuTarget.classList.remove("hover-open");
  }

  setRailWidth(narrow) {
    if (!this.hasDesktopMenuTarget) return;
    this.desktopMenuTarget.classList.toggle("decor:lg:w-20", narrow);
    this.desktopMenuTarget.classList.toggle("decor:lg:w-72", !narrow);
  }

  // ── Client-side nav filter ─────────────────────────────────────────────
  search(event) {
    const query = (event.target.value || "").trim().toLowerCase();
    this.element.querySelectorAll("nav a").forEach((link) => {
      const match = query === "" || link.textContent.toLowerCase().includes(query);
      link.classList.toggle("decor:hidden", !match);
    });
  }
}
