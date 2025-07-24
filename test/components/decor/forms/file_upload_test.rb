require "test_helper"

class Decor::Forms::FileUploadTest < ActiveSupport::TestCase
  test "renders successfully with required attributes" do
    component = Decor::Forms::FileUpload.new(
      name: "avatar",
      label: "Upload Avatar"
    )
    rendered = render_component(component)

    assert_includes rendered, "Upload Avatar"
    assert_includes rendered, 'type="file"'
  end

  test "renders with DaisyUI file-input classes by default" do
    component = Decor::Forms::FileUpload.new(
      name: "avatar",
      label: "Upload Avatar"
    )
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="file"]')
    assert_not_nil input
    assert_includes input["class"], "file-input"
    assert_includes input["class"], "w-full"
  end

  test "applies color attribute correctly" do
    component = Decor::Forms::FileUpload.new(
      name: "avatar",
      label: "Upload Avatar",
      color: :secondary
    )
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="file"]')
    assert_includes input["class"], "file-input-secondary"
  end

  test "applies size attribute correctly" do
    component = Decor::Forms::FileUpload.new(
      name: "avatar",
      label: "Upload Avatar",
      size: :lg
    )
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="file"]')
    assert_includes input["class"], "file-input-lg"
  end

  test "applies error styling when errors present" do
    component = Decor::Forms::FileUpload.new(
      name: "avatar",
      label: "Upload Avatar",
      error_messages: ["File is required"]
    )
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="file"]')
    assert_includes input["class"], "file-input-error"
  end

  test "supports file mime types" do
    component = Decor::Forms::FileUpload.new(
      name: "avatar",
      label: "Upload Avatar",
      file_mime_types: "image/png,image/jpeg"
    )
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="file"]')
    assert_equal "image/png,image/jpeg", input["accept"]
  end

  test "component inherits from FormField" do
    component = Decor::Forms::FileUpload.new(
      name: "avatar",
      label: "Upload Avatar"
    )

    assert component.is_a?(Decor::Forms::FormField)
  end

  test "renders with correct name attribute" do
    component = Decor::Forms::FileUpload.new(
      name: "avatar",
      label: "Upload Avatar"
    )
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="file"]')
    assert_not_nil input
    assert_equal "avatar", input["name"]
  end

  test "supports disabled state" do
    component = Decor::Forms::FileUpload.new(
      name: "avatar",
      label: "Upload Avatar",
      disabled: true
    )
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="file"]')
    assert input.has_attribute?("disabled")
  end

  test "supports required attribute" do
    component = Decor::Forms::FileUpload.new(
      name: "avatar",
      label: "Upload Avatar",
      required: true
    )
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="file"]')
    assert input.has_attribute?("required")
  end

  test "supports helper text" do
    component = Decor::Forms::FileUpload.new(
      name: "avatar",
      label: "Upload Avatar",
      helper_text: "Choose an image file for your avatar"
    )
    rendered = render_component(component)

    assert_includes rendered, "Choose an image file for your avatar"
  end

  test "supports image style with preview" do
    component = Decor::Forms::FileUpload.new(
      name: "avatar",
      label: "Upload Avatar",
      preview_type: :image,
      existing_file_url: "https://example.com/avatar.jpg"
    )
    fragment = render_fragment(component)

    image = fragment.at_css("img")
    assert_not_nil image
    assert_equal "https://example.com/avatar.jpg", image["src"]
  end

  test "supports avatar style" do
    component = Decor::Forms::FileUpload.new(
      name: "avatar",
      label: "Upload Avatar",
      preview_type: :avatar,
      initials: "AB"
    )
    rendered = render_component(component)

    assert_includes rendered, "AB"
  end

  test "renders clear checkbox when file exists" do
    component = Decor::Forms::FileUpload.new(
      name: "avatar",
      label: "Upload Avatar",
      existing_file_url: "https://example.com/avatar.jpg",
      clear_checkbox: true
    )
    rendered = render_component(component)

    assert_includes rendered, "Select to remove current file"
    assert_includes rendered, 'type="checkbox"'
  end
end
