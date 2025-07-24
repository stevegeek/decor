# @label FileUpload
# A flexible file upload component supporting documents, images, and avatars with preview capabilities.
class ::Decor::Forms::FileUploadPreview < ::Lookbook::Preview
  # @group Examples

  # Standard file upload for documents
  def default
    render ::Decor::Forms::FileUpload.new(
      name: "document",
      label: "Upload Document",
      preview_type: :file,
      description: "PDF, DOC, DOCX, TXT (Max 5MB)",
      file_mime_types: ".pdf,.doc,.docx,.txt",
      max_size_in_mb: 5
    )
  end

  # Image upload with preview functionality
  def image_upload
    render ::Decor::Forms::FileUpload.new(
      name: "product_image",
      label: "Product Image",
      preview_type: :image,
      preview_layout: :stacked,
      description: "JPG, PNG, GIF (Max 10MB)",
      file_mime_types: "image/*",
      max_size_in_mb: 10,
      existing_file_url: "https://i.pravatar.cc/300",
      clear_checkbox: true
    )
  end

  # Avatar upload with circular preview
  def avatar_upload
    render ::Decor::Forms::FileUpload.new(
      name: "user_avatar",
      label: "Profile Picture",
      preview_type: :avatar,
      shape: :circle,
      initials: "JD",
      description: "Square image recommended",
      file_mime_types: "image/*",
      max_size_in_mb: 2,
      existing_file_url: "https://i.pravatar.cc/300"
    )
  end

  # Within a form with validation
  def in_form_example
    klass = Class.new(TypedForm) do
      def self.name
        "ProfileForm"
      end
      prop :avatar, _Nilable(_Any)
    end

    render_with_template(
      template: "decor/forms/file_upload_preview/in_form",
      locals: {
        model: klass.new(avatar: ""),
        stacked_form: true,
        label: "Avatar",
        label_position: :left,
        grid_span: :span_full,
        floating_error_text: false,
        value: nil,
        required: true,
        disabled: false,
        helper_text: "Upload a profile picture",
        hide_required_asterisk: false,
        description: "JPG or PNG (Max 2MB)",
        file_mime_types: "image/*",
        clear_checkbox: true,
        initials: "U",
        shape: :circle,
        existing_file_url: nil,
        image: nil,
        max_size_in_mb: 2,
        button_label: "Choose Avatar"
      }
    )
  end

  # @!endgroup

  # @group Playground

  # Interactive playground with all customization options
  # @param preview_type [Symbol] select [file, image, avatar] The type of file upload display
  # @param preview_layout [Symbol] select [stacked, inline] Layout for preview elements
  # @param name text The input field name
  # @param label text Label text for the upload field
  # @param label_position [Symbol] select [top, left, right, inline, inside] Position of the label
  # @param grid_span [Symbol] select [span_1, span_2, span_half, span_4, span_5, span_full] Grid span for form layouts
  # @param floating_error_text toggle Float error messages above the field
  # @param required toggle Mark field as required
  # @param hide_label_required_asterisk toggle Hide the asterisk for required fields
  # @param disabled toggle Disable the upload field
  # @param helper_text text Additional help text below the field
  # @param value text Current field value
  # @param image select ["https://i.pravatar.cc/300", "https://cataas.com/cat"] Preview image URL
  # @param description text Description text for the upload area
  # @param file_mime_types text Accepted file types (e.g., "image/*" or ".pdf,.doc")
  # @param initials text Initials to display when no image (avatar type)
  # @param shape select [circle, square] Shape for avatar preview
  # @param max_size_in_mb text Maximum file size in megabytes
  # @param aspect_w number Aspect ratio width for image cropping
  # @param aspect_h number Aspect ratio height for image cropping
  # @param clear_checkbox toggle Show checkbox to remove existing file
  # @param existing_file_url select ["https://i.pravatar.cc/300", "https://cataas.com/cat"] URL of existing uploaded file
  # @param color select [primary, secondary, accent, success, error, warning, info, ghost, neutral] Component color theme
  # @param size select [xs, sm, md, lg, xl] Component size
  # @param style select [file, image, avatar] Visual style of the upload component
  def playground(
    preview_type: :file,
    preview_layout: :inline,
    name: "file-upload",
    label: "Upload File",
    label_position: :top,
    grid_span: nil,
    floating_error_text: false,
    value: nil,
    required: false,
    disabled: false,
    helper_text: nil,
    hide_label_required_asterisk: false,
    description: "Choose a file to upload",
    file_mime_types: "*/*",
    initials: "FU",
    shape: :circle,
    image: nil,
    max_size_in_mb: 5,
    aspect_w: nil,
    aspect_h: nil,
    clear_checkbox: false,
    existing_file_url: nil,
    color: :primary,
    size: :md,
    style: nil
  )
    render ::Decor::Forms::FileUpload.new(
      preview_layout: preview_layout,
      preview_type: style || preview_type,
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

  # @!endgroup

  # @group Preview Types

  # Standard file upload
  def file_type
    render ::Decor::Forms::FileUpload.new(
      name: "document",
      label: "Upload Document",
      preview_type: :file,
      description: "PDF, DOC, DOCX, TXT",
      file_mime_types: ".pdf,.doc,.docx,.txt"
    )
  end

  # Image upload with preview
  def image_type
    render ::Decor::Forms::FileUpload.new(
      name: "photo",
      label: "Upload Photo",
      preview_type: :image,
      description: "JPG, PNG, GIF",
      file_mime_types: "image/*",
      existing_file_url: "https://i.pravatar.cc/300",
      clear_checkbox: true
    )
  end

  # Avatar upload with initials
  def avatar_type
    render ::Decor::Forms::FileUpload.new(
      name: "avatar",
      label: "Profile Picture",
      preview_type: :avatar,
      shape: :circle,
      initials: "AB",
      description: "Upload your photo",
      file_mime_types: "image/*"
    )
  end

  # @!endgroup

  # @group Layout Options

  # Stacked preview layout
  def stacked_layout
    render ::Decor::Forms::FileUpload.new(
      name: "stacked_upload",
      label: "Stacked Layout",
      preview_type: :image,
      preview_layout: :stacked,
      existing_file_url: "https://i.pravatar.cc/300",
      description: "Preview above upload button"
    )
  end

  # Inline preview layout
  def inline_layout
    render ::Decor::Forms::FileUpload.new(
      name: "inline_upload",
      label: "Inline Layout",
      preview_type: :image,
      preview_layout: :inline,
      existing_file_url: "https://i.pravatar.cc/300",
      description: "Preview beside upload button"
    )
  end

  # @!endgroup

  # @group States

  # Required field
  def required_state
    render ::Decor::Forms::FileUpload.new(
      name: "required_file",
      label: "Required Document",
      required: true,
      description: "This field is required",
      helper_text: "Please upload a PDF or Word document"
    )
  end

  # Disabled state
  def disabled_state
    render ::Decor::Forms::FileUpload.new(
      name: "disabled_file",
      label: "Disabled Upload",
      disabled: true,
      description: "Upload is currently disabled",
      existing_file_url: "https://i.pravatar.cc/300"
    )
  end

  # With error messages
  def error_state
    render ::Decor::Forms::FileUpload.new(
      name: "error_file",
      label: "File with Error",
      error_messages: ["File size exceeds 5MB limit", "Invalid file type"],
      description: "Please fix the errors",
      color: :error
    )
  end

  # @!endgroup

  # @group Colors and Sizes

  # All available color and size combinations
  def color_and_size_examples
    render_with_template
  end

  # @!endgroup
end
