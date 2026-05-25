# Decor

Phlex + Vident + daisyUI 5 component library for Rails. Distributed as a Ruby gem and Rails engine.

## Installation

1. Add to your Gemfile:

   ```ruby
   gem "decor", github: "stevegeek/decor"
   # Or, for local dev:
   gem "decor", path: "../decor"
   ```

2. In your layout: `<%= stylesheet_link_tag "decor", "data-turbo-track": "reload" %>`
3. In your Stimulus entry:

```javascript
import { Application } from "@hotwired/stimulus";
import { register as registerDecor } from "decor";

const application = Application.start();
registerDecor(application);
```

4. Use components — Decor ships two skins:

```erb
<%# Daisy skin — daisyUI semantic styling %>
<%= render ::Decor::Daisy::Button.new(label: "Click me", color: :primary) %>

<%# Suite skin — alternative visual idiom with bespoke design tokens %>
<%= render ::Decor::Suite::Avatar.new(initials: "JG", color: :alt2) %>
```

Each component shares an abstract base (`Decor::Components::<Name>`) with a unified prop API; the two skins (`Decor::Daisy::*`, `Decor::Suite::*`) own their visual language. See `CHANGELOG.md` for the full component family list.

## Security

URL props on link-rendering components (`href`, `src`, `action`, …) strip `javascript:`, `data:`, and `vbscript:` schemes. Modal `initial_content` is rendered raw only when `html_safe?`; plain Strings are escaped. Bulk-action forms inject CSRF tokens automatically.

## Development

Local dev runs the Lookbook demo from `test/dummy/`:

```bash
bin/dev
```

This boots:
- `bin/watch-css` — Tailwind v4 build (utility prefix `decor:`, daisyUI prefix `d-`) → `app/assets/builds/decor.css`
- `bin/watch-js` — esbuild bundle → `app/assets/builds/decor.js`
- Rails server in `test/dummy/` on port 3000 (Lookbook at `/lookbook`)

Peer-dep externals (host provides): `@hotwired/stimulus`, `@hotwired/turbo`, `@floating-ui/dom`, `swiper`, `cally`, `tailwind-merge`.

## Component prefix

All Decor components emit prefixed Tailwind classes. Utility classes are prefixed `decor:` (e.g. `decor:p-4`); daisyUI component classes are prefixed `decor:d-` (e.g. `decor:d-btn`). Host's own Tailwind utilities never collide with Decor's classes.

When consuming a component, you can pass unprefixed Tailwind utilities to override component defaults — `Decor::ClassMerger` handles the prefix-aware merge correctly.

## Acknowledgements

- Thanks to [daisyUI](https://daisyui.com) for the beautiful default styling and component design
- Thanks to [Phlex](https://phlex.fun) for the view components system
- Thanks to [literal](https://literal.fun) for the typed attributes system
- Thanks to https://github.com/willpinha/daisy-components for the inspiration for certain components
- Thanks to [Lookbook](https://lookbook.build) for the component preview system
- Thanks to [Confinus](https://confinus.com) for sponsoring the development of this library and open sourcing it.
