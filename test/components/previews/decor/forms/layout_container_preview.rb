# Form layout container for organizing form sections with optional action buttons
# @label LayoutContainer
class ::Decor::Forms::LayoutContainerPreview < ::Lookbook::Preview
  # @!group Examples

  # Basic layout container with sections
  def default
    render ::Decor::Forms::LayoutContainer.new do |container|
      container.render ::Decor::Forms::LayoutSection.new(title: "Personal Information") do |section|
        section.render ::Decor::Forms::TextField.new(label: "First Name", name: "first_name")
        section.render ::Decor::Forms::TextField.new(label: "Last Name", name: "last_name")
      end

      container.render ::Decor::Forms::LayoutSection.new(title: "Contact Details") do |section|
        section.render ::Decor::Forms::TextField.new(label: "Email", name: "email", type: :email)
        section.render ::Decor::Forms::TextField.new(label: "Phone", name: "phone", type: :tel)
      end
    end
  end

  # Layout container with action buttons
  def with_buttons
    render ::Decor::Forms::LayoutContainer.new do |container|
      container.with_buttons do
        container.render ::Decor::Button.new(label: "Cancel", color: :secondary)
        container.render ::Decor::Button.new(label: "Save Changes", color: :primary)
      end

      container.render ::Decor::Forms::LayoutSection.new(title: "Account Settings") do |section|
        section.render ::Decor::Forms::TextField.new(label: "Username", name: "username")
        section.render ::Decor::Forms::Switch.new(label: "Enable notifications", name: "notifications")
      end
    end
  end

  # Complex form with multiple sections and helper text
  def complex_form
    render ::Decor::Forms::LayoutContainer.new do |container|
      container.with_buttons do
        container.render ::Decor::Button.new(label: "Reset", style: :outlined)
        container.render ::Decor::Button.new(label: "Submit", color: :primary)
      end

      container.render ::Decor::Forms::LayoutSection.new(
        title: "Basic Information",
        description: "Please provide your basic details"
      ) do |section|
        section.render ::Decor::Forms::TextField.new(
          label: "Full Name",
          name: "name",
          required: true,
          helper_text: "Enter your full legal name"
        )
        section.render ::Decor::Forms::Select.new(
          options_array: [["United States", "US"], ["Canada", "CA"], ["Mexico", "MX"]],
          label: "Country",
          name: "country",
          placeholder: "Select a country"
        )
      end

      container.render ::Decor::Forms::LayoutSection.new(
        title: "Preferences",
        description: "Customize your experience"
      ) do |section|
        section.render ::Decor::Forms::ButtonRadioGroup.new(
          label: "Theme",
          name: "theme",
          choices: [["Light", "light"], ["Dark", "dark"], ["Auto", "auto"]],
          value: "auto"
        )
      end
    end
  end

  # @!endgroup

  # @!group Playground

  # @param with_buttons toggle "Show action buttons"
  # @param sections select "Number of sections" [[1, "1"], [2, "2"], [3, "3"]]
  # @param section_titles toggle "Show section titles"
  # @param section_descriptions toggle "Show section descriptions"
  def playground(
    with_buttons: true,
    sections: 2,
    section_titles: true,
    section_descriptions: false
  )
    render ::Decor::Forms::LayoutContainer.new do |container|
      if with_buttons
        container.with_buttons do
          container.render ::Decor::Button.new(label: "Cancel", style: :secondary)
          container.render ::Decor::Button.new(label: "Save", style: :primary)
        end
      end

      sections.times do |i|
        title = section_titles ? "Section #{i + 1}" : nil
        description = section_descriptions ? "Description for section #{i + 1}" : nil

        container.render ::Decor::Forms::LayoutSection.new(
          title: title,
          description: description
        ) do |section|
          section.render ::Decor::Forms::TextField.new(
            label: "Field #{i + 1}.1",
            name: "field_#{i}_1"
          )
          section.render ::Decor::Forms::TextField.new(
            label: "Field #{i + 1}.2",
            name: "field_#{i}_2"
          )
        end
      end
    end
  end

  # @!endgroup

  # @!group Layout Variations

  # Single section layout
  def single_section
    render ::Decor::Forms::LayoutContainer.new do |container|
      container.render ::Decor::Forms::LayoutSection.new(title: "User Profile") do |section|
        section.render ::Decor::Forms::TextField.new(label: "Display Name", name: "display_name")
        section.render ::Decor::Forms::TextArea.new(label: "Bio", name: "bio", rows: 4)
        section.render ::Decor::Forms::FileUpload.new(label: "Profile Picture", name: "avatar")
      end
    end
  end

  # Nested form layout
  def nested_layout
    render ::Decor::Forms::LayoutContainer.new do |container|
      container.with_buttons do
        container.render ::Decor::Button.new(label: "Save All", style: :primary)
      end

      container.render ::Decor::Forms::LayoutSection.new(
        title: "Company Information"
      ) do |section|
        section.render ::Decor::Forms::TextField.new(label: "Company Name", name: "company_name")

        # Nested container for address
        section.render ::Decor::Forms::LayoutContainer.new do |nested|
          nested.render ::Decor::Forms::LayoutSection.new(
            title: "Address",
            description: "Primary business address"
          ) do |address_section|
            address_section.render ::Decor::Forms::TextField.new(label: "Street", name: "street")
            address_section.render ::Decor::Forms::TextField.new(label: "City", name: "city")
            address_section.render ::Decor::Forms::TextField.new(label: "ZIP", name: "zip")
          end
        end
      end
    end
  end

  # @!endgroup

  # @!group Button Configurations

  # Multiple button styles
  def button_variations
    render ::Decor::Forms::LayoutContainer.new do |container|
      container.with_buttons do
        container.render ::Decor::Button.new(label: "Delete", style: :danger, size: :sm)
        container.render ::Decor::Button.new(label: "Cancel", style: :outline)
        container.render ::Decor::Button.new(label: "Save Draft", style: :secondary)
        container.render ::Decor::Button.new(label: "Publish", style: :primary)
      end

      container.render ::Decor::Forms::LayoutSection.new(title: "Content") do |section|
        section.render ::Decor::Forms::TextField.new(label: "Title", name: "title")
      end
    end
  end

  # Centered button layout
  def centered_buttons
    render ::Decor::Forms::LayoutContainer.new do |container|
      container.with_buttons(class: "justify-center") do
        container.render ::Decor::Button.new(label: "Go Back", style: :outline)
        container.render ::Decor::Button.new(label: "Continue", style: :primary)
      end

      container.render ::Decor::Forms::LayoutSection.new(title: "Code") do |section|
        section.render ::Decor::Forms::TextField.new(label: "Enter code", name: "code")
      end
    end
  end

  # @!endgroup
end
