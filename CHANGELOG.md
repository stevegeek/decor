# Changelog

## 0.8.0 — Unreleased

### Suite design tokens — visual-parity pass

A coordinated rewrite of every Suite component to restore visual parity with
the historical ConfinusUI design system. The prior implementations leaked
daisyUI's saturated-semantic palette into Suite (washed-out body text on
muted backgrounds, plus shape/typography drift); this release ports
Confinus's numbered color scale, hairline borders, custom radii, motion
duration, and typography utilities into Decor's theme under a `suite-*`
prefix, then rewrites every Suite component to reference them.

**New theme tokens** (in `app/assets/tailwind/decor.css`):
- Numbered color shades: `--color-suite-{primary,success,warning,danger}-{50..900}` (hex copied from Confinus design system).
- Hairlines: `--color-suite-hairline` (8% black), `--color-suite-hairline-strong` (12% black).
- Surface tint: `--color-suite-gray-25` (faint warm white footer/chip background).
- Radius: `--radius-suite-card` (10px), `--radius-suite-control` (6px) + matching `rounded-suite-card`, `rounded-suite-control` utilities.
- Motion: `--duration-suite-fast` (120ms), `--duration-suite-base` (200ms) + matching `duration-suite-fast`, `duration-suite-base` utilities.
- Typography utilities: `suite-section-title`, `suite-subsection-title`, `suite-label`, `suite-body`, `suite-dense-body`, `suite-description`, `suite-caption` — size+weight+leading+letter-spacing only; caller sets `color:`.

**Component rewrites:**
- `Decor::Suite::Avatar`: `prop :border` default flipped to `true` (Confinus rendered a hairline by default). `tracking-tight` → `tracking-[-0.01em]`. Size pixel ladder aligned to Confinus (xs=20, sm=28, md=36, lg=48, xl=56). Border uses `border-suite-hairline`.
- `Decor::Suite::Spinner`: complete rewrite — was empty subclass of `Decor::Daisy::Spinner` (daisyUI `d-loading-spinner`). Now a CSS border-rotate ring (`gray-200` track + `border-t-suite-{color}-500` colored top, `animate-spin`).
- `Decor::Suite::ClickToCopy`: tokens swapped to `bg-suite-gray-25`, `border-suite-hairline-strong`, `rounded-suite-control`, `duration-suite-fast`; typography → `suite-dense-body` (chip) / `suite-description` (inline).
- `Decor::Suite::Tag`: filled palette `bg-suite-{color}-50 + text-suite-{color}-700`; outlined `bg-white + border-suite-{color}-{100|200}`; LED dot `bg-suite-{color}-500 + shadow-suite-{color}-500/20`; `default_size :sm`; hole + nose use suite hairline.
- `Decor::Suite::Badge`: same palette migration as Tag; `default_size :sm`; icon color one shade lighter (`text-suite-{color}-600`).
- `Decor::Suite::Flash`: variant palettes use `suite-{color}-50/100/700`; icon-wrap uses `bg-suite-{color}-100 + text-suite-{color}-600`; title/body typography → `suite-section-title` + `suite-description`; radii → `rounded-suite-card` / `rounded-suite-control`.
- `Decor::Suite::FlowStep`: **dropped the `Decor::Daisy::Title` delegation** that was rendering a daisyUI-shaped large heading with flex chrome. Title now inline `h4.suite-section-title` + `p.suite-description`. Step circle palettes use suite-* shades.
- `Decor::Suite::Card`: hairlines → `border-suite-hairline`; footer tint → `bg-suite-gray-25`; radius → `rounded-suite-card`; title → `suite-dense-body`; body → `suite-description`.
- `Decor::Suite::Banner`: variant palette → suite-* shades; body text → `suite-dense-body`; radius → `rounded-suite-card`; icon color one shade lighter; link button → suite tokens.

## 0.7.0 — Unreleased

### Suite::Badge — per-component migration cycle

