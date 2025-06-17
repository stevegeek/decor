# Example Pages for Cloud Instance Management Tool

This document outlines example pages for showcasing the Decor UI component library in the context of a fictional cloud instance management SaaS product called "CloudStack Pro". These pages demonstrate real-world usage of components in complete page contexts.

## Page Overview

### 1. Dashboard Overview
**Route**: `/dashboard`
**Purpose**: Main landing page showing system overview, recent activity, and key metrics

**Key Components Used**:
- **Card**: Multiple cards for metrics (CPU usage, memory, active instances, billing summary)
- **Panel/PanelGroup**: Organizing dashboard sections
- **Button**: Quick action buttons (Launch Instance, View All, etc.)
- **Avatar**: User profile in header
- **Dropdown**: User menu in top navigation
- **Badge**: Status indicators (Active, Warning, Critical)
- **Notification/NotificationManager**: System alerts and updates
- **Icon**: Various status and action icons
- **Title**: Page and section headings

**Content Sections**:
- Resource usage overview cards
- Recent instance activity timeline
- Quick launch shortcuts
- System health status
- Billing summary widget

---

### 2. Instance Management
**Route**: `/instances`
**Purpose**: Comprehensive list view of all cloud instances with filtering, sorting, and bulk actions

**Key Components Used**:
- **Card**: Container for the instances table and filters
- **DataTableBuilder**: Advanced table with sorting, filtering, pagination, and search
- **Dropdown**: Bulk actions menu, per-instance actions menu, filter dropdowns
- **Button**: Create Instance, Apply Filters, Export, individual action buttons
- **Badge**: Instance status (Running, Stopped, Error, Pending)
- **Tabs**: Different views (All Instances, Running, Stopped, etc.)
- **Flash**: Success/error messages for actions
- **Modal/ConfirmModal**: Instance creation wizard, deletion confirmations
- **Tooltip**: Additional info on hover for technical details
- **Link**: Navigation to instance details

**DataTableBuilder Implementation**:
```ruby
class CloudInstancesTable < ::Decor::Tables::DataTableBuilder
  def search_or_filter_element?
    true
  end

  def default_sort_direction
    :desc
  end

  def default_sort_by
    :created_at
  end

  def default_page_size
    20
  end

  def header_height
    :comfortable
  end

  def row_height
    :comfortable
  end

  def transform_row(instance, _index, _item_index)
    CloudInstancePresenter.new(model: instance)
  end

  def path_for_row(instance, _transformed_data, _index, _item_index)
    helpers.instance_path(instance)
  end

  def row_attributes(_instance, presenter, _index, _item_index)
    case presenter.status
    when :error
      {highlight: :high}
    when :warning
      {highlight: :medium}
    else
      {}
    end
  end

  def cell_attributes(_instance, presenter, _index, _item_index)
    if presenter.critical?
      {emphasis: :high, weight: :bold}
    else
      {emphasis: :regular}
    end
  end

  def search
    ::Decor::SearchAndFilter::Search.new(
      name: "instances_search",
      label: "Search by name or ID",
      apply: ->(query, param) do
        query.where("name ILIKE ? OR id::text ILIKE ?", "%#{param}%", "%#{param}%")
      end
    )
  end

  def filters
    [
      ::Decor::SearchAndFilter::Filter.new(
        type: :select,
        name: "instance_status",
        label: "Status",
        options: [
          ["All", "all"],
          ["Running", "running"],
          ["Stopped", "stopped"],
          ["Error", "error"],
          ["Pending", "pending"]
        ],
        apply: ->(query, param) do
          param == "all" ? query : query.where(status: param)
        end
      ),
      ::Decor::SearchAndFilter::Filter.new(
        type: :select,
        name: "instance_type",
        label: "Instance Type",
        options: [
          ["All", "all"],
          ["t2.micro", "t2.micro"],
          ["t2.small", "t2.small"],
          ["t3.medium", "t3.medium"],
          ["c5.large", "c5.large"]
        ],
        apply: ->(query, param) do
          param == "all" ? query : query.where(instance_type: param)
        end
      )
    ]
  end

  def sorting
    {
      name: ->(query, asc) do
        query.order(name: asc ? :asc : :desc)
      end,
      status: ->(query, asc) do
        query.order(status: asc ? :asc : :desc)
      end,
      created_at: ->(query, asc) do
        query.order(created_at: asc ? :asc : :desc)
      end,
      cpu_usage: ->(query, asc) do
        query.order(cpu_usage: asc ? :asc : :desc)
      end,
      monthly_cost: ->(query, asc) do
        query.order(monthly_cost: asc ? :asc : :desc)
      end
    }
  end
end
```

