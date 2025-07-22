# @label Spinner
# @display bg_color gray
class ::Decor::SpinnerPreview < ::Lookbook::Preview
  # Spinner
  # -------
  #
  # Loading spinner with configurable size and color.
  # A spinner is used to indicate that content is loading or processing.
  # It can be customized with different styles, sizes, and colors to match your design.
  #
  # @group Examples
  # @label Basic Spinner
  def basic_spinner
    render ::Decor::Spinner.new
  end

  # @group Examples
  # @label Primary Large Spinner
  def primary_large_spinner
    render ::Decor::Spinner.new(size: :lg, color: :primary)
  end

  # @group Examples
  # @label Dots Style Loading
  def dots_loading
    render ::Decor::Spinner.new(style: :dots, color: :secondary)
  end

  # @group Playground
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, spinner, dots, ring, ball, bars, infinity]
  def playground(size: nil, color: nil, style: nil)
    render ::Decor::Spinner.new(size: size, color: color, style: style)
  end

  # @group Sizes
  # @label XS Size
  def size_xs
    render ::Decor::Spinner.new(size: :xs)
  end

  # @group Sizes
  # @label SM Size
  def size_sm
    render ::Decor::Spinner.new(size: :sm)
  end

  # @group Sizes
  # @label MD Size (Default)
  def size_md
    render ::Decor::Spinner.new(size: :md)
  end

  # @group Sizes
  # @label LG Size
  def size_lg
    render ::Decor::Spinner.new(size: :lg)
  end

  # @group Sizes
  # @label XL Size
  def size_xl
    render ::Decor::Spinner.new(size: :xl)
  end

  # @group Colors
  # @label Base Color
  def color_base
    render ::Decor::Spinner.new(color: :base)
  end

  # @group Colors
  # @label Primary Color
  def color_primary
    render ::Decor::Spinner.new(color: :primary)
  end

  # @group Colors
  # @label Secondary Color
  def color_secondary
    render ::Decor::Spinner.new(color: :secondary)
  end

  # @group Colors
  # @label Accent Color
  def color_accent
    render ::Decor::Spinner.new(color: :accent)
  end

  # @group Colors
  # @label Success Color
  def color_success
    render ::Decor::Spinner.new(color: :success)
  end

  # @group Colors
  # @label Error Color
  def color_error
    render ::Decor::Spinner.new(color: :error)
  end

  # @group Colors
  # @label Warning Color
  def color_warning
    render ::Decor::Spinner.new(color: :warning)
  end

  # @group Colors
  # @label Info Color
  def color_info
    render ::Decor::Spinner.new(color: :info)
  end

  # @group Styles
  # @label Spinner Style (Default)
  def style_spinner
    render ::Decor::Spinner.new(style: :spinner)
  end

  # @group Styles
  # @label Dots Style
  def style_dots
    render ::Decor::Spinner.new(style: :dots)
  end

  # @group Styles
  # @label Ring Style
  def style_ring
    render ::Decor::Spinner.new(style: :ring)
  end

  # @group Styles
  # @label Ball Style
  def style_ball
    render ::Decor::Spinner.new(style: :ball)
  end

  # @group Styles
  # @label Bars Style
  def style_bars
    render ::Decor::Spinner.new(style: :bars)
  end

  # @group Styles
  # @label Infinity Style
  def style_infinity
    render ::Decor::Spinner.new(style: :infinity)
  end

  # @group Combinations
  # @label Large Primary Dots
  def combo_large_primary_dots
    render ::Decor::Spinner.new(style: :dots, size: :lg, color: :primary)
  end

  # @group Combinations
  # @label Small Error Ring
  def combo_small_error_ring
    render ::Decor::Spinner.new(style: :ring, size: :sm, color: :error)
  end

  # @group Combinations
  # @label XL Success Bars
  def combo_xl_success_bars
    render ::Decor::Spinner.new(style: :bars, size: :xl, color: :success)
  end
end
