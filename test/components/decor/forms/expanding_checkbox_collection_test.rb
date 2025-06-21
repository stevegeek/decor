require "test_helper"
require "ostruct"

class Decor::Forms::ExpandingCheckboxCollectionTest < ActiveSupport::TestCase
  def setup
    @options = [
      ["Option 1", "1"],
      ["Option 2", "2"],
      ["Option 3", "3"],
      ["Option 4", "4"],
      ["Option 5", "5"]
    ]
    @mock_model = OpenStruct.new(preferences: ["1", "3"])
  end

  test "renders successfully with required attributes" do
    component = Decor::Forms::ExpandingCheckboxCollection.new(
      property_name: :preferences,
      options: @options
    )
    rendered = render_component(component)

    assert_includes rendered, "decor--expanding-checkbox-collection"
    assert_includes rendered, "Option 1"
  end

  test "renders with expandable/collapsible structure" do
    component = Decor::Forms::ExpandingCheckboxCollection.new(
      property_name: :preferences,
      options: @options
    )
    rendered = render_component(component)

    assert_includes rendered, "collapse"
  end

  test "supports initial_visible_count" do
    component = Decor::Forms::ExpandingCheckboxCollection.new(
      property_name: :preferences,
      options: @options,
      initial_visible_count: 2
    )
    rendered = render_component(component)

    # Should show first 2 options initially
    assert_includes rendered, "Option 1"
    assert_includes rendered, "Option 2"
  end

  test "renders checkboxes for each option" do
    component = Decor::Forms::ExpandingCheckboxCollection.new(
      property_name: :preferences,
      options: @options
    )
    fragment = render_fragment(component)

    checkboxes = fragment.css('input[type="checkbox"]')
    assert_equal 5, checkboxes.length
  end

  test "supports model binding with selected values" do
    component = Decor::Forms::ExpandingCheckboxCollection.new(
      property_name: :preferences,
      options: @options,
      model: @mock_model
    )
    fragment = render_fragment(component)

    checked_boxes = fragment.css('input[type="checkbox"]:checked')
    assert_equal 2, checked_boxes.length

    checked_values = checked_boxes.map { |cb| cb["value"] }
    assert_includes checked_values, "1"
    assert_includes checked_values, "3"
  end

  test "component inherits from FormField" do
    component = Decor::Forms::ExpandingCheckboxCollection.new(
      property_name: :preferences,
      options: @options
    )

    assert component.is_a?(Decor::Forms::FormField)
  end

  test "renders with expand/collapse toggle" do
    component = Decor::Forms::ExpandingCheckboxCollection.new(
      property_name: :preferences,
      options: @options,
      initial_visible_count: 2
    )
    rendered = render_component(component)

    # Should have some mechanism to show more options
    assert_includes rendered, "collapse"
  end

  test "supports disabled state" do
    component = Decor::Forms::ExpandingCheckboxCollection.new(
      property_name: :preferences,
      options: @options,
      disabled: true
    )
    rendered = render_component(component)

    assert_includes rendered, "disabled"
  end

  test "renders with form field layout structure" do
    component = Decor::Forms::ExpandingCheckboxCollection.new(
      property_name: :preferences,
      options: @options,
      label: "Select Preferences"
    )
    rendered = render_component(component)

    assert_includes rendered, "Select Preferences"
    assert_includes rendered, "decor--expanding-checkbox-collection"
  end

  test "supports helper text" do
    component = Decor::Forms::ExpandingCheckboxCollection.new(
      property_name: :preferences,
      options: @options,
      helper_text: "Choose multiple options"
    )
    rendered = render_component(component)

    assert_includes rendered, "Choose multiple options"
  end

  test "handles various option formats" do
    simple_options = ["Red", "Green", "Blue", "Yellow", "Purple"]
    component = Decor::Forms::ExpandingCheckboxCollection.new(
      property_name: :colors,
      options: simple_options
    )
    rendered = render_component(component)

    assert_includes rendered, "Red"
    assert_includes rendered, "Green"
    assert_includes rendered, "Blue"
  end

  test "checkboxes have correct name and value attributes" do
    component = Decor::Forms::ExpandingCheckboxCollection.new(
      property_name: :preferences,
      options: @options
    )
    fragment = render_fragment(component)

    checkboxes = fragment.css('input[type="checkbox"]')
    checkboxes.each_with_index do |checkbox, index|
      expected_value = @options[index][1]
      assert_equal expected_value, checkbox["value"]
      assert_includes checkbox["name"], "preferences"
    end
  end

  test "supports custom initial_visible_count values" do
    [1, 3, 5].each do |count|
      component = Decor::Forms::ExpandingCheckboxCollection.new(
        property_name: :preferences,
        options: @options,
        initial_visible_count: count
      )
      rendered = render_component(component)

      assert_includes rendered, "decor--expanding-checkbox-collection"
    end
  end
end