- Add `Decor::Suite::Badge` — muted pill (`bg-{color}/10 text-{color}`) with optional `dot:` boolean prop for an animated halo indicator. Supports `:filled` (default, subtle) and `:outlined` styles plus icon prefix. Companion to `Decor::Daisy::Badge`.

## 0.6.0 — Unreleased

### Suite::Card + Tag + Banner — parallel per-component migration cycle

- Add `Decor::Suite::Card` — muted-chrome container with `with_header` / `with_title` / `with_footer` slots. Body, header, title, footer rows use `bg-base-100` + `border-black/10` hairlines; footer uses `bg-base-200/40`.
- Extend `Decor::Components::Card` (abstract base) with `card_title` / `with_title` and `card_footer` / `with_footer` slot helpers alongside the existing `card_header`. Daisy skin unaffected; future skins or hosts can use them.
- Add `Decor::Suite::Tag` — distinctive pill silhouette: pointed-nose left edge via `::before` clip-path, circular "hole" punch via `::after`, optional animated LED indicator dot (halo via `shadow-{color}/20`). Filled + outlined variants, 5 sizes, optional icon + removable close button.
- Add `Decor::Suite::Banner` — muted full-width alert with optional icon, body block, `link:` ("Learn more") and `call_to_action` slot. Defaults `centered: true` (Decor abstract default is `false`).

