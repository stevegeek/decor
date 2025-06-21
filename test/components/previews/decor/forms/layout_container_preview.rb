# @label LayoutContainer
class ::Decor::Forms::LayoutContainerPreview < ::Lookbook::Preview
  # LayoutContainer
  # -------
  #
  # A layout container is a container of Forms::LayoutSections for a form.
  #
  # A form container can also render a `buttons` slot for form action buttons
  #
  # @param buttons toggle
  def playground(buttons: false)
    render ::Decor::Forms::LayoutContainer.new do |container|
      if buttons
        container.with_buttons do
          container.render ::Decor::Button.new(label: "Save")
        end
      end
      "Content goes here".html_safe
    end
  end
end
