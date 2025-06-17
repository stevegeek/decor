# @label CloudStack Pro Examples
class CloudstackExamplesPreview < ::Lookbook::Preview
  # CloudStack Pro Example Pages
  # ---------------------------
  #
  # This preview provides navigation to all the CloudStack Pro example pages
  # that demonstrate real-world usage of Decor components in a complete
  # application context.
  #
  # These pages showcase a fictional cloud instance management SaaS product
  # and demonstrate how components work together to create cohesive,
  # professional user interfaces.
  #
  # @label Navigation
  def navigation
    render Cloudstack::NavigationComponent.new
  end
  
  # Individual page previews for quick component testing
  
  # @label Dashboard Metrics Cards
  def dashboard_metrics
    render ::Decor::PanelGroup.new do |group|
      group.panel do
        render ::Decor::Card.new(color: :primary, size: :md) do |card|
          div(class: "text-center") do
            render ::Decor::Icon.new(name: "server", html_options: {class: "mx-auto h-8 w-8 mb-2 text-primary"})
            div(class: "text-3xl font-bold text-primary") { "12" }
            div(class: "text-sm text-gray-600") { "Active Instances" }
          end
        end
      end
      
      group.panel do
        render ::Decor::Card.new(color: :info, size: :md) do |card|
          div(class: "text-center") do
            render ::Decor::Icon.new(name: "cpu-chip", html_options: {class: "mx-auto h-8 w-8 mb-2 text-info"})
            div(class: "text-3xl font-bold text-info") { "68%" }
            div(class: "text-sm text-gray-600") { "Avg CPU Usage" }
          end
        end
      end
      
      group.panel do
        render ::Decor::Card.new(color: :success, size: :md) do |card|
          div(class: "text-center") do
            render ::Decor::Icon.new(name: "currency-dollar", html_options: {class: "mx-auto h-8 w-8 mb-2 text-success"})
            div(class: "text-3xl font-bold text-success") { "$234.56" }
            div(class: "text-sm text-gray-600") { "This Month" }
          end
        end
      end
    end
  end
  
  # @label Instance Status Table Row
  def instance_table_row
    render ::Decor::Card.new(title: "Instance Table Example", size: :lg) do |card|
      div(class: "overflow-x-auto") do
        table(class: "table table-zebra w-full") do
          thead do
            tr do
              th { "Name" }
              th { "Status" }
              th { "Type" }
              th { "Actions" }
            end
          end
          tbody do
            tr(class: "hover") do
              td do
                div(class: "font-medium") { "web-server-01" }
                div(class: "text-sm text-gray-500") { "i-1234567890abcdef0" }
              end
              td do
                render ::Decor::Badge.new(text: "Running", color: :success)
              end
              td { "t3.medium" }
              td do
                render ::Decor::Dropdown.new(color: :primary, size: :sm) do |dropdown|
                  dropdown.trigger_button_content do
                    plain "Actions"
                    render ::Decor::Icon.new(name: "chevron-down", html_options: {class: "ml-1 h-4 w-4"})
                  end
                  
                  dropdown.menu_item(::Decor::DropdownItem.new(text: "View Details", href: "#", icon_name: "eye"))
                  dropdown.menu_item(::Decor::DropdownItem.new(text: "Stop", href: "#", icon_name: "stop"))
                  dropdown.menu_item(::Decor::DropdownItem.new(text: "Restart", href: "#", icon_name: "arrow-path"))
                end
              end
            end
          end
        end
      end
    end
  end
  
  # @label User Profile Card
  def profile_card
    render ::Decor::Card.new(title: "Profile", size: :lg) do |card|
      div(class: "text-center") do
        render ::Decor::Avatar.new(
          src: "/images/pic.jpg",
          alt: "John Doe",
          size: :xl,
          html_options: {class: "mx-auto mb-4"}
        )
        
        h3(class: "text-lg font-semibold") { "John Doe" }
        p(class: "text-gray-600") { "john.doe@company.com" }
        
        div(class: "flex justify-center mt-4") do
          render ::Decor::Badge.new(text: "Pro", color: :primary, size: :large)
        end
        
        div(class: "mt-6") do
          render ::Decor::Button.new(
            label: "Edit Profile",
            color: :primary,
            variant: :outlined,
            icon: "pencil",
            full_width: true
          )
        end
      end
    end
  end
  
  # @label Billing Summary
  def billing_summary
    render ::Decor::Card.new(title: "Current Billing Period - December 2024", size: :lg) do |card|
      div(class: "grid grid-cols-1 md:grid-cols-4 gap-6") do
        div(class: "text-center") do
          div(class: "text-3xl font-bold text-primary") { "$234.56" }
          div(class: "text-sm text-gray-600") { "Current Charges" }
        end
        
        div(class: "text-center") do
          div(class: "text-3xl font-bold text-warning") { "$280.00" }
          div(class: "text-sm text-gray-600") { "Projected Total" }
        end
        
        div(class: "text-center") do
          div(class: "text-3xl font-bold text-info") { "78%" }
          div(class: "text-sm text-gray-600") { "Period Used" }
        end
        
        div(class: "text-center") do
          div(class: "text-3xl font-bold text-success") { "6" }
          div(class: "text-sm text-gray-600") { "Days Remaining" }
        end
      end
      
      div(class: "mt-6") do
        div(class: "flex justify-between text-sm mb-2") do
          span { "Billing Period Progress" }
          span { "78% complete" }
        end
        div(class: "w-full bg-gray-200 rounded-full h-3") do
          div(class: "bg-gradient-to-r from-blue-500 to-blue-600 h-3 rounded-full", style: "width: 78%") {}
        end
      end
    end
  end
  
  # @label Support Ticket Summary
  def support_tickets_summary
    render ::Decor::Card.new(title: "Your Support Tickets", size: :lg) do |card|
      div(class: "grid grid-cols-2 gap-4 mb-4") do
        div(class: "text-center") do
          div(class: "text-2xl font-bold text-orange-600") { "2" }
          div(class: "text-sm text-gray-600") { "Open" }
        end
        div(class: "text-center") do
          div(class: "text-2xl font-bold text-blue-600") { "1" }
          div(class: "text-sm text-gray-600") { "In Progress" }
        end
        div(class: "text-center") do
          div(class: "text-2xl font-bold text-yellow-600") { "0" }
          div(class: "text-sm text-gray-600") { "Waiting" }
        end
        div(class: "text-center") do
          div(class: "text-2xl font-bold text-green-600") { "5" }
          div(class: "text-sm text-gray-600") { "Resolved" }
        end
      end
      
      div(class: "flex space-x-2") do
        render ::Decor::Button.new(
          label: "View All Tickets",
          color: :primary,
          variant: :outlined,
          full_width: true
        )
        render ::Decor::Button.new(
          label: "Create Ticket",
          color: :primary,
          icon: "plus",
          full_width: true
        )
      end
    end
  end
end