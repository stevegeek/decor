# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::FileUploadTest < ActiveSupport::TestCase
  test "renders root element with suite file-upload identifier" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(name: "doc", label: "Upload"))
    assert_includes html, "decor--suite--forms--file-upload"
  end

  test "renders a native file input by default" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(name: "doc", label: "Upload"))
    assert_match(/<input[^>]*type="file"/, html)
    assert_match(/name="doc"/, html)
  end

  test "default :file variant renders dashed drop zone with Suite tokens" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(name: "doc", label: "Upload"))
    assert_includes html, "Click to upload"
    assert_includes html, "decor:border-dashed"
    assert_includes html, "decor:border-suite-hairline-strong"
    assert_includes html, "decor:rounded-suite-control"
    assert_includes html, "decor:bg-suite-gray-25"
  end

  test ":file drop zone uses suite primary hover + duration-suite-fast motion" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(name: "doc", label: "Upload"))
    assert_includes html, "decor:hover:border-suite-primary-500"
    assert_includes html, "decor:duration-suite-fast"
    refute_includes html, "decor:duration-150"
    refute_includes html, "decor:duration-200"
  end

  test ":file variant emits Click-to-upload accent in suite-primary-500" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(name: "doc", label: "Upload"))
    assert_includes html, "decor:text-suite-primary-500"
  end

  test ":file variant description renders from prop default" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(name: "doc", label: "Upload"))
    assert_includes html, "Upload a .jpg or .png file, smaller than 5MB"
  end

  test "accept attribute reflects file_mime_types prop" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(
      name: "doc", label: "Upload", file_mime_types: "image/png,image/jpeg"
    ))
    assert_match(/accept="image\/png,image\/jpeg"/, html)
  end

  test "label renders with suite-field-label typography" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(name: "doc", label: "Profile photo"))
    assert_includes html, "Profile photo"
    assert_includes html, "decor:suite-field-label"
  end

  test "required appends an asterisk to the label and on the input" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(name: "doc", label: "Doc", required: true))
    assert_includes html, "Doc *"
    assert_match(/<input[^>]*required/, html)
  end

  test "disabled marks the input disabled and dims the drop zone" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(name: "doc", label: "Doc", disabled: true))
    assert_match(/<input[^>]*disabled/, html)
    assert_includes html, "decor:opacity-50"
    assert_includes html, "decor:cursor-not-allowed"
  end

  test "error state colours label and emits the error text in suite-danger-700" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(
      name: "doc", label: "Doc", error_messages: ["Too large"]
    ))
    assert_includes html, "Too large"
    assert_includes html, "decor:text-suite-danger-700"
  end

  test ":image variant with existing url renders an <img> preview" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(
      name: "avatar", label: "Avatar",
      preview_type: :image, existing_file_url: "https://example.com/a.jpg"
    ))
    assert_match(/<img[^>]*src="https:\/\/example\.com\/a\.jpg"/, html)
    assert_includes html, "Choose Image"
  end

  test ":image variant without a file renders the empty-state placeholder" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(
      name: "avatar", label: "Avatar", preview_type: :image
    ))
    assert_includes html, "No image"
    assert_includes html, "decor:bg-suite-gray-25"
    assert_includes html, "decor:border-suite-hairline"
  end

  test ":image variant emits a hidden delete field driven by deleteField target" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(
      name: "avatar", label: "Avatar", preview_type: :image
    ))
    assert_match(/<input[^>]*type="hidden"[^>]*data-decor--daisy--forms--file-upload-target="deleteField"/, html)
    assert_match(/<input[^>]*value="false"/, html)
  end

  test ":avatar variant renders the Suite Avatar with given initials" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(
      name: "avatar", label: "Avatar", preview_type: :avatar, initials: "AB"
    ))
    assert_includes html, "decor--suite--avatar"
    assert_includes html, "AB"
  end

  test ":avatar variant styles the file:* pseudo-element with Suite tokens" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(
      name: "avatar", label: "Avatar", preview_type: :avatar, initials: "AB"
    ))
    assert_includes html, "decor:file:rounded-suite-control"
    assert_includes html, "decor:file:border-suite-hairline-strong"
  end

  test ":avatar variant with existing file shows the clear checkbox row" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(
      name: "avatar", label: "Avatar",
      preview_type: :avatar, initials: "AB",
      existing_file_url: "https://example.com/a.jpg"
    ))
    assert_includes html, "Select to remove current file"
  end

  test "wires the Daisy file-upload Stimulus controller on the data-controller attr" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(name: "doc", label: "Upload"))
    # The Suite class APPENDS the Daisy controller path so the existing JS
    # (registered as decor--daisy--forms--file-upload) drives drag/drop +
    # preview behaviour. Both identifiers appear on data-controller.
    assert_includes html, "decor--daisy--forms--file-upload"
    assert_includes html, "decor--suite--forms--file-upload"
  end

  test "drop zone wires daisy controller target + drag actions" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(name: "doc", label: "Upload"))
    assert_includes html, "data-decor--daisy--forms--file-upload-target=\"dropZone\""
    assert_includes html, "dragover->decor--daisy--forms--file-upload#onDragOver"
    assert_includes html, "drop->decor--daisy--forms--file-upload#onDrop"
  end

  test "max_size_in_mb prop flows through to a stimulus value" do
    html = render_component(::Decor::Suite::Forms::FileUpload.new(
      name: "doc", label: "Upload", max_size_in_mb: 12
    ))
    assert_match(/-max-size-in-mb-value="12"/, html)
  end
end
