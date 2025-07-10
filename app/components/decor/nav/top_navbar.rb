# frozen_string_literal: true

module Decor
  module Nav
    class TopNavbar < PhlexComponent
      prop :has_search, _Boolean, default: true
      prop :instant_search_path, _Nilable(String)
      prop :brand_text, _Nilable(String)
      prop :brand_href, String, default: "/"

      stimulus do
        values_from_props :instant_search_path
      end

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
        root_element do |el|
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
                render ::Decor::Icon.new(name: "bars-3", classes: "h-6 w-6")
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
          div(class: "navbar-center px-2 lg:px-4 min-w-36") do
            if @has_search
              el.tag(
                :div,
                stimulus_target: :search,
                class: "form-control w-full max-w-xs sm:max-w-md lg:max-w-lg"
              ) do
                form(class: "relative w-full") do
                  div(class: "relative") do
                    div(class: "absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none") do
                      render ::Decor::Icon.new(
                        name: "search",
                        variant: :solid,
                        classes: "h-5 w-5 text-base-content/40"
                      )
                    end
                    el.tag(
                      :input,
                      id: "search-input",
                      name: "search",
                      type: "search",
                      autocomplete: "on",
                      value: "",
                      class: "input input-bordered w-full pl-10 pr-4 focus:outline-none focus:ring-2 focus:ring-primary",
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

      def element_classes
        "navbar sticky top-0 z-10 bg-base-100 shadow-lg min-h-16"
      end
    end
  end
end
