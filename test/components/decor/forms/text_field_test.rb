require "test_helper"

class Decor::Forms::TextFieldTest < ActiveSupport::TestCase
  test "renders successfully with valid attributes" do
    component = Decor::Forms::TextField.new(
      name: "my_text",
      label: "Label",
      value: "Wow!"
    )

    assert_nothing_raised do
      rendered = render_component(component)
      assert_includes rendered, "Label"
      assert_includes rendered, 'type="text"'
      assert_includes rendered, 'value="Wow!"'
      assert_includes rendered, 'name="my_text"'
      assert_includes rendered, 'class="input w-full"'
    end
  end

  test "renders successfully with valid attributes for password field" do
    component = Decor::Forms::TextField.new(
      type: :password,
      name: "my_pass",
      label: "Label",
      value: "secret"
    )

    assert_nothing_raised do
      rendered = render_component(component)
      assert_includes rendered, "Label"
      assert_includes rendered, 'type="password"'
      assert_includes rendered, 'value="secret"'
      assert_includes rendered, 'name="my_pass"'
    end
  end

  test "text field contains correct attributes" do
    component = Decor::Forms::TextField.new(
      name: "my_text",
      label: "Label",
      value: "Wow!"
    )
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="text"]')
    assert_not_nil input
    assert_equal "Wow!", input["value"]
    assert_equal "my_text", input["name"]
  end

  test "password field contains correct attributes" do
    component = Decor::Forms::TextField.new(
      type: :password,
      name: "my_pass",
      label: "Label",
      value: "secret"
    )
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="password"]')
    assert_not_nil input
    assert_equal "secret", input["value"]
    assert_equal "my_pass", input["name"]
  end

  test "renders with leading icon using DaisyUI label structure" do
    component = Decor::Forms::TextField.new(
      name: "username",
      label: "Username",
      leading_icon_name: "user"
    )
    fragment = render_fragment(component)

    label = fragment.at_css("label.input")
    assert_not_nil label

    input = label.at_css("input")
    assert_not_nil input
    assert_equal "username", input["name"]
  end

  test "renders with trailing icon using DaisyUI label structure" do
    component = Decor::Forms::TextField.new(
      name: "email",
      label: "Email",
      trailing_icon_name: "envelope"
    )
    fragment = render_fragment(component)

    label = fragment.at_css("label.input")
    assert_not_nil label

    input = label.at_css("input")
    assert_not_nil input
    assert_equal "email", input["name"]
  end

  test "adds validator class when validation attributes present" do
    component = Decor::Forms::TextField.new(
      name: "validated_field",
      label: "Validated Field",
      leading_icon_name: "user",
      required: true,
      minimum_length: 3
    )
    fragment = render_fragment(component)

    label = fragment.at_css("label.input.validator")
    assert_not_nil label
  end

  test "renders helper text with validator-hint class" do
    component = Decor::Forms::TextField.new(
      name: "field_with_help",
      label: "Field with Help",
      helper_text: "This is helper text"
    )
    rendered = render_component(component)

    assert_includes rendered, "validator-hint"
    assert_includes rendered, "This is helper text"
  end

  test "renders with leading text add-on using DaisyUI label structure" do
    component = Decor::Forms::TextField.new(
      name: "url_field",
      label: "Website URL",
      leading_text_add_on: "https://"
    )
    fragment = render_fragment(component)

    label = fragment.at_css("label.input")
    assert_not_nil label

    span = label.at_css("span")
    assert_not_nil span
    assert_includes span.text, "https://"
  end

  test "renders with trailing text add-on using DaisyUI label structure" do
    component = Decor::Forms::TextField.new(
      name: "price_field",
      label: "Price",
      trailing_text_add_on: "USD"
    )
    fragment = render_fragment(component)

    label = fragment.at_css("label.input")
    assert_not_nil label

    span = label.at_css("span")
    assert_not_nil span
    assert_includes span.text, "USD"
  end

  test "renders with leading add-on slot using DaisyUI label structure" do
    component = Decor::Forms::TextField.new(
      name: "custom_field",
      label: "Custom Field"
    )

    component.leading_add_on { "Custom Content" }

    fragment = render_fragment(component)

    label = fragment.at_css("label.input")
    assert_not_nil label
    assert_includes label.text, "Custom Content"
  end
end
