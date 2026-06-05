# Changelog

## 0.24.3

- **Suite `Modal` tears down a lazily-fetched body on close.** A modal opened
  with `content_href` (or a per-open content href) now clears its
  `.decor-modal__body` on the native `close` event, disconnecting the fetched
  content's controllers and dropping its DOM. Previously the fetched body
  lingered after close, so two modals fed from different fragments could coexist
  in the DOM — and any non-unique element ids they shared (e.g. a `label[for]`)
  would resolve to the wrong, hidden modal's control. The body is re-fetched on
  every open, so this is non-destructive; static (non-fetched) bodies are
  untouched.
- **Suite `Dropdown` merges its size classes instead of replacing them.**
  `dropdown_size_classes:` is now tailwind-merged with the defaults
  (`w-auto max-h-80`) rather than replacing them, so passing only a width no
  longer silently drops the `max-h` cap. Without the cap a tall menu (e.g. a
  full cart) grew past the viewport and the CSS-anchor `flip-block` fallback
  re-anchored it off the top of the screen. A consumer's own width/`max-h`
  still overrides the defaults (last-wins).
- **Fix the outlined Suite `Tag` "nose" rendering invisibly on light surfaces.**
  The left tag nose is a `::before` clip-path triangle, and a CSS border can't
  follow a clip-path — so the outlined nose was filled with `bg-inherit` (the
  white body background) with no visible edge. On a white surface it vanished,
  leaving the tag looking like a three-sided box with an open left point. The
  outlined nose is now filled with the body's border colour (mirroring the
  per-`color` map used for the body outline), so the tip reads as a solid
  extension of the outline. Filled tags are unchanged — `bg-inherit` already
  shows their tip against the coloured body.

## 0.24.2

- **Ship TypeScript declarations for the prebuilt bundle.** The package now
  includes `app/assets/builds/decor.d.ts` (referenced via package.json `types`)
  declaring the public JS surface exported from the bundle entry: the `register`
  function, `CONTROLLERS`, the reusable controller classes (`TextFieldController`,
  `NumberFieldController`, `FormFieldController`, `ConfirmTemplateController`,
  `DataTableController`), and every Suite/Daisy identifier constant (typed as its
  literal string). Host apps that type-check with `tsc` now resolve `import …
  from "decor"` without a hand-written module shim. No runtime change.

## 0.24.1

- **Expose the public JS surface from the package entry.** The bundle entry
  (`import "decor"`) now re-exports the identifier constants (Suite + Daisy) and
  the controller classes intended for reuse/subclassing (`TextFieldController`,
  `NumberFieldController`, `FormFieldController`, `ConfirmTemplateController`,
  `DataTableController`). Host apps can import these from `"decor"` instead of
  deep-importing the package's source tree, so consuming the prebuilt bundle is
  sufficient and no source files need to be resolvable at the consumer's build.

## 0.24.0

High-level summary of notable changes since 0.23.0:

- **Forms default to inheriting Turbo behavior.** `Decor::Components::Forms::Form`
  (and the Suite/Daisy skins) now default `turbo:` to `nil` instead of `false`,
  so a form emits no `data-turbo` attribute and inherits Turbo Drive from its
  nearest ancestor. Pass `turbo: false` to explicitly opt a single form out of
  Drive, or `turbo: true` to force it on. This makes forms behave correctly by
  default in a Turbo Drive application.
- **Removed the Suite form's Rails-UJS callback path.** The Suite form no
  longer rewrites its lifecycle callbacks to `ajax:*` event names; all forms now
  use Turbo's native `turbo:submit-*` events. `on_success`/`on_error`/etc. fire
  on `turbo:submit-end` (check `event.detail.success`).
- **Form-builder submit buttons translate legacy data attributes.** `submit` /
  `submit_primary` now map `data: {confirm:}` → `data-turbo-confirm` and
  `data: {disable_with:}` → `data-turbo-submits-with`, so existing call sites
  keep working without Rails-UJS.

## 0.23.0

High-level summary of notable changes since 0.22.0:

