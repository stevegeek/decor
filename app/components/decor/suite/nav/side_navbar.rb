# frozen_string_literal: true

module Decor
  module Suite
    module Nav
      class SideNavbar < ::Decor::Components::Nav::SideNavbar
        def view_template(&)
          vanish(&)
          build_from_menu_items(@menu_items) if @menu_items&.any?
          @sections_html = render_sections.html_safe
          root_element do |el|
            # Mobile menu overlay
            div(class: "decor:fixed decor:inset-0 decor:flex decor:z-40 decor:hidden", role: "dialog", aria_modal: "true", data: {**el.stimulus_target(:mobile_menu)}) do
              div(class: "decor:fixed decor:inset-0 decor:bg-gray-900/50 #{class_list_for_stimulus_classes(:mobile_menu_overlay_entering_from)}", aria_hidden: "true", data: {**el.stimulus_target(:mobile_menu_overlay)})

              div(class: "decor:relative decor:flex-1 decor:flex decor:flex-col decor:max-w-xs decor:w-full decor:bg-white decor:border-r decor:border-suite-hairline #{class_list_for_stimulus_classes(:mobile_menu_canvas_entering_from)}", data: {**el.stimulus_target(:mobile_menu_canvas)}) do
                div(class: "decor:absolute decor:top-0 decor:right-0 decor:-mr-12 decor:pt-2 #{class_list_for_stimulus_classes(:mobile_menu_close_button_entering_from)}", data: {**el.stimulus_target(:mobile_menu_close_button)}) do
                  button(
                    type: "button",
                    data: {**el.stimulus_action(:click, :toggle_mobile_menu)},
                    class: "decor:ml-1 decor:flex decor:items-center decor:justify-center decor:h-10 decor:w-10 decor:rounded-full decor:focus:outline-none decor:focus:ring-2 decor:focus:ring-inset decor:focus:ring-white"
                  ) do
                    span(class: "decor:sr-only") { "Close sidebar" }
                    render ::Decor::Icon.new(name: "x", html_options: {class: "decor:h-6 decor:w-6 decor:text-white"})
                  end
                end

                div(class: "decor:flex decor:items-center decor:gap-3 decor:px-4 decor:py-4 decor:border-b decor:border-suite-hairline decor:shrink-0") do
                  img(src: @landscape_logo_url, alt: "Logo", class: "decor:h-8 decor:object-contain decor:max-w-[180px]")
                  span(class: "decor:suite-field-label decor:text-gray-900") { @app_title } if @app_title.present?
                end

                div(class: "decor:flex-1 decor:h-0 decor:overflow-y-auto") do
                  div(class: "decor:w-full decor:px-4 decor:pt-3 decor:pb-1", id: "mobile-sidebar-search") do
                    label(for: "mobile-search", class: "decor:sr-only") { "Search" }
                    div(class: "decor:relative") do
                      div(class: "decor:pointer-events-none decor:absolute decor:inset-y-0 decor:left-0 decor:pl-3 decor:flex decor:items-center") do
                        render ::Decor::Icon.new(name: "search", style: :solid, html_options: {class: "decor:h-4 decor:w-4 decor:text-gray-400"})
                      end
                      input(
                        class: "decor:w-full decor:bg-suite-gray-25 decor:border decor:border-suite-hairline decor:rounded-suite-control decor:py-2 decor:pl-10 decor:pr-3 decor:suite-description decor:text-gray-900 decor:placeholder-gray-400 decor:focus:outline-none decor:focus:border-suite-primary-500 decor:duration-suite-fast decor:ease-out",
                        id: "mobile-search",
                        autocomplete: "on",
                        data: {
                          **el.stimulus_target(:mobile_search_navigation),
                          **el.stimulus_action(:keyup, :search)
                        },
                        placeholder: "I want to...",
                        type: "text",
                        name: "search"
                      )
                    end
                  end

                  nav(class: "decor:flex-1 decor:px-2 decor:py-1") do
                    raw @sections_html
                  end
                end
              end

              div(class: "decor:shrink-0 decor:w-14", aria_hidden: "true")
            end

            # Desktop sidebar
            div(
              data: {**el.stimulus_target(:desktop_menu)},
              id: "side-navbar-desktop",
              class: "decor:side-navbar-desktop decor:hidden decor:lg:fixed decor:lg:flex decor:lg:flex-col #{@collapsed ? "decor:lg:w-20" : "decor:lg:w-72"} decor:lg:inset-y-0 decor:transition-all decor:duration-300 decor:ease-out decor:z-50"
            ) do
              div(class: "decor:flex-1 decor:flex decor:flex-col decor:min-h-0 decor:bg-white decor:border-r decor:border-suite-hairline") do
                div(class: "decor:flex decor:items-center decor:gap-3 decor:px-4 decor:py-3 decor:border-b decor:border-suite-hairline decor:shrink-0 decor:relative decor:min-h-[60px]") do
                  render ::Decor::Suite::Avatar.new(
                    size: :sm,
                    initials: "C",
                    border: false,
                    url: @avatar_logo_url,
                    classes: "decor:hidden",
                    stimulus_targets: [el.stimulus_target(:desktop_avatar_logo)]
                  )

                  child_element(:div, stimulus_target: :desktop_logo, class: "decor:flex decor:items-center decor:min-w-0 decor:flex-1") do
                    img(src: @landscape_logo_url, alt: "Logo", class: "decor:h-8 decor:object-contain decor:max-w-[180px]")
                  end

                  span(class: "decor:suite-field-label decor:text-gray-900") { @app_title } if @app_title.present?

                  button(
                    type: "button",
                    id: "side-navbar-desktop-collapse-button",
                    data: {**el.stimulus_action(:click, :toggle_collapse_desktop_menu)},
                    class: "decor:ml-auto decor:inline-flex decor:items-center decor:justify-center decor:w-7 decor:h-7 decor:rounded-suite-control decor:text-gray-500 decor:hover:text-gray-900 decor:hover:bg-gray-100 decor:duration-suite-fast decor:ease-out decor:shrink-0"
                  ) do
                    render ::Decor::Icon.new(
                      name: "menu-2",
                      html_options: {class: "decor:h-5 decor:w-5 #{"decor:hidden" if @collapsed}"},
                      stimulus_targets: [el.stimulus_target(:desktop_collapse_icon)]
                    )
                    render ::Decor::Icon.new(
                      name: "chevron-right",
                      html_options: {class: "decor:h-5 decor:w-5 #{"decor:hidden" unless @collapsed}"},
                      stimulus_targets: [el.stimulus_target(:desktop_expand_icon)]
                    )
                  end
                end

                div(class: "decor:side-navbar-desktop-custom-scrollbar decor:flex-1 decor:flex decor:flex-col decor:overflow-y-auto") do
                  div(id: "side-navbar-desktop-search", class: "decor:w-full decor:px-3 decor:pt-3 decor:pb-1") do
                    label(for: "side-navbar-desktop-search-input", class: "decor:sr-only") { "Search" }
                    div(class: "decor:relative") do
                      div(class: "decor:pointer-events-none decor:absolute decor:inset-y-0 decor:left-0 decor:pl-3 decor:flex decor:items-center") do
                        render ::Decor::Icon.new(name: "search", style: :solid, html_options: {class: "decor:h-4 decor:w-4 decor:text-gray-400"})
                      end
                      input(
                        class: "decor:w-full decor:bg-suite-gray-25 decor:border decor:border-suite-hairline decor:rounded-suite-control decor:py-2 decor:pl-10 decor:pr-3 decor:suite-description decor:text-gray-900 decor:placeholder-gray-400 decor:focus:outline-none decor:focus:border-suite-primary-500 decor:duration-suite-fast decor:ease-out",
                        id: "side-navbar-desktop-search-input",
                        autocomplete: "on",
                        data: {
                          **el.stimulus_target(:search_navigation),
                          **el.stimulus_action(:keyup, :search)
                        },
                        placeholder: "I want to...",
                        type: "text",
                        name: "search"
                      )
                    end
                  end

                  nav(class: "decor:flex-1 decor:px-2 decor:py-1") do
                    raw @sections_html
                  end
                end
              end
            end
          end
        end

        # Override the slot factory so the Suite navbar nests Suite sections
        # (the abstract base hard-codes the Daisy section class).
        def with_section(**attributes, &block)
          @sections ||= []
          section = ::Decor::Suite::Nav::SideNavbarSection.new(**attributes)
          @sections << [section, block]
          section
        end

        private

        def render_sections
          capture do
            sections.each do |section, block|
              render(section, &block)
            end
          end
        end
      end
    end
  end
end
