require "test_helper"

class Decor::NotificationTest < ActiveSupport::TestCase
  test "renders successfully with basic attributes" do
    component = Decor::Notification.new(
      title: "Test Title",
      description: "Test Description"
    )
    rendered = render_component(component)

    assert_includes rendered, "Test Title"
    assert_includes rendered, "Test Description"
  end

  test "renders with icon" do
    component = Decor::Notification.new(
      title: "Test Title",
      description: "Test Description",
      icon: "check"
    )
    rendered = render_component(component)

    assert_includes rendered, "Test Title"
    assert_includes rendered, "Test Description"
    assert_includes rendered, "check"
  end

  test "renders with different colors" do
    %i[warning success error info].each do |color|
      component = Decor::Notification.new(
        title: "Test Title",
        description: "Test Description",
        color: color
      )
      rendered = render_component(component)

      assert_includes rendered, "Test Title"
      assert_includes rendered, "Test Description"
    end
  end

  test "renders with action buttons" do
    action_button = Decor::Notification::ActionButton.new(
      label: "Action",
      primary: true
    )
    
    component = Decor::Notification.new(
      title: "Test Title",
      description: "Test Description",
      action_buttons: [action_button]
    )
    rendered = render_component(component)

    assert_includes rendered, "Test Title"
    assert_includes rendered, "Test Description"
    assert_includes rendered, "Action"
  end

  test "renders with action button with href" do
    action_button = Decor::Notification::ActionButton.new(
      label: "Link Action",
      href: "https://example.com",
      primary: true
    )
    
    component = Decor::Notification.new(
      title: "Test Title",
      description: "Test Description",
      action_buttons: [action_button]
    )
    rendered = render_component(component)

    assert_includes rendered, "Test Title"
    assert_includes rendered, "Test Description"
    assert_includes rendered, "Link Action"
  end

  test "uses correct color classes" do
    component = Decor::Notification.new(
      title: "Test Title",
      description: "Test Description",
      color: :success,
      icon: "check"
    )
    rendered = render_component(component)

    assert_includes rendered, "bg-success"
    assert_includes rendered, "text-success-content"
    assert_includes rendered, "text-success"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Notification.new(
      title: "Test Title",
      description: "Test Description"
    )

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "renders with join classes for card-like appearance" do
    component = Decor::Notification.new(
      title: "Test Title",
      description: "Test Description"
    )
    rendered = render_component(component)

    assert_includes rendered, "join"
    assert_includes rendered, "rounded-box"
    assert_includes rendered, "shadow-lg"
  end

  test "renders with avatar block" do
    component = Decor::Notification.new(
      title: "Test Title",
      description: "Test Description"
    )
    
    component.avatar do
      "Avatar content"
    end
    
    rendered = render_component(component)

    assert_includes rendered, "Test Title"
    assert_includes rendered, "Test Description"
    assert_includes rendered, "Avatar content"
  end
end