# Decor: UI Components for Ruby on Rails

A comprehensive Ruby on Rails UI component library built for flexibility, maintainability, and developer experience.

## ✨ Features

- **Modern Component Architecture**: Built with [Phlex](https://phlex.fun) and [Vident](https://github.com/stevegeek/vident) for server-side rendering with attribute type safety
- **Beautiful Default Styling**: Powered by [daisyUI](https://daisyui.com) and [Tailwind CSS v4](https://tailwindcss.com), which cah easily be [customized at the component render site](https://github.com/stevegeek/vident/blob/main/README.md?plain=1#L614).
- **Interactive Frontend**: Enhanced with [Stimulus](https://stimulus.hotwired.dev) controllers and [Turbo](https://turbo.hotwired.dev)
- **Developer Experience**: Complete [Lookbook](https://lookbook.build) preview system for component development
- (well... not yet...) **Production Ready**: Comprehensive test coverage and battle-tested in production applications
- **MIT Licensed**: Free for commercial and personal use

### A note on the state of the project

This project is extracted from a production application and has been in use for years (starting out on a [custom view component system](https://github.com/stevegeek/vc) with my own [typed attributes](https://github.com/stevegeek/typed_support), moving to [ViewComponent](https://viewcomponent.org), and now finally to [Phlex](https://phlex.fun))

**However**, the original was using ViewComponent and styled differently. This open source version is moving to Phlex, daisyUI and Tailwind CSS v4, which means the components are being rewritten 
and in some cases the APIs are changing. Therefore, for the time being, assume that this is a work in progress and not all components
are ready for production. 

Once I port my production application to this version and battle test it, I will update the README to reflect that!

## Main TODOs

- [ ] Add all components
- [x] Add more tests / previews
- [ ] Update vident, review vident API
- [x] Stop using slots
- [ ] Change `dry-struct` to `Literal` (via vident-typed)
- [ ] simplify naming of sizes (e.g. `micro` to `xs`, `small` to `sm`, etc.) and unify across components
- [ ] Unify variant naming
- [ ] Unify style attribute naming (sometimes we use `style`, sometimes `theme`)
- [ ] Dark mode support

# Using Decor / Installation

You can use Decor in two ways:

## 1. Fork this repository to start a new Rails application

Fork this repository to create a new simple Rails application with Decor preconfigured.

Build your application on top of it. If you want to be able to update Decor in the future (recommended), simply
avoid modifying the provided components, and simply pull changes from this repository as they are made.

## 2. Copy into an existing Rails application

Add to Gemfile:

```ruby
gem "dry-struct" # TODO: change to Literal
gem "phlex-rails"
gem "vident"
gem "vident-typed" # TODO: change to Literal
gem "vident-phlex" 
gem "vident-typed-phlex" # TODO: change to Literal
gem "vident-tailwind"

# In development and test environments
gem "lookbook"
```

```bash
bundle install
```

Copy `app/components`, `app/javascript/controllers` and `test/components` directories from this repository to your Rails application.

Copy over `app/assets/tailwind/application.css` or at least merge the contents into your existing Tailwind CSS setup.

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

# Acknowledgements
 
- Thanks to https://github.com/willpinha/daisy-components for the inspiration for certain components
