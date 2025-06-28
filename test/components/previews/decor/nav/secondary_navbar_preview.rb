# @label SecondaryNavbar
class ::Decor::Nav::SecondaryNavbarPreview < ::Lookbook::Preview
  # @param variant select [~, narrow, wide]
  # @param has_left_element toggle
  # @param has_center_element toggle
  # @param has_right_element toggle
  # @param has_bottom_border toggle
  def playground(variant: :narrow, has_left_element: true, has_center_element: true, has_right_element: true, has_bottom_border: false)
    render_with_template(
      locals: {
        variant: variant,
        has_left_element: has_left_element,
        has_center_element: has_center_element,
        has_right_element: has_right_element,
        has_bottom_border: has_bottom_border
      }
    )
  end
end
