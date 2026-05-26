# frozen_string_literal: true

module Decor
  module Suite
    module Nav
      class TopNavbar < ::Decor::Components::Nav::TopNavbar
        def view_template(&)
          vanish(&)
          root_element do |el|
            # Mobile hamburger (only when nav items are present)
            if @nav_items_block
              button(
                type: "button",
                class: "decor:inline-flex decor:items-center decor:justify-center decor:w-8 decor:h-8 decor:rounded-suite-control decor:text-gray-500 decor:border-r decor:border-suite-hairline decor:transition-colors decor:duration-suite-fast decor:ease-out decor:hover:text-gray-900 decor:hover:bg-suite-gray-25 decor:focus:outline-none decor:lg:hidden decor:shrink-0",
                data: {
                  action: "click->#{stimulus_identifier}#toggle_mobile_menu"
                }
              ) do
                span(class: "decor:sr-only") { "Open sidebar" }
                render ::Decor::Icon.new(name: "menu-2", classes: "decor:h-5 decor:w-5")
              end
            end

            # Brand
            if @brand_block
              div(class: "decor:flex decor:items-center decor:min-w-0 decor:shrink-0") do
                instance_eval(&@brand_block)
              end
            elsif @brand_text
              a(
                href: @brand_href,
                class: "decor:flex decor:items-center decor:suite-section-title decor:text-gray-900 decor:font-bold decor:no-underline decor:shrink-0"
              ) do
                plain @brand_text
              end
            end

            # Desktop navigation items
            if @nav_items_block
              div(class: "decor:hidden decor:lg:flex decor:items-center") do
                ul(class: "decor:flex decor:items-center decor:gap-1") do
                  instance_eval(&@nav_items_block)
                end
              end
            end

            # Search
            if @has_search
              child_element(
                :div,
                stimulus_target: :search,
                class: "decor:relative decor:flex-1 decor:max-w-[360px] decor:ml-auto"
              ) do
                form(class: "decor:relative decor:w-full") do
                  div(class: "decor:absolute decor:inset-y-0 decor:left-0 decor:flex decor:items-center decor:pl-2.5 decor:pointer-events-none") do
                    render ::Decor::Icon.new(
                      name: "search",
                      style: :solid,
                      classes: "decor:h-3.5 decor:w-3.5 decor:text-gray-400"
                    )
                  end
                  child_element(
                    :input,
                    id: "search-input",
                    name: "search",
                    type: "search",
                    autocomplete: "on",
                    value: "",
                    class: "decor:w-full decor:bg-suite-gray-25 decor:border decor:border-transparent decor:rounded-suite-control decor:py-1.5 decor:pl-8 decor:pr-2.5 decor:suite-description decor:text-gray-700 decor:transition-all decor:duration-suite-fast decor:ease-out decor:focus:outline-none decor:focus:bg-white decor:focus:border-suite-primary-700",
                    placeholder: "Search",
                    stimulus_target: :search_input,
                    stimulus_actions: [
                      [:click, :clicked_search_input],
                      [:keyup, :search],
                      [:search, :search],
                      [:input, :search],
                      [:focus, :got_search_focus],
                      [:focusout, :lost_search_focus]
                    ]
                  )
                end
              end
            end

            # Right-side menus
            div(class: "decor:flex decor:items-center decor:gap-1 decor:shrink-0 #{"decor:ml-auto" unless @has_search}") do
              if @notifications_menu
                notifications_menu = ::Decor::Suite::Dropdown.new(**(@notifications_menu_options || {}))
                instance_exec(notifications_menu, &@notifications_menu)
                render notifications_menu
              end
              if @account_menu
                account_menu = ::Decor::Suite::Dropdown.new(**(@account_menu_options || {}))
                instance_exec(account_menu, &@account_menu)
                render account_menu
              end
            end

            # Search results dropdown (panel below the navbar)
            render ::Decor::Daisy::SearchResultsDropdown.new(
              nav_element: el,
              stimulus_actions: [[:click, :clicked_search_content]],
              stimulus_targets: [:search_dropdown]
            )
          end
        end

        private

        def root_element_attributes
          {
            element_tag: :header
          }
        end

        def root_element_classes
          "decor:sticky decor:top-0 decor:z-30 decor:shrink-0 decor:flex decor:items-center decor:gap-4 decor:h-[50px] decor:bg-white decor:border-b decor:border-suite-hairline decor:px-6"
        end
      end
    end
  end
end
