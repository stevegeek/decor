# @label Form
class ::Decor::Forms::FormPreview < ::Lookbook::Preview
  # Form
  # -------
  #
  # A form component that wraps Rails form_with helper with additional Stimulus functionality.
  # Provides form validation, AJAX submission handling, and custom events.
  #
  # @label Playground
  # @param local [Boolean] checkbox
  # @param http_method select [get, post, patch, delete]
  def playground(local: true, http_method: :post)
    # Create a simple form model for demonstration
    model = OpenStruct.new(name: "", email: "", message: "")

    render ::Decor::Forms::Form.new(
      model: model,
      url: "#",
      local: local,
      http_method: http_method
    ) do |form|
      content_tag(:div, class: "space-y-6") do
        concat content_tag(:h2, "Contact Form", class: "text-lg font-medium text-gray-900")

        concat form.builder.text_field(:name,
          label: "Full Name",
          placeholder: "Enter your full name",
          required: true,
          class: "mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500")

        concat form.builder.email_field(:email,
          label: "Email Address",
          placeholder: "Enter your email",
          required: true,
          class: "mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500")

        concat form.builder.text_area(:message,
          label: "Message",
          placeholder: "Enter your message",
          rows: 4,
          class: "mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500")

        concat content_tag(:div, class: "flex justify-end") do
          form.builder.submit("Send Message", class: "inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500")
        end
      end
    end
  end

  # @label Basic Form
  def basic_form
    model = OpenStruct.new(title: "", description: "")

    render ::Decor::Forms::Form.new(
      model: model,
      url: "#",
      local: true
    ) do |form|
      content_tag(:div, class: "space-y-4") do
        concat content_tag(:h3, "Basic Form Example", class: "text-md font-medium")

        concat form.builder.text_field(:title,
          label: "Title",
          placeholder: "Enter title")

        concat form.builder.text_area(:description,
          label: "Description",
          placeholder: "Enter description",
          rows: 3)

        concat form.builder.submit("Save", class: "btn btn-primary")
      end
    end
  end

  # @label AJAX Form
  def ajax_form
    model = OpenStruct.new(feedback: "")

    render ::Decor::Forms::Form.new(
      model: model,
      url: "#",
      local: false, # AJAX form
      on_success: "form--feedback#onSuccess",
      on_error: "form--feedback#onError"
    ) do |form|
      content_tag(:div, class: "space-y-4") do
        concat content_tag(:h3, "AJAX Form Example", class: "text-md font-medium")
        concat content_tag(:p, "This form submits via AJAX with custom event handlers", class: "text-sm text-gray-600")

        concat form.builder.text_area(:feedback,
          label: "Feedback",
          placeholder: "Share your feedback",
          rows: 3)

        concat form.builder.submit("Submit Feedback", class: "btn btn-primary")
      end
    end
  end

  # @label Form with Custom Namespace
  def namespaced_form
    model = OpenStruct.new(settings: {theme: "dark", notifications: true})

    render ::Decor::Forms::Form.new(
      model: model,
      url: "#",
      namespace: :settings
    ) do |form|
      content_tag(:div, class: "space-y-4") do
        concat content_tag(:h3, "Settings Form", class: "text-md font-medium")

        concat form.builder.select(:theme,
          options_for_select([["Light", "light"], ["Dark", "dark"]], "dark"),
          {label: "Theme"})

        concat form.builder.check_box(:notifications,
          label: "Enable Notifications")

        concat form.builder.submit("Save Settings", class: "btn btn-primary")
      end
    end
  end
end
