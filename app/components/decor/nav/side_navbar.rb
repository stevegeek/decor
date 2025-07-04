# frozen_string_literal: true

module Decor
  module Nav
    class SideNavbar < PhlexComponent
      attribute :landscape_logo_url, String, allow_blank: false
      attribute :avatar_logo_url, String, allow_blank: false
      attribute :menu_items, Array, default: []
      attribute :collapsed, :boolean, default: false

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
        render parent_element do |el|
          # Mobile menu overlay
          div(class: "fixed inset-0 flex z-40 hidden", role: "dialog", aria_modal: "true", data: {**target_data_attributes(el, :mobile_menu)}) do
            div(class: "fixed inset-0 bg-gray-600 bg-opacity-75 #{el.named_classes(:mobile_menu_overlay_entering_from)}", aria_hidden: "true", data: {**target_data_attributes(el, :mobile_menu_overlay)})

            div(class: "relative flex-1 flex flex-col max-w-xs w-full pt-5 pb-4 bg-base-300 #{el.named_classes(:mobile_menu_canvas_entering_from)}", data: {**target_data_attributes(el, :mobile_menu_canvas)}) do
              div(class: "absolute top-0 right-0 -mr-12 pt-2 #{el.named_classes(:mobile_menu_close_button_entering_from)}", data: {**target_data_attributes(el, :mobile_menu_close_button)}) do
                button(
                  type: "button",
                  data: {**action_data_attributes(el, [:click, :toggle_mobile_menu])},
                  class: "ml-1 flex items-center justify-center h-10 w-10 rounded-full focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
                ) do
                  span(class: "sr-only") { "Close sidebar" }
                  render ::Decor::Icon.new(name: "x", html_options: {class: "h-6 w-6 text-white"})
                end
              end

              div(class: "flex-shrink-0 flex items-center font-righteous px-4") do
                div(class: "h-20 flex-shrink-0 flex items-center font-righteous px-5 relative") do
                  img(src: @landscape_logo_url, alt: "Logo", class: "h-16 pt-3")
                end
              end

              div(class: "mt-5 flex-1 h-0 overflow-y-auto") do
                div(class: "w-full px-5", id: "mobile-sidebar-search") do
                  label(for: "mobile-search", class: "sr-only") { "Search" }
                  div(class: "relative") do
                    div(class: "pointer-events-none absolute inset-y-0 left-0 pl-3 flex items-center") do
                      render ::Decor::Icon.new(name: "search", variant: :solid, html_options: {class: "h-5 w-5 text-base-content/70"})
                    end
                    input(
                      class: "input input-bordered w-full pl-10 bg-base-100 text-base-content placeholder-base-content/70 focus:border-primary",
                      id: "mobile-search",
                      autocomplete: "on",
                      data: {
                        **target_data_attributes(el, :mobile_search_navigation),
                        **action_data_attributes(el, [:keyup, :search])
                      },
                      placeholder: "I want to...",
                      type: "text",
                      name: "search"
                    )
                  end
                end

                nav(class: "flex-1 px-5") do
                  render_mobile_sections
                end
              end
            end

            div(class: "flex-shrink-0 w-14", aria_hidden: "true")
          end

          # Desktop sidebar
          div(
            data: {**target_data_attributes(el, :desktop_menu)},
            id: "side-navbar-desktop",
            class: "side-navbar-desktop hidden lg:fixed lg:flex lg:flex-col #{@collapsed ? "lg:w-20" : "lg:w-72"} lg:inset-y-0 transition-all duration-300 z-50"
          ) do
            div(class: "flex-1 flex flex-col min-h-0 bg-base-300") do
              div(class: "h-20 flex-shrink-0 flex items-center font-righteous px-5 relative") do
                render ::Decor::Avatar.new(
                  targets: [el.target(:desktop_avatar_logo)],
                  size: :md,
                  initials: "C",
                  border: false,
                  url: @avatar_logo_url,
                  html_options: {class: "hidden"}
                )

                el.target_tag(:div, :desktop_logo) do
                  img(src: @landscape_logo_url, alt: "Logo", class: "h-16 pt-3 object-contain max-w-[220px]")
                end

                button(
                  type: "button",
                  id: "side-navbar-desktop-collapse-button",
                  data: {**action_data_attributes(el, [:click, :toggle_collapse_desktop_menu])},
                  class: "absolute right-5 top-6 text-white"
                ) do
                  render ::Decor::Icon.new(
                    name: "menu-alt-2",
                    html_options: {class: "h-6 w-6 #{@collapsed ? "hidden" : nil}"},
                    targets: [el.target(:desktop_collapse_icon)]
                  )
                  render ::Decor::Icon.new(
                    name: "chevron-right",
                    html_options: {class: "h-6 w-6 #{@collapsed ? "" : "hidden"}"},
                    targets: [el.target(:desktop_expand_icon)]
                  )
                end
              end

              div(class: "side-navbar-desktop-custom-scrollbar flex-1 flex flex-col overflow-y-auto py-7") do
                div(id: "side-navbar-desktop-search", class: "w-full pl-5 pr-3") do
                  label(for: "side-navbar-desktop-search-input", class: "sr-only") { "Search" }
                  div(class: "relative h-9") do
                    div(class: "pointer-events-none absolute inset-y-0 left-0 pl-3 flex items-center") do
                      render ::Decor::Icon.new(name: "search", variant: :solid, html_options: {class: "h-5 w-5 text-base-content/70"})
                    end
                    input(
                      class: "input input-bordered w-full pl-10 bg-base-100 text-base-content placeholder-base-content/70 focus:border-primary",
                      id: "side-navbar-desktop-search-input",
                      autocomplete: "on",
                      data: {
                        **target_data_attributes(el, :search_navigation),
                        **action_data_attributes(el, [:keyup, :search])
                      },
                      placeholder: "I want to...",
                      type: "text",
                      name: "search"
                    )
                  end
                end

                nav(class: "flex-1 pl-5 pr-3") do
                  render_desktop_sections
                end
              end
            end
          end
        end
      end

      def id
        "decor--nav-sidebar"
      end

      def root_element_attributes
        {
          actions: [
            [:"#{component_class_name}:toggle-mobile-overlay@window", :toggle_mobile_menu],
            [:touchstart, :handle_mouse_over],
            [:mouseenter, :handle_mouse_over],
            [:mouseleave, :handle_mouse_away]
          ],
          values: [
            {
              collapsed: @collapsed
            }
          ],
          outlets: [::Decor::Nav::SideNavbarSection.stimulus_identifier]
        }
      end

      private

      def render_mobile_sections
        build_sections_from_menu_items(@menu_items)
      end

      def render_desktop_sections
        build_sections_from_menu_items(@menu_items)
      end

      def build_sections_from_menu_items(menu_items)
        return unless menu_items&.any?

        menu_items.each do |nav_section|
          section_attrs = nav_section.dup
          section_attrs.delete(:items)
          section_component = SideNavbarSection.new(**section_attrs)

          nav_section[:items]&.each do |item|
            item_attrs = item.dup
            item_attrs.delete(:sub_items)
            section_component.with_item(**item_attrs) do |item_component|
              item[:sub_items]&.each do |sub_item|
                item_component.with_sub_item(**sub_item)
              end
            end
          end

          render section_component
        end
      end

      def build_from_menu_items(menu_items)
        menu_items.each do |nav_section|
          section_attrs = nav_section.dup
          section_attrs.delete(:items)
          with_section(**section_attrs) do |section_component|
            nav_section[:items]&.each do |item|
              item_attrs = item.dup
              item_attrs.delete(:sub_items)
              section_component.with_item(**item_attrs) do |item_component|
                item[:sub_items]&.each do |sub_item|
                  item_component.with_sub_item(**sub_item)
                end
              end
            end
          end
        end
        self
      end
    end
  end
end
