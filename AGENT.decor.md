# Decor UI Library - AI Agent Guidelines

## Overview

Decor is a comprehensive UI component library built with [Phlex](https://phlex.dev/), [Vident](https://github.com/stevegeek/vident) and styled with [daisyUI](https://daisyui.com/). This document provides AI agents with complete guidelines for effectively using Decor components.

## About Vident

Vident is a Ruby component library that provides type-safe, interactive web components with robust Stimulus.js integration. Vident documentation can be found at: https://raw.githubusercontent.com/stevegeek/vident/refs/heads/main/llm.txt

### Key Vident Features Used in Decor:
- **Type-safe property definitions** using the Literal gem (`prop :name, String, default: "value"`)
- **Declarative Stimulus integration** via `stimulus` blocks for interactive behavior
- **Intelligent CSS class management** with automatic Tailwind CSS class merging
- **Automatic Stimulus controller generation** (e.g., `ButtonComponent` → `button-component`)
- **Component caching mechanisms** for performance optimization
- **Scoped custom event handling** for component communication

## Literal Properties System

The Literal gem provides a robust property definition system for type-safe Ruby components. Full documentation: https://literal.fun/docs/properties.html

### Basic Property Definition
```ruby
class MyComponent
  extend Literal::Properties
  prop :name, String
  prop :age, Integer
  prop :enabled, _Boolean
end
```

Sets instance variables for each property.

### Property Types
- **Basic Types**: `String`, `Integer`, `Float`, `_Boolean`
- **Collections**: `_Array(String)`, `_Hash(String, Integer)`
- **Unions**: `_Union(:small, :medium, :large)` for enums
- **Nilable**: `_Nilable(String)` for optional properties
- **Complex Types**: Custom classes, modules, and interfaces, see full documentation for details.
- **Predicates**: `_Nilable(_String(_Predicate("present", &:present?)))`

### Default Values
```ruby
# Static defaults (frozen objects)
prop :status, String, default: "active".freeze

# Dynamic defaults (procs)
prop :created_at, Time, default: -> { Time.now }
prop :id, String, default: -> { SecureRandom.uuid }

# Conditional defaults
prop :theme, _Union(:light, :dark), default: -> { Rails.env.production? ? :light : :dark }
```

### Type Coercion
```ruby
# Transform input values
prop :age, Integer do |value|
  value.to_i
end
```

### Advanced Features
```ruby
# Optional properties (can be nil)
prop :description, _Nilable(String)

# Reader/writer visibility
prop :internal_id, String, reader: :private, writer: :protected
```

## Core Principles

### 1. Vident + Phlex-Based Components
- Components are Ruby objects extending `Vident::Phlex::HTML`, not templates
- Initialize with `ComponentName.new(<keyword arguments attributes>)`
- Render with `render component_instance`
- Use blocks for content: `render Component.new(...) do |c| ... end`
- Properties are defined with `prop :name, Type, default: value` for type safety, using the Literal gem
- Stimulus integration is declarative via `stimulus` blocks
- Base class `Decor::PhlexComponent` includes standardized concerns for size, color, and style handling

### 2. DaisyUI Styling System
- Use semantic attributes: `color: :primary`, `size: :lg`, `style: :outlined`
- Avoid custom CSS classes - leverage daisyUI's design system
- **Colors** (via ColorClasses concern): `:base`, `:primary`, `:secondary`, `:accent`, `:neutral`, `:success`, `:error`, `:warning`, `:info`
- **Sizes** (via SizeClasses concern): `:xs`, `:sm`, `:md`, `:lg`, `:xl`
  - Legacy aliases supported: `:small` → `:sm`, `:medium` → `:md`, `:large` → `:lg`, `:micro` → `:xs`, `:extra_small` → `:xs`, `:extra_large` → `:xl`
- **Styles** (via StyleClasses concern): Component-specific, commonly `:filled`, `:outlined`, `:ghost`
- **Note**: Some components use `variant` for backwards compatibility, but new components use `style`

### 3. Type-Safe Attribute Configuration
- Components are configured through type-safe Ruby properties using Vident's `prop` system
- Properties are validated at runtime using the Literal gem
- Always check component files for available properties and their types
- Use semantic attributes before `html_options: { class: "..." }`
- Properties support defaults, validation, and type coercion

### 4. CSS Class Management
- Use `classes:` parameter to **add** CSS classes to component defaults (additive)
- Use `html_options: { class: "..." }` to **override** all component-defined classes (destructive)
- **Recommended**: Use `classes:` for additional styling while preserving component defaults
- **Avoid**: Using `html_options: { class: }` unless you need to completely replace component classes

### 5. Standardized Concerns System
Decor uses three standardized concerns for consistent styling across components:

#### SizeClasses Concern
- Provides standardized size handling with `size` prop
- Standard sizes: `:xs`, `:sm`, `:md`, `:lg`, `:xl`
- Automatic alias support (e.g., `:small` → `:sm`)
- Components implement `component_size_classes(size)` for specific styling
- Helper methods: `icon_size_pixels`, `text_size_class`

#### ColorClasses Concern
- Provides standardized color handling with `color` prop
- Semantic colors: `:base`, `:primary`, `:secondary`, `:accent`, `:neutral`, `:success`, `:error`, `:warning`, `:info`
- Components implement `component_color_classes(color)` for specific styling
- Helper methods: `text_color_classes`, `background_color_classes`, `border_color_classes`

#### StyleClasses Concern
- Provides component-specific style variations with `style` prop
- Common styles: `:filled`, `:outlined`, `:ghost` (varies by component)
- Components implement `component_style_classes(style)` for specific styling
- Components can redefine available styles using `redefine_styles`

## AI Agent Usage Guidelines

### Component Selection Strategy
1. **Identify user intent** (show warning, create form, display data)
2. **Choose semantically appropriate components** from inventory below
3. **Use specific components** over generic divs (e.g., `Decor::Button` not `div` with click handler)

### Attribute Usage Priority
1. **Semantic attributes first**: `color`, `size`, `variant`, `disabled`
2. **Component-specific attributes**: `label`, `icon`, `required`
3. **Additional CSS classes**: `classes: "custom-class"` (additive to component defaults)
4. **HTML options last**: `html_options: { class: "custom-class" }` (overrides component classes)

### Common Attribute Patterns
- **Sizing**: `size: :xs | :sm | :md | :lg | :xl` (standardized via SizeClasses concern)
- **Coloring**: `color:` with semantic colors (standardized via ColorClasses concern)
- **Styling**: `style:` for component appearance (standardized via StyleClasses concern)
- **States**: `disabled: true`, `required: true`

## Complete Component Inventory

### Core Components (Decor::)

#### Interactive Elements
- **Button** - Interactive buttons with styles and states
  - Attributes: `label`, `icon`, `color`, `style`, `size`, `disabled`, `full_width`
  - Styles: `:contained`, `:outlined`, `:text` (via StyleClasses concern)
  - Colors: All semantic colors (via ColorClasses concern)
  - Sizes: All standard sizes (via SizeClasses concern)
  - Slots: `with_before_label`, `with_after_label`

- **ButtonLink** - Button-styled links
  - Inherits Button attributes + `href`, `http_method`, `turbo_frame`

- **Link** - Styled links with Turbo support
  - Attributes: `href`, `theme`, `size`, `variant`

#### Content Containers
- **Card** - Flexible content containers
  - Attributes: `title`, `image_url`, `image_position`, `size`, `color`, `style`
  - Sizes: All standard sizes (via SizeClasses concern)
  - Styles: `:bordered`, `:compact` (via StyleClasses concern)
  - Slots: `with_header`

- **Box** - Simple containers with title/description
  - Attributes: `title`, `size`, `style`
  - Sizes: All standard sizes (via SizeClasses concern)
  - Styles: `:bordered`, `:filled` (via StyleClasses concern)
  - Slots: `left`, `right`

- **Panel** - Information panels with icons
  - Attributes: `title`, `icon`, `size`, `style`
  - Sizes: All standard sizes (via SizeClasses concern)
  - Styles: `:bordered`, `:filled` (via StyleClasses concern)

- **PanelGroup** - Organized panel collections
  - Attributes: `title`, `description`, `size`, `color`, `style`
  - Sizes: All standard sizes (via SizeClasses concern)
  - Colors: All semantic colors (via ColorClasses concern)
  - Styles: Component-specific (via StyleClasses concern)
  - Methods: `panels`, `panel`, `cta`

#### Visual Elements
- **Avatar** - User avatars with images/initials
  - Attributes: `url`, `initials`, `shape`, `size`, `border`, `color`, `style`
  - Sizes: All standard sizes (via SizeClasses concern)
  - Shapes: `:circle`, `:square`

- **Badge** - Status indicators and labels
  - Attributes: `label`, `color`, `size`, `style`, `icon`, `dashed`
  - Colors: All semantic colors (via ColorClasses concern)
  - Sizes: All standard sizes (via SizeClasses concern)
  - Styles: `:filled`, `:outlined`, `:ghost` (via StyleClasses concern)

- **Tag** - Removable labels
  - Attributes: `label`, `icon`, `color`, `size`, `style`, `removable`
  - Colors: All semantic colors (via ColorClasses concern)
  - Sizes: All standard sizes (via SizeClasses concern)
  - Styles: Component-specific (via StyleClasses concern)

- **Icon** - SVG icons (Heroicons)
  - Attributes: `name`, `size`, `variant` (`:solid`, `:outline`, `:mini`)

- **SVG** - Custom SVG components
  - Attributes: `size`, `color`

- **Spinner** - Loading indicators
  - Attributes: `size`, `color`, `style`
  - Sizes: All standard sizes (via SizeClasses concern)
  - Colors: All semantic colors (via ColorClasses concern)
  - Styles: `:spinner`, `:dots`, `:ring`, `:ball`, `:bars`, `:infinity` (via StyleClasses concern)

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
  - Attributes: `size`, `color`, `style`, `position`, `trigger`, `force_open`
  - Sizes: All standard sizes (via SizeClasses concern)
  - Colors: All semantic colors (via ColorClasses concern)
  - Styles: Component-specific (via StyleClasses concern)
  - Methods: `trigger_button_content`, `menu_item`, `menu_header`, `card_content`

- **Tooltip** - Contextual help text
  - Attributes: `tip_text`, `position`, `size`, `color`, `style`
  - Sizes: All standard sizes (via SizeClasses concern)
  - Colors: All semantic colors (via ColorClasses concern)
  - Styles: `:filled`, `:outlined` (via StyleClasses concern)

- **ClickToCopy** - Copy-to-clipboard wrapper

#### Media & Content
- **Carousel** - Image/content sliders
  - Methods: `slide`, `with_items`

- **Map** - Google Maps integration
  - Attributes: `center`, `points`, advanced Google Maps options

#### Progress & Flow
- **Progress** - Progress indicators with steps
  - Attributes: `current_step`, `steps`, `color`, `size`, `style`, `show_numbers`, `vertical`
  - Style options: `:steps`, `:progress`, `:both`
  - Colors: All semantic colors (via ColorClasses concern)
  - Sizes: All standard sizes (via SizeClasses concern)

- **FlowStep** - Individual step indicators
  - Attributes: `title`, `description`, `step`, `icon`, `size`, `color`, `style`
  - Sizes: All standard sizes (via SizeClasses concern)
  - Styles: `:completed`, `:current`, `:pending` (via StyleClasses concern)

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

- **FlowStep** - Individual step indicators for multi-step processes
  - Attributes: `title`, `description`, `step`, `icon`, `size`, `color`, `variant`
  - Features: step numbering, progress indication, completion states

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
  - Inherits FormField + `choices`, `selected_choice`, `show_label`, `style`
  - Styles: `:contained`, `:outlined` (via StyleClasses concern)
  - Colors: All semantic colors (via ColorClasses concern)
  - Sizes: All standard sizes (via SizeClasses concern)

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
  - Attributes: `links`, `size`, `color`, `style`
  - Sizes: All standard sizes (via SizeClasses concern)
  - Colors: All semantic colors (via ColorClasses concern)
  - Styles: `:boxed`, `:lifted` (via StyleClasses concern)
  - Features: icons, badges, mobile responsive, disabled states

#### Search & Utility
- **SearchResultsDropdown** - Search results display
- **SearchAndFilter** - Search and filter controls
  - Attributes: `url`, `filters`, `search`, `download_path`
  - Classes: `Filter`, `Search` with apply methods
  - Methods: `actions`, `with_actions`, `filters`, `with_filters`

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
  - Slots: `with_hero`, `with_header`, `with_cta`, `with_tabs`, `with_badge`, `with_tag`

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

### Modal Components (Decor::Modals::)

- **Modal** - Base modal dialog
  - Attributes: `initial_content`, `content_href`, `start_shown`, `close_on_overlay_click`

- **ModalLayout** - Structured modal layout
  - Attributes: `title`, `description`, `icon`, `color`, `style`, `size`
  - Colors: All semantic colors (via ColorClasses concern)
  - Sizes: `:sm`, `:md`, `:lg`, `:xl` (via SizeClasses concern)
  - Styles: `:default`, `:full_height` (via StyleClasses concern)
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

### Modals and Notifications

To use modals and the notification system, you need to render their main components in your layout or application view, so they can be used anywhere in your app.

For example, before closing the body tag in your layout file (e.g., `application.html.erb`), you can add:

```erb
  <%= render ::Decor::Modals::Modal.new %>
    <%= render ::Decor::Modals::ConfirmModal.new %>
    <%= render ::Decor::NotificationManager.new(
      stimulus_values: {
        initial_notifications: [notice, alert].compact.map do |message|
          {content: {content: render(::Decor::Notification.new(title: message)), __safe: true}}
        end
      }
    ) %>
```

### 1. Buttons & Links

```ruby
# Action button
render Decor::Button.new(
  label: "Save Changes",
  color: :primary,
  style: :contained,
  icon: "check"
)

# Action button with additional CSS classes (additive)
render Decor::Button.new(
  label: "Save Changes",
  color: :primary,
  style: :contained,
  icon: "check",
  classes: "shadow-lg custom-spacing"
)

# Navigation link styled as button
render Decor::ButtonLink.new(
  label: "Go to Dashboard",
  href: "/dashboard",
  color: :secondary,
  style: :outlined
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

  # Page content
end
```

### 5. Modals

```ruby
# Modal trigger button
render Decor::Modals::ModalOpenButton.new(
  label: "Delete User",
  modal_id: "confirm-delete",
  color: :danger,
  style: :outlined
)

# Modal with structured layout
render Decor::Modals::ModalLayout.new(
  title: "Confirm Deletion",
  description: "This action cannot be undone",
  icon: "exclamation-triangle",
  color: :error
) do |modal|
  modal.with_footer do
    render Decor::Button.new(label: "Cancel", style: :ghost)
    render Decor::Button.new(label: "Delete", color: :danger)
  end
end
```

### 6. Feedback & Alerts

```ruby
# Flash message
render Decor::Flash.new(
  style: :success,
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
- **Leverage standardized concerns**: Components automatically handle size/color/style via concerns

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

## Vident + Phlex Component Optimization Patterns

### Single Element Components
- Use `root_element` directly with `element_classes` rather than adding another element inside root_element's block
- Example: `root_element` (classes applied to root) vs `root_element do; span(class: "..."); end` (extra nested element)
- Vident components use `root_element` method instead of `parent_element`
- **Note**: You call `root_element` directly, not `render root_element`

### Type-Safe Property Definitions
- Always use `prop :name, Type, default: value` for component properties
- Use Literal gem types: `String`, `Integer`, `_Boolean`, `_Array`, `_Hash`, etc.
- Example: `prop :size, _Union[:xs, :sm, :md, :lg, :xl], default: :md`
- Properties are automatically validated and provide better error messages

### Stimulus Integration
- Use `stimulus` blocks for declarative Stimulus controller configuration
- Controllers are automatically named based on component class (e.g., `ButtonComponent` → `button-component`)
- Use `stimulus_data_attributes` method to generate proper data attributes
- Example:
  ```ruby
  stimulus do
    actions [:click, :handle_click], :another_handler, -> { [:click, :handle_click_again] if handle_again? }
    targets :label, -> { :my_conditional_target if condition? }
    outlets my_outlet: MyComponent.stimulus_identifier
    values enabled: false, random_num: -> { rand }
    classes my_name: "my-class", another_name: "another-class"
  end
  ```

Set stimulus attributes at the render site too, and nested components can setup their attributes from the parent component's stimulus attributes
using helper methods like `stimulus_targets`, `stimulus_actions`, and `stimulus_values`.

```ruby
root_element do |el|
  render Decor::Button.new(
    label: "Click Me",
    stimulus_targets: [stimulus_target(:label)], # sets button as a target for outer components controller
    stimulus_actions: [el.stimulus_action(:click, :handle_click)], # sets button click to call method on outer components controller, note you can be explicit about calling on the instance of the outer element (`el` here)
    stimulus_values: {
      my_value: "some value",
      another_value: -> { "dynamic value" } # can be a proc for dynamic values
    },
    stimulus_outlets: {
      my_outlet: Decor::Button.stimulus_identifier # sets up the outlet for this button component
    },
    stimulus_classes: {
      loading: "loading", # sets up the stimulus class with the name "loading"
      fetch_error: "bg-red-500"
    }
  )
end
```

### Memory Notes
- Do not use OpenStruct in tests or anywhere
- For SVG `path`s in phlex do `svg(...) do |s| s.path(...) end`

### Rendering Lookbook Previews
- When creating lookbook previews, blocks passed to rendered components need to call methods on the component, eg `do |component| component.render...` or `component.div(...)`

### Size System
- **Current**: Components support both legacy naming (`micro`) and standardized naming (`xs`) via SizeClasses concern
- **Recommendation**: Use standardized DaisyUI sizes (`:xs`, `:sm`, `:md`, `:lg`, `:xl`)
- **Automatic Aliasing**: The SizeClasses concern automatically handles legacy aliases:
  - `:small` → `:sm`
  - `:medium` → `:md`
  - `:large` → `:lg`
  - `:micro` → `:xs`
  - `:extra_small` → `:xs`
  - `:extra_large` → `:xl`

### Testing Infrastructure
- **Framework**: Comprehensive test suite with Minitest
- **Coverage**: Unit tests for component rendering and behavior
- **Lookbook**: Preview system for component development
- **No OpenStruct**: Avoid using OpenStruct in tests or component code

### Performance Considerations
- **Caching**: Vident provides built-in component caching mechanisms
- **CSS**: Intelligent Tailwind CSS class merging reduces redundant classes
- **Stimulus**: Lazy-loaded controllers for better performance

### Best Practices Summary
1. **Use type-safe properties** with Literal gem types
2. **Leverage Vident's Stimulus DSL** for interactive behavior
3. **Follow DaisyUI conventions** for consistent styling
4. **Prefer semantic attributes** over custom CSS classes
5. **Use `root_element`** for single-element components
6. **Test components thoroughly** with behavior-focused tests

## Implementing Components with Concerns

When creating new components or understanding existing ones:

### 1. Including Concerns
Most Decor components inherit from `Decor::PhlexComponent` which automatically includes:
```ruby
class Decor::PhlexComponent < Vident::Phlex::HTML
  include Decor::Concerns::SizeClasses
  include Decor::Concerns::ColorClasses
  include Decor::Concerns::StyleClasses
end
```

### 2. Implementing Concern Methods
Components customize behavior by implementing these methods:

```ruby
# Size handling
def component_size_classes(size)
  case size
  when :xs then "btn-xs"
  when :sm then "btn-sm"
  when :md then "btn-md"
  when :lg then "btn-lg"
  when :xl then "btn-xl"
  end
end

# Color handling
def component_color_classes(color)
  case color
  when :primary then "btn-primary"
  when :secondary then "btn-secondary"
  # etc.
  end
end

# Style handling
def component_style_classes(style)
  case style
  when :contained then "btn-contained"
  when :outlined then "btn-outlined"
  when :text then "btn-text"
  end
end
```

### 3. Customizing Available Options
Components can redefine what values are valid:

```ruby
class MyComponent < Decor::PhlexComponent
  # Limit to specific sizes
  redefine_sizes :sm, :md, :lg
  
  # Add custom colors
  redefine_colors :primary, :secondary, :danger, :custom
  
  # Define component-specific styles
  redefine_styles :minimal, :bold, :rounded
  
  # Set defaults
  default_size :md
  default_color :primary
  default_style :minimal
end
```

### 4. Using Concern Helpers
The concerns provide helper methods:

```ruby
# In component implementation
def render
  root_element(class: [
    size_classes,           # Calls component_size_classes with normalized size
    color_classes,          # Calls component_color_classes if valid
    style_classes,          # Calls component_style_classes if valid
    text_size_class,        # Helper for text sizing
    background_color_classes # Helper for backgrounds
  ]) do
    # Component content
  end
end
```

### 5. Size Normalization
The SizeClasses concern automatically handles aliases:
```ruby
# User provides: size: :small
# normalize_size(:small) returns :sm
# component_size_classes(:sm) is called
```

This comprehensive guide should enable AI agents to effectively use the Decor UI library with confidence and consistency.