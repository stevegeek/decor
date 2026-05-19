# Changelog

## 0.15.0 — Unreleased

### Suite component batch 5 — 10 ports + DateCalendar popover-scroll fix + two abstract-base bug fixes

Ported in parallel; each component carries a Suite reskin of the ConfinusUI
identity (or, for `CodeBlock` which has no ConfinusUI peer, a Daisy reskin
in Suite tokens).

- `Decor::Suite::Forms::TextArea` — same shell as Suite::Forms::TextField with
  resize-y, min-h-[84px], `font-mono`-free body type. Optional character
  counter when `maximum_length` is set.
- `Decor::Suite::Forms::HiddenField` — emits `<input type="hidden">`; no chrome.
- `Decor::Suite::Forms::ButtonRadioGroup` — segmented control: gray-100 pill,
  white-lifted selected segment with hairline-strong outline shadow +
  primary-500 text. Uses `has-[input:checked]:*` for selection state.
- `Decor::Suite::Forms::FileUpload` — three variants (`:file` dashed drop
  zone, `:image` thumbnail + CTA, `:avatar` circle + native input). Appends
  the existing Daisy controller via `controllers DAISY_CTRL_PATH` so DnD
  + preview JS works without duplication.
- `Decor::Suite::Forms::ExpandingCheckboxCollection` — Suite chrome around
  the base's checkboxes slot, with a `Decor::Suite::Button(:ghost, :primary,
  :sm)` toggle.
- `Decor::Suite::Tables::DataTableFooter` — flex band with hairline top
  border, suite-gray-25 bg, `:section` / `:final` separators.
- `Decor::Suite::NotificationManager` — fixed-position toast container
  (6 positions: top/bottom × left/center/right), `<template>` clones a
  Suite::Notification skeleton.
- `Decor::Suite::Chat::List` — message-thread container with Suite section
  title + empty-state. Adopts the abstract base's `messages:` array prop API.
- `Decor::Suite::Chat::ListMessage` — own-message rows tinted suite-primary-50
  with suite-primary-700 author name; other rows neutral. Avatar falls back
  to a user icon in a suite-gray-25 circle. Timestamp flips between H:M
  (<24h) and m/d (older).
- `Decor::Suite::CodeBlock` — Suite reskin (no ConfinusUI peer). Reuses the
  Daisy JS controller verbatim by overriding `self.stimulus_identifier_path`
  to return `"decor/daisy/code_block"`, so the existing `import "cally"`-style
  controller binds without duplication.

### Fix: Suite::Forms::DateCalendar popover stuck on viewport scroll

`mode: :popover` writes inline `top`/`left` on the panel before `showPopover()`
so the calendar sits below the trigger. But with `position: fixed`, the panel
stays glued to the viewport while page content scrolls underneath — visually
decoupling from the trigger. The controller now registers
capture-phase `scroll` + `resize` listeners on window while the popover is
open and re-runs `_positionPopover()` on each fire, then tears the listeners
down via the popover's `toggle` event when state flips to `closed`.

### Fix: Components::Forms::ButtonRadioGroup `required`/`disabled` never emitted

The abstract base wrote `attrs[:required] = nil if @required` /
`attrs[:disabled] = nil if @disabled`. Phlex drops `nil`-valued attributes
entirely on either branch, so `required` and `disabled` radios actually
rendered without those attributes — silently breaking form-level required
validation on the Daisy variant for the entire life of the component.
Changed to `attrs[:required] = true if @required` / `attrs[:disabled] = true
if @disabled`. Same fix applied to `label_html_attributes`.

### Fix: Components::Forms::ExpandingCheckboxCollection outlet hard-coded to Daisy

The abstract base declared `outlets({Decor::Daisy::Forms::Checkbox.stimulus_identifier => nil})`
on its stimulus block, so Suite consumers would emit an outlet pointing at
the Daisy checkbox identifier — wrong skin, wrong controller. Changed to
declare BOTH skin's checkbox identifiers as outlets; one extra
`data-…-outlet` attribute on the root is cheap and avoids a per-skin
override.

### Tests

Batch 5 components: 156 runs / 642 assertions / 0F.
Full Suite suite: 1048 runs / 4267 assertions / 0F.
(One pre-existing failure in `Decor::Daisy::Forms::ExpandingCheckboxCollectionTest`
asserts unprefixed `"join join-vertical"` but Daisy emits `decor:d-join
decor:d-join-vertical` post-codemod; unrelated to this batch.)

## 0.14.0 — Unreleased

### Add: Suite::Forms::DateCalendar gains `mode: :inline | :popover`

`:inline` (default) keeps the always-expanded calendar (batch-4 behaviour).
`:popover` renders a read-only Suite TextField trigger plus a native
`<div popover="auto">` panel containing the cally calendar — matches
ConfinusUI's flatpickr UX for narrow filter/table contexts where the
inline calendar takes too much vertical room. The controller anchors
the panel below the trigger via inline top/left written before
`showPopover()`, copies the picked value into the trigger input, and
dismisses on pick (single/month) or on `rangeend` (range) — multi-select
keeps the panel open so the user can keep picking.

### Add: Suite-skinned Tables::DataTableHeaderRow / DataTableHeaderCell / DataTableRow

The Suite DataTable was falling back to Daisy's row + header chrome,
producing daisyUI's `text-base-content` / `text-xs tracking-wider`
column headers (mismatched against Confinus's expected
`suite-caption uppercase tracking-[0.04em] text-gray-500`) and no per-row
border separator. Ported all three with Suite tokens:

- `Decor::Suite::Tables::DataTableHeaderCell` — suite-caption typography,
  hairline bottom border, unicode-arrow sort indicator (fades in on hover
  for sortable columns, opacity-70 when sorted).
- `Decor::Suite::Tables::DataTableHeaderRow` — uses Suite header cell by
  default, Suite Checkbox for selection.
- `Decor::Suite::Tables::DataTableRow` — Suite Checkbox for selection,
  suite-gray-25 hover, suite-primary-50/100 highlight rows. The per-cell
  `border-b border-suite-hairline` provides row separation; the table now
  carries `[&_tbody_tr:last-child_td]:border-b-0` to avoid double-border
  against the card edge (replaces the misguided `divide-y` on tbody from
  the previous version, which would have stacked with the per-cell
  borders).

Suite DataTable's `with_data_table_header_row` / `with_data_table_row`
already routed through `suite_const_or_daisy(:X)`, so these new
components are picked up automatically.

### Tests

DateCalendar + DataTable + Suite tables tests: 83 runs / 277 assertions / 0F.
Full Suite suite: 892 runs / 3625 assertions / 0F.

## 0.13.0 — Unreleased

### Fix: SearchableSelect / SearchableMultiSelect dropdown never opened

The shared abstract base classes (`Decor::Components::Forms::SearchableSelect`
and `SearchableMultiSelect`) declared `targets :input, :dropdown, …` /
`actions …` inside their `stimulus do` blocks. Vident's `targets` and `actions`
DSL emit on the **controller root**, so the wrapper `<div>` ended up carrying
`data-…-target="input dropdown …"` — Stimulus's `[data-…-target~="input"]`
matcher then resolved `inputTarget` to that wrapper and every controller method
touching `inputTarget.value` (`_openBrowseIfClosed`, `search`, etc.) threw
`TypeError: Cannot read properties of undefined (reading 'trim')`. Removed the
spurious DSL entries — the per-element children already wire their own targets
and actions inline via `child_element(stimulus_target:, stimulus_actions:)`.

### Fix: DateCalendar rendered as inert custom elements

The `decor--daisy--forms--date-calendar` controller (which the Suite controller
inherits from) had no import of the `cally` package, so `<calendar-date>`,
`<calendar-range>`, `<calendar-multi>` and `<calendar-month>` were never
registered as custom elements. Added a side-effect `import "cally"` at the top
of the Daisy controller — the gem already declared `cally >= 0.7` as a peer
dependency.

### Fix: Suite DataTable rendered without row separators

The Suite DataTable's tbody had no inter-row divider class. Added
`decor:divide-y decor:divide-suite-hairline` to the tbody so body rows match
the historical hairline-separated identity.

### Add: Suite-skinned FormBuilder so `form_component.builder.x` renders Suite

`Decor::Forms::ActionViewFormBuilder` hard-codes `Decor::Daisy::Forms::*` in
every tag-wrapper, so leaf ERB calls like `form_component.builder.text_field`
inside a `Decor::Suite::Forms::Form` block were rendering Daisy chrome.
Introduced `Decor::Suite::Forms::ActionViewFormBuilder` (+ Suite TagWrapper
subclasses for TextField / NumberField / Select / Checkbox / Switch /
RadioButton) and switched the Suite Form's `form_builder_class` default to it.
Helpers without a Suite counterpart (file_field, rich_text_area, tag_field,
button_radio_group, select_with_search, image_upload, avatar_upload,
collection_check_boxes) still fall through to the Daisy parent.

Tests: 137 runs / 549 assertions / 0F across all touched form/table tests.
Full Suite suite: 892 runs / 3625 assertions / 0F.

## 0.12.0 — Unreleased

### Suite component batch 4 — 10 ports (forms foundation + modal sub-types + tables)

- `Decor::Suite::Forms::FormFieldLayout` (+ companion `HelperTextSection` + `ErrorIconSection`) — foundation for label/input/helper/error layout; 5 label_position variants (top/left/inline/right/inside). Existing Suite form fields can refactor to use this as a follow-up.
- `Decor::Suite::Forms::Radio` (+ abstract `required_individual?` fix) — 16px white-ring → primary-500 filled when checked; suite-primary-100 focus halo.
- `Decor::Suite::Forms::NumberField` — inherits Suite::Forms::TextField; adds `text-right tabular-nums` for numeric-column alignment.
- `Decor::Suite::Forms::DateCalendar` (cally-based) — uses Decor's cally peerDep (not flatpickr). NB: Confinus call sites passing flatpickr-style props will need migration.
- `Decor::{Components,Daisy,Suite}::Forms::SearchableMultiSelect` — multi-select sibling of SearchableSelect with chip-removal UX (X button + backspace-on-empty pops last chip).
- `Decor::{Components,Daisy,Suite}::Modals::Confirm` — composition over Modal + ModalCloseButton + Button. Destructive variant tints header AND switches confirm button to `:error`.
- `Decor::{Components,Daisy,Suite}::Modals::Alert` — single-button alert dialog with severity-tinted chrome.
- `Decor::{Components,Daisy,Suite}::Modals::Information` — read-only info dialog with dismiss action.
- `Decor::Suite::Tables::DataTable` (+ selection-persistence props on abstract) — preserves Confinus's builder DSL slot API + 13px body + hairline divider + suite-gray-25 thead.
- `Decor::Suite::Tables::DataTableCell` (+ `compact` + `align` props on abstract) — link-overlay, alignment, density behaviors preserved from ConfinusUI.

Tests: 213 runs / 784 assertions / 0F across the 10 new Suite components. Full Suite directory smoke: 892 runs / 3625 assertions / 0F.

## 0.11.0 — Unreleased

### Suite component batch 3 — 10 ports (forms + modal family) in parallel

User flagged Confinus's form components as the canonical implementation. This batch ports the most-used form primitives plus completes the modal family started in batch 2.

- `Decor::Suite::Forms::Form` (+ `scope` prop on abstract) — preserves Confinus' Form behavior (CSRF, lock_version, dynamic outlet wiring per FormField descendant, ajax: events, custom validate event). Field controllers participate via a `validate()` / `disabled` / `focusControl()` contract.
- `Decor::Suite::Forms::LayoutSection` (+ widen abstract title to nilable) — form-section wrapper with hero/cta slots, conditional heading row, optional flash region.
- `Decor::Suite::Forms::TextField` — self-contained inline chrome (no Suite FormFieldLayout dependency); supports label_top/left/inline placements.
- `Decor::Suite::Forms::Select` (+ multiple/include_blank/silent_helper props on abstract) — supports multi-select + Rails-style include_blank.
- `Decor::Suite::Forms::Checkbox` — self-contained chrome.
- `Decor::Suite::Forms::Switch` — toggle switch with rounded track, color variants.
- `Decor::{Components,Daisy,Suite}::Forms::SearchableSelect` — typeahead with chip-on-select, debounced XHR, single-select (no auto-backspace), in-flow absolute dropdown (NOT native Popover — keeps input width + keyboard focus).
- `Decor::Suite::Modals::Modal` (+ Suite props on abstract: variant/size/title/description/icon/closeable/show_close_button/start_open) — native `<dialog>` element with `closedby="any"`, content_href lazy-fetch + skeleton, footer marker template protocol.
- `Decor::{Components,Daisy,Suite}::Modals::Form` — Modal + Form composition; submit button uses HTML5 `form=""` attribute to target the inner form; renamed `submit_theme:` → `submit_color:` for vocabulary alignment.
- `Decor::{Components,Daisy,Suite}::Modals::ModalTrigger` — wrapper variant of ModalOpenButton (transparent span around any clickable element); same event-bus contract.

Tests: 210 runs / 821 assertions / 0F across the 10 new Suite components. Full Suite directory smoke: 679 runs / 2841 assertions / 0F.

## 0.10.0 — Unreleased

### Suite component batch 2 — 10 more ports in parallel

- `Decor::Suite::Button` (+ `loading` prop on abstract base) — Suite-tokened buttons with filled/outlined/ghost/soft styles and Suite-specific `:wide` and `:link` size aliases.
- `Decor::Suite::ButtonLink` — button-styled anchor with same color/style/size matrix.
- `Decor::Suite::Tabs` — segmented strip + scroll-shadow scroll affordance; ports the Confinus Stimulus controller (Daisy's tabs controller handles a different mobile-select pattern and couldn't be reused).
- `Decor::Suite::SettingsList` (+ abstract base + Daisy skin) — collapsible row list with kicker/scope chips; Suite uses a Stimulus controller for chevron rotation + aria-expanded sync (Daisy uses native `<details>`). Confinus's `modal:` integration replaced with a plain edit-link prop (gem can't depend on Confinus' modal helpers).
- `Decor::Suite::PropertyList` (+ abstract + Daisy) — vertical list composition over `Suite::Property` with section grouping + CTA slot.
- `Decor::Suite::PropertyCard` (+ abstract + Daisy) — standalone composition with left-accent edge and 2/3/4-column body grid (NOT a Card + PropertyList wrapper; Confinus' PropertyCard has distinct chrome).
- `Decor::Suite::SearchAndFilter` — search input + filter chip popover; native `@floating-ui` not needed because Suite uses native CSS anchor positioning + Popover API like Suite::Dropdown.
- `Decor::{Components,Daisy,Suite}::LoadingBar` — linear progress bar with determinate + indeterminate slider modes. Suite preserves the ConfinusUI thin-pill look (`rounded-full` + suite-{color}-500 fill); animation via CSS keyframes (no JS).
- `Decor::Suite::Modals::ModalCloseButton` — namespaced under `modals/` to match abstract base + Daisy; dispatches window-scoped `decor--suite--modals--modal:close` event (replaces Confinus's ancestor-DOM `dialog.close()` coupling).
- `Decor::Suite::Modals::ModalOpenButton` (+ `title` prop on abstract) — namespaced match; dispatches `decor--suite--modals--modal:open` with snake+camel detail keys.

Tests: 174 runs / 727 assertions / 0F across the 10 new Suite components.

## 0.9.0 — Unreleased

### Suite component batch — 10 ports in parallel

Followed the porting playbook at `docs/superpowers/specs/2026-05-15-suite-port-playbook.md` (in the consumer repo) to add 10 Suite-skinned components in one parallel pass. Each port: extended the abstract base where the Suite skin needed props the Daisy version didn't carry, wrote the Suite class against Suite design tokens (numbered color shades, suite-hairline borders, rounded-suite-card/control radii, suite-* typography utilities), shipped a Lookbook preview + tests, plus a Stimulus controller where the abstract base declared one. Daisy unaffected; abstract bases extended additively.

- `Decor::Suite::Box` — container with header/title/footer slots.
- `Decor::Suite::Carousel` — Swiper-driven carousel with the full Swiper init lifecycle in a Suite Stimulus controller (Daisy's hash-anchor `d-carousel` stays as-is).
- `Decor::Suite::Dropdown` + `Decor::Suite::DropdownItem` — native CSS anchor positioning (`position-anchor`/`anchor()`/`position-try-fallbacks`) + native Popover API for show/hide; no `@floating-ui/dom` dependency.
- `Decor::Suite::Map` — Google Maps host with Suite chrome (hairline border, suite-card radius, gray-25 surface tint).
- `Decor::Suite::Notification` — slotted alert with `data-notification-slot` markers prepared for a future NotificationManager clone-template flow.
- `Decor::Suite::Pagination` — page-number nav with prev/next chevrons, active-page indicator, optional page-size selector chip row.
- `Decor::Suite::Progress` — step indicator + linear bar, two styles via `:style :steps|:progress|:both`.
- `Decor::Suite::Property` + `Decor::Suite::PropertyStrip` — label/value pairs and responsive auto-fit grid of pairs.
- `Decor::Suite::SwitchingBox` — title/description + bound switch slot. Latent abstract-base bug fixed (subclass `prop` additions silently shadowed the parent `initialize`; slot wiring moved to `after_component_initialize`).
- `Decor::Suite::Tooltip` — `@floating-ui/dom`-positioned dark bubble, 12 placements (cardinals + `-start`/`-end`), optional arrow.

Plus: gem-internal `@utility shadow-suite-popover` + popover-animation rules in the theme for things Tailwind utilities can't express (dropdown menu drop-shadow + enter/leave animations).

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
