# @label SideNavbar
# @display margin none
class ::Decor::Nav::SideNavbarPreview < ::Lookbook::Preview
  # Page::SideNavbar
  # -------
  #
  # The SideNavbar is a navigation component that is placed on the side of the page.
  # On desktop is expanded by default and can be collapsed to an icon only form by clicking
  # on the hamburger icon.
  # On mobile the SideNavbar is always collapsed.
  #
  # @label Playground
  # @param start_collapsed toggle
  def playground(start_collapsed: false)
    render_with_template(
      locals: {
        start_collapsed: start_collapsed
      }
    )
  end

  # @!group DaisyUI Styling Examples

  # @label Expanded with DaisyUI Menu Classes
  def expanded_daisyui
    render_with_template(
      template: "daisyui_example",
      locals: {
        start_collapsed: false,
        highlight_daisyui: true
      }
    )
  end

  # @label Collapsed Icon-Only Mode
  def collapsed_daisyui
    render_with_template(
      template: "daisyui_example",
      locals: {
        start_collapsed: true,
        highlight_daisyui: true
      }
    )
  end

  # @label Active States and Badges
  def active_states_and_badges
    render_with_template(
      template: "active_states_example"
    )
  end

  # @!endgroup

  # @!group New Method-Based API Examples

  # @label Fluent Builder API
  def fluent_builder_api
    render_with_template(
      template: "fluent_builder_example"
    )
  end

  # @label Mixed API (Builder + Block)
  def mixed_api_example
    render_with_template(
      template: "mixed_api_example"
    )
  end

  # @!endgroup
end