### Engine correctness
- Fix: `Decor::FlashHelper` registration now uses `config.to_prepare` to avoid an autoload-timing race at host boot.
- Add: `isolate_namespace Decor` to make helper distribution intentional (hosts no longer auto-include every helper in `app/helpers/decor/`).
- Add: Zeitwerk ignore for `app/javascript/` and `app/assets/` (prevents unnecessary tree walking at boot).
- Add: `app/assets/builds/` to asset paths so hosts can link the built CSS via `stylesheet_link_tag "decor"`.
- Fix: Lookbook initializer now guards against `app.config.lookbook` being nil (initializer-ordering race vs. Lookbook's railtie).
- Polish: gemspec metadata (homepage, source_code_uri, changelog_uri, bug_tracker_uri, description).

### Suite::Flash — per-component migration cycle
- Add `Decor.default_skin` configuration accessor (default `:daisy`). Apps override to pick the visual skin used by Decor view helpers like `decor_flash`.
- Add `Decor::FlashHelper` view helper providing `decor_flash(skin:, **opts, &block)`. Bridges the Rails request context (flash hash, controller path, action name) to the pure component. Auto-registered into ActionController via the engine, and into Phlex components via `register_output_helper`.
- Add `Decor::Suite::Flash` — muted-card skin with avatar-style icon wrap and close-X button. Companion to `Decor::Daisy::Flash`.

### Suite::FlowStep — next per-component migration cycle
- Add `Decor::Suite::FlowStep` with muted palette and card-chromed child block, suited for multi-step admin import forms.

### Icon unification + Tabler migration
- Added `Decor::Icon` (top-level) — sprite-based, single shared class. Replaces `Decor::Daisy::Icon`, `Decor::Suite::Icon`, and `Decor::Daisy::Svg`.
- Switched from Heroicons inline-SVG (1117 individual files) to Tabler sprite (`<use href="sprite.svg#id">`). Lifted body from ConfinusUI::Icon.
- Bundled sprites: `tabler-outline.svg` (~2.1 MB), `tabler-filled.svg` (~708 KB), `decor.svg` (tiny, custom glyphs).
- Filled-variant fallback: `Decor::Icon::TABLER_FILLED_ICONS` set built at boot — silent fallback to `:outline` when a requested `:solid`/`:small_solid` variant has no filled counterpart.
- Dropped runtime dependency on `inline_svg` gem.
- Internal Decor call sites codemodded: ~20 Heroicons-only icon names renamed to Tabler equivalents.
- Established the "skin-less single class at top level" pattern: components with no visual divergence between Daisy and Suite live at `Decor::X`, not `Decor::{Daisy,Suite,Components}::X`.

### Spinner + ClickToCopy — second per-component migration cycle
- Added `Decor::Suite::Spinner` — empty subclass of Daisy (no visual divergence; drops Confinus' `:pulse` style which had zero callers).
- Added `Decor::Suite::Icon` — empty subclass of Daisy; both skins use Tabler-style icon names (asset resolution still goes through the existing image path; full Tabler asset migration is future work).
- Added `Decor::Suite::ClickToCopy` — preserves the two-variant API (`:chip` / `:inline`) and `:tag_name` prop. Bespoke brand tokens replaced with generic Tailwind utilities (no additions to Decor's `@theme`).
- `Decor::Daisy::ClickToCopy` icon name fixed from `"duplicate"` to `"copy"` (Tabler convention).
- Suite::ClickToCopy Stimulus controller is a one-line re-export of Daisy's controller (shared behavior).
- `bin/stimulus-imports` now disambiguates same-basename controllers across skins (e.g. Daisy + Suite ClickToCopy → `DaisyClickToCopyController` + `SuiteClickToCopyController`).
- `bin/build-js` esbuild alias ordering fixed so longer-path aliases precede shorter prefix aliases (pre-existing latent bug surfaced by the new file).

### Suite::Avatar — first per-component migration cycle
- Added `Decor::Suite::Avatar` — bespoke gradient placeholder palette (`:alt1..:alt5`), hairline border, custom `rounded-card` shape, status dot. An alternative visual idiom to Daisy for hosts that need a more bespoke look.
- Abstract base `Decor::Components::Avatar`: renamed `:ring` → `:border`; added `:alt` (accessibility) and `:status` (online/away/offline) props.
- `Decor::Daisy::Avatar` updated to match: ring-style border still rendered for `:border: true`; new status dot using daisyUI semantic colors; image `alt` falls back through `:alt → :initials → t(".image")`.
- Added `--radius-card: 10px` Tailwind theme token for Suite's square shape.

First gem release of Decor. Previously distributed as a Rails reference app.

### Repo structure
- Converted from Rails app to Rails engine + gem.
- Dummy app + Lookbook host moved to `test/dummy/`.
- Engine surface: `app/components/decor/`, `app/javascript/{controllers/decor,decor}/`, `app/assets/{stylesheets/decor,tailwind/decor.css,images,builds}/`, `lib/decor/`.

### Asset pipeline
- Tailwind v4 with `prefix(decor)` (utilities) + daisyUI v5 with `prefix: "d-"` (components).
- esbuild bundles `app/javascript/decor/index.js` → `app/assets/builds/decor.js` with `@hotwired/stimulus`, `@hotwired/turbo`, `@floating-ui/dom`, `swiper`, `cally`, `tailwind-merge` as peer-deps (host provides).

### Class merging
- `Decor::ClassMerger` wraps `tailwind_merge` to strip `decor:` prefix before merging, then restore. Consumer unprefixed classes correctly override gem defaults.
- Vident integration via `Decor::PhlexComponent#tailwind_merger`.

### Component template migration
- All `class:` / `classes:` strings across 109+ components migrated to `decor:` prefix (utilities) and `decor:d-*` prefix (daisyUI classes).
- `CODEMOD-REVIEW` markers (documented in `docs/codemod-review-items.md`) flag sites for follow-up during per-component step-2 migration.

### Component dropped
- `Decor::Daisy::FormattedEncodedId` — host-specific abstraction unsuitable for the gem's public API; hosts that need it can reimplement locally.

### Known limitations
- `tailwind_merge` does not know daisyUI conflict groups; conflicting daisyUI variants in the same class string both survive (CSS cascade decides).
- Component-level bug fixes from the consolidation INDEX (Flash camelCase, DataTableFooter Proc eval, dead Stimulus declarations in nav/tables clusters, etc.) ship unfixed; each fix lands at that component's per-component step-2 migration.
