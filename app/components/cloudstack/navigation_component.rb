module Cloudstack
  class NavigationComponent < ::Decor::PhlexComponent
    def call
      render ::Decor::Card.new(title: "CloudStack Pro Example Pages", size: :xl) do |card|
        div(class: "mb-6") do
          p(class: "text-gray-600 mb-4") do
            plain "Explore complete example pages that demonstrate real-world usage of Decor components "
            plain "in a fictional cloud instance management SaaS product called CloudStack Pro."
          end
          
          render ::Decor::Banner.new(color: :info, variant: :outlined) do
            render ::Decor::Icon.new(name: "information-circle", html_options: {class: "h-5 w-5 mr-2"})
            plain "These pages show how components work together to create professional, cohesive user interfaces."
          end
        end

        # Main Navigation Grid
        div(class: "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6") do
          # Dashboard
          navigation_card(
            title: "Dashboard Overview",
            description: "Main landing page with metrics, activity feed, and quick actions",
            href: "/cloudstack/dashboard",
            icon: "chart-bar",
            color: :primary,
            components: ["Card", "Icon", "Button", "Banner", "Title"]
          )

          # Instance Management  
          navigation_card(
            title: "Instance Management",
            description: "Comprehensive list view with filtering, sorting, and bulk actions",
            href: "/cloudstack/instances",
            icon: "server",
            color: :info,
            components: ["DataTableBuilder", "Tabs", "Dropdown", "Badge", "Modal"]
          )

          # Instance Details
          navigation_card(
            title: "Instance Details",
            description: "Detailed view with configuration options and monitoring",
            href: "/cloudstack/instances/i-1234567890abcdef0",
            icon: "cpu-chip",
            color: :secondary,
            components: ["Tabs", "Panel", "ClickToCopy", "Progress", "Tooltip"]
          )

          # User Profile
          navigation_card(
            title: "User Profile",
            description: "Account management, preferences, and security settings",
            href: "/cloudstack/profile",
            icon: "user",
            color: :success,
            components: ["Avatar", "Tabs", "Button", "Badge", "Modal"]
          )

          # Billing & Usage
          navigation_card(
            title: "Billing & Usage",
            description: "Billing overview, usage analytics, and cost tracking",
            href: "/cloudstack/billing",
            icon: "currency-dollar",
            color: :warning,
            components: ["DataTableBuilder", "Chart", "Banner", "Link"]
          )

          # Support Center
          navigation_card(
            title: "Support Center",
            description: "Help center with documentation and ticket management",
            href: "/cloudstack/support",
            icon: "question-mark-circle",
            color: :neutral,
            components: ["DataTableBuilder", "Tabs", "Flash", "Search"]
          )
        end

        # Implementation Notes
        div(class: "mt-8 pt-6 border-t") do
          render ::Decor::Title.new(text: "Implementation Notes", level: 3)
          
          div(class: "grid grid-cols-1 md:grid-cols-2 gap-6 mt-4") do
            div do
              h4(class: "font-medium text-gray-900 mb-2") { "🎯 What's Included" }
              ul(class: "text-sm text-gray-600 space-y-1") do
                li { "• Complete Rails controllers with mock data" }
                li { "• Realistic view templates using Decor components" }
                li { "• Proper component composition and nesting" }
                li { "• Interactive states and user feedback" }
                li { "• Responsive design patterns" }
              end
            end
            
            div do
              h4(class: "font-medium text-gray-900 mb-2") { "🚀 Ready for Enhancement" }
              ul(class: "text-sm text-gray-600 space-y-1") do
                li { "• DataTableBuilder integration placeholders" }
                li { "• Modal and form implementations" }
                li { "• Real-time updates with Turbo" }
                li { "• Chart integration points" }
                li { "• API integration stubs" }
              end
            end
          end
        end

        # Quick Actions
        div(class: "mt-6 pt-6 border-t") do
          div(class: "flex flex-wrap gap-3") do
            render ::Decor::Button.new(
              label: "View All Pages",
              color: :primary,
              icon: "arrow-top-right-on-square",
              element_tag: :a
            )
            
            render ::Decor::Button.new(
              label: "Component Documentation",
              color: :secondary,
              variant: :outlined,
              icon: "book-open",
              element_tag: :a
            )
            
            render ::Decor::Button.new(
              label: "Download Examples",
              color: :neutral,
              variant: :outlined,
              icon: "arrow-down-tray",
              element_tag: :a
            )
          end
        end
      end
    end

    private

    def navigation_card(title:, description:, href:, icon:, color:, components:)
      link_to href, class: "block group", target: "_blank" do
        render ::Decor::Card.new(size: :lg, variant: :outlined, html_options: {class: "h-full transition-all duration-200 group-hover:shadow-lg group-hover:border-#{color}"}) do |card|
          div(class: "flex items-start space-x-3 mb-3") do
            div(class: "flex-shrink-0") do
              render ::Decor::Icon.new(name: icon, html_options: {class: "h-8 w-8 text-#{color}"})
            end
            div(class: "flex-1 min-w-0") do
              h3(class: "text-lg font-semibold text-gray-900 group-hover:text-#{color} transition-colors") { title }
              p(class: "text-sm text-gray-600 mt-1") { description }
            end
          end
          
          div(class: "mb-4") do
            h4(class: "text-xs font-medium text-gray-500 uppercase tracking-wide mb-2") { "Key Components:" }
            div(class: "flex flex-wrap gap-1") do
              components.each do |component|
                render ::Decor::Badge.new(
                  text: component,
                  color: :neutral,
                  variant: :outlined,
                  size: :small
                )
              end
            end
          end
          
          div(class: "flex items-center text-sm text-#{color} font-medium") do
            plain "View Page"
            render ::Decor::Icon.new(name: "arrow-right", html_options: {class: "ml-1 h-4 w-4 group-hover:translate-x-1 transition-transform"})
          end
        end
      end
    end
  end
end