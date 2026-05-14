# Codemod Review Items

Markers placed by the prefix codemod for sites needing follow-up. Most are tagged for step-2 per-component migration in the gemification plan, not for immediate fix. The items below are interpolated-variable or method-call class expressions where the codemod could not statically verify that the yielded value is already prefixed.

**Count at post-pass:** 77 markers (down from 81 original; 4 resolved in Step 4 ternary fixes).

**Category key:**
- `var-ref` — interpolated `#{var_or_method}` reference; verify the var/method already returns `decor:`-prefixed classes
- `latent-bug` — code path with a structural issue (e.g. Proc instance_eval) deferred to step-2
- `custom-class` — a custom non-utility class correctly left without `d-` prefix

---

## `app/components/decor/daisy/avatar.rb`
- Line 8: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 79: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/badge.rb`
- Line 31: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/box_template.rb`
- Line 76: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/card.rb`
- Line 46: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 64: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 118: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/card_header.rb`
- Line 75: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 91: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/dropdown.rb`
- Line 21: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 37: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 52: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/map.rb`
- Line 8: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/notification.rb`
- Line 15: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 28: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/page.rb`
- Line 90: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/page_header.rb`
- Line 89: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 233: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 254: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/pagination.rb`
- Line 11: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 13: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 64: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 68: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 78: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 98: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 102: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/panel.rb`
- Line 45: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 48: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 51: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/panel_group.rb`
- Line 52: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 55: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/search_and_filter.rb`
- Line 46: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 137: `custom-class` — `filters-slot` is a custom/non-utility class — leave unprefixed

## `app/components/decor/daisy/tabs.rb`
- Line 116: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/tag.rb`
- Line 87: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/title.rb`
- Line 75: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 78: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 81: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 84: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 87: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 97: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 100: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 103: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 106: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 109: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/chat/list_message.rb`
- Line 32: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 70: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 81: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 84: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/forms/file_upload.rb`
- Line 137: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 140: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 148: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/forms/form_field_layout.rb`
- Line 14: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 31: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 36: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/forms/switch.rb`
- Line 29: `var-ref` — interpolated class expression — verify `cursor_classes` method returns already-prefixed classes

## `app/components/decor/daisy/modals/confirm_modal.rb`
- Line 14: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 27: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 33: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 38: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 119: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 122: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/modals/modal_close_button.rb`
- Line 18: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 28: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/modals/modal_layout.rb`
- Line 24: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 26: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/nav/side_navbar.rb`
- Line 17: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 20: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 22: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/nav/side_navbar_item.rb`
- Line 37: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/daisy/tables/data_table_cell.rb`
- Line 61: `custom-class` — `cell-row-link-overlay` is a custom/non-utility class — leave unprefixed

## `app/components/decor/daisy/tables/data_table_footer.rb`
- Line 11: `latent-bug` — Proc `instance_eval` would raise; defer to per-component step-2 migration
- Line 24: `latent-bug` — Proc `instance_eval` would raise; defer to per-component step-2 migration
- Line 32: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 34: `var-ref` — interpolated class expression — verify var is already prefixed
- Line 36: `var-ref` — interpolated class expression — verify var is already prefixed

## `app/components/decor/components/forms/number_field.rb`
- Line 33: `var-ref` — `#{super}` call — verify parent class returns already-prefixed classes
