# @label Form
class ::Decor::Forms::FormPreview < ::Lookbook::Preview
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

    render ::Decor::Forms::Form.new(
      model: model,
      url: "#",
      local: true
    ) do |form|
      form.render ::Decor::Element.new do |el|
        el.h3(class: "text-md font-medium") { "Basic Form Example" }

        form.raw form.builder.text_field(:title,
          label: "Title",
          placeholder: "Enter title")

        form.raw form.builder.text_area(:description,
          label: "Description",
          placeholder: "Enter description",
          rows: 3)

        form.raw form.builder.submit("Save", classes: "btn btn-primary")
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

    render ::Decor::Forms::Form.new(
      model: model,
      url: "#",
      local: false # AJAX form
    ) do |form|
      form.render ::Decor::Element.new do |el|
        el.h3(class: "text-md font-medium") { "AJAX Form Example" }
        el.p(class: "text-sm text-gray-600") { "This form submits via AJAX with custom event handlers" }

        form.raw form.builder.text_area(:feedback,
          label: "Feedback",
          placeholder: "Share your feedback",
          rows: 3)

        form.raw form.builder.submit("Submit Feedback", classes: "btn btn-primary")
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

    render ::Decor::Forms::Form.new(
      model: model,
      url: "#",
      namespace: :settings
    ) do |form|
      form.render ::Decor::Element.new do |el|
        el.h3(class: "text-md font-medium") { "Settings Form" }

        form.raw form.builder.select(:theme,
          [["Light", "light"], ["Dark", "dark"]],
          {label: "Theme"})

        form.raw form.builder.check_box(:notifications,
          label: "Enable Notifications")

        form.raw form.builder.submit("Save Settings", classes: "btn btn-primary")
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

    render ::Decor::Forms::Form.new(
      model: model,
      url: "#",
      local: local,
      http_method: http_method
    ) do |form|
      form.render ::Decor::Element.new do |el|
        el.h2(class: "text-lg font-medium text-gray-900") { "Contact Form" }

        # TODO: work out why we need the `raw` method here
        form.raw form.builder.text_field(:name,
          label: "Full Name",
          placeholder: "Enter your full name",
          required: true,
          classes: "mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500")
        form.raw form.builder.email_field(:email,
          label: "Email Address",
          placeholder: "Enter your email",
          required: true,
          classes: "mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500")
        form.raw form.builder.text_area(:message,
          label: "Message",
          placeholder: "Enter your message",
          rows: 4,
          classes: "mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500")
        el.div class: "flex justify-end" do
          form.raw form.builder.submit("Send Message", classes: "inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500")
        end
      end
    end
  end

  # @!endgroup
end