**Content Sections**:
- Search and filter bar (integrated with DataTableBuilder)
- Tabbed view for different instance states
- Advanced data table with sorting, filtering, and pagination
- Bulk action controls
- Export and action buttons

---

### 3. Instance Detail & Configuration
**Route**: `/instances/:id`
**Purpose**: Detailed view of a single instance with configuration options and monitoring

**Key Components Used**:
- **PanelGroup/Panel**: Organizing different configuration sections
- **Card**: Grouping related settings and information
- **Tabs**: Different configuration areas (General, Network, Storage, Monitoring)
- **Button**: Save, Reset, Power actions (Start/Stop/Restart)
- **Dropdown**: Configuration option selectors
- **Badge**: Status indicators, resource tags
- **Banner**: Important notices or warnings
- **Tooltip**: Help text for complex settings
- **ConfirmModal**: Destructive action confirmations
- **Flash**: Configuration save status

**Content Sections**:
- Instance header with key info and actions
- Tabbed configuration panels
- Resource monitoring charts
- Network and security settings
- Backup and snapshot management

---

### 4. User Profile & Settings
**Route**: `/profile` and `/settings`
**Purpose**: User account management, preferences, and system configuration

**Key Components Used**:
- **Card**: Profile information, billing details, security settings
- **Button**: Save changes, generate tokens, update password
- **Avatar**: Profile picture display and upload
- **Tabs**: Different settings categories (Profile, Security, Billing, Notifications)
- **Flash**: Success/error messages for updates
- **Modal**: Profile picture upload, API key generation
- **Dropdown**: Timezone, region, notification preferences
- **Badge**: Account tier (Free, Pro, Enterprise)
- **ClickToCopy**: API keys and connection strings

**Content Sections**:
- Personal information form
- Security settings (password, 2FA, API keys)
- Billing information and subscription management
- Notification preferences
- Account activity log

---

### 5. Billing & Usage Analytics
**Route**: `/billing` and `/usage`
**Purpose**: Billing overview, usage analytics, and resource cost tracking

**Key Components Used**:
- **Card**: Billing summary, usage breakdowns, cost analysis
- **DataTableBuilder**: Detailed billing history and usage reports with advanced filtering
- **Tabs**: Current period, historical data, projections
- **Button**: Download invoice, upgrade plan, payment method updates
- **Badge**: Plan type, payment status
- **Panel**: Organizing cost breakdowns and charts
- **Dropdown**: Time period selectors, export options
- **Link**: Invoice downloads, plan comparison
- **Banner**: Billing alerts, usage warnings

