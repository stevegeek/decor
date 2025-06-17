# @label Progress
class ::Decor::ProgressPreview < ::Lookbook::Preview
  # Progress Component
  # ==================
  #
  # A versatile progress component for showing completion through multi-step processes.
  # Supports DaisyUI-powered features with multiple variants, colors, and sizes.
  #
  # ## Features
  # - **Multiple Variants**: Steps-only, progress bar-only, or combined display
  # - **Color Themes**: 7 semantic color options for different contexts
  # - **Size Options**: 4 sizes from extra small to large
  # - **Accessibility**: Proper ARIA labels and semantic HTML
  # - **Interactive**: Clickable completed steps with optional links
  #
  # @label Interactive Playground
  # @param i18n_key text
  # @param current_step number
  # @param color [Symbol] select [primary, secondary, accent, success, error, warning, info]
  # @param size [Symbol] select [xs, sm, md, lg]
  # @param variant [Symbol] select [steps, progress, both]
  # @param show_numbers toggle
  # @param animated toggle
  # @param vertical toggle
  def playground(
    i18n_key: "",
    current_step: 3,
    color: :primary,
    size: :md,
    variant: :steps,
    show_numbers: true,
    animated: true,
    vertical: false
  )
    render ::Decor::Progress.new(
      steps: [
        {label_key: "Account Setup", href: (current_step > 1) ? "#account" : nil},
        {label_key: "Profile Info", href: (current_step > 2) ? "#profile" : nil},
        {label_key: "Preferences", href: (current_step > 3) ? "#preferences" : nil},
        {label_key: "Confirmation"}
      ],
      i18n_key: i18n_key.presence,
      current_step: current_step,
      color: color,
      size: size,
      variant: variant,
      show_numbers: show_numbers,
      animated: animated,
      vertical: vertical
    )
  end

  # @group Display Variants
  # @label Steps Only
  def variant_steps_only
    render ::Decor::Progress.new(
      steps: [
        {label_key: "Register"},
        {label_key: "Choose Plan"},
        {label_key: "Payment"},
        {label_key: "Complete"}
      ],
      current_step: 3,
      color: :primary
    )
  end

  # @group Display Variants
  # @label Progress Bar Only
  def variant_progress_only
    render ::Decor::Progress.new(
      steps: [
        {label_key: "Uploading"},
        {label_key: "Processing"},
        {label_key: "Analyzing"},
        {label_key: "Complete"}
      ],
      current_step: 2,
      variant: :progress,
      color: :success,
      size: :lg,
      animated: true
    )
  end

  # @group Display Variants
  # @label Vertical Steps
  def variant_vertical_steps
    render ::Decor::Progress.new(
      steps: [
        {label_key: "Account Setup"},
        {label_key: "Profile Info"},
        {label_key: "Preferences"},
        {label_key: "Confirmation"}
      ],
      current_step: 2,
      variant: :steps,
      color: :primary,
      vertical: true
    )
  end

  # @group Display Variants
  # @label Combined Display
  def variant_combined
    render ::Decor::Progress.new(
      steps: [
        {label_key: "Data Collection"},
        {label_key: "Processing"},
        {label_key: "Analysis"},
        {label_key: "Report Generation"}
      ],
      current_step: 3,
      variant: :both,
      color: :accent
    )
  end

  # @group Colors
  # @label Primary Color
  def color_primary
    render ::Decor::Progress.new(
      steps: standard_steps,
      current_step: 3,
      color: :primary
    )
  end

  # @group Colors
  # @label Secondary Color
  def color_secondary
    render ::Decor::Progress.new(
      steps: standard_steps,
      current_step: 2,
      color: :secondary
    )
  end

  # @group Colors
  # @label Success Color
  def color_success
    render ::Decor::Progress.new(
      steps: standard_steps,
      current_step: 4,
      color: :success
    )
  end

  # @group Colors
  # @label Error Color
  def color_error
    render ::Decor::Progress.new(
      steps: standard_steps,
      current_step: 2,
      color: :error
    )
  end

  # @group Colors
  # @label Warning Color
  def color_warning
    render ::Decor::Progress.new(
      steps: standard_steps,
      current_step: 2,
      color: :warning
    )
  end

  # @group Colors
  # @label Info Color
  def color_info
    render ::Decor::Progress.new(
      steps: standard_steps,
      current_step: 3,
      color: :info
    )
  end

  # @group Colors
  # @label Accent Color
  def color_accent
    render ::Decor::Progress.new(
      steps: standard_steps,
      current_step: 4,
      color: :accent
    )
  end

  # @group Sizes
  # @label Extra Small
  def size_xs
    render ::Decor::Progress.new(
      steps: compact_steps,
      current_step: 2,
      size: :xs,
      variant: :steps
    )
  end

  # @group Sizes
  # @label Small
  def size_sm
    render ::Decor::Progress.new(
      steps: compact_steps,
      current_step: 2,
      size: :sm,
      variant: :steps
    )
  end

  # @group Sizes
  # @label Medium (Default)
  def size_md
    render ::Decor::Progress.new(
      steps: compact_steps,
      current_step: 2,
      size: :md,
      variant: :steps
    )
  end

  # @group Sizes
  # @label Large
  def size_lg
    render ::Decor::Progress.new(
      steps: compact_steps,
      current_step: 2,
      size: :lg,
      variant: :steps
    )
  end

  # @group Sizes
  # @label Large Vertical Steps
  def size_lg_steps
    render ::Decor::Progress.new(
      steps: [
        {label_key: "Account Created"},
        {label_key: "Email Verified"},
        {label_key: "Profile Completed"},
        {label_key: "Subscription Active"}
      ],
      current_step: 3,
      size: :lg,
      color: :success,
      vertical: true
    )
  end

  # @group Examples
  # @label E-commerce Checkout
  def example_checkout
    render ::Decor::Progress.new(
      steps: [
        {label_key: "Cart", href: "/cart"},
        {label_key: "Shipping", href: "/checkout/shipping"},
        {label_key: "Payment", href: "/checkout/payment"},
        {label_key: "Review"},
        {label_key: "Complete"}
      ],
      current_step: 3,
      color: :primary,
      variant: :both
    )
  end

  # @group Examples
  # @label File Upload Process
  def example_file_upload
    render ::Decor::Progress.new(
      steps: [
        {label_key: "Selecting Files"},
        {label_key: "Uploading"},
        {label_key: "Processing"},
        {label_key: "Complete"}
      ],
      current_step: 2,
      variant: :steps,
      color: :info,
      size: :lg,
      animated: true
    )
  end

  # @group Examples
  # @label User Onboarding
  def example_onboarding
    render ::Decor::Progress.new(
      steps: [
        {label_key: "Welcome"},
        {label_key: "Setup Profile"},
        {label_key: "Connect Accounts"},
        {label_key: "Customize"},
        {label_key: "Get Started"}
      ],
      current_step: 3,
      show_numbers: false,
      color: :accent
    )
  end


  # @group States
  # @label Not Started
  def state_not_started
    render ::Decor::Progress.new(
      steps: standard_steps,
      current_step: 0,
      variant: :both,
      color: :primary
    )
  end

  # @group States
  # @label In Progress
  def state_in_progress
    render ::Decor::Progress.new(
      steps: standard_steps,
      current_step: 2,
      variant: :both,
      color: :primary
    )
  end

  # @group States
  # @label Completed
  def state_completed
    render ::Decor::Progress.new(
      steps: [
        {label_key: "Started", href: "#"},
        {label_key: "In Progress", href: "#"},
        {label_key: "Finishing", href: "#"},
        {label_key: "Done!", href: "#"}
      ],
      current_step: 5,
      variant: :both,
      color: :success
    )
  end

  # @group Options
  # @label Without Numbers
  def option_no_numbers
    render ::Decor::Progress.new(
      steps: standard_steps,
      current_step: 3,
      show_numbers: false,
      color: :secondary
    )
  end

  # @group Options
  # @label Progress Bar Animation
  def option_progress_bar_animation
    current_step = 2
    render ::Decor::Element.new(
      options: {
        controllers: ["decor--progress-animation"]
      }
    ) do |el|
      el.render ::Decor::Progress.new(
        steps: [
          {label_key: "Initialize"},
          {label_key: "Process"},
          {label_key: "Analyze"},
          {label_key: "Optimize"},
          {label_key: "Complete"}
        ],
        current_step:,
        variant: :both,
        color: :success,
        size: :lg,
        actions: [
          # FIXME: vident syntax here is confusing, ie an event in this case from el, triggering an action in progress controller,
          # (ok its more confusing as we are using a custom controller here
          # could be at least [el.event(:"changed"), :handle_step_changed], better more explicit {event: el.event(:"changed"), action: :handle_step_changed}
          # Note we listen on the window as we are a child of the Decor::Element here and since events are bubbled up, we can listen on the window.
          [:"decor--progress-animation:changed@window", :handle_step_changed]
        ]
      )
    end
  end

  # @group Options
  # @label With Clickable Links
  def option_with_links
    render ::Decor::Progress.new(
      steps: [
        {label_key: "Step 1", href: "#step1"},
        {label_key: "Step 2", href: "#step2"},
        {label_key: "Step 3"},
        {label_key: "Step 4"}
      ],
      current_step: 3,
      color: :primary
    )
  end

  private

  def standard_steps
    [
      {label_key: "Step 1"},
      {label_key: "Step 2"},
      {label_key: "Step 3"},
      {label_key: "Step 4"}
    ]
  end

  def compact_steps
    [
      {label_key: "A"},
      {label_key: "B"},
      {label_key: "C"}
    ]
  end
end
