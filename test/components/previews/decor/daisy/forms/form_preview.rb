# @label Form
class ::Decor::Daisy::Forms::FormPreview < ::Lookbook::Preview
  # A form component that wraps Rails form_with helper with Stimulus functionality.
  # Provides form validation, AJAX submission handling, and custom events.

  # @!group Examples

  # @label Basic Form
  def basic_form
    klass = Class.new(TypedForm) do
      prop :title, String
      prop :description, String

      def self.name
        "BasicFormClass"
      end
    end
    model = klass.new(title: "", description: "")

    render ::Decor::Daisy::Forms::Form.new(
      model: model,
      url: "#",
      local: true
    ) do |form|
      form.render ::Decor::Daisy::Element.new do |el|
        el.h3(class: "decor:text-md decor:font-medium") { "Basic Form Example" }

        form.raw form.builder.text_field(:title,
          label: "Title",
          placeholder: "Enter title")

        form.raw form.builder.text_area(:description,
          label: "Description",
          placeholder: "Enter description",
          rows: 3)

        form.raw form.builder.submit("Save", classes: "decor:d-btn decor:d-btn-primary")
      end
    end
  end

  # @label AJAX Form
  def ajax_form
    klass = Class.new(TypedForm) do
      prop :feedback, String

      def self.name
        "AjaxFormClass"
      end
    end
    model = klass.new(feedback: "")

    render ::Decor::Daisy::Forms::Form.new(
      model: model,
      url: "#",
      local: false # AJAX form
    ) do |form|
      form.render ::Decor::Daisy::Element.new do |el|
        el.h3(class: "decor:text-md decor:font-medium") { "AJAX Form Example" }
        el.p(class: "decor:text-sm decor:text-gray-600") { "This form submits via AJAX with custom event handlers" }

        form.raw form.builder.text_area(:feedback,
          label: "Feedback",
          placeholder: "Share your feedback",
          rows: 3)

        form.raw form.builder.submit("Submit Feedback", classes: "decor:d-btn decor:d-btn-primary")
      end
    end
  end

  # @label Form with Namespace
  def namespaced_form
    klass = Class.new(TypedForm) do
      prop :theme, String
      prop :notifications, _Boolean

      def self.name
        "SettingsFormClass"
      end
    end
    model = klass.new(theme: "dark", notifications: true)

    render ::Decor::Daisy::Forms::Form.new(
      model: model,
      url: "#",
      namespace: :settings
    ) do |form|
      form.render ::Decor::Daisy::Element.new do |el|
        el.h3(class: "decor:text-md decor:font-medium") { "Settings Form" }

        form.raw form.builder.select(:theme,
          [["Light", "light"], ["Dark", "dark"]],
          {label: "Theme"})

        form.raw form.builder.check_box(:notifications,
          label: "Enable Notifications")

        form.raw form.builder.submit("Save Settings", classes: "decor:d-btn decor:d-btn-primary")
      end
    end
  end

  # @!endgroup

  # @!group Playground

  # @label Playground
  # @param local [Boolean] toggle "Submit form locally (true) or via AJAX (false)"
  # @param http_method select { choices: [get, post, patch, delete] } "HTTP method for form submission"
  def playground(local: true, http_method: :post)
    # Create a simple form model for demonstration
    klass = Class.new(TypedForm) do
      prop :name, String
      prop :email, String
      prop :message, String

      def self.name
        "TestFormClass"
      end
    end
    model = klass.new(name: "", email: "", message: "")

    render ::Decor::Daisy::Forms::Form.new(
      model: model,
      url: "#",
      local: local,
      http_method: http_method
    ) do |form|
      form.render ::Decor::Daisy::Element.new do |el|
        el.h2(class: "decor:text-lg decor:font-medium decor:text-gray-900") { "Contact Form" }

        # TODO: work out why we need the `raw` method here
        form.raw form.builder.text_field(:name,
          label: "Full Name",
          placeholder: "Enter your full name",
          required: true,
          classes: "decor:mt-1 decor:block decor:w-full decor:border-gray-300 decor:rounded-md decor:shadow-sm decor:focus:ring-indigo-500 decor:focus:border-indigo-500")
        form.raw form.builder.email_field(:email,
          label: "Email Address",
          placeholder: "Enter your email",
          required: true,
          classes: "decor:mt-1 decor:block decor:w-full decor:border-gray-300 decor:rounded-md decor:shadow-sm decor:focus:ring-indigo-500 decor:focus:border-indigo-500")
        form.raw form.builder.text_area(:message,
          label: "Message",
          placeholder: "Enter your message",
          rows: 4,
          classes: "decor:mt-1 decor:block decor:w-full decor:border-gray-300 decor:rounded-md decor:shadow-sm decor:focus:ring-indigo-500 decor:focus:border-indigo-500")
        el.div class: "decor:flex decor:justify-end" do
          form.raw form.builder.submit("Send Message", classes: "decor:inline-flex decor:justify-center decor:py-2 decor:px-4 decor:border decor:border-transparent decor:shadow-sm decor:text-sm decor:font-medium decor:rounded-md decor:text-white decor:bg-indigo-600 decor:hover:bg-indigo-700 decor:focus:outline-none decor:focus:ring-2 decor:focus:ring-offset-2 decor:focus:ring-indigo-500")
        end
      end
    end
  end

  # @!endgroup
end
