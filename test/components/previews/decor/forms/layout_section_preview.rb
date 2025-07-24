# @label LayoutSection
#
# Form sections organize related form fields with optional title, description, and additional content areas.
# Supports both grid and stacked layouts for flexible form organization.
class ::Decor::Forms::LayoutSectionPreview < ::Lookbook::Preview
  # @group Examples

  # @label Default
  # Basic form section with title and description
  def default
    render ::Decor::Forms::LayoutSection.new(
      title: "Personal Information",
      description: "Please provide your basic details."
    ) do
      '<div class="sm:col-span-4">
        <label class="block text-sm font-medium mb-2">Full Name</label>
        <input type="text" class="w-full px-3 py-2 border border-gray-300 rounded-md">
      </div>
      <div class="sm:col-span-2">
        <label class="block text-sm font-medium mb-2">Age</label>
        <input type="number" class="w-full px-3 py-2 border border-gray-300 rounded-md">
      </div>'.html_safe
    end
  end

  # @label With Flash Message
  # Section with an alert message displayed at the top
  def with_flash_message
    render ::Decor::Forms::LayoutSection.new(
      title: "Account Settings",
      description: "Update your account preferences.",
      flash: true,
      flash_message: "Your changes have been saved successfully."
    )
  end

  # @label With Hero and CTA
  # Section with hero content and call-to-action button
  def with_hero_and_cta
    render ::Decor::Forms::LayoutSection.new(
      title: "Premium Features",
      description: "Unlock additional capabilities for your account."
    ) do |section|
      section.with_hero do
        '<div class="bg-gradient-to-r from-blue-500 to-purple-600 text-white p-6 rounded-lg">
          <h2 class="text-2xl font-bold mb-2">Upgrade to Pro</h2>
          <p>Get access to advanced features and priority support.</p>
        </div>'.html_safe
      end

      section.with_cta do
        section.render ::Decor::Button.new(label: "Upgrade Now", style: :primary)
      end

      '<div class="sm:col-span-6">
        <p class="text-gray-600">Select your subscription plan and billing preferences.</p>
      </div>'.html_safe
    end
  end

  # @label Stacked Layout
  # Vertical stacking of form elements instead of grid layout
  def stacked_layout
    render ::Decor::Forms::LayoutSection.new(
      title: "Address Information",
      description: "Enter your complete mailing address.",
      stacked: true
    ) do
      '<div class="space-y-4">
        <div>
          <label class="block text-sm font-medium mb-2">Street Address</label>
          <input type="text" class="w-full px-3 py-2 border border-gray-300 rounded-md">
        </div>
        <div>
          <label class="block text-sm font-medium mb-2">City</label>
          <input type="text" class="w-full px-3 py-2 border border-gray-300 rounded-md">
        </div>
        <div>
          <label class="block text-sm font-medium mb-2">Postal Code</label>
          <input type="text" class="w-full px-3 py-2 border border-gray-300 rounded-md">
        </div>
      </div>'.html_safe
    end
  end

  # @group Playground

  # @label Playground
  # @param title text
  # @param description text
  # @param stacked_layout toggle "Use vertical layout instead of grid"
  # @param include_flash toggle "Show flash message area"
  # @param include_hero toggle "Add hero section"
  # @param include_cta toggle "Add call-to-action button"
  def playground(
    title: "Section Title",
    description: "Add a helpful description for this section.",
    stacked_layout: false,
    include_flash: false,
    include_hero: false,
    include_cta: false
  )
    render ::Decor::Forms::LayoutSection.new(
      title: title,
      description: description,
      stacked: stacked_layout,
      flash: include_flash
    ) do |section|
      if include_flash
        section.flash do
          section.render ::Decor::Flash.new(type: :info) do
            "This is an informational message for this section."
          end
        end
      end

      if include_hero
        section.with_hero do
          '<div class="bg-gray-100 p-6 rounded-lg">
            <h3 class="text-xl font-semibold mb-2">Hero Section</h3>
            <p class="text-gray-600">This area can contain promotional content or important information.</p>
          </div>'.html_safe
        end
      end

      if include_cta
        section.with_cta do
          section.render ::Decor::Button.new(label: "Take Action", style: :primary)
        end
      end

      if stacked_layout
        '<div class="space-y-4">
          <div>
            <label class="block text-sm font-medium mb-2">Field 1</label>
            <input type="text" class="w-full px-3 py-2 border border-gray-300 rounded-md">
          </div>
          <div>
            <label class="block text-sm font-medium mb-2">Field 2</label>
            <input type="text" class="w-full px-3 py-2 border border-gray-300 rounded-md">
          </div>
        </div>'.html_safe
      else
        '<div class="sm:col-span-3">
          <label class="block text-sm font-medium mb-2">Field 1</label>
          <input type="text" class="w-full px-3 py-2 border border-gray-300 rounded-md">
        </div>
        <div class="sm:col-span-3">
          <label class="block text-sm font-medium mb-2">Field 2</label>
          <input type="text" class="w-full px-3 py-2 border border-gray-300 rounded-md">
        </div>'.html_safe
      end
    end
  end

  # @group Layout Variations

  # @label Grid Layout (Default)
  # Standard grid-based form layout
  def grid_layout
    render ::Decor::Forms::LayoutSection.new(
      title: "Contact Information",
      description: "How can we reach you?"
    ) do
      '<div class="sm:col-span-3">
        <label class="block text-sm font-medium mb-2">Phone</label>
        <input type="tel" class="w-full px-3 py-2 border border-gray-300 rounded-md">
      </div>
      <div class="sm:col-span-3">
        <label class="block text-sm font-medium mb-2">Email</label>
        <input type="email" class="w-full px-3 py-2 border border-gray-300 rounded-md">
      </div>
      <div class="sm:col-span-6">
        <label class="block text-sm font-medium mb-2">Preferred Contact Method</label>
        <select class="w-full px-3 py-2 border border-gray-300 rounded-md">
          <option>Email</option>
          <option>Phone</option>
          <option>SMS</option>
        </select>
      </div>'.html_safe
    end
  end

  # @label Minimal Section
  # Section with minimal configuration
  def minimal_section
    render ::Decor::Forms::LayoutSection.new(
      title: "Additional Comments"
    ) do
      '<div class="sm:col-span-6">
        <label class="block text-sm font-medium mb-2">Comments</label>
        <textarea class="w-full px-3 py-2 border border-gray-300 rounded-md" rows="4"></textarea>
      </div>'.html_safe
    end
  end

  # @group Content Slots

  # @label All Content Slots
  # Demonstration of all available content areas
  def all_content_slots
    render ::Decor::Forms::LayoutSection.new(
      title: "Complete Example",
      description: "This section demonstrates all available content slots.",
      flash: true
    ) do |section|
      section.flash do
        section.render ::Decor::Flash.new(type: :success) do
          "All fields have been validated successfully!"
        end
      end

      section.with_hero do
        '<div class="bg-blue-50 border-2 border-blue-200 p-6 rounded-lg">
          <h3 class="text-lg font-semibold text-blue-900 mb-2">Important Notice</h3>
          <p class="text-blue-700">Please review all information carefully before submitting.</p>
        </div>'.html_safe
      end

      section.with_cta do
        '<div class="flex gap-2">'.html_safe +
          section.render(::Decor::Button.new(label: "Save Draft", style: :secondary)) +
          section.render(::Decor::Button.new(label: "Submit", style: :primary)) +
          "</div>".html_safe
      end

      '<div class="sm:col-span-6">
        <label class="block text-sm font-medium mb-2">Summary</label>
        <textarea class="w-full px-3 py-2 border border-gray-300 rounded-md" rows="3"></textarea>
      </div>'.html_safe
    end
  end
end
