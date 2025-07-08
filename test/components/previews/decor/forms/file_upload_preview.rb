# @label FileUpload
class ::Decor::Forms::FileUploadPreview < ::Lookbook::Preview
  # A component for forms which is for uploading a file or image. For image or avatar variant, shows the currently
  # uploaded image, a preview of a new image selected and a checkbox to remove the currently set image.
  #
  # Form field attrs
  # @param variant [Symbol] select [~, file, image, avatar]
  # @param preview_layout [Symbol] select [~, stacked, inline]
  # @param name text
  # @param label text
  # @param label_position [Symbol] select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param floating_error_text toggle
  # @param required toggle
  # @param hide_label_required_asterisk toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  #
  # @param image select [~, "https://i.pravatar.cc/300", "https://cataas.com/cat"]
  # @param description text
  # @param file_mime_types text
  # @param initials text
  # @param shape select [~, circle, square]
  # @param max_size_in_mb text
  # @param aspect_w number
  # @param aspect_h number
  # @param clear_checkbox toggle
  # @param existing_file_url select [~, "https://i.pravatar.cc/300", "https://cataas.com/cat"]
  # @param color select [primary, secondary, accent, success, error, warning, info, ghost, neutral]
  # @param size select [xs, sm, md, lg, xl]
  def playground(
    variant: :file,
    preview_layout: :inline,
    name: "file-upload-1",
    label: "Upload a file!",
    label_position: :top,
    grid_span: nil,
    floating_error_text: false,
    value: nil,
    required: false,
    disabled: false,
    helper_text: nil,
    hide_label_required_asterisk: false,
    description: "Max 1MB",
    file_mime_types: "image/*",
    initials: "-",
    shape: :circle,
    image: nil,
    max_size_in_mb: 5,
    aspect_w: nil,
    aspect_h: nil,
    clear_checkbox: false,
    existing_file_url: nil,
    color: :primary,
    size: :md
  )
    render ::Decor::Forms::FileUpload.new(
      preview_layout: preview_layout,
      variant: variant,
      name: name,
      label: label,
      label_position: label_position,
      grid_span: grid_span,
      floating_error_text: floating_error_text,
      value: value,
      required: required,
      disabled: disabled,
      helper_text: helper_text,
      hide_required_asterisk: hide_label_required_asterisk,
      description: description,
      file_mime_types: file_mime_types,
      aspect_w: aspect_w,
      aspect_h: aspect_h,
      clear_checkbox: clear_checkbox,
      existing_file_url: existing_file_url,
      file: image,
      initials: initials,
      shape: shape,
      max_size_in_mb: max_size_in_mb,
      color: color,
      size: size
    )
  end

  # @param stacked_form toggle
  #
  # Form field attrs
  # @param label text
  # @param label_position [Symbol] select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param floating_error_text toggle
  # @param required toggle
  # @param hide_label_required_asterisk toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  #
  # @param profile_image select [~, "https://i.pravatar.cc/300", "https://cataas.com/cat"]
  # @param description text
  # @param file_mime_types text
  # @param initials text
  # @param shape select [~, circle, square]
  # @param max_size_in_mb text
  # @param button_label text
  # @param has_clear_checkbox toggle
  def in_form(
    stacked_form: true,
    label: "Upload a pic!",
    label_position: :left,
    grid_span: nil,
    floating_error_text: false,
    value: nil,
    required: nil,
    disabled: nil,
    helper_text: nil,
    hide_label_required_asterisk: nil,
    description: "Max 1MB",
    file_mime_types: "image/*",
    initials: "-",
    shape: :circle,
    profile_image: nil,
    max_size_in_mb: 5,
    button_label: nil,
    has_clear_checkbox: nil
  )
    klass = Class.new(TypedForm) do
      def self.name
        "TestClass"
      end

      prop :pic, _Nilable(_Any)
    end

    render_with_template(
      locals: {
        model: klass.new(pic: ""),
        stacked_form: stacked_form,
        label: label,
        label_position: label_position,
        grid_span: grid_span,
        floating_error_text: floating_error_text,
        value: value,
        required: required,
        disabled: disabled,
        helper_text: helper_text,
        hide_required_asterisk: hide_label_required_asterisk,
        description: description,
        file_mime_types: file_mime_types,
        clear_checkbox: has_clear_checkbox,
        initials: initials,
        shape: shape,
        existing_file_url: profile_image,
        image: profile_image,
        max_size_in_mb: max_size_in_mb,
        button_label: button_label
      }
    )
  end

  # DaisyUI Colors and Sizes
  # ------------------------
  #
  # Showcase the different color and size options available with DaisyUI styling.
  def color_and_size_examples
    render_with_template
  end
end
