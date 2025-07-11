# @label Search Results Dropdown
class ::Decor::SearchResultsDropdownPreview < ::Lookbook::Preview
  # Mock nav element class that implements the required interface
  class MockNavElement < Decor::PhlexComponent
    no_stimulus_controller

    def stimulus_target(target_name)
      {"data-nav-target" => target_name.to_s.dasherize}
    end
  end

  def mock_nav_element
    MockNavElement.new
  end

  # Search Results Dropdown
  # -------
  #
  # A dropdown component that displays search results with a loading spinner
  # and scrollable content area. Typically used in navigation contexts.
  #
  # @label Playground
  def playground
    render ::Decor::SearchResultsDropdown.new(
      nav_element: mock_nav_element
    )
  end
end
