# Lookbook::Preview#render returns a Hash describing the scenario for
# Lookbook's own templating layer to render. Inside the *block* passed
# to that outer render (evaluated later, when the component renders),
# `render(Other.new)` would still resolve to Lookbook's Hash-returning
# method and bork the block's return value. Use `render_phlex` for any
# inline component render inside a content block.
module LookbookPhlexInlineRender
  def render_phlex(component, &block)
    component.call(&block).html_safe
  end
end

Rails.application.config.to_prepare do
  Lookbook::Preview.include(LookbookPhlexInlineRender) if defined?(Lookbook::Preview)
end
