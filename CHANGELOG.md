# Changelog

## Unreleased

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
