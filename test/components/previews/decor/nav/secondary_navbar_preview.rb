# @label SecondaryNavbar
# The SecondaryNavbar provides flexible sub-navigation for pages with left, center, and right content areas.
class ::Decor::Nav::SecondaryNavbarPreview < ::Lookbook::Preview
  # @!group Examples

  # @label Breadcrumb Navigation
  def breadcrumb_navigation
    render ::Decor::Nav::SecondaryNavbar.new(style: :narrow, bottom_border: true) do |navbar|
      navbar.with_left do
        render ::Decor::Nav::Breadcrumbs.new(
          breadcrumbs: [
            {name: "Home", path: "/"},
            {name: "Products", path: "/products"},
            {name: "Electronics", path: "/products/electronics"}
          ]
        )
      end

      navbar.with_right do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "flex items-center gap-1"}}) do
          render ::Decor::Button.new(label: "Edit", size: :sm, style: :outlined, icon: "pencil")
          render ::Decor::Button.new(label: "Add Product", size: :sm, icon: "plus")
        end
      end
    end
  end

  # @label Action Toolbar
  def action_toolbar
    render ::Decor::Nav::SecondaryNavbar.new(style: :wide, bottom_border: true) do |navbar|
      navbar.with_left do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "flex items-center gap-4"}}) do
          render ::Decor::Element.new(root_element_attributes: {element_tag: :h2, html_root_element_attributes: {class: "text-xl font-bold text-base-content"}}) do
            "User Management"
          end
          render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "badge badge-primary"}}) do
            "1,234 users"
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
          render ::Decor::Button.new(label: "Import", size: :sm, style: :outlined, icon: "upload")
          render ::Decor::Button.new(label: "Add User", size: :sm, icon: "plus")
        end
      end
    end
  end

  # @label Tab Navigation
  def tab_navigation
    render ::Decor::Nav::SecondaryNavbar.new(style: :narrow, bottom_border: true) do |navbar|
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

  # @!group Playground

  # @label Playground
  # @param navbar_style select [narrow, wide]
  # @param has_left_element toggle
  # @param has_center_element toggle
  # @param has_right_element toggle
  # @param has_bottom_border toggle
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(navbar_style: :narrow, has_left_element: true, has_center_element: true, has_right_element: true, has_bottom_border: false, size: nil, color: nil, style: nil)
    render ::Decor::Nav::SecondaryNavbar.new(
      style: navbar_style,
      bottom_border: has_bottom_border,
      size: size,
      color: color
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
            render ::Decor::Button.new(label: "Action", size: :sm, style: :outlined)
            render ::Decor::Button.new(label: "Primary", size: :sm)
          end
        end
      end
    end
  end

  # @!endgroup

  # @!group Styles

  # @label Narrow Style
  def narrow_style
    render ::Decor::Nav::SecondaryNavbar.new(style: :narrow, bottom_border: true) do |navbar|
      navbar.with_left do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :h2, html_root_element_attributes: {class: "text-lg font-semibold text-base-content"}}) do
          "Narrow Container"
        end
      end

      navbar.with_right do
        render ::Decor::Button.new(label: "Action", size: :sm)
      end
    end
  end

  # @label Wide Style
  def wide_style
    render ::Decor::Nav::SecondaryNavbar.new(style: :wide, bottom_border: true) do |navbar|
      navbar.with_left do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :h2, html_root_element_attributes: {class: "text-lg font-semibold text-base-content"}}) do
          "Wide Container"
        end
      end

      navbar.with_right do
        render ::Decor::Button.new(label: "Action", size: :sm)
      end
    end
  end

  # @!endgroup

  # @!group Layout Variants

  # @label Left Content Only
  def left_only
    render ::Decor::Nav::SecondaryNavbar.new(style: :narrow) do |navbar|
      navbar.with_left do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :h2, html_root_element_attributes: {class: "text-lg font-semibold text-base-content"}}) do
          "Page Title"
        end
      end
    end
  end

  # @label Center Content Only
  def center_only
    render ::Decor::Nav::SecondaryNavbar.new(style: :narrow) do |navbar|
      navbar.with_center do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "tabs tabs-boxed"}}) do
          render ::Decor::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "tab tab-active"}}) { "Tab 1" }
          render ::Decor::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "tab"}}) { "Tab 2" }
          render ::Decor::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "tab"}}) { "Tab 3" }
        end
      end
    end
  end

  # @label Right Content Only
  def right_only
    render ::Decor::Nav::SecondaryNavbar.new(style: :narrow) do |navbar|
      navbar.with_right do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "flex gap-2"}}) do
          render ::Decor::Button.new(label: "Cancel", size: :sm, style: :outlined)
          render ::Decor::Button.new(label: "Save", size: :sm)
        end
      end
    end
  end

  # @label Full Layout
  def full_layout
    render ::Decor::Nav::SecondaryNavbar.new(style: :wide, bottom_border: true) do |navbar|
      navbar.with_left do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :h1, html_root_element_attributes: {class: "text-lg font-semibold text-base-content"}}) do
          "Dashboard Overview"
        end
      end

      navbar.with_center do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "tabs tabs-boxed"}}) do
          render ::Decor::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "tab tab-active"}}) { "Overview" }
          render ::Decor::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "tab"}}) { "Details" }
          render ::Decor::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "tab"}}) { "Charts" }
        end
      end

      navbar.with_right do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "flex items-center gap-2"}}) do
          render ::Decor::Button.new(label: "Export", size: :sm, style: :outlined, icon: "download")
          render ::Decor::Button.new(label: "Settings", size: :sm, icon: "cog")
        end
      end
    end
  end

  # @!endgroup
end
