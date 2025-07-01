require "test_helper"

class Decor::FormattedEncodedIdTest < ActiveSupport::TestCase
  test "renders successfully with encoded_id" do
    component = Decor::FormattedEncodedId.new(encoded_id: "ABC123DEF456")
    rendered = render_component(component)

    assert_includes rendered, "ABC123DEF456"
    assert_includes rendered, "<p"
  end

  test "renders with default element classes" do
    component = Decor::FormattedEncodedId.new(encoded_id: "ABC123DEF456")
    rendered = render_component(component)

    assert_includes rendered, "inline-flex items-center"
  end

  test "renders encoded ID with high emphasis styling" do
    component = Decor::FormattedEncodedId.new(encoded_id: "ABC123DEF456")
    rendered = render_component(component)

    assert_includes rendered, "text-primary font-medium tracking-wide"
    assert_includes rendered, "ABC123DEF456"
  end

  test "renders prefix with low emphasis styling when provided" do
    # Mock the EncodedId configuration
    component = Decor::FormattedEncodedId.new(encoded_id: "USR-ABC123DEF456", prefix: "USR")

    # Stub the configuration access
    component.define_singleton_method(:prefix_combined) { "USR-" }
    component.define_singleton_method(:cleaned_encoded_id) { "ABC123DEF456" }

    rendered = render_component(component)

    assert_includes rendered, "text-base-500 font-extralight mr-0.5"
    assert_includes rendered, "USR"
  end

  test "does not render prefix when blank" do
    component = Decor::FormattedEncodedId.new(encoded_id: "ABC123DEF456", prefix: "")
    rendered = render_component(component)

    assert_not_includes rendered, "text-low-emphasis font-extralight"
    assert_includes rendered, "ABC123DEF456"
  end

  test "does not render prefix when nil" do
    component = Decor::FormattedEncodedId.new(encoded_id: "ABC123DEF456")
    rendered = render_component(component)

    assert_not_includes rendered, "text-low-emphasis font-extralight"
    assert_includes rendered, "ABC123DEF456"
  end

  test "returns full encoded_id when no prefix provided" do
    component = Decor::FormattedEncodedId.new(encoded_id: "ABC123DEF456")

    cleaned_id = component.send(:cleaned_encoded_id)
    assert_equal "ABC123DEF456", cleaned_id
  end

  test "returns prefix for prefix_combined when prefix is blank" do
    component = Decor::FormattedEncodedId.new(encoded_id: "ABC123DEF456", prefix: "")

    prefix_combined = component.send(:prefix_combined)
    assert_equal "", prefix_combined
  end

  test "renders as p element by default (uses parent_element)" do
    component = Decor::FormattedEncodedId.new(encoded_id: "ABC123DEF456")
    rendered = render_component(component)

    # Component uses render parent_element with element_tag: :p
    assert_includes rendered, "<p"
    assert_includes rendered, "class="
  end

  test "applies default CSS classes" do
    component = Decor::FormattedEncodedId.new(encoded_id: "ABC123DEF456")
    rendered = render_component(component)

    assert_includes rendered, "decor--formatted-encoded-id"
    assert_includes rendered, "inline-flex items-center"
  end

  test "file_name method returns correct path structure" do
    component = Decor::FormattedEncodedId.new(encoded_id: "ABC123DEF456")

    # Test that element_classes method returns expected classes
    classes = component.send(:element_classes)
    assert_equal "inline-flex items-center", classes
  end

  test "root_element_attributes configures element_tag as :p" do
    component = Decor::FormattedEncodedId.new(encoded_id: "ABC123DEF456")

    attrs = component.send(:root_element_attributes)
    assert_equal :p, attrs[:element_tag]
  end

  test "uses nokogiri for parsing p element structure" do
    component = Decor::FormattedEncodedId.new(encoded_id: "ABC123DEF456")
    fragment = render_fragment(component)

    # Should have a p element (component renders as p due to element_tag: :p)
    p = fragment.at_css("p")
    assert_not_nil p
    assert_includes p["class"], "inline-flex items-center"
    assert_includes p["class"], "decor--formatted-encoded-id"

    # Should have one span for the ID when no prefix
    spans = fragment.css("span")
    assert_equal 1, spans.length

    id_span = spans.first
    assert_includes id_span["class"], "text-primary"
    assert_equal "ABC123DEF456", id_span.text
  end

  test "handles encoded ID without prefix in rendered output" do
    component = Decor::FormattedEncodedId.new(encoded_id: "XYZ789")
    fragment = render_fragment(component)

    spans = fragment.css("span")
    assert_equal 1, spans.length

    id_span = spans.first
    assert_includes id_span["class"], "text-primary font-medium tracking-wide"
    assert_equal "XYZ789", id_span.text
  end

  test "renders component with ID attribute" do
    component = Decor::FormattedEncodedId.new(encoded_id: "TEST123", id: "my-formatted-id")
    rendered = render_component(component)

    assert_includes rendered, 'id="my-formatted-id"'
  end

  test "handles various encoded ID formats" do
    # Test IDs without separators (no prefix splitting)
    simple_ids = ["ABC123", "XYZ789", "item123"]

    simple_ids.each do |test_id|
      component = Decor::FormattedEncodedId.new(encoded_id: test_id)
      rendered = render_component(component)

      assert_includes rendered, test_id
      assert_includes rendered, "text-primary"
    end

    # Test ID with separator (will be split into prefix and ID)
    component = Decor::FormattedEncodedId.new(encoded_id: "USER_456")
    rendered = render_component(component)

    # Should split into "USER_" (prefix) and "456" (ID)
    assert_includes rendered, "USER_"
    assert_includes rendered, "456"
    assert_includes rendered, "text-primary"
    assert_includes rendered, "text-base-500"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::FormattedEncodedId.new(encoded_id: "ABC123")

    assert component.is_a?(Decor::PhlexComponent)
  end
end