- **Suite navigation skin.** New `Decor::Suite::Nav::SideNavbar` (+ section /
  item / sub-item), `TopNavbar`, `SecondaryNavbar`, and `Breadcrumbs` — a
  light-by-default, generic port of the Navigo design with an optional `dark:`
  flag for a dark rail. The side navbar adds a mobile drawer, a collapsible
  icon-only desktop rail with hover-peek, cookie-persisted collapse state
  (no-flash server render), a `.decor--side-navbar-content` wrapper whose
  padding follows the rail width, and client-side item search.
- **Tooltip is a top-layer popover.** The Suite `Tooltip` now renders as a
  native `popover` anchored to its trigger via Floating UI, so it can't be
  clipped by `overflow:hidden` ancestors and no longer drifts when its wrapper
  is stretched by a flex/grid parent.
- **Shipped previously-missing Stimulus controllers.** The side navbar and top
  navbar referenced controllers that were never shipped (the drawer, collapse,
  search, and mobile hamburger were inert); both now ship, as skin-neutral
  bases with per-skin subclasses (no skin → skin coupling).
- **Dynamic-component demo harness.** `test/dummy` gains `/demo/*` pages for
  both skins (overlays/notifications, navigation, rich inputs, media) driven by
  Cuprite system tests that verify the Stimulus behaviour in a real browser.

## 0.22.x

Pre-1.0. The entries below describe the gem's current surface area at a
high level; a versioned, narrower changelog will start with the 1.0
release.

### Foundation
- Rails engine + gem layout. Tailwind v4 with `prefix(decor)` utilities;
  daisyUI v5 with `prefix: "d-"` components.
- esbuild bundles `app/javascript/decor/index.js` →
  `app/assets/builds/decor.js`. `@hotwired/stimulus`,
  `@hotwired/turbo`, `@floating-ui/dom`, `swiper`, `cally`, and
  `tailwind-merge` are peer dependencies.
- `Decor::ClassMerger` wraps `tailwind_merge` to strip the `decor:`
  prefix before merging, then restore — so consumer-side unprefixed
  classes correctly override gem defaults. Wired into Vident via
  `Decor::PhlexComponent#tailwind_merger`.
- Sprite-based `Decor::Icon` (top-level, skin-less). Tabler outline +
  filled sprites plus a small custom `decor.svg`. Filled-variant
  fallback to outline when no filled glyph exists. No runtime
  dependency on `inline_svg`.

### Two-skin architecture
- Components live as `Decor::Components::X` (abstract base) plus
  `Decor::Daisy::X` and `Decor::Suite::X` skins. Abstract bases own the
  prop API; skins own chrome.
- Suite design tokens (`app/assets/tailwind/decor.css`): numbered color
  shades (`--color-suite-{primary,success,warning,danger,gray}-{50..900}`),
  hairlines (`--color-suite-hairline`, `--color-suite-hairline-strong`),
  surface tint (`--color-suite-gray-25`), radii
  (`--radius-suite-{card,control}`), motion durations, and typography
  utilities (`suite-section-title`, `suite-body`, `suite-description`,
  `suite-caption`, etc.).
- `Decor.default_skin` configuration accessor (`:daisy` default) drives
  the skin used by view helpers like `decor_flash`.

### Components
Forms — `Form`, `FormField`, `FormFieldLayout`, `LayoutSection`,
`LayoutContainer`, `TextField`, `NumberField`, `TextArea`,
`HiddenField`, `Select`, `SearchableSelect`, `SearchableMultiSelect`,
`Checkbox`, `Radio`, `Switch`, `ButtonRadioGroup`,
`ExpandingCheckboxCollection`, `FileUpload`, `MultiImageUpload`,
`DateCalendar`, plus skin-aware tag wrappers and a skin-aware
`ActionViewFormBuilder` so `form_component.builder.x` renders the right
skin's chrome.

Tables — `DataTable`, `DataTableBuilder` DSL,
`DataTableHeaderRow`/`DataTableHeaderCell`,
`DataTableRow`/`DataTableCell`, `DataTableFooter`, `BulkActionsBar`,
`FilterBar`, `FilterBarChip`, `TagFilterBar`, plus
`Builder::Cell`/`Column`/`Row` data structs.

Modals — native `<dialog>`-based `Modal` (with `closedby="any"`,
`content_href:` lazy fetch + skeleton, footer marker template
protocol), `ModalOpenButton`, `ModalCloseButton`, `ModalTrigger`,
`Form`, `Confirm`, `Alert`, `Information`. JS-cloned `ConfirmTemplate`
for the global `showConfirmModal(...)` helper, with stimulus-classes
sharing variant chrome between server-rendered and JS-spawned paths.
The Suite `Modal` is a capped-height flex column (`max-h` of the
viewport) whose body is the internal scroll region (`overflow-y-auto`
+ `min-h-0`), with `shrink-0` header/footer — so content taller than
the viewport scrolls inside the body and the footer action buttons
stay reachable instead of being clipped. The Suite modal exposes a
stable BEM hook class `decor-modal` (with `__header`/`__body`/`__footer`
/`__title`/`__destructive-slot` elements and `--confirm`/`--loading`
modifiers) — decoupled from the namespace-derived Stimulus identifier —
that the controller's `querySelector`s and the fragment-unwrap check
rely on, and that consumers can target for content fragments.

Layout — `Page`, `PageHeader`, `PageSection`, `Panel`, `PanelGroup`,
`Box`, `Card`, `Stat`, `Stats`, `Property`, `PropertyStrip`,
`PropertyList`, `PropertyCard`, `SettingsList`, `Title`, `Heading`,
`Hero`, `FlowStep`.

Navigation — `Tabs`, `Pagination`, `SearchAndFilter`, `Breadcrumbs`,
`SideNavbar`, `TopNavbar`, `SecondaryNavbar`, `Footer`,
`CompactFooter`.

Notifications & chat — `Flash`, `Notification`, `NotificationManager`
(toast container with template-clone pattern), `Toaster`, `Chat::List`,
`Chat::ListMessage`, plus an AI chat widget that consumes broadcast
events from a consumer-provided streaming channel.

Misc — `Button`, `ButtonLink`, `Link`, `Tag`, `Badge`, `Banner`,
`Avatar`, `Spinner`, `Tooltip`, `Dropdown`/`DropdownItem`,
`ClickToCopy`, `Carousel`, `Map`, `EmptyState`, `CodeBlock`,
`CodeSnippet`, `LoadingBar`, `Progress`, `SwitchingBox`.

### Stimulus / JavaScript
- Stimulus controllers paired with components under
  `app/javascript/controllers/decor/{daisy,suite}/**`. Vident handles
  identifier derivation; consumers import via
  `app/javascript/controllers/decor/{daisy,suite}/index.js`.
- Named identifier constants exported from
  `app/javascript/decor/{daisy,suite,identifiers}.js` so consumer JS
  doesn't hardcode the `decor--<skin>--<path>` strings.
- Dropdown/popover-style components prefer native CSS anchor positioning
  + Popover API where supported, falling back to `@floating-ui/dom`
  for tooltips.

### Security
- `Decor::Concerns::ActsAsLink#safe_href` filters `data:` and
  `vbscript:` URL schemes (Phlex 2.4 already strips `javascript:` from
  REF attributes).
- `Suite::Modals::Modal` emits raw HTML for `initial_content` only when
  `html_safe?`; plain Strings are escaped.
- `Suite::Tables::BulkActionsBar` uses `form_with` so authenticity
  tokens and method tunneling are emitted automatically.
- `Daisy::Tables::DataTableFooter` slot dispatch uses
  `instance_eval(&block)` rather than passing the Proc as a positional
  argument.
- JS innerHTML writes on the AI chat widget and confirm-template
  controller route through the existing `safelySetInnerHTML` /
  `markAsSafeHTML` gate.

### Engine
- `isolate_namespace Decor` so helpers don't auto-include into hosts.
- `Decor::FlashHelper` registered via `config.to_prepare` to avoid an
  autoload-timing race.
- Zeitwerk ignores for `app/javascript/` and `app/assets/`.
- `app/assets/builds/` on the asset paths so hosts can
  `stylesheet_link_tag "decor"`.
- Lookbook initializer guards `app.config.lookbook` being nil.
