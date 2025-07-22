# @label Spinner
# @display bg_color gray
class ::Decor::SpinnerPreview < ::Lookbook::Preview
  # Spinner
  # -------
  #
  # Loading spinner with configurable size and color.
  #
  # @param style [Symbol] select { choices: [spinner, dots, ring, ball, bars, infinity] } "Style of the spinner"
  # @param size [Symbol] select { choices: [xs, sm, md, lg, xl] } "Size of the spinner"
  # @param color [Symbol] select { choices: [base, primary, secondary, accent, neutral, success, error, warning, info] } "Color scheme"
  def playground(style: :spinner, size: :md, color: :neutral)
    render ::Decor::Spinner.new(style: style, size: size, color: color)
  end

  # Different sizes
  # @display bg_color white
  def sizes
    div(class: "flex items-center gap-4") do
      [:xs, :sm, :md, :lg, :xl].each do |size|
        div(class: "flex flex-col items-center gap-2") do
          render ::Decor::Spinner.new(size: size, color: :primary)
          p(class: "text-xs text-gray-600") { size.to_s }
        end
      end
    end
  end

  # Different colors
  # @display bg_color white
  def colors
    div(class: "flex items-center gap-4") do
      [:base, :primary, :secondary, :accent, :success, :error, :warning, :info].each do |color|
        div(class: "flex flex-col items-center gap-2") do
          render ::Decor::Spinner.new(size: :md, color: color)
          p(class: "text-xs text-gray-600") { color.to_s }
        end
      end
    end
  end

  # Different styles
  # @display bg_color white
  def styles
    div(class: "grid grid-cols-3 gap-8") do
      [:spinner, :dots, :ring, :ball, :bars, :infinity].each do |style|
        div(class: "flex flex-col items-center gap-2") do
          render ::Decor::Spinner.new(style: style, size: :lg, color: :primary)
          p(class: "text-sm font-medium text-gray-700") { style.to_s }
        end
      end
    end
  end
end
