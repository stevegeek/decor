# @label SecondaryNavbar
class ::Decor::Daisy::Nav::SecondaryNavbarPreview < ::Lookbook::Preview
  # The SecondaryNavbar provides flexible sub-navigation for pages with left, center, and right content areas.
  # @!group Examples

  # @label Breadcrumb Navigation
  def breadcrumb_navigation
    render ::Decor::Daisy::Nav::SecondaryNavbar.new(style: :narrow, bottom_border: true) do |navbar|
      navbar.with_left do
        render ::Decor::Daisy::Nav::Breadcrumbs.new(
          breadcrumbs: [
            {name: "Home", path: "/"},
            {name: "Products", path: "/products"},
            {name: "Electronics", path: "/products/electronics"}
          ]
        )
      end

      navbar.with_right do
        render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "decor:flex decor:items-center decor:gap-1"}}) do
          render ::Decor::Daisy::Button.new(label: "Edit", size: :sm, style: :outlined, icon: "pencil")
          render ::Decor::Daisy::Button.new(label: "Add Product", size: :sm, icon: "plus")
        end
      end
    end
  end

  # @label Action Toolbar
  def action_toolbar
    render ::Decor::Daisy::Nav::SecondaryNavbar.new(style: :wide, bottom_border: true) do |navbar|
      navbar.with_left do
        render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "decor:flex decor:items-center decor:gap-4"}}) do
          render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :h2, html_root_element_attributes: {class: "decor:text-xl decor:font-bold decor:text-base-content"}}) do
            "User Management"
          end
          render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "decor:d-badge decor:d-badge-primary"}}) do
            "1,234 users"
          end
        end
      end

      navbar.with_right do
        render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "decor:flex decor:items-center decor:gap-2"}}) do
          render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :input, html_root_element_attributes: {
            type: "search",
            placeholder: "Search users...",
            class: "decor:d-input decor:d-input-bordered decor:d-input-sm decor:w-64"
          }})
          render ::Decor::Daisy::Button.new(label: "Import", size: :sm, style: :outlined, icon: "upload")
          render ::Decor::Daisy::Button.new(label: "Add User", size: :sm, icon: "plus")
        end
      end
    end
  end

  # @label Tab Navigation
  def tab_navigation
    render ::Decor::Daisy::Nav::SecondaryNavbar.new(style: :narrow, bottom_border: true) do |navbar|
      navbar.with_left do
        render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :h3, html_root_element_attributes: {class: "decor:text-lg decor:font-semibold decor:text-base-content"}}) do
          "Project Settings"
        end
      end

      navbar.with_center do
        render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "decor:d-tabs decor:d-tabs-lifted"}}) do
          render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "decor:d-tab decor:d-tab-active"}}) { "General" }
          render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "decor:d-tab"}}) { "Team" }
          render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "decor:d-tab"}}) { "Integrations" }
          render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "decor:d-tab"}}) { "Advanced" }
        end
      end

      navbar.with_right do
        render ::Decor::Daisy::Button.new(label: "Save Changes", size: :sm)
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
    render ::Decor::Daisy::Nav::SecondaryNavbar.new(
      style: navbar_style,
      bottom_border: has_bottom_border,
      size: size,
      color: color
    ) do |navbar|
      if has_left_element
        navbar.with_left do
          render ::Decor::Daisy::Nav::Breadcrumbs.new(
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
          render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :span, html_root_element_attributes: {class: "decor:text-sm decor:font-medium decor:text-base-content"}}) do
            "Secondary Navigation Center"
          end
        end
      end

      if has_right_element
        navbar.with_right do
          render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "decor:flex decor:gap-2"}}) do
            render ::Decor::Daisy::Button.new(label: "Action", size: :sm, style: :outlined)
            render ::Decor::Daisy::Button.new(label: "Primary", size: :sm)
          end
        end
      end
    end
  end

  # @!endgroup

  # @!group Styles

  # @label Narrow Style
  def narrow_style
    render ::Decor::Daisy::Nav::SecondaryNavbar.new(style: :narrow, bottom_border: true) do |navbar|
      navbar.with_left do
        render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :h2, html_root_element_attributes: {class: "decor:text-lg decor:font-semibold decor:text-base-content"}}) do
          "Narrow Container"
        end
      end

      navbar.with_right do
        render ::Decor::Daisy::Button.new(label: "Action", size: :sm)
      end
    end
  end

  # @label Wide Style
  def wide_style
    render ::Decor::Daisy::Nav::SecondaryNavbar.new(style: :wide, bottom_border: true) do |navbar|
      navbar.with_left do
        render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :h2, html_root_element_attributes: {class: "decor:text-lg decor:font-semibold decor:text-base-content"}}) do
          "Wide Container"
        end
      end

      navbar.with_right do
        render ::Decor::Daisy::Button.new(label: "Action", size: :sm)
      end
    end
  end

  # @!endgroup

  # @!group Layout Variants

  # @label Left Content Only
  def left_only
    render ::Decor::Daisy::Nav::SecondaryNavbar.new(style: :narrow) do |navbar|
      navbar.with_left do
        render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :h2, html_root_element_attributes: {class: "decor:text-lg decor:font-semibold decor:text-base-content"}}) do
          "Page Title"
        end
      end
    end
  end

  # @label Center Content Only
  def center_only
    render ::Decor::Daisy::Nav::SecondaryNavbar.new(style: :narrow) do |navbar|
      navbar.with_center do
        render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "decor:d-tabs decor:d-tabs-boxed"}}) do
          render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "decor:d-tab decor:d-tab-active"}}) { "Tab 1" }
          render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "decor:d-tab"}}) { "Tab 2" }
          render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "decor:d-tab"}}) { "Tab 3" }
        end
      end
    end
  end

  # @label Right Content Only
  def right_only
    render ::Decor::Daisy::Nav::SecondaryNavbar.new(style: :narrow) do |navbar|
      navbar.with_right do
        render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "decor:flex decor:gap-2"}}) do
          render ::Decor::Daisy::Button.new(label: "Cancel", size: :sm, style: :outlined)
          render ::Decor::Daisy::Button.new(label: "Save", size: :sm)
        end
      end
    end
  end

  # @label Full Layout
  def full_layout
    render ::Decor::Daisy::Nav::SecondaryNavbar.new(style: :wide, bottom_border: true) do |navbar|
      navbar.with_left do
        render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :h1, html_root_element_attributes: {class: "decor:text-lg decor:font-semibold decor:text-base-content"}}) do
          "Dashboard Overview"
        end
      end

      navbar.with_center do
        render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "decor:d-tabs decor:d-tabs-boxed"}}) do
          render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "decor:d-tab decor:d-tab-active"}}) { "Overview" }
          render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "decor:d-tab"}}) { "Details" }
          render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :a, html_root_element_attributes: {class: "decor:d-tab"}}) { "Charts" }
        end
      end

      navbar.with_right do
        render ::Decor::Daisy::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "decor:flex decor:items-center decor:gap-2"}}) do
          render ::Decor::Daisy::Button.new(label: "Export", size: :sm, style: :outlined, icon: "download")
          render ::Decor::Daisy::Button.new(label: "Settings", size: :sm, icon: "settings")
        end
      end
    end
  end

  # @!endgroup
end
