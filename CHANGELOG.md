# Changelog

## 0.2.0 — Unreleased

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
