# Decor UI Library - AI Agent Guidelines

## Overview

Decor is a comprehensive UI component library built with [Phlex](https://phlex.dev/), [Vident](https://github.com/stevegeek/vident) and styled with [daisyUI](https://daisyui.com/). This document provides AI agents with complete guidelines for effectively using Decor components.

## Core Principles

### 1. Phlex-Based Components
- Components are Ruby objects, not templates
- Initialize with `ComponentName.new(attributes)`
- Render with `render component_instance`
- Use blocks for content: `render Component.new(...) do |c| ... end`

### 2. DaisyUI Styling System
- Use semantic attributes: `color: :primary`, `size: :lg`, `variant: :outlined`
- Avoid custom CSS classes - leverage daisyUI's design system
- Colors: `:primary`, `:secondary`, `:accent`, `:success`, `:error`, `:warning`, `:info`, `:neutral`, `:base`
- Sizes: `:xs`, `:sm`, `:md`, `:lg`, `:xl`

### 3. Attribute-Driven Configuration
- Components are configured through rich Ruby attributes
- Always check component files for available attributes
- Use semantic attributes before `html_options: { class: "..." }`

## AI Agent Usage Guidelines

### Component Selection Strategy
1. **Identify user intent** (show warning, create form, display data)
2. **Choose semantically appropriate components** from inventory below
3. **Use specific components** over generic divs (e.g., `Decor::Button` not `div` with click handler)

### Attribute Usage Priority
1. **Semantic attributes first**: `color`, `size`, `variant`, `disabled`
2. **Component-specific attributes**: `label`, `icon`, `required`
3. **HTML options last**: `html_options: { class: "custom-class" }`

### Common Attribute Patterns
- **Sizing**: `size: :xs | :sm | :md | :lg | :xl`
- **Coloring**: `color:` or `style:` with semantic colors
- **Variants**: `variant: :filled | :outlined | :ghost | :text | :contained`
- **States**: `disabled: true`, `required: true`

## Complete Component Inventory

### Core Components (Decor::)

#### Interactive Elements
- **Button** - Interactive buttons with variants and states
  - Attributes: `label`, `icon`, `color`, `variant`, `size`, `disabled`, `full_width`
  - Variants: `:contained`, `:outlined`, `:text`
  - Slots: `with_before_label`, `with_after_label`

- **ButtonLink** - Button-styled links
  - Inherits Button attributes + `href`, `http_method`, `turbo_frame`

- **Link** - Styled links with Turbo support
  - Attributes: `href`, `theme`, `size`, `variant`

#### Content Containers
- **Card** - Flexible content containers
  - Attributes: `title`, `image_url`, `image_position`, `size`, `color`, `variant`
  - Slots: `with_header`

- **Box** - Simple containers with title/description
  - Attributes: `title`
  - Slots: `left`, `right`

- **Panel** - Information panels with icons
  - Attributes: `title`, `icon`

- **PanelGroup** - Organized panel collections
  - Attributes: `title`, `description`, `size`, `color`, `variant`
  - Methods: `panels`, `panel`, `cta`

#### Visual Elements
- **Avatar** - User avatars with images/initials
  - Attributes: `url`, `initials`, `shape`, `size`, `border`, `color`, `variant`

- **Badge** - Status indicators and labels
  - Attributes: `label`, `style`, `size`, `variant`, `icon`, `dashed`

- **Tag** - Removable labels
  - Attributes: `label`, `icon`, `color`, `size`, `variant`, `removable`

- **Icon** - SVG icons (Heroicons)
  - Attributes: `name`, `size`, `variant` (`:solid`, `:outline`, `:mini`)

- **SVG** - Custom SVG components
  - Attributes: `size`, `color`

- **Spinner** - Loading indicators
  - Attributes: `size`, `color`

#### Feedback & Alerts
- **Banner** - Large alert messages
  - Attributes: `style`, `icon`, `link`, `centered`
  - Styles: `:warning`, `:info`, `:error`, `:notice`, `:success`

- **Flash** - Flash messages
  - Attributes: `variant`, `title`, `text`, `preserve_flash`, `collapse_if_empty`

- **Notification** - Toast notifications
  - Attributes: `title`, `description`, `icon`, `color`, `action_buttons`
  - Slots: `avatar`

- **NotificationManager** - Notification container

#### Interactive UI
- **Dropdown** - Contextual menus
  - Attributes: `size`, `color`, `variant`, `position`, `trigger`, `force_open`
  - Methods: `trigger_button_content`, `menu_item`, `menu_header`, `card_content`

- **Tooltip** - Contextual help text
  - Attributes: `tip_text`, `position`, `size`, `color`, `variant`

- **ClickToCopy** - Copy-to-clipboard wrapper

#### Media & Content
- **Carousel** - Image/content sliders
  - Methods: `slide`, `with_items`

- **Map** - Google Maps integration
  - Attributes: `center`, `points`, advanced Google Maps options

#### Progress & Flow
- **Progress** - Progress indicators with steps
  - Attributes: `current_step`, `steps`, `color`, `size`, `variant`, `show_numbers`, `vertical`

- **FlowStep** - Individual step indicators
  - Attributes: `title`, `description`, `step`, `icon`, `size`, `color`, `variant`

#### Utility
- **Element** - Generic Stimulus wrapper
  - Attributes: `stimulus_controller`

- **FormattedEncodedId** - Display formatted IDs
  - Attributes: `encoded_id`, `prefix`

- **SwitchingBox** - State-switching containers (extends Box)
  - Attributes: `property_name`, `model`, `url`, `http_method`, `switch_options`

- **Toggle** - Simple toggle component
  - Attributes: `property_name`, `model`, `url`, `http_method`, `switch_options`

- **Title** - Page and section titles
  - Attributes: `title`, `description`, `size`

### Form Components (Decor::Forms::)

#### Base Form Infrastructure
- **ActionViewFormBuilder** - Custom Rails form builder (recommended for Rails apps)
  - Use with: `form_with model: @user, builder: Decor::Forms::ActionViewFormBuilder`
  - Methods: `text_field`, `email_field`, `select`, `check_box`, `switch`, `submit_primary`, etc.
  - Automatically handles model binding, validation errors, and Decor styling

- **Form** - Form wrapper with Stimulus integration (for non-Rails forms)
  - Attributes: `model`, `namespace`, `form_builder_class`, UJS/Turbo handlers

- **FormField** - Base class for form fields (inherited by all form components)
  - **Common Attributes**: `name`, `label`, `description`, `placeholder`, `required`, `disabled`, `helper_text`, `error_messages`, `color`, `size`
  - **Layout**: `label_position`, `grid_span`, `compact`, `floating_error_text`
  - **Validation**: `validations`, `validation_messages`, `autocomplete`
  - **Stimulus**: `control_actions`, `control_targets`, `control_html_options`

#### Text Input Components
- **TextField** - Text input with add-ons
  - Inherits FormField + `type`, `leading_text_add_on`, `trailing_text_add_on`, `leading_icon_name`, `trailing_icon_name`

- **TextArea** - Multi-line text input
  - Inherits FormField + `rows`

- **NumberField** - Number input with validation
  - Inherits FormField + number-specific attributes

- **HiddenField** - Hidden form fields
  - Attributes: `name`, `value`

#### Selection Components
- **Select** - Dropdown selection
  - Inherits FormField + `options`, `include_blank_option`, `grouped` support

- **Checkbox** - Checkbox input
  - Inherits FormField + `checked`, checkable-specific styling

- **Radio** - Radio button input
  - Inherits FormField + `value`, radio-specific styling

- **ButtonRadioGroup** - Radio buttons as button group
  - Inherits FormField + `choices`, `selected_choice`, `show_label`, `variant`

- **Switch** - Toggle switch with auto-submit
  - Inherits FormField + `submit_on_change`, `confirm_on_submit`

#### Advanced Input Components
- **DateCalendar** - Advanced calendar picker
  - Inherits FormField + `calendar_type`, `min_date`, `max_date`, `months`, `first_day_of_week`, `locale`, date filtering options

- **FileUpload** - File upload with preview
  - Inherits FormField + `variant`, `preview_layout`, `file_mime_types`, `aspect_w/h`, `existing_file_url`, `initials`, `shape`

- **ExpandingCheckboxCollection** - Checkbox collections with show more
  - Inherits FormField + `hide_after_showing`, collection management
- **FormFieldLayout** - Field layout wrapper
  - Attributes: `label_position`, layout and styling options

- **LayoutContainer** - Form layout container
#### Form Layout Components

- **LayoutSection** - Form section wrapper
  - Attributes: `title`
- **HelperTextSection** - Helper text display
  - Attributes: `helper_text`, `error_messages`

- **ErrorIconSection** - Error icon display
  - Attributes: `error_messages`

### Data Display Components

#### Tables
- **Tables::DataTable** - Feature-rich tables
  - Attributes: `title`, `subtitle`, `variant`, `compact`, `pin_cols`, `striped`, `zebra`
  - Features: sortable columns, selectable rows, expandable content, DaisyUI styling
  - Slots: `with_search_and_filter`, `with_data_table_footer`

- **Tables::DataTableBuilder** - Advanced table builder (subclass for reusable tables)
  - Attributes: `query`, `title`, `paginated`, `rows_selectable_as_name`, `alternating`, `hover_highlight`
  - Methods: `column`, `with_cta`
  - **Overridable methods**: `title`, `default_sort_by`, `default_sort_direction`, `default_page_size`, `query`, `pagination_options`, `transform_row`, `path_for_row`, `row_attributes`, `row_highlight`, `filters`, `sorting`, `search`
  - Advanced features: search/filter integration, download functionality, nested forms

- **Tables::DataTableHeaderRow** - Table header row
- **Tables::DataTableRow** - Table data row
- **Tables::DataTableCell** - Table cell
- **Tables::DataTableHeaderCell** - Table header cell
- **Tables::DataTableFooter** - Table footer with summary

#### Data Presentation
- **Pagination** - Page navigation
  - Attributes: `current_page`, `page_size`, `total_count`, `path`
  - Features: responsive design, page size selector, high page number handling

- **Stats** - Statistics container
- **Stat** - Individual statistic
  - Attributes: `title`, `value`, `description`
  - Slots: `figure`, `actions`

- **Tabs** - Tabbed interfaces
  - Attributes: `links`, `size`, `color`, `variant`
  - Features: icons, badges, mobile responsive, disabled states

### Navigation Components (Decor::Nav::)

#### Primary Navigation
- **SideNavbar** - Responsive sidebar navigation
  - Attributes: `landscape_logo_url`, `avatar_logo_url`, `menu_items`, `collapsed`
  - Methods: `with_section` → `with_item` (use `path` not `href`)
  - Features: collapsible, search, hierarchical menu, active states

- **SideNavbarSection** - Sidebar sections
  - Attributes: `title`
  - Methods: `with_item`

- **SideNavbarItem** - Sidebar menu items
  - Attributes: `title`, `path`, `icon`, navigation attributes
  - Methods: `with_sub_item`

- **SideNavbarSubItem** - Sidebar sub-items

- **TopNavbar** - Top navigation bars
  - Methods: `with_brand`, `with_nav_items`, `with_account_menu`, `with_notifications_menu`

- **SecondaryNavbar** - Secondary navigation
  - Methods: `with_left`, `with_center`, `with_right`

#### Page Structure
- **Page** - Page layout component
  - Attributes: `title`, `size`, `background`, `padding`, `spacing`, `full_height`
  - Slots: `with_hero`, `with_header`, `with_cta`, `with_tabs`, `with_body`, `with_badge`, `with_tag`

- **PageHeader** - Flexible page headers
  - Attributes: `title`, `subtitle`, `layout`, `size`, `background`
  - Layouts: `:default`, `:centered`, `:minimal`, `:hero`, `:compact`
  - Slots: `with_avatar`, `with_title_content`, `with_meta_content`, `with_actions`, `with_breadcrumbs`, `with_status`

- **PageSection** - Page section separators
  - Attributes: `title`, `description`, `size`, `background`, `padding`

#### Footer & Breadcrumbs
- **Footer** - Comprehensive footers
  - Attributes: `company_name`, `link_groups`, `social_links`

- **CompactFooter** - Simple footers
  - Slots: `with_logo`, `with_links`, `with_copyright`

- **Breadcrumbs** - Navigation breadcrumbs
  - Attributes: `breadcrumbs` array with `title`, `href`
  - Features: mobile-friendly select dropdown

#### Search & Utility
- **SearchResultsDropdown** - Search results display
- **SearchAndFilter** - Search and filter controls
  - Attributes: `url`, `filters`, `search`, `download_path`
  - Classes: `Filter`, `Search` with apply methods
  - Methods: `actions`, `with_actions`, `filters`, `with_filters`

### Modal Components (Decor::Modals::)

- **Modal** - Base modal dialog
  - Attributes: `initial_content`, `content_href`, `start_shown`, `close_on_overlay_click`

- **ModalLayout** - Structured modal layout
  - Attributes: `title`, `description`, `icon`, `color`, `variant`, `size`
  - Slots: `with_header`, `with_body`, `with_footer`

- **ConfirmModal** - Confirmation dialogs
  - Extends Modal (no custom title/message parameters)

- **ModalOpenButton** - Modal trigger button
  - Extends Button + `modal_id`, `initial_content`, `content_href`

- **ModalCloseButton** - Modal close button
  - Extends Button + `close_reason`

### Chat Components (Decor::Chat::)

- **List** - Chat message container
  - Methods: message management, empty states

- **ListMessage** - Individual chat messages
  - Attributes: `message`, `incoming`, `author_name`, `author_profile_image_url`, `author_initials`, `is_current_user`, `footer_text`, `localised_created_at`
  - Slots: `attachment`

## Key Usage Patterns

### 1. Buttons & Links

```ruby
# Action button
render Decor::Button.new(
  label: "Save Changes",
  color: :primary,
  variant: :contained,
  icon: "check"
)

# Navigation link styled as button
render Decor::ButtonLink.new(
  label: "Go to Dashboard",
  href: "/dashboard",
  color: :secondary,
  variant: :outlined
)

# Simple link
render Decor::Link.new(href: "/page", theme: :primary) { "Link text" }
```

### 2. Forms

**Rails Applications - Use Form Builder (Recommended)**

```ruby
# Rails form with Decor's custom ActionView form builder
<%= form_with model: @user, builder: Decor::Forms::ActionViewFormBuilder do |form| %>
  <%= form.text_field :name, label: "Full Name", required: true %>
  <%= form.email_field :email, label: "Email Address", required: true %>
  <%= form.select :role, [["Admin", "admin"], ["User", "user"]], label: "Role" %>
  <%= form.switch :notifications, label: "Enable Notifications" %>
  <%= form.submit_primary "Save User" %>
<% end %>

# Available form builder methods:
# text_field, email_field, password_field, number_field, text_area
# select, collection_select, grouped_collection_select
# check_box, radio_button, collection_radio_buttons, button_radio_group
# switch, switch_and_submit
# file_field, image_upload, avatar_upload
# date_field, hidden_field
# button, button_link_to, submit, submit_primary
```

**Direct Component Rendering (Only when outside Rails forms)**

```ruby
# Only use direct component rendering when NOT in a Rails form
render Decor::Forms::TextField.new(
  name: "search_query",
  label: "Search",
  placeholder: "Enter search terms...",
  required: false
)

# Form wrapper for non-model forms
render Decor::Forms::Form.new do |form|
  render Decor::Forms::LayoutSection.new(title: "Search Filters") do
    render Decor::Forms::TextField.new(name: "query", label: "Search")
    render Decor::Forms::Select.new(name: "category", label: "Category", options: [["All", ""]])
  end
end
```

### 3. Data Tables

**Custom Table Subclass (Recommended)**

```ruby
# Create a custom table class by subclassing DataTableBuilder
class UsersTable < Decor::Tables::DataTableBuilder
  def title
    "User Management"
  end

  def default_sort_by
    :created_at
  end

  def default_sort_direction
    :desc
  end

  def default_page_size
    25
  end

  def query
    User.includes(:role)
  end

  def pagination_options
    {
      path: users_path
    }
  end

  def transform_row(user, index, item_index)
    # Transform data before display
    user.display_name = "#{user.first_name} #{user.last_name}"
    user
  end

  def path_for_row(user, transformed_user, index, item_index)
    user_path(user)
  end

  def row_attributes(user, transformed_user, index, item_index)
    user.active? ? {} : { highlight: :low }
  end
end

# Use the custom table in your view
render UsersTable.new({}, params, helpers) do |table|
  table.column :display_name, "Name", sortable: true
  table.column :email, "Email", sortable: true
  table.column :role, "Role" do |user|
    user.role.name
  end
  table.column :created_at, "Joined" do |user|
    user.created_at.strftime("%B %d, %Y")
  end
end
```

**Direct DataTableBuilder Usage (For quick one-off tables)**

```ruby
# Simple table
render Decor::Tables::DataTable.new(title: "Users") do |table|
  table.with_data_table_header_row do |header|
    header.with_data_table_header_cell(content: "Name")
    header.with_data_table_header_cell(content: "Email")
  end
  
  @users.each do |user|
    table.with_data_table_row do |row|
      row.with_data_table_cell(content: user.name)
      row.with_data_table_cell(content: user.email)
    end
  end
end

# Inline builder usage
render Decor::Tables::DataTableBuilder.new(
  query: @users,
  title: "Users",
  paginated: true
) do |builder|
  builder.column :name, "Full Name"
  builder.column :email, "Email Address"
  builder.column :created_at, "Joined" do |user|
    user.created_at.strftime("%B %d, %Y")
  end
end
```

### 4. Navigation

```ruby
# Sidebar navigation (use 'path' not 'href')
render Decor::Nav::SideNavbar.new(
  landscape_logo_url: "/logo.png",
  avatar_logo_url: "/avatar.png"
) do |navbar|
  navbar.with_section(title: "Main") do |section|
    section.with_item(title: "Dashboard", path: dashboard_path, icon: "home")
    section.with_item(title: "Users", path: users_path, icon: "users")
  end
  
  navbar.with_section(title: "Admin") do |section|
    section.with_item(title: "Settings", path: settings_path, icon: "cog")
  end
end

# Page with header
render Decor::Page.new(title: "Dashboard") do |page|
  page.with_header do
    render Decor::PageHeader.new(
      title: "Dashboard",
      subtitle: "Welcome back",
      layout: :default
    ) do |header|
      header.with_actions do
        render Decor::Button.new(label: "New Item", color: :primary)
      end
    end
  end
  
  page.with_body do
    # Page content
  end
end
```

### 5. Modals

```ruby
# Modal trigger button
render Decor::Modals::ModalOpenButton.new(
  label: "Delete User",
  modal_id: "confirm-delete",
  color: :danger,
  variant: :outlined
)

# Modal with structured layout
render Decor::Modals::ModalLayout.new(
  title: "Confirm Deletion",
  description: "This action cannot be undone",
  icon: "exclamation-triangle",
  color: :error
) do |modal|
  modal.with_footer do
    render Decor::Button.new(label: "Cancel", variant: :text)
    render Decor::Button.new(label: "Delete", color: :danger)
  end
end
```

### 6. Feedback & Alerts

```ruby
# Flash message
render Decor::Flash.new(
  variant: :success,
  title: "Success!",
  text: "Your changes have been saved."
)

# Banner
render Decor::Banner.new(
  style: :warning,
  icon: "exclamation-triangle",
  centered: true
) do
  "Scheduled maintenance tonight from 2-4 AM EST"
end

# Notification with actions
render Decor::Notification.new(
  title: "New Message",
  description: "You have received a new message",
  color: :info,
  action_buttons: [
    {label: "View", href: "/messages", primary: true},
    {label: "Dismiss", action_name: "dismiss"}
  ]
)
```

## Best Practices for AI Agents

### 1. Component Selection
- **Use semantic components**: `Decor::Button` for actions, `Decor::ButtonLink` for navigation
- **Choose appropriate form fields**: `TextField` for text, `Select` for dropdowns, `Switch` for toggles
- **Use builders for complex data**: `DataTableBuilder` for sortable/filterable tables

### 2. Attribute Usage
- **Start with semantic attributes**: `color: :primary` before custom classes
- **Use consistent sizing**: Stick to `:xs`, `:sm`, `:md`, `:lg`, `:xl`
- **Leverage variants**: `:filled`, `:outlined`, `:ghost` for different styles

### 3. Form Patterns
- **Use Rails form builder** for model-backed forms: `form_with model: @user, builder: Decor::Forms::ActionViewFormBuilder`
- **Direct component rendering** only for standalone fields outside Rails forms
- **Always set `name` attribute** when using direct component rendering
- **Use `required: true`** for required fields
- **Provide helpful `label` and `placeholder`** text
- **Group related fields** with `LayoutSection`

### 4. Navigation Patterns
- **Use `path` not `href`** for SideNavbar items
- **Structure navigation hierarchically** with sections and items
- **Provide icons** for better UX

### 5. Data Display
- **Subclass DataTableBuilder** for reusable tables with custom logic
- **Use direct DataTableBuilder** only for simple, one-off tables
- **Override methods** like `default_sort_by`, `query`, `transform_row` for custom behavior
- **Enable pagination** for large datasets: `paginated: true`
- **Add search/filter** for better UX

### 6. Error Handling
- **Use Flash components** for user feedback
- **Set appropriate `variant`** (`:success`, `:error`, `:warning`)
- **Provide clear, actionable messages**

## Phlex Component Optimization Patterns

### Single Element Components
- Use `render parent_element` directly with `element_classes` rather than adding another element inside parent_element's block
- Example: `render parent_element` (classes applied to parent) vs `render parent_element do; span(class: "..."); end` (extra nested element)

### Memory Notes
- Remember that parent_element takes element_classes, so if you just need to style one element, use that combo, like in Spinner, rather than adding another element to parent_elements block
- Do not use OpenStruct in tests or anywhere
- For SVG `path`s in phlex do `svg(...) do |s| s.path(...) end`

### Rendering Lookbook Previews
- When creating lookbook previews, blocks passed to rendered components need to call methods on the component, eg `do |component| component.render...` or `component.div(...)`

This comprehensive guide should enable AI agents to effectively use the Decor UI library with confidence and consistency.