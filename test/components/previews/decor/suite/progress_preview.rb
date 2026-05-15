# @label Progress
class ::Decor::Suite::ProgressPreview < ::Lookbook::Preview
  # Progress (Suite)
  # ----------------
  #
  # Two display modes:
  #
  # - `:steps`    — circle markers + dot connectors. Horizontal on lg+,
  #                stacked vertically on mobile.
  # - `:progress` — linear bar (muted track + saturated fill).
  # - `:both`     — bar above hairline divider above steps.
  #
  # All colors use the suite-* numbered token scale.
  #
  # @group Examples
  # @label Steps — in progress
  def example_steps_in_progress
    render ::Decor::Suite::Progress.new(
      steps: standard_steps,
      current_step: 2
    )
  end

  # @group Examples
  # @label Steps — with links and descriptions
  def example_steps_with_links
    render ::Decor::Suite::Progress.new(
      steps: [
        {label_key: "Cart", href: "#cart"},
        {label_key: "Shipping", href: "#shipping"},
        {label_key: "Payment"},
        {label_key: "Review"}
      ],
      current_step: 3
    )
  end

  # @group Examples
  # @label Progress bar only
  def example_progress_bar
    render ::Decor::Suite::Progress.new(
      steps: standard_steps,
      current_step: 3,
      style: :progress
    )
  end

  # @group Examples
  # @label Both — bar + steps
  def example_both
    render ::Decor::Suite::Progress.new(
      steps: standard_steps,
      current_step: 2,
      style: :both
    )
  end

  # @group Examples
  # @label Vertical steps
  def example_vertical
    render ::Decor::Suite::Progress.new(
      steps: standard_steps,
      current_step: 2,
      vertical: true
    )
  end

  # @group Colors
  # @label Primary
  def color_primary
    render ::Decor::Suite::Progress.new(steps: standard_steps, current_step: 2, color: :primary)
  end

  # @group Colors
  # @label Success
  def color_success
    render ::Decor::Suite::Progress.new(steps: standard_steps, current_step: 4, color: :success)
  end

  # @group Colors
  # @label Warning
  def color_warning
    render ::Decor::Suite::Progress.new(steps: standard_steps, current_step: 2, color: :warning)
  end

  # @group Colors
  # @label Error
  def color_error
    render ::Decor::Suite::Progress.new(steps: standard_steps, current_step: 2, color: :error)
  end

  # @group Colors
  # @label Neutral
  def color_neutral
    render ::Decor::Suite::Progress.new(steps: standard_steps, current_step: 2, color: :neutral)
  end

  # @group Bar Colors
  # @label Primary bar
  def bar_color_primary
    render ::Decor::Suite::Progress.new(steps: standard_steps, current_step: 2, style: :progress, color: :primary)
  end

  # @group Bar Colors
  # @label Success bar
  def bar_color_success
    render ::Decor::Suite::Progress.new(steps: standard_steps, current_step: 3, style: :progress, color: :success)
  end

  # @group Bar Colors
  # @label Warning bar
  def bar_color_warning
    render ::Decor::Suite::Progress.new(steps: standard_steps, current_step: 2, style: :progress, color: :warning)
  end

  # @group Bar Colors
  # @label Error bar
  def bar_color_error
    render ::Decor::Suite::Progress.new(steps: standard_steps, current_step: 2, style: :progress, color: :error)
  end

  # @group Sizes
  # @label xs
  def size_xs
    render ::Decor::Suite::Progress.new(steps: standard_steps, current_step: 2, size: :xs)
  end

  # @group Sizes
  # @label sm
  def size_sm
    render ::Decor::Suite::Progress.new(steps: standard_steps, current_step: 2, size: :sm)
  end

  # @group Sizes
  # @label md (default)
  def size_md
    render ::Decor::Suite::Progress.new(steps: standard_steps, current_step: 2, size: :md)
  end

  # @group Sizes
  # @label lg
  def size_lg
    render ::Decor::Suite::Progress.new(steps: standard_steps, current_step: 2, size: :lg)
  end

  # @group States
  # @label Not started
  def state_not_started
    render ::Decor::Suite::Progress.new(steps: standard_steps, current_step: 0, style: :both)
  end

  # @group States
  # @label Completed
  def state_completed
    render ::Decor::Suite::Progress.new(steps: standard_steps, current_step: 5, style: :both, color: :success)
  end

  # @group Playground
  # @param current_step number
  # @param style [Symbol] select [~, steps, progress, both]
  # @param color [Symbol] select [~, primary, secondary, accent, neutral, success, error, warning, info]
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param show_numbers toggle
  # @param vertical toggle
  def playground(current_step: 2, style: nil, color: nil, size: nil, show_numbers: true, vertical: false)
    render ::Decor::Suite::Progress.new(
      steps: standard_steps,
      current_step: current_step,
      style: style,
      color: color,
      size: size,
      show_numbers: show_numbers,
      vertical: vertical
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
end
