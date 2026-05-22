# @label LoadingBar
class ::Decor::Suite::LoadingBarPreview < ::Lookbook::Preview
  # @group Examples
  # @label Indeterminate (default)
  def indeterminate
    render ::Decor::Suite::LoadingBar.new
  end

  # @label Determinate 40%
  def determinate_forty
    render ::Decor::Suite::LoadingBar.new(style: :determinate, progress: 40)
  end

  # @label Determinate with label and percentage
  def determinate_with_label
    render ::Decor::Suite::LoadingBar.new(
      style: :determinate,
      progress: 65,
      label: "Uploading",
      show_percentage: true,
      size: :lg
    )
  end

  # @label Success color
  def success
    render ::Decor::Suite::LoadingBar.new(style: :determinate, progress: 100, color: :success)
  end

  # @group Playground
  # @param style select [indeterminate, determinate]
  # @param progress number
  # @param animated toggle
  # @param label text
  # @param show_percentage toggle
  # @param size select [xs, sm, md, lg, xl]
  # @param color select [primary, secondary, success, warning, danger, neutral, base, info]
  def playground(style: :indeterminate, progress: 50, animated: true, label: nil, show_percentage: false, size: :md, color: :primary)
    render ::Decor::Suite::LoadingBar.new(
      style: style,
      progress: progress,
      animated: animated,
      label: label.presence,
      show_percentage: show_percentage,
      size: size,
      color: color
    )
  end
end
