# @label Form
class ::Decor::Suite::Forms::FormPreview < ::Lookbook::Preview
  # A top-level form wrapper that renders Rails' `form_with`, exposes the raw
  # FormBuilder via `form_component.builder`, and orchestrates client-side
  # validation across child form fields.

  # @!group Examples

  # @label Basic local form
  def example_basic
    klass = Class.new(TypedForm) do
      prop :title, String
      prop :description, String

      def self.name
        "BasicFormClass"
      end
    end
    model = klass.new(title: "", description: "")

    render ::Decor::Suite::Forms::Form.new(
      model: model,
      url: "#",
      local: true
    ) do |form_component|
      form_component.raw form_component.builder.text_field(:title,
        label: "Title",
        placeholder: "Enter title")

      form_component.raw form_component.builder.text_area(:description,
        label: "Description",
        placeholder: "Enter description",
        rows: 3)

      form_component.raw form_component.builder.submit("Save")
    end
  end

  # @label Remote (AJAX) form
  def example_remote
    klass = Class.new(TypedForm) do
      prop :feedback, String

      def self.name
        "RemoteFormClass"
      end
    end
    model = klass.new(feedback: "")

    render ::Decor::Suite::Forms::Form.new(
      model: model,
      url: "#",
      local: false
    ) do |form_component|
      form_component.raw form_component.builder.text_area(:feedback,
        label: "Feedback",
        placeholder: "Share your feedback",
        rows: 3)

      form_component.raw form_component.builder.submit("Submit Feedback")
    end
  end

  # @label With namespace
  def example_namespaced
    klass = Class.new(TypedForm) do
      prop :theme, String

      def self.name
        "SettingsFormClass"
      end
    end
    model = klass.new(theme: "dark")

    render ::Decor::Suite::Forms::Form.new(
      model: model,
      url: "#",
      namespace: :settings
    ) do |form_component|
      form_component.raw form_component.builder.select(:theme,
        [["Light", "light"], ["Dark", "dark"]],
        {label: "Theme"})

      form_component.raw form_component.builder.submit("Save")
    end
  end

  # @!endgroup

  # @!group Playground

  # @param local toggle
  # @param http_method select { choices: [get, post, patch, delete] }
  def playground(local: true, http_method: :post)
    klass = Class.new(TypedForm) do
      prop :name, String
      prop :email, String
      prop :message, String

      def self.name
        "PlaygroundFormClass"
      end
    end
    model = klass.new(name: "", email: "", message: "")

    render ::Decor::Suite::Forms::Form.new(
      model: model,
      url: "#",
      local: local,
      http_method: http_method
    ) do |form_component|
      form_component.raw form_component.builder.text_field(:name,
        label: "Full Name",
        placeholder: "Enter your full name",
        required: true)
      form_component.raw form_component.builder.email_field(:email,
        label: "Email Address",
        placeholder: "Enter your email",
        required: true)
      form_component.raw form_component.builder.text_area(:message,
        label: "Message",
        placeholder: "Enter your message",
        rows: 4)
      form_component.raw form_component.builder.submit("Send Message")
    end
  end

  # @!endgroup
end
