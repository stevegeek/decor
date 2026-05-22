require "test_helper"

class Decor::Daisy::ProgressTest < ActiveSupport::TestCase
  def setup
    @steps = [
      {label_key: "step_one", href: "/step-1"},
      {label_key: "step_two", href: "/step-2"},
      {label_key: "step_three", href: nil}
    ]
  end

  test "renders successfully with steps" do
    component = Decor::Daisy::Progress.new(steps: @steps, i18n_key: "progress")
    rendered = render_component(component)

    assert_includes rendered, "steps"
    assert_includes rendered, "step"
  end

  test "renders multiple steps" do
    component = Decor::Daisy::Progress.new(steps: @steps, i18n_key: "progress")

    fragment = render_fragment(component)
    list_items = fragment.css("li")
    assert_equal 3, list_items.length
  end

  test "defaults to step 1" do
    component = Decor::Daisy::Progress.new(steps: @steps, i18n_key: "progress")

    assert_equal 1, component.instance_variable_get(:@current_step)
  end

  test "renders DaisyUI steps by default" do
    component = Decor::Daisy::Progress.new(steps: @steps)
    rendered = render_component(component)

    assert_includes rendered, "steps"
    assert_includes rendered, "step"
  end

  test "renders progress bar in progress style" do
    component = Decor::Daisy::Progress.new(steps: @steps, style: :progress)
    rendered = render_component(component)

    assert_includes rendered, "<progress"
    assert_includes rendered, "progress-primary"
    refute_includes rendered, "class=\"steps"
    refute_includes rendered, "<ul"
  end

  test "renders both progress bar and steps in both style" do
    component = Decor::Daisy::Progress.new(steps: @steps, style: :both)
    rendered = render_component(component)

    assert_includes rendered, "<progress"
    assert_includes rendered, "steps"
    assert_includes rendered, "divider"
  end

  test "renders with different color styles" do
    [:primary, :secondary, :accent, :success, :error, :warning, :info].each do |color|
      component = Decor::Daisy::Progress.new(steps: @steps, color: color)
      rendered = render_component(component)

      assert_includes rendered, "step-#{color}"
    end
  end

  test "renders progress bar with correct color" do
    [:primary, :secondary, :accent, :success, :error, :warning, :info].each do |color|
      component = Decor::Daisy::Progress.new(
        steps: @steps,
        color: color,
        style: :progress
      )
      rendered = render_component(component)

      assert_includes rendered, "progress-#{color}"
    end
  end

  test "renders with different size styles" do
    [:xs, :sm, :md, :lg].each do |size|
      component = Decor::Daisy::Progress.new(
        steps: @steps,
        size: size,
        style: :progress
      )
      rendered = render_component(component)

      if size != :md
        assert_includes rendered, "progress-#{size}"
      end
    end
  end

  test "renders vertical steps when vertical is true" do
    component = Decor::Daisy::Progress.new(steps: @steps, vertical: true)
    rendered = render_component(component)

    assert_includes rendered, "steps-vertical"
  end

  test "does not render vertical steps when vertical is false" do
    component = Decor::Daisy::Progress.new(steps: @steps, vertical: false)
    rendered = render_component(component)

    refute_includes rendered, "steps-vertical"
  end

  test "large size does not automatically force vertical layout" do
    component = Decor::Daisy::Progress.new(steps: @steps, size: :lg, vertical: false)
    rendered = render_component(component)

    refute_includes rendered, "steps-vertical"
  end

  test "calculates progress value correctly" do
    component = Decor::Daisy::Progress.new(steps: @steps, current_step: 2, style: :progress)
    rendered = render_component(component)

    assert_includes rendered, 'value="33"'
    assert_includes rendered, "Progress: 33% complete"
  end

  test "handles edge cases for progress value" do
    component = Decor::Daisy::Progress.new(steps: @steps, current_step: 0, style: :progress)
    rendered = render_component(component)
    assert_includes rendered, 'value="0"'

    component = Decor::Daisy::Progress.new(steps: @steps, current_step: 5, style: :progress)
    rendered = render_component(component)
    assert_includes rendered, 'value="100"'
  end

  test "hides numbers when show_numbers is false" do
    component = Decor::Daisy::Progress.new(steps: @steps, show_numbers: false)
    rendered = render_component(component)

    refute_includes rendered, 'data-content="1"'
    refute_includes rendered, 'data-content="2"'
    refute_includes rendered, 'data-content="3"'
  end

  test "shows numbers when show_numbers is true" do
    component = Decor::Daisy::Progress.new(steps: @steps, show_numbers: true)
    rendered = render_component(component)

    assert_includes rendered, 'data-content="1"'
    assert_includes rendered, 'data-content="2"'
  end

  test "includes animation classes by default" do
    component = Decor::Daisy::Progress.new(
      steps: @steps,
      style: :progress
    )
    rendered = render_component(component)

    assert_includes rendered, "transition-all"
    assert_includes rendered, "duration-300"
  end

  test "always includes animation classes" do
    component = Decor::Daisy::Progress.new(
      steps: @steps,
      style: :progress
    )
    rendered = render_component(component)

    assert_includes rendered, "transition-all"
    assert_includes rendered, "duration-300"
  end

  test "includes proper ARIA labels" do
    component = Decor::Daisy::Progress.new(steps: @steps)
    rendered = render_component(component)

    assert_includes rendered, "steps"
    assert_includes rendered, "step_one"
  end

  test "progress bar has proper ARIA label" do
    component = Decor::Daisy::Progress.new(steps: @steps, current_step: 2, style: :progress)
    rendered = render_component(component)

    assert_includes rendered, 'aria-label="Progress: 33% complete"'
  end

  test "handles empty steps array" do
    component = Decor::Daisy::Progress.new(steps: [])
    rendered = render_component(component)

    assert rendered # Should not raise error
  end

  test "handles single step" do
    single_step = [{label_key: "only_step"}]
    component = Decor::Daisy::Progress.new(steps: single_step)
    fragment = render_fragment(component)

    list_items = fragment.css("li")
    assert_equal 1, list_items.length
  end

  test "renders links for completed steps" do
    component = Decor::Daisy::Progress.new(
      steps: @steps,
      current_step: 3
    )
    rendered = render_component(component)

    assert_includes rendered, 'href="/step-1"'
    assert_includes rendered, 'href="/step-2"'
  end

  test "does not render links for current or upcoming steps" do
    component = Decor::Daisy::Progress.new(
      steps: [
        {label_key: "step_one", href: "/step-1"},
        {label_key: "step_two", href: "/step-2"}
      ],
      current_step: 1
    )
    rendered = render_component(component)

    refute_includes rendered, "href="
  end

  test "shows checkmark for completed steps" do
    component = Decor::Daisy::Progress.new(steps: @steps, current_step: 3)
    rendered = render_component(component)

    assert_includes rendered, 'data-content="✓"'
  end

  test "has correct default values" do
    component = Decor::Daisy::Progress.new(steps: @steps)

    assert_equal :primary, component.instance_variable_get(:@color)
    assert_equal :md, component.instance_variable_get(:@size)
    assert_equal :steps, component.instance_variable_get(:@style)
    assert_equal true, component.instance_variable_get(:@show_numbers)
    assert_equal false, component.instance_variable_get(:@vertical)
  end
end
