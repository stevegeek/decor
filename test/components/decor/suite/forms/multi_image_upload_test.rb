# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::MultiImageUploadTest < ActiveSupport::TestCase
  test "renders root element with suite multi-image-upload identifier" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(name: "imgs", label: "Photos"))
    assert_includes html, "decor--suite--forms--multi-image-upload"
  end

  test "renders label text with suite-field-label typography" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(name: "imgs", label: "Product photos"))
    assert_includes html, "Product photos"
    assert_includes html, "decor:suite-field-label"
  end

  test "renders the Add Images button" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(name: "imgs", label: "Photos"))
    assert_includes html, "Add Images"
  end

  test "renders the image counter with default max of 10" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(name: "imgs", label: "Photos"))
    assert_includes html, "0 / 10 images"
  end

  test "renders both file inputs (picker + new_files payload)" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(name: "imgs", label: "Photos"))
    assert_match(/<input[^>]*type="file"[^>]*data-decor--daisy--forms--multi-image-upload-target="fileInput"/, html)
    assert_match(/<input[^>]*type="file"[^>]*name="imgs\[new_images\]\[\]"/, html)
  end

  test "file inputs include accept attribute from file_mime_types prop" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(
      name: "imgs", label: "Photos", file_mime_types: "image/png,image/jpeg"
    ))
    assert_match(/accept="image\/png,image\/jpeg"/, html)
  end

  test "wires the Daisy multi-image-upload Stimulus controller on data-controller" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(name: "imgs", label: "Photos"))
    assert_includes html, "decor--daisy--forms--multi-image-upload"
    assert_includes html, "decor--suite--forms--multi-image-upload"
  end

  test "renders sortable container target" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(name: "imgs", label: "Photos"))
    assert_includes html, "data-decor--daisy--forms--multi-image-upload-target=\"sortableContainer\""
  end

  test "filesSelected action wired on the picker input" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(name: "imgs", label: "Photos"))
    assert_includes html, "change->decor--daisy--forms--multi-image-upload#filesSelected"
  end

  test "openFilePicker action wired on the Add Images button" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(name: "imgs", label: "Photos"))
    assert_includes html, "click->decor--daisy--forms--multi-image-upload#openFilePicker"
  end

  test "renders crop modal scaffolding when enable_crop is true (default)" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(name: "imgs", label: "Photos"))
    assert_includes html, "data-decor--daisy--forms--multi-image-upload-target=\"cropModal\""
    assert_includes html, "Crop Image"
    assert_includes html, "Apply Crop"
    assert_includes html, "click->decor--daisy--forms--multi-image-upload#applyCrop"
    assert_includes html, "click->decor--daisy--forms--multi-image-upload#cancelCrop"
  end

  test "omits the crop modal when enable_crop is false" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(
      name: "imgs", label: "Photos", enable_crop: false
    ))
    refute_includes html, "Crop Image"
    refute_includes html, "Apply Crop"
    refute_includes html, "data-decor--daisy--forms--multi-image-upload-target=\"cropModal\""
  end

  test "max_size_in_mb prop flows through to a stimulus value" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(
      name: "imgs", label: "Photos", max_size_in_mb: 12
    ))
    assert_match(/-max-size-in-mb-value="12"/, html)
  end

  test "max_images prop flows through to a stimulus value and the counter" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(
      name: "imgs", label: "Photos", max_images: 4
    ))
    assert_match(/-max-images-value="4"/, html)
    assert_includes html, "0 / 4 images"
  end

  test "enable_crop + crop_aspect props flow through to stimulus values" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(
      name: "imgs", label: "Photos", enable_crop: true, crop_aspect_w: 16, crop_aspect_h: 9
    ))
    assert_match(/-enable-crop-value="true"/, html)
    assert_match(/-crop-aspect-w-value="16"/, html)
    assert_match(/-crop-aspect-h-value="9"/, html)
  end

  test "motion uses suite duration tokens" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(name: "imgs", label: "Photos"))
    assert_includes html, "decor:duration-suite-fast"
    refute_includes html, "decor:duration-150"
    refute_includes html, "decor:duration-200"
  end

  test "error_messages renders the caption in suite-danger-500 and reddens the label" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(
      name: "imgs", label: "Photos", error_messages: ["Too many"]
    ))
    assert_includes html, "Too many"
    assert_includes html, "decor:text-suite-danger-500"
    assert_includes html, "decor:text-suite-danger-700"
  end

  test "helper_text renders below when no errors" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(
      name: "imgs", label: "Photos", helper_text: "Upload up to 10 images"
    ))
    assert_includes html, "Upload up to 10 images"
    assert_includes html, "decor:suite-field-help"
  end

  test "disabled marks the Add Images button disabled and dims the wrapper" do
    html = render_component(::Decor::Suite::Forms::MultiImageUpload.new(
      name: "imgs", label: "Photos", disabled: true
    ))
    assert_includes html, "decor:disabled"
  end
end
