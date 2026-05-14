class ::Decor::Daisy::FlowStepPreview < ::Lookbook::Preview
  # FlowStep
  # --------
  #
  # A flow step component for displaying sequential process steps.
  # Features icons or numbers, titles, descriptions, and custom content.
  # Commonly used for multi-step forms, onboarding flows, and process indicators.
  #
  # @group Examples
  # @label Basic Step
  def basic_step
    render ::Decor::Daisy::FlowStep.new(
      title: "Create Account",
      description: "Set up your new account with basic information",
      step: 1
    )
  end

  # @group Examples
  # @label Step with Icon
  def step_with_icon
    render ::Decor::Daisy::FlowStep.new(
      title: "Verification Complete",
      description: "Your account has been successfully verified",
      icon: "check",
      color: :success
    )
  end

  # @group Examples
  # @label Step with Content
  def step_with_content
    render ::Decor::Daisy::FlowStep.new(
      title: "Upload Documents",
      description: "Upload required verification documents",
      step: 2,
      color: :warning
    ) do
      content_tag :div, class: "decor:mt-2" do
        render ::Decor::Daisy::Button.new(label: "Upload Files", color: :primary, size: :sm)
      end
    end
  end

  # @group Playground
  # @label Playground
  # @param title text
  # @param description text
  # @param step number
  # @param icon text
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(title: "Step Title", description: "Step description goes here", step: 1, icon: nil, size: nil, color: nil, style: nil)
    render ::Decor::Daisy::FlowStep.new(
      title: title,
      description: description,
      step: step,
      icon: icon,
      size: size,
      color: color,
      style: style
    ) do
      "Additional step content can go here."
    end
  end

  # @group Sizes
  # @label XS Size
  def size_xs
    render ::Decor::Daisy::FlowStep.new(
      title: "Extra Small Step",
      description: "This flow step uses XS size",
      step: 1,
      size: :xs
    )
  end

  # @group Sizes
  # @label SM Size
  def size_sm
    render ::Decor::Daisy::FlowStep.new(
      title: "Small Step",
      description: "This flow step uses SM size",
      step: 2,
      size: :sm
    )
  end

  # @group Sizes
  # @label MD Size (Default)
  def size_md
    render ::Decor::Daisy::FlowStep.new(
      title: "Medium Step",
      description: "This flow step uses MD size",
      step: 3,
      size: :md
    )
  end

  # @group Sizes
  # @label LG Size
  def size_lg
    render ::Decor::Daisy::FlowStep.new(
      title: "Large Step",
      description: "This flow step uses LG size",
      step: 4,
      size: :lg
    )
  end

  # @group Sizes
  # @label XL Size
  def size_xl
    render ::Decor::Daisy::FlowStep.new(
      title: "Extra Large Step",
      description: "This flow step uses XL size",
      step: 5,
      size: :xl
    )
  end

  # @group Colors
  # @label Primary Color
  def color_primary
    render ::Decor::Daisy::FlowStep.new(
      title: "Primary Step",
      description: "This step uses primary color",
      step: 1,
      color: :primary
    )
  end

  # @group Colors
  # @label Success Color
  def color_success
    render ::Decor::Daisy::FlowStep.new(
      title: "Success Step",
      description: "This step completed successfully",
      step: 2,
      color: :success
    )
  end

  # @group Colors
  # @label Warning Color
  def color_warning
    render ::Decor::Daisy::FlowStep.new(
      title: "Warning Step",
      description: "This step needs attention",
      step: 3,
      color: :warning
    )
  end

  # @group Colors
  # @label Error Color
  def color_error
    render ::Decor::Daisy::FlowStep.new(
      title: "Error Step",
      description: "This step has an error",
      step: 4,
      color: :error
    )
  end

  # @group Colors
  # @label Info Color
  def color_info
    render ::Decor::Daisy::FlowStep.new(
      title: "Information Step",
      description: "This is an informational step",
      step: 5,
      color: :info
    )
  end

  # @group Styles
  # @label Filled Style
  def style_filled
    render ::Decor::Daisy::FlowStep.new(
      title: "Filled Style",
      description: "Solid background with contrasting text",
      step: 1,
      style: :filled
    )
  end

  # @group Styles
  # @label Outlined Style
  def style_outlined
    render ::Decor::Daisy::FlowStep.new(
      title: "Outlined Style",
      description: "Transparent background with colored border",
      step: 2,
      style: :outlined
    )
  end

  # @group Styles
  # @label Ghost Style
  def style_ghost
    render ::Decor::Daisy::FlowStep.new(
      title: "Ghost Style",
      description: "Minimal styling with hover effects",
      step: 3,
      style: :ghost
    )
  end

  # @group Examples
  # @label Onboarding Flow
  def onboarding_flow
    content_tag :div, class: "decor:max-w-2xl decor:space-y-4" do
      safe_join([
        render(::Decor::Daisy::FlowStep.new(
          title: "Account Setup",
          description: "Create your account and verify your email",
          step: 1,
          color: :success,
          style: :filled
        ) do
          content_tag :div, class: "decor:text-sm decor:font-medium decor:text-success" do
            "✓ Completed"
          end
        end),
        render(::Decor::Daisy::FlowStep.new(
          title: "Profile Information",
          description: "Add your personal and professional details",
          step: 2,
          color: :info,
          style: :filled
        ) do
          content_tag :div, class: "decor:text-sm" do
            "In progress..."
          end
        end),
        render(::Decor::Daisy::FlowStep.new(
          title: "Preferences",
          description: "Configure your notification and privacy settings",
          step: 3,
          color: :info,
          style: :outlined
        )),
        render(::Decor::Daisy::FlowStep.new(
          title: "Review & Launch",
          description: "Review your setup and activate your account",
          step: 4,
          color: :info,
          style: :outlined
        ))
      ])
    end
  end

  # @group Examples
  # @label Document Upload Step
  def document_upload_step
    render ::Decor::Daisy::FlowStep.new(
      title: "Upload Documents",
      description: "Upload required verification documents",
      step: 2,
      color: :warning,
      style: :filled
    ) do
      content_tag :div, class: "decor:space-y-3" do
        safe_join([
          content_tag(:div, class: "decor:grid decor:grid-cols-1 decor:gap-2") do
            safe_join([
              content_tag(:div, class: "decor:flex decor:items-center decor:justify-between decor:p-2 decor:bg-gray-50 decor:rounded") do
                safe_join([
                  content_tag(:span, "ID Document", class: "decor:text-sm"),
                  render(::Decor::Daisy::Badge.new(label: "Required", color: :warning))
                ])
              end,
              content_tag(:div, class: "decor:flex decor:items-center decor:justify-between decor:p-2 decor:bg-gray-50 decor:rounded") do
                safe_join([
                  content_tag(:span, "Proof of Address", class: "decor:text-sm"),
                  render(::Decor::Daisy::Badge.new(label: "Optional", color: :neutral))
                ])
              end
            ])
          end,
          content_tag(:div, class: "decor:flex decor:gap-2") do
            safe_join([
              render(::Decor::Daisy::Button.new(label: "Upload Files", color: :primary, size: :sm)),
              render(::Decor::Daisy::Button.new(label: "Skip for Now", style: :outlined, size: :sm))
            ])
          end
        ])
      end
    end
  end

  # @group Examples
  # @label Error State Step
  def error_state_step
    render ::Decor::Daisy::FlowStep.new(
      title: "Payment Failed",
      description: "There was an issue processing your payment",
      icon: "x",
      color: :error,
      style: :filled
    ) do
      content_tag :div, class: "decor:space-y-2" do
        safe_join([
          content_tag(:p, "Please check your payment details and try again.", class: "decor:text-sm"),
          render(::Decor::Daisy::Button.new(label: "Retry Payment", color: :error, size: :sm))
        ])
      end
    end
  end
end
