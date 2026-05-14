# frozen_string_literal: true

module Decor
  module Daisy
    module Nav
      # TopNavbar A horizontal navigation bar with start/center/end sections,
      # an optional search input that opens a SearchResultsDropdown, and slots
      # for brand, nav items, account menu, and notifications menu.
      class TopNavbar < ::Decor::Components::Nav::TopNavbar
        def view_template(&)
          vanish(&)
          root_element do |el|
            # navbar-start section
            div(class: "decor:d-navbar-start") do
              # Mobile menu button (only show if we have nav items)
              if @nav_items_block
                button(
                  type: "button",
                  class: "decor:d-btn decor:d-btn-ghost decor:d-btn-circle decor:lg:hidden",
                  data: {
                    action: "click->#{stimulus_identifier}#toggle_mobile_menu"
                  }
                ) do
                  span(class: "decor:sr-only") { "Open sidebar" }
                  render ::Decor::Daisy::Icon.new(name: "bars-3", classes: "decor:h-6 decor:w-6")
                end
              end

              # Brand section
              if @brand_block
                instance_eval(&@brand_block)
              elsif @brand_text
                a(href: @brand_href, class: "decor:d-btn decor:d-btn-ghost decor:text-xl decor:font-bold") do
                  @brand_text
                end
              end

              # Desktop navigation items
              if @nav_items_block
                div(class: "decor:hidden decor:lg:flex") do
                  ul(class: "decor:d-menu decor:d-menu-horizontal decor:px-1") do
                    instance_eval(&@nav_items_block)
                  end
                end
              end
            end

            # navbar-center section (search)
            div(class: "decor:d-navbar-center decor:px-2 decor:lg:px-4 decor:min-w-36") do
              if @has_search
                child_element(
                  :div,
                  stimulus_target: :search,
                  class: "decor:form-control decor:w-full decor:max-w-xs decor:sm:max-w-md decor:lg:max-w-lg"
                ) do
                  form(class: "decor:relative decor:w-full") do
                    div(class: "decor:relative") do
                      div(class: "decor:absolute decor:inset-y-0 decor:left-0 decor:flex decor:items-center decor:pl-3 decor:pointer-events-none") do
                        render ::Decor::Daisy::Icon.new(
                          name: "search",
                          style: :solid,
                          classes: "decor:h-5 decor:w-5 decor:text-base-content/40"
                        )
                      end
                      child_element(
                        :input,
                        id: "search-input",
                        name: "search",
                        type: "search",
                        autocomplete: "on",
                        value: "",
                        class: "decor:d-input decor:d-input-bordered decor:w-full decor:pl-10 decor:pr-4 decor:focus:outline-none decor:focus:ring-2 decor:focus:ring-primary",
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
              end
            end

            # navbar-end section
            div(class: "decor:d-navbar-end") do
              if @notifications_menu
                notifications_menu = ::Decor::Daisy::Dropdown.new(**(@notifications_menu_options || {}))
                instance_exec(notifications_menu, &@notifications_menu)
                render notifications_menu
              end
              if @account_menu
                account_menu = ::Decor::Daisy::Dropdown.new(**(@account_menu_options || {}))
                instance_exec(account_menu, &@account_menu)
                render account_menu
              end
            end

            # Search results dropdown (outside navbar sections)
            render ::Decor::Daisy::SearchResultsDropdown.new(
              nav_element: el,
              stimulus_actions: [[:click, :clicked_search_content]],
              stimulus_targets: [:search_dropdown]
            )
          end
        end

        def root_element_attributes
          {
            element_tag: :header
          }
        end

        def root_element_classes
          "decor:d-navbar decor:sticky decor:top-0 decor:z-10 decor:bg-base-100 decor:shadow-lg decor:min-h-16"
        end
      end
    end
  end
end
