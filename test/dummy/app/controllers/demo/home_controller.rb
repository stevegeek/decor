class Demo::HomeController < ApplicationController
  layout "demo"

  # Single source of truth for the index links. Add an entry here when a new
  # demo/harness page lands.
  SECTIONS = [
    {
      title: "Dynamic-component demos (Cuprite-tested)",
      links: [
        {name: "Overlays & Notifications", path: "/demo/overlays",
         desc: "Toast placement, tooltip + dropdown popovers, flash"},
        {name: "Navigation", path: "/demo/navigation",
         desc: "Side navbar: mobile drawer, desktop collapse, search filter"},
        {name: "Rich inputs", path: "/demo/inputs",
         desc: "Switch, button radio group, searchable select, date field"},
        {name: "Media & misc", path: "/demo/media",
         desc: "Carousel (Swiper), click-to-copy, code block"}
      ]
    },
    {
      title: "Form harness",
      links: [
        {name: "Daisy Todos (Turbo Drive)", path: "/daisy/todos",
         desc: "Daisy form components under Turbo Drive + morphing"},
        {name: "Suite Todos (UJS)", path: "/suite/todos",
         desc: "Suite form under old-school UJS (Turbo opted out)"},
        {name: "Suite Todos (Turbo Drive)", path: "/suite/turbo/todos",
         desc: "Suite form + DataTable + bulk-action modal under Turbo"}
      ]
    }
  ].freeze

  def index
    @sections = SECTIONS
    @lookbook = Rails.env.local? || ENV["PROD_LOOKBOOK_ENABLED"] == "true"
  end
end
