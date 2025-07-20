# @label SecondaryNavbar
class ::Decor::Nav::SecondaryNavbarPreview < ::Lookbook::Preview
  # Page::SecondaryNavbar
  # -------
  #
  # The SecondaryNavbar is a flexible navigation component for sub-pages and contextual navigation.
  # It provides left, center, and right content areas with DaisyUI styling and responsive design.
  #
  # @label Playground
  # @param variant select [narrow, wide]
  # @param has_left_element toggle
  # @param has_center_element toggle
  # @param has_right_element toggle
  # @param has_bottom_border toggle
  def playground(variant: :narrow, has_left_element: true, has_center_element: true, has_right_element: true, has_bottom_border: false)
    render ::Decor::Nav::SecondaryNavbar.new(
      variant: variant,
      bottom_border: has_bottom_border
    ) do |navbar|
      if has_left_element
        navbar.with_left do
          render ::Decor::Nav::Breadcrumbs.new(
            breadcrumbs: [
              {name: "Home", path: "/"},
              {name: "Products", path: "/products"},
              {name: "Electronics", path: "/products/electronics"}
            ]
          )
        end
      end

      if has_center_element
        navbar.with_center do
          render ::Decor::Element.new(root_element_attributes: {element_tag: :span, html_root_element_attributes: {class: "text-sm font-medium text-base-content"}}) do
            "Secondary Navigation Center"
          end
        end
      end

      if has_right_element
        navbar.with_right do
          render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "flex gap-2"}}) do
            render ::Decor::Button.new(label: "Action", size: :sm, variant: :outlined)
            render ::Decor::Button.new(label: "Primary", size: :sm)
          end
        end
      end
    end
  end

  # @!group DaisyUI Examples

  # @label DaisyUI Secondary Navigation
  def daisyui_styling
    render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "space-y-6"}}) do
      # Wide variant with border
      render ::Decor::Nav::SecondaryNavbar.new(variant: :wide, bottom_border: true) do |navbar|
        navbar.with_left do
          render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "flex items-center gap-3"}}) do
            render ::Decor::Element.new(root_element_attributes: {element_tag: :h1, html_root_element_attributes: {class: "text-lg font-semibold text-base-content"}}) do
              "Dashboard Overview"
            end
            render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "badge badge-primary badge-sm"}}) do
              "New"
            end
          end
        end

        navbar.with_right do
          render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "flex items-center gap-2"}}) do
            render ::Decor::Button.new(label: "Export", size: :sm, variant: :outlined, icon: "download")
            render ::Decor::Button.new(label: "Settings", size: :sm, icon: "cog")
          end
        end
      end

      # Narrow variant with breadcrumbs
      render ::Decor::Nav::SecondaryNavbar.new(variant: :narrow, bottom_border: true) do |navbar|
        navbar.with_left do
          render ::Decor::Nav::Breadcrumbs.new(
            breadcrumbs: [
              {name: "Analytics", path: "/analytics"},
              {name: "Reports", path: "/analytics/reports"},
              {name: "Monthly", path: "/analytics/reports/monthly"}
            ]
          )
        end

        navbar.with_center do
          render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "tabs tabs-boxed"}}) do
            render ::Decor::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "tab tab-active"}}) { "Overview" }
            render ::Decor::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "tab"}}) { "Details" }
            render ::Decor::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "tab"}}) { "Charts" }
          end
        end

        navbar.with_right do
          render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "dropdown dropdown-end"}}) do
            render ::Decor::Element.new(root_element_attributes: {element_tag: :button, html_root_element_attributes: {class: "btn btn-sm btn-ghost", tabindex: "0"}}) do
              render ::Decor::Icon.new(name: "chevron-down", html_root_element_attributes: {class: "h-4 w-4 ml-1"})
            end
          end
        end
      end

      # DaisyUI feature explanation
      render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "alert alert-info"}}) do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :div}) do
          strong { "DaisyUI Features:" }
          ul(class: "list-disc list-inside mt-2 space-y-1") do
            li { code(class: "bg-base-200 px-2 py-1 rounded text-sm") { "navbar" } + " base component with semantic structure" }
            li { code(class: "bg-base-200 px-2 py-1 rounded text-sm") { "bg-base-100" } + " for consistent theming" }
            li { code(class: "bg-base-200 px-2 py-1 rounded text-sm") { "border-base-300" } + " for semantic borders" }
            li { code(class: "bg-base-200 px-2 py-1 rounded text-sm") { "badge-primary" } + " and " + code(class: "bg-base-200 px-2 py-1 rounded text-sm") { "tabs-boxed" } + " for content elements" }
          end
        end
      end
    end
  end

  # @label Breadcrumb Navigation
  def with_breadcrumbs
    render ::Decor::Nav::SecondaryNavbar.new(variant: :narrow, bottom_border: true) do |navbar|
      navbar.with_left do
        render ::Decor::Nav::Breadcrumbs.new(
          breadcrumbs: [
            {name: "E-commerce", path: "/"},
            {name: "Products", path: "/products"},
            {name: "Categories", path: "/products/categories"},
            {name: "Electronics", path: "/products/categories/electronics"},
            {name: "Laptops", path: "/products/categories/electronics/laptops"}
          ]
        )
      end

      navbar.with_right do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "flex items-center gap-1"}}) do
          render ::Decor::Button.new(label: "Edit", size: :sm, variant: :outlined, icon: "pencil")
          render ::Decor::Button.new(label: "Add Product", size: :sm, icon: "plus")
        end
      end
    end
  end

  # @label Action Toolbar
  def action_toolbar
    render ::Decor::Nav::SecondaryNavbar.new(variant: :wide, bottom_border: true) do |navbar|
      navbar.with_left do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "flex items-center gap-4"}}) do
          render ::Decor::Element.new(root_element_attributes: {element_tag: :h2, html_root_element_attributes: {class: "text-xl font-bold text-base-content"}}) do
            "User Management"
          end
          render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "stats stats-horizontal shadow-sm"}}) do
            render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "stat"}}) do
              render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "stat-title text-xs"}}) { "Total Users" }
              render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "stat-value text-sm text-primary"}}) { "1,234" }
            end
          end
        end
      end

      navbar.with_right do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "flex items-center gap-2"}}) do
          render ::Decor::Element.new(root_element_attributes: {element_tag: :input, html_root_element_attributes: {
            type: "search",
            placeholder: "Search users...",
            class: "input input-bordered input-sm w-64"
          }})
          render ::Decor::Button.new(label: "Import", size: :sm, variant: :outlined, icon: "upload")
          render ::Decor::Button.new(label: "Add User", size: :sm, icon: "plus")
        end
      end
    end
  end

  # @label Tab Navigation
  def with_tabs
    render ::Decor::Nav::SecondaryNavbar.new(variant: :narrow, bottom_border: true) do |navbar|
      navbar.with_left do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :h3, html_root_element_attributes: {class: "text-lg font-semibold text-base-content"}}) do
          "Project Settings"
        end
      end

      navbar.with_center do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "tabs tabs-lifted"}}) do
          render ::Decor::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "tab tab-active"}}) { "General" }
          render ::Decor::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "tab"}}) { "Team" }
          render ::Decor::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "tab"}}) { "Integrations" }
          render ::Decor::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "tab"}}) { "Advanced" }
        end
      end

      navbar.with_right do
        render ::Decor::Button.new(label: "Save Changes", size: :sm)
      end
    end
  end

  # @!endgroup

  # @!group Layout Examples

  # @label Minimal Left Only
  def minimal_left
    render ::Decor::Nav::SecondaryNavbar.new(variant: :narrow) do |navbar|
      navbar.with_left do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :h2, html_root_element_attributes: {class: "text-lg font-semibold text-base-content"}}) do
          "Page Title"
        end
      end
    end
  end

  # @label Center Only
  def center_only
    render ::Decor::Nav::SecondaryNavbar.new(variant: :narrow) do |navbar|
      navbar.with_center do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "tabs tabs-boxed"}}) do
          render ::Decor::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "tab tab-active"}}) { "Tab 1" }
          render ::Decor::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "tab"}}) { "Tab 2" }
          render ::Decor::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "tab"}}) { "Tab 3" }
        end
      end
    end
  end

  # @label Right Actions Only
  def right_actions
    render ::Decor::Nav::SecondaryNavbar.new(variant: :narrow) do |navbar|
      navbar.with_right do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "flex gap-2"}}) do
          render ::Decor::Button.new(label: "Cancel", size: :sm, variant: :outlined)
          render ::Decor::Button.new(label: "Save", size: :sm)
        end
      end
    end
  end

  # @!endgroup
end
