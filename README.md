# README

Assuming a Rails application using Tailwind CSS (v4)


## Main TODOs

- Update vident
- Stop using slots
- Change `dry-struct` to `Literal` (via vident-typed)


## The dependencies

in Gemfile:

```ruby
gem "dry-struct" # TODO: change to Literal
gem "phlex-rails"
gem "phlex-slotable"
gem "vident"
gem "vident-typed" # TODO: change to Literal
gem "vident-phlex" 
gem "vident-typed-phlex" # TODO: change to Literal
gem "vident-tailwind"

# In development and test environments
gem "lookbook"
```

### Installation

```bash
bundle install
```

Copy `app/components`, `app/javascript/controllers` and `test/components` directories from this repository to your Rails application.

Copy over `app/assets/tailwind/application.css`

### External SVG Loader Setup

For external SVG loading functionality, add the following:

1. **Add to `config/importmap.rb`:**
```ruby
# External SVG loader for dynamic SVG loading
pin "external-svg-loader", to: "https://ga.jspm.io/npm:external-svg-loader@1.7.1/dist/svg-loader.min.js"
```

2. **Add to `app/javascript/application.js`:**
```javascript
import "external-svg-loader"
```

and add the following to `test/test_helper.rb`:

```ruby
    # Phlex component testing helper
    def render_component(component)
      controller = ApplicationController.new
      controller.request = ActionDispatch::TestRequest.create
      component.call(view_context: controller.view_context)
    end

    # Parse rendered HTML for testing
    def render_fragment(component)
      html = render_component(component)
      Nokogiri::HTML5.fragment(html)
    end

    def render_document(component)
      html = render_component(component)
      Nokogiri::HTML5(html)
    end
```


and to your `config/routes.rb`:

```ruby
  if Rails.env.local?
    mount Lookbook::Engine, at: "/lookbook"
  end
```