# Decor Prefix Codemod — Frozen Brief

Source spec: docs/superpowers/specs/2026-05-06-decor-gemification-design.md Section 6.

## Directory structure (verified at brief-writing time)

Two parallel class trees exist — both must be transformed:

- `app/components/decor/daisy/` — concrete daisyUI skin components (have `view_template` + `_classes` methods with actual class literals)
- `app/components/decor/components/` — abstract base classes (fewer class literals, but some exist — e.g. `switching_box.rb`, `forms/button_radio_group.rb`)
- `app/components/decor/concerns/` — shared mixins with `_classes` methods returning class strings
- `app/components/decor/forms/` — ActionView form builder wrappers (no `class:` literals, skip)

Navigation components live under `app/components/decor/daisy/nav/` (not flat in `daisy/`).
Chat components live under `app/components/decor/daisy/chat/`.
JS controllers are `.js` (transpiled from source) — no `.ts` source files exist at execution time.

## Allowlist source

The daisyUI v5 class allowlist lives at `docs/codemod-daisyui-allowlist.txt`. One base class name per line; treat as a Set. The list was derived from `node_modules/daisyui/components/*.css` at build time (54 entries).

## Rules (frozen — every agent applies identical rules)

1. **Scope of change**: rewrite string literals in three positions only:
   - `class: "..."` keyword arg
   - `classes: "..."` keyword arg
   - return value of any method whose name ends in `_classes` or `_class` and returns a string literal of utility tokens

2. **Token rule**: split on whitespace. For each token, classify and rewrite:
   - **Already prefixed** (starts with `decor:`): leave alone.
   - **daisyUI class** (token matches `^[a-zA-Z0-9-]+$` AND the base name — everything up to the first `-` or the entire token if no `-` — is in the daisyUI allowlist): prepend `decor:` + `d-` to position 0. Example: `btn` → `decor:d-btn`. With Tailwind variants: `hover:btn-primary` → `decor:hover:d-btn-primary`. The `d-` goes immediately before the class portion, not before the variant prefix.
   - **Tailwind utility** (everything else that looks like a class token): prepend `decor:` to position 0. Example: `hover:p-4` → `decor:hover:p-4`.

3. **What is NOT a class string** (leave untouched):
   - `data-*:` keyword args
   - `stimulus_controller:`, `stimulus_action:`, `stimulus_target:`, `stimulus_value:`
   - Phlex HTML method names (`div`, `span`, `p`, `a`, `h1`–`h6`, etc.)
   - `id:`, `name:`, `type:`, `aria_*:`, `role:`
   - URL strings (`href:`, `src:`, `action:`)
   - SVG path data (`d:`)
   - Event name strings
   - Ruby symbol values (`:filled`, `:md`, etc.)

4. **Interpolation**: `"#{var} p-4 m-2"` → `"#{var} decor:p-4 decor:m-2"`. If `var` is likely a class-list (variable/method name ends in `_class` or `_classes`), inject `# CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed` one line above the call site. Do NOT transform `var`.

5. **Conditional builders**: ternaries, `case` statements, `if`/`else` expressions — transform all string literal branches.

6. **Arrays passed to `class:`**: transform each string element. Skip non-string elements.

7. **`token_list` / `class_names` helpers**: apply same array transform to each string argument.

8. **JS controllers** (`.js` files under `app/javascript/controllers/decor/`): find string literals in `classList.add/remove/toggle/replace`, `setAttribute("class", "...")`, and any constant assigned to a `*Class*`-named variable. Apply token rule.

9. **Commit shape**: one commit per slice, subject `decor: prefix codemod (slice N — <area>)`. No reformatting, no unrelated changes, no test additions.

10. **`# CODEMOD-REVIEW` markers**: format `# CODEMOD-REVIEW: <one-line reason>`. Collated post-run into a single Markdown file.

## Slice assignments (10 slices)

Use `git ls-files` and `find` to discover the actual file lists at execution time — the table below is authoritative for intent, adapt paths to actual structure.

All `daisy/` paths are relative to `app/components/decor/daisy/`.
All `components/` paths are relative to `app/components/decor/components/`.

| Slice | Area | Source files (glob patterns) |
|---|---|---|
| 1 | Tier 1 primitives | `daisy/{avatar,badge,click_to_copy,code_block,code_snippet,formatted_encoded_id,icon,link,progress,spinner,svg,tag,title,toggle,tooltip}.rb` + matching files in `components/` |
| 2 | Tier 2 building blocks | `daisy/{banner,box,box_template,button,button_classes,button_link,button_template,card,element,flash,flow_step,notification}.rb` + matching files in `components/` |
| 3 | Tier 3 layout | `daisy/{card_header,empty_state,page,page_header,page_section,panel,panel_group,stat,stats,switching_box,tabs}.rb` + matching files in `components/` |
| 4 | Tier 4 navigation | `daisy/nav/{breadcrumbs,compact_footer,footer,secondary_navbar,side_navbar,side_navbar_item,side_navbar_section,side_navbar_sub_item,top_navbar}.rb` + matching files in `components/nav/` |
| 5 | Tier 5 stimulus-heavy | `daisy/{carousel,chat/list,chat/list_message,dropdown,dropdown_item,map,notification_manager}.rb` + `daisy/modals/**/*.rb` + matching files in `components/` |
| 6 | Tier 6 tables + pagination | `daisy/tables/**/*.rb` + `daisy/pagination.rb` + `daisy/search_and_filter.rb` + `components/pagination/**/*.rb` + matching files in `components/tables/` |
| 7a | Tier 7a forms (non-stimulus) | `daisy/forms/{button_radio_group,checkbox,error_icon_section,expanding_checkbox_collection,helper_text_section,hidden_field,layout_container,layout_section,number_field,radio,select,switch,text_area,text_field,text_field_template}.rb` + matching files in `components/forms/` |
| 7b | Tier 7b forms (stimulus-heavy) | `daisy/forms/{date_calendar,file_upload,form,form_child,form_field,form_field_layout}.rb` + matching files in `components/forms/` |
| 9 | JS controllers + concerns | `app/javascript/controllers/decor/**/*.js` + `app/components/decor/concerns/**/*.rb` |
| 10 | Lookbook previews | `test/components/previews/**/*.rb` |

## Verification

After all 10 commits land:

1. `bin/build-css` succeeds and `app/assets/builds/decor.css` size INCREASES (more utilities emit because every template names them with `decor:` prefix).
2. `bin/build-js` succeeds.
3. `cd test/dummy && bin/rails s -p 3001`; `curl http://localhost:3001/lookbook` returns 200.
4. The post-pass verifier (grep for un-prefixed daisyUI and Tailwind tokens in class: positions) reports zero un-prefixed tokens.
5. `# CODEMOD-REVIEW` markers are collated and documented in `docs/codemod-review-items.md`.
