# @label Search Results Dropdown
class ::Decor::SearchResultsDropdownPreview < ::Lookbook::Preview
  # Mock nav element class that implements the required interface
  class MockNavElement
    include Vident::StimulusComponent
    
    def stimulus_target(target_name)
      {"data-target" => "nav--#{target_name}"}
    end

    def parse_targets(targets)
      {controller: "nav", targets: targets}
    end

    def build_target_data_attributes(attrs)
      result = {}
      attrs[:targets]&.each do |target|
        result[:target] = "nav--#{target}"
      end
      result
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
