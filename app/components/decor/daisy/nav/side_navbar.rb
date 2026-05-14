# frozen_string_literal: true

module Decor
  module Daisy
    module Nav
      # SideNavbar A responsive sidebar navigation with a mobile slide-over
      # overlay and a desktop fixed sidebar that can collapse. Hosts a search
      # input and a vertical stack of SideNavbarSection groups.
      class SideNavbar < ::Decor::Components::Nav::SideNavbar
        def view_template(&)
          vanish(&)
          build_from_menu_items(@menu_items) if @menu_items&.any?
          @sections_html = render_sections.html_safe
          root_element do |el|
            # Mobile menu overlay
            div(class: "decor:fixed decor:inset-0 decor:flex decor:z-40 decor:hidden", role: "dialog", aria_modal: "true", data: {**el.stimulus_target(:mobile_menu)}) do
              # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
              div(class: "decor:fixed decor:inset-0 decor:bg-gray-600 decor:bg-opacity-75 #{class_list_for_stimulus_classes(:mobile_menu_overlay_entering_from)}", aria_hidden: "true", data: {**el.stimulus_target(:mobile_menu_overlay)})

              # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
              div(class: "decor:relative decor:flex-1 decor:flex decor:flex-col decor:max-w-xs decor:w-full decor:pt-5 decor:pb-4 decor:bg-base-200 #{class_list_for_stimulus_classes(:mobile_menu_canvas_entering_from)}", data: {**el.stimulus_target(:mobile_menu_canvas)}) do
                # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
                div(class: "decor:absolute decor:top-0 decor:right-0 decor:-mr-12 decor:pt-2 #{class_list_for_stimulus_classes(:mobile_menu_close_button_entering_from)}", data: {**el.stimulus_target(:mobile_menu_close_button)}) do
                  button(
                    type: "button",
                    data: {**el.stimulus_action(:click, :toggle_mobile_menu)},
                    class: "decor:ml-1 decor:flex decor:items-center decor:justify-center decor:h-10 decor:w-10 decor:rounded-full decor:focus:outline-none decor:focus:ring-2 decor:focus:ring-inset decor:focus:ring-white"
                  ) do
                    span(class: "decor:sr-only") { "Close sidebar" }
                    render ::Decor::Daisy::Icon.new(name: "x", html_options: {class: "decor:h-6 decor:w-6 decor:text-white"})
                  end
                end

                div(class: "decor:flex-shrink-0 decor:flex decor:items-center decor:font-righteous decor:px-4") do
                  div(class: "decor:h-20 decor:flex-shrink-0 decor:flex decor:items-center decor:gap-3 decor:font-righteous decor:px-5 decor:relative") do
                    img(src: @landscape_logo_url, alt: "Logo", class: "decor:h-12 decor:object-contain")
                    span(class: "decor:text-lg decor:font-semibold decor:text-base-content") { @app_title } if @app_title.present?
                  end
                end

                div(class: "decor:mt-5 decor:flex-1 decor:h-0 decor:overflow-y-auto") do
                  div(class: "decor:w-full decor:px-5", id: "mobile-sidebar-search") do
                    label(for: "mobile-search", class: "decor:sr-only") { "Search" }
                    div(class: "decor:relative") do
                      div(class: "decor:pointer-events-none decor:absolute decor:inset-y-0 decor:left-0 decor:pl-3 decor:flex decor:items-center") do
                        render ::Decor::Daisy::Icon.new(name: "search", style: :solid, html_options: {class: "decor:h-5 decor:w-5 decor:text-base-content/70"})
                      end
                      input(
                        class: "decor:d-input decor:d-input-bordered decor:w-full decor:pl-10 decor:bg-base-100 decor:text-base-content decor:placeholder-base-content/70 decor:focus:border-primary",
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

                  nav(class: "decor:flex-1 decor:px-5") do
                    raw @sections_html
                  end
                end
              end

              div(class: "decor:flex-shrink-0 decor:w-14", aria_hidden: "true")
            end

            # Desktop sidebar
            div(
              data: {**el.stimulus_target(:desktop_menu)},
              id: "side-navbar-desktop",
              class: "decor:side-navbar-desktop decor:hidden decor:lg:fixed decor:lg:flex decor:lg:flex-col #{@collapsed ? "decor:lg:w-20" : "decor:lg:w-72"} decor:lg:inset-y-0 decor:transition-all decor:duration-300 decor:z-50"
            ) do
              div(class: "decor:flex-1 decor:flex decor:flex-col decor:min-h-0 decor:bg-base-300") do
                div(class: "decor:h-20 decor:flex-shrink-0 decor:flex decor:items-center decor:justify-between decor:font-righteous decor:px-5 decor:relative") do
                  div(class: "decor:flex decor:items-center decor:gap-3") do
                    render ::Decor::Daisy::Avatar.new(
                      size: :md,
                      initials: "C",
                      url: @avatar_logo_url,
                      classes: "decor:hidden",
                      stimulus_targets: [el.stimulus_target(:desktop_avatar_logo)]
                    )

                    child_element(:div, stimulus_target: :desktop_logo) do
                      img(src: @landscape_logo_url, alt: "Logo", class: "decor:h-12 decor:object-contain decor:max-w-[180px]")
                    end

                    span(class: "decor:text-lg decor:font-semibold decor:text-base-content") { @app_title } if @app_title.present?
                  end

                  button(
                    type: "button",
                    id: "side-navbar-desktop-collapse-button",
                    data: {**el.stimulus_action(:click, :toggle_collapse_desktop_menu)},
                    class: "decor:text-base-content/70 decor:hover:text-base-content"
                  ) do
                    render ::Decor::Daisy::Icon.new(
                      name: "menu-alt-2",
                      html_options: {class: "decor:h-6 decor:w-6 #{@collapsed ? "decor:hidden" : nil}"},
                      stimulus_targets: [el.stimulus_target(:desktop_collapse_icon)]
                    )
                    render ::Decor::Daisy::Icon.new(
                      name: "chevron-right",
                      html_options: {class: "decor:h-6 decor:w-6 #{@collapsed ? "" : "decor:hidden"}"},
                      stimulus_targets: [el.stimulus_target(:desktop_expand_icon)]
                    )
                  end
                end

                div(class: "decor:side-navbar-desktop-custom-scrollbar decor:flex-1 decor:flex decor:flex-col decor:overflow-y-auto decor:py-7") do
                  div(id: "side-navbar-desktop-search", class: "decor:w-full decor:pl-5 decor:pr-3") do
                    label(for: "side-navbar-desktop-search-input", class: "decor:sr-only") { "Search" }
                    div(class: "decor:relative decor:h-9") do
                      div(class: "decor:pointer-events-none decor:absolute decor:inset-y-0 decor:left-0 decor:pl-3 decor:flex decor:items-center") do
                        render ::Decor::Daisy::Icon.new(name: "search", style: :solid, html_options: {class: "decor:h-5 decor:w-5 decor:text-base-content/70"})
                      end
                      input(
                        class: "decor:d-input decor:d-input-bordered decor:w-full decor:pl-10 decor:bg-base-100 decor:text-base-content decor:placeholder-base-content/70 decor:focus:border-primary",
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

                  nav(class: "decor:flex-1 decor:pl-5 decor:pr-3") do
                    raw @sections_html
                  end
                end
              end
            end
          end
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