**DataTableBuilder Implementation for Billing History**:
```ruby
class BillingHistoryTable < ::Decor::Tables::DataTableBuilder
  def search_or_filter_element?
    true
  end

  def default_sort_direction
    :desc
  end

  def default_sort_by
    :invoice_date
  end

  def default_page_size
    12
  end

  def header_height
    :comfortable
  end

  def row_height
    :compact
  end

  def transform_row(invoice, _index, _item_index)
    BillingInvoicePresenter.new(model: invoice)
  end

  def path_for_row(invoice, _transformed_data, _index, _item_index)
    helpers.billing_invoice_path(invoice)
  end

  def row_attributes(_invoice, presenter, _index, _item_index)
    if presenter.overdue?
      {highlight: :high}
    elsif presenter.pending?
      {highlight: :medium}  
    end
  end

  def search
    ::Decor::SearchAndFilter::Search.new(
      name: "billing_search",
      label: "Search invoices",
      apply: ->(query, param) do
        query.where("invoice_number ILIKE ? OR description ILIKE ?", "%#{param}%", "%#{param}%")
      end
    )
  end

  def filters
    [
      ::Decor::SearchAndFilter::Filter.new(
        type: :select,
        name: "billing_status",
        label: "Payment Status",
        options: [
          ["All", "all"],
          ["Paid", "paid"],
          ["Pending", "pending"],
          ["Overdue", "overdue"],
          ["Failed", "failed"]
        ],
        apply: ->(query, param) do
          param == "all" ? query : query.where(payment_status: param)
        end
      ),
      ::Decor::SearchAndFilter::Filter.new(
        type: :date_range,
        name: "billing_date_range",
        label: "Invoice Date Range",
        apply: ->(query, param) do
          return query if param.blank?
          start_date, end_date = param.split(" to ")
          query.where(invoice_date: Date.parse(start_date)..Date.parse(end_date))
        end
      )
    ]
  end

  def sorting
    {
      invoice_date: ->(query, asc) do
        query.order(invoice_date: asc ? :asc : :desc)
      end,
      amount: ->(query, asc) do
        query.order(total_amount: asc ? :asc : :desc)
      end,
      payment_status: ->(query, asc) do
        query.order(payment_status: asc ? :asc : :desc)
      end
    }
  end
end
```

**Content Sections**:
- Current billing summary
- Resource usage charts
- Advanced billing history table with search and filtering
- Cost breakdown by service/instance
- Payment method management

---

### 6. Support & Documentation
**Route**: `/support` and `/docs`
**Purpose**: Help center with documentation, support tickets, and knowledge base

**Key Components Used**:
- **Card**: FAQ items, documentation sections, support ticket summaries
- **DataTableBuilder**: Support ticket management with advanced filtering and search
- **Tabs**: Different support categories (Docs, Tickets, Community)
- **Button**: Create ticket, search, helpful/not helpful feedback
- **Badge**: Ticket status, priority levels
- **Modal**: Ticket creation form, feedback submission
- **Link**: Navigation between documentation pages
- **Flash**: Ticket submission confirmations
- **Dropdown**: Category filters, sort options
- **Box**: Code examples and API documentation

**DataTableBuilder Implementation for Support Tickets**:
```ruby
class SupportTicketsTable < ::Decor::Tables::DataTableBuilder
  def search_or_filter_element?
    true
  end

  def default_sort_direction
    :desc
  end

  def default_sort_by
    :updated_at
  end

  def default_page_size
    15
  end

  def header_height
    :comfortable
  end

  def row_height
    :comfortable
  end

  def transform_row(ticket, _index, _item_index)
    SupportTicketPresenter.new(model: ticket)
  end

  def path_for_row(ticket, _transformed_data, _index, _item_index)
    helpers.support_ticket_path(ticket)
  end

  def row_attributes(_ticket, presenter, _index, _item_index)
    case presenter.priority
    when :critical
      {highlight: :high}
    when :high
      {highlight: :medium}
    else
      {}
    end
  end

  def cell_attributes(_ticket, presenter, _index, _item_index)
    if presenter.unread_by_customer?
      {emphasis: :high, weight: :bold}
    else
      {emphasis: :regular}
    end
  end

  def search
    ::Decor::SearchAndFilter::Search.new(
      name: "tickets_search",
      label: "Search tickets by subject or content",
      apply: ->(query, param) do
        query.where("subject ILIKE ? OR description ILIKE ?", "%#{param}%", "%#{param}%")
      end
    )
  end

  def filters
    [
      ::Decor::SearchAndFilter::Filter.new(
        type: :select,
        name: "ticket_status",
        label: "Status",
        options: [
          ["All", "all"],
          ["Open", "open"],
          ["In Progress", "in_progress"],
          ["Waiting for Customer", "waiting_customer"],
          ["Resolved", "resolved"],
          ["Closed", "closed"]
        ],
        apply: ->(query, param) do
          param == "all" ? query : query.where(status: param)
        end
      ),
      ::Decor::SearchAndFilter::Filter.new(
        type: :select,
        name: "ticket_priority",
        label: "Priority",
        options: [
          ["All", "all"],
          ["Critical", "critical"],
          ["High", "high"],
          ["Medium", "medium"],
          ["Low", "low"]
        ],
        apply: ->(query, param) do
          param == "all" ? query : query.where(priority: param)
        end
      ),
      ::Decor::SearchAndFilter::Filter.new(
        type: :select,
        name: "ticket_category",
        label: "Category",
        options: [
          ["All", "all"],
          ["Technical", "technical"],
          ["Billing", "billing"],
          ["Feature Request", "feature_request"],
          ["Bug Report", "bug_report"]
        ],
        apply: ->(query, param) do
          param == "all" ? query : query.where(category: param)
        end
      )
    ]
  end

  def sorting
    {
      updated_at: ->(query, asc) do
        query.order(updated_at: asc ? :asc : :desc)
      end,
      created_at: ->(query, asc) do
        query.order(created_at: asc ? :asc : :desc)
      end,
      priority: ->(query, asc) do
        priority_order = asc ? 
          "CASE priority WHEN 'critical' THEN 1 WHEN 'high' THEN 2 WHEN 'medium' THEN 3 WHEN 'low' THEN 4 END" :
          "CASE priority WHEN 'critical' THEN 4 WHEN 'high' THEN 3 WHEN 'medium' THEN 2 WHEN 'low' THEN 1 END"
        query.order(Arel.sql(priority_order))
      end,
      status: ->(query, asc) do
        query.order(status: asc ? :asc : :desc)
      end
    }
  end
end
```

