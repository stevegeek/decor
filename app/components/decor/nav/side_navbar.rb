# frozen_string_literal: true

module Decor
  module Nav
    class SideNavbar < PhlexComponent
      prop :app_title, _Nilable(_String(_Predicate("present", &:present?)))
      prop :landscape_logo_url, _Nilable(String)
      prop :avatar_logo_url, _Nilable(String)
      prop :collapsed, _Boolean, default: false

      stimulus do
        actions -> { [stimulus_scoped_event_on_window(:toggle_mobile_menu), :toggle_mobile_menu] },
          [:touchstart, :handle_mouse_over],
          [:mouseenter, :handle_mouse_over],
          [:mouseleave, :handle_mouse_away]
        values_from_props :collapsed
        outlets navbar_section: ::Decor::Nav::SideNavbarSection.stimulus_identifier
      end

      def with_section(**attributes, &block)
        @sections ||= []
        section = SideNavbarSection.new(**attributes)
        @sections << [section, block]
        section
      end

      def sections
        @sections ||= []
      end

      def view_template(&)
        vanish(&)
        build_from_menu_items(@menu_items) if @menu_items&.any?
        @sections_html = render_sections
        root_element do |el|
          # Mobile menu overlay
          div(class: "fixed inset-0 flex z-40 hidden", role: "dialog", aria_modal: "true", data: {**el.stimulus_target(:mobile_menu)}) do
            div(class: "fixed inset-0 bg-gray-600 bg-opacity-75 #{class_list_for_stimulus_classes(:mobile_menu_overlay_entering_from)}", aria_hidden: "true", data: {**el.stimulus_target(:mobile_menu_overlay)})

            div(class: "relative flex-1 flex flex-col max-w-xs w-full pt-5 pb-4 bg-base-200 #{class_list_for_stimulus_classes(:mobile_menu_canvas_entering_from)}", data: {**el.stimulus_target(:mobile_menu_canvas)}) do
              div(class: "absolute top-0 right-0 -mr-12 pt-2 #{class_list_for_stimulus_classes(:mobile_menu_close_button_entering_from)}", data: {**el.stimulus_target(:mobile_menu_close_button)}) do
                button(
                  type: "button",
                  data: {**el.stimulus_action(:click, :toggle_mobile_menu)},
                  class: "ml-1 flex items-center justify-center h-10 w-10 rounded-full focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
                ) do
                  span(class: "sr-only") { "Close sidebar" }
                  render ::Decor::Icon.new(name: "x", html_options: {class: "h-6 w-6 text-white"})
                end
              end

              div(class: "flex-shrink-0 flex items-center font-righteous px-4") do
                div(class: "h-20 flex-shrink-0 flex items-center gap-3 font-righteous px-5 relative") do
                  img(src: @landscape_logo_url, alt: "Logo", class: "h-12 object-contain")
                  span(class: "text-lg font-semibold text-base-content") { @app_title } if @app_title.present?
                end
              end

              div(class: "mt-5 flex-1 h-0 overflow-y-auto") do
                div(class: "w-full px-5", id: "mobile-sidebar-search") do
                  label(for: "mobile-search", class: "sr-only") { "Search" }
                  div(class: "relative") do
                    div(class: "pointer-events-none absolute inset-y-0 left-0 pl-3 flex items-center") do
                      render ::Decor::Icon.new(name: "search", style: :solid, html_options: {class: "h-5 w-5 text-base-content/70"})
                    end
                    input(
                      class: "input input-bordered w-full pl-10 bg-base-100 text-base-content placeholder-base-content/70 focus:border-primary",
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

                nav(class: "flex-1 px-5") do
                  raw @sections_html
                end
              end
            end

            div(class: "flex-shrink-0 w-14", aria_hidden: "true")
          end

          # Desktop sidebar
          div(
            data: {**el.stimulus_target(:desktop_menu)},
            id: "side-navbar-desktop",
            class: "side-navbar-desktop hidden lg:fixed lg:flex lg:flex-col #{@collapsed ? "lg:w-20" : "lg:w-72"} lg:inset-y-0 transition-all duration-300 z-50"
          ) do
            div(class: "flex-1 flex flex-col min-h-0 bg-base-300") do
              div(class: "h-20 flex-shrink-0 flex items-center justify-between font-righteous px-5 relative") do
                div(class: "flex items-center gap-3") do
                  render ::Decor::Avatar.new(
                    size: :md,
                    initials: "C",
                    border: false,
                    url: @avatar_logo_url,
                    classes: "hidden",
                    stimulus_targets: [el.stimulus_target(:desktop_avatar_logo)]
                  )

                  el.tag(:div, stimulus_target: :desktop_logo) do
                    img(src: @landscape_logo_url, alt: "Logo", class: "h-12 object-contain max-w-[180px]")
                  end

                  span(class: "text-lg font-semibold text-base-content") { @app_title } if @app_title.present?
                end

                button(
                  type: "button",
                  id: "side-navbar-desktop-collapse-button",
                  data: {**el.stimulus_action(:click, :toggle_collapse_desktop_menu)},
                  class: "text-base-content/70 hover:text-base-content"
                ) do
                  render ::Decor::Icon.new(
                    name: "menu-alt-2",
                    html_options: {class: "h-6 w-6 #{@collapsed ? "hidden" : nil}"},
                    stimulus_targets: [el.stimulus_target(:desktop_collapse_icon)]
                  )
                  render ::Decor::Icon.new(
                    name: "chevron-right",
                    html_options: {class: "h-6 w-6 #{@collapsed ? "" : "hidden"}"},
                    stimulus_targets: [el.stimulus_target(:desktop_expand_icon)]
                  )
                end
              end

              div(class: "side-navbar-desktop-custom-scrollbar flex-1 flex flex-col overflow-y-auto py-7") do
                div(id: "side-navbar-desktop-search", class: "w-full pl-5 pr-3") do
                  label(for: "side-navbar-desktop-search-input", class: "sr-only") { "Search" }
                  div(class: "relative h-9") do
                    div(class: "pointer-events-none absolute inset-y-0 left-0 pl-3 flex items-center") do
                      render ::Decor::Icon.new(name: "search", style: :solid, html_options: {class: "h-5 w-5 text-base-content/70"})
                    end
                    input(
                      class: "input input-bordered w-full pl-10 bg-base-100 text-base-content placeholder-base-content/70 focus:border-primary",
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

                nav(class: "flex-1 pl-5 pr-3") do
                  raw @sections_html
                end
              end
            end
          end
        end
      end

      def id
        "decor--nav-sidebar"
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
