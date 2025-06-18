# frozen_string_literal: true

# @label Flow Step
class ::Decor::FlowStepPreview < ::Lookbook::Preview
  # Flow Step
  # ---------
  #
  # A flow step component for displaying sequential process steps
  # with icons or numbers, titles, descriptions, and custom content.
  #
  # @label Playground
  # @param title text
  # @param description text
  # @param step number
  # @param icon text
  # @param size select [xs, sm, md, lg, xl]
  # @param color select [primary, secondary, accent, success, error, warning, info, neutral]
  # @param variant select [filled, outlined, ghost]
  def playground(title: "Step Title", description: "Step description goes here", step: 1, icon: nil, size: :md, color: :info, variant: :filled)
    render ::Decor::FlowStep.new(
      title: title,
      description: description,
      step: step,
      icon: icon&.presence,
      size: size.to_sym,
      color: color.to_sym,
      variant: variant.to_sym
    ) do
      "Additional step content can go here."
    end
  end

  # Basic step with number
  # @label With Step Number
  def with_step_number
    render ::Decor::FlowStep.new(
      title: "Create Account",
      description: "Set up your new account with basic information",
      step: 1
    ) do
      content_tag :div, class: "mt-2 text-sm" do
        "Fill out the form below to get started."
      end
    end
  end

  # Step with icon
  # @label With Icon
  def with_icon
    render ::Decor::FlowStep.new(
      title: "Verification Complete",
      description: "Your account has been successfully verified",
      icon: "check",
      color: :success,
      variant: :filled
    ) do
      content_tag :div, class: "mt-2" do
        render ::Decor::Button.new(label: "Continue", variant: :primary, size: :sm)
      end
    end
  end

  # Different colors
  # @label All Colors
  def all_colors
    colors = [
      {color: :info, title: "Information Step", description: "This is an informational step"},
      {color: :success, title: "Success Step", description: "This step completed successfully"},
      {color: :warning, title: "Warning Step", description: "This step needs attention"},
      {color: :error, title: "Error Step", description: "This step has an error"},
      {color: :primary, title: "Primary Step", description: "This step uses primary color"}
    ]

    content_tag :div, class: "space-y-6" do
      colors.map.with_index do |config, index|
        render ::Decor::FlowStep.new(
          title: config[:title],
          description: config[:description],
          step: index + 1,
          color: config[:color],
          variant: :filled
        )
      end.join.html_safe
    end
  end

  # Multi-step flow example
  # @label Multi-Step Flow
  def multi_step_flow
    steps = [
      {
        title: "Account Setup",
        description: "Create your account and verify your email",
        step: 1,
        color: :success,
        variant: :filled,
        content: "✓ Completed"
      },
      {
        title: "Profile Information",
        description: "Add your personal and professional details",
        step: 2,
        color: :info,
        variant: :filled,
        content: "In progress..."
      },
      {
        title: "Preferences",
        description: "Configure your notification and privacy settings",
        step: 3,
        color: :info,
        variant: :outlined,
        content: "Pending"
      },
      {
        title: "Review & Launch",
        description: "Review your setup and activate your account",
        step: 4,
        color: :info,
        variant: :outlined,
        content: "Pending"
      }
    ]

    content_tag :div, class: "max-w-2xl" do
      steps.each do |step_config|
        render ::Decor::FlowStep.new(
          title: step_config[:title],
          description: step_config[:description],
          step: step_config[:step],
          color: step_config[:color],
          variant: step_config[:variant]
        ) do
          content_tag :div, class: "text-sm font-medium" do
            step_config[:content]
          end
        end
      end
    end
  end

  # Step with complex content
  # @label With Complex Content
  def with_complex_content
    render ::Decor::FlowStep.new(
      title: "Upload Documents",
      description: "Upload required verification documents",
      step: 2,
      color: :warning,
      variant: :filled
    ) do
      content_tag :div, class: "space-y-3" do
        safe_join([
          content_tag(:div, class: "grid grid-cols-1 gap-2") do
            safe_join([
              content_tag(:div, class: "flex items-center justify-between p-2 bg-gray-50 rounded") do
                safe_join([
                  content_tag(:span, "ID Document", class: "text-sm"),
                  render(::Decor::Badge.new(label: "Required", color: :warning))
                ])
              end,
              content_tag(:div, class: "flex items-center justify-between p-2 bg-gray-50 rounded") do
                safe_join([
                  content_tag(:span, "Proof of Address", class: "text-sm"),
                  render(::Decor::Badge.new(label: "Optional", color: :neutral))
                ])
              end
            ])
          end,
          content_tag(:div, class: "flex gap-2") do
            safe_join([
              render(::Decor::Button.new(label: "Upload Files", variant: :primary, size: :sm)),
              render(::Decor::Button.new(label: "Skip for Now", variant: :outline, size: :sm))
            ])
          end
        ])
      end
    end
  end

  # Modern sizes
  # @label Modern Sizes
  def modern_sizes
    sizes = [:xs, :sm, :md, :lg, :xl]

    content_tag :div, class: "space-y-4" do
      sizes.map.with_index do |size, index|
        render ::Decor::FlowStep.new(
          title: "Size #{size.upcase}",
          description: "This flow step uses size #{size}",
          step: index + 1,
          size: size,
          color: :primary
        )
      end.join.html_safe
    end
  end

  # Modern colors
  # @label Modern Colors
  def modern_colors
    colors = [:primary, :secondary, :accent, :success, :error, :warning, :info, :neutral]

    content_tag :div, class: "space-y-4" do
      colors.map.with_index do |color, index|
        render ::Decor::FlowStep.new(
          title: "#{color.to_s.capitalize} Color",
          description: "This flow step uses #{color} color with filled variant",
          step: index + 1,
          color: color,
          variant: :filled
        )
      end.join.html_safe
    end
  end

  # Modern variants
  # @label Modern Variants
  def modern_variants
    variants = [
      {variant: :filled, title: "Filled Variant", description: "Solid background with contrasting text"},
      {variant: :outlined, title: "Outlined Variant", description: "Transparent background with colored border"},
      {variant: :ghost, title: "Ghost Variant", description: "Minimal styling with hover effects"}
    ]

    content_tag :div, class: "space-y-4" do
      variants.map.with_index do |config, index|
        render ::Decor::FlowStep.new(
          title: config[:title],
          description: config[:description],
          step: index + 1,
          color: :primary,
          variant: config[:variant]
        )
      end.join.html_safe
    end
  end

  # Component composition demonstration
  # @label Component Composition
  def component_composition
    content_tag :div, class: "space-y-6" do
      safe_join([
        content_tag(:h3, "Using Avatar component for step indicators:", class: "text-lg font-semibold"),
        content_tag(:div, class: "space-y-4") do
          render ::Decor::FlowStep.new(title: "Avatar Integration", description: "Step numbers rendered with Avatar component", step: 1, color: :success, variant: :filled)
        end,
        content_tag(:h3, "Using Title component for content:", class: "text-lg font-semibold mt-6"),
        content_tag(:div, class: "space-y-4") do
          render ::Decor::FlowStep.new(title: "Title Integration", description: "Title and description rendered with Title component", step: 2, color: :primary, variant: :outlined)
        end
      ])
    end
  end
end