**Content Sections**:
- Search functionality
- Documentation navigation  
- Advanced support ticket management table
- Community forum integration
- System status page

---

## Component Distribution Analysis

### High-Usage Components (Used in 5+ pages):
- **Card**: Primary container for content organization
- **Button**: Action triggers throughout the application
- **Dropdown**: Menus, filters, and option selection
- **Badge**: Status indicators and labels
- **Modal**: Forms and confirmations
- **Flash**: User feedback messages
- **Icon**: Visual enhancement and status indication

### Medium-Usage Components (Used in 2-4 pages):
- **DataTableBuilder**: Advanced table functionality with search, filtering, and pagination
- **Tabs**: Content organization within pages
- **Panel/PanelGroup**: Section organization
- **Avatar**: User representation
- **Link**: Navigation elements
- **Tooltip**: Additional information on hover

### Specialized Components (Used in 1-2 pages):
- **Banner**: Important announcements
- **ClickToCopy**: Technical data sharing
- **NotificationManager**: System-wide notifications
- **Carousel**: Featured content or tutorials
- **Chat**: Support system integration

## DataTableBuilder Usage Patterns

The **DataTableBuilder** is particularly effective for:

1. **Instance Management**: Complex filtering by status, type, region with search across multiple fields
2. **Billing History**: Date range filtering, payment status filtering, and monetary sorting
3. **Support Tickets**: Priority-based highlighting, status filtering, and multi-category organization

### Key DataTableBuilder Features Demonstrated:

- **Advanced Search**: Text-based search across multiple model fields
- **Multi-Filter Support**: Dropdown selectors for various data attributes
- **Custom Sorting**: Complex sorting logic including custom SQL for priority ordering
- **Row/Cell Styling**: Conditional highlighting based on data state (errors, priorities, status)
- **Presenter Integration**: Using presenter objects to transform raw data for display
- **Navigation Integration**: Clickable rows that navigate to detail pages
- **Pagination Control**: Configurable page sizes appropriate for different data types

## Technical Implementation Notes

Each example page should be implemented as a Rails view that demonstrates:
1. Realistic data structure and content
2. Proper component composition and nesting
3. Responsive design patterns
4. Interactive states and feedback
5. Accessibility considerations
6. Real-world styling and layout patterns

These pages serve as both component showcases and implementation references for developers using the Decor library in production applications.