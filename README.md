# README

Assuming a Rails application using Tailwind CSS (v4)

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