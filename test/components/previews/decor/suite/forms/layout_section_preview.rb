# @label LayoutSection
class ::Decor::Suite::Forms::LayoutSectionPreview < ::Lookbook::Preview
  # @group Examples
  # @label Default with title + description
  def example_default
    render ::Decor::Suite::Forms::LayoutSection.new(
      title: "Profile",
      description: "This information will be displayed publicly."
    ) do
      "Field placeholder content goes here.".html_safe
    end
  end

  # @group Examples
  # @label Stacked layout
  def example_stacked
    render ::Decor::Suite::Forms::LayoutSection.new(
      title: "Notifications",
      description: "Choose how you want to be notified.",
      stacked: true
    ) do
      "Stacked field rows.".html_safe
    end
  end

  # @group Examples
  # @label With CTA
  def example_with_cta
    component = ::Decor::Suite::Forms::LayoutSection.new(
      title: "Team members",
      description: "Manage members and their roles."
    )
    component.with_cta { "[Invite]".html_safe }
    render(component) { "Member list goes here.".html_safe }
  end

  # @group Examples
  # @label With hero
  def example_with_hero
    component = ::Decor::Suite::Forms::LayoutSection.new(
      title: "Cover photo",
      description: "Shown on your public profile."
    )
    component.with_hero { "[Hero image goes here]".html_safe }
    render(component) { "Upload field goes here.".html_safe }
  end

  # @group Examples
  # @label With flash
  def example_with_flash
    render ::Decor::Suite::Forms::LayoutSection.new(
      title: "Address",
      description: "Where should we ship your order?",
      flash: true,
      flash_message: "Address verification updated."
    ) do
      "Address fields go here.".html_safe
    end
  end

  # @group Examples
  # @label Custom content wrapper
  def example_custom_wrapper
    render ::Decor::Suite::Forms::LayoutSection.new(
      title: "Custom layout",
      description: "Skip the built-in fields wrapper and own the layout.",
      custom_content_wrapper: true
    ) do
      "<div class=\"decor:p-4 decor:bg-suite-gray-25 decor:rounded-suite-card\">Custom-painted region</div>".html_safe
    end
  end

  # @group Examples
  # @label No heading
  def example_no_heading
    render ::Decor::Suite::Forms::LayoutSection.new do
      "A section without a heading still renders its content region.".html_safe
    end
  end

  # @group Playground
  # @param title text
  # @param description text
  # @param stacked toggle
  # @param custom_content_wrapper toggle
  # @param flash toggle
  # @param flash_message text
  def playground(title: "Section title", description: "Section description", stacked: false, custom_content_wrapper: false, flash: false, flash_message: "Saved.")
    render ::Decor::Suite::Forms::LayoutSection.new(
      title: title,
      description: description,
      stacked: stacked,
      custom_content_wrapper: custom_content_wrapper,
      flash: flash,
      flash_message: flash_message
    ) do
      "Field content goes here.".html_safe
    end
  end
end
