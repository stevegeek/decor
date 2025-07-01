# frozen_string_literal: true

module Decor
  module Nav
    class TopNavbar < PhlexComponent
      attribute :has_search, :boolean, default: true
      attribute :instant_search_path, String
      attribute :brand_text, String
      attribute :brand_href, String, default: "/"

      # Manual slot implementations
      def with_brand(&block)
        @brand_block = block
        self
      end

      def with_nav_items(&block)
        @nav_items_block = block
        self
      end

      def with_account_menu(**options, &block)
        @account_menu_options = options
        @account_menu = block
        self
      end

      def with_notifications_menu(**options, &block)
        @notifications_menu_options = options
        @notifications_menu = block
        self
      end

      def view_template(&)
        vanish(&)
        render parent_element do |el|
          # navbar-start section
          div(class: "navbar-start") do
            # Mobile menu button (only show if we have nav items)
            if @nav_items_block
              button(
                type: "button",
                class: "btn btn-ghost btn-circle lg:hidden",
                data: {
                  action: "click->#{stimulus_identifier}#toggle_mobile_menu"
                }
              ) do
                span(class: "sr-only") { "Open sidebar" }
                render ::Decor::Icon.new(name: "bars-3", html_options: {class: "h-6 w-6"})
              end
            end

            # Brand section
            if @brand_block
              instance_eval(&@brand_block)
            elsif @brand_text
              a(href: @brand_href, class: "btn btn-ghost text-xl font-bold") do
                @brand_text
              end
            end

            # Desktop navigation items
            if @nav_items_block
              div(class: "hidden lg:flex") do
                ul(class: "menu menu-horizontal px-1") do
                  instance_eval(&@nav_items_block)
                end
              end
            end
          end

          # navbar-center section (search)
          div(class: "navbar-center flex-1 px-2 lg:px-4") do
            if @has_search
              div(
                class: "form-control w-full max-w-xs sm:max-w-md lg:max-w-lg",
                data: {"#{stimulus_identifier}_target": "search"}
              ) do
                form(class: "relative w-full") do
                  div(class: "relative") do
                    div(class: "absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none") do
                      render ::Decor::Icon.new(
                        name: "search",
                        variant: :solid,
                        html_options: {class: "h-5 w-5 text-base-content/40"}
                      )
                    end
                    input(
                      id: "search-input",
                      name: "search",
                      type: "search",
                      autocomplete: "on",
                      value: "",
                      class: "input input-bordered w-full pl-10 pr-4 focus:outline-none focus:ring-2 focus:ring-primary",
                      placeholder: "Search",
                      data: {
                        "#{stimulus_identifier}_target": "search_input",
                        action: [
                          "focus->#{stimulus_identifier}#got_search_focus",
                          "focusout->#{stimulus_identifier}#lost_search_focus",
                          "keyup->#{stimulus_identifier}#search",
                          "search->#{stimulus_identifier}#search",
                          "input->#{stimulus_identifier}#search",
                          "click->#{stimulus_identifier}#clicked_search_input"
                        ].join(" ")
                      }
                    )
                  end
                end
              end
            end
          end

          # navbar-end section
          div(class: "navbar-end") do
            if @notifications_menu
              notifications_menu = ::Decor::Dropdown.new(**(@notifications_menu_options || {}))
              instance_exec(notifications_menu, &@notifications_menu)
              render notifications_menu
            end
            if @account_menu
              account_menu = ::Decor::Dropdown.new(**(@account_menu_options || {}))
              instance_exec(account_menu, &@account_menu)
              render account_menu
            end
          end

          # Search results dropdown (outside navbar sections)
          render ::Decor::SearchResultsDropdown.new(
            nav_element: el,
            actions: [[:click, :clicked_search_content]],
            targets: [:search_dropdown]
          )
        end
      end

      def root_element_attributes
        {
          element_tag: :header,
          values: [{search_url: @instant_search_path}],
          actions: [],
          html_options: @html_options
        }
      end

      def element_classes
        [
          "navbar",
          "sticky",
          "top-0",
          "z-10",
          "bg-base-100",
          "shadow-lg",
          "min-h-16"
        ].join(" ")
      end
    end
  end
end
