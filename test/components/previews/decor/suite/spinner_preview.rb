# @label Spinner
class ::Decor::Suite::SpinnerPreview < ::Lookbook::Preview
  # @label Playground
  # @param style select [spinner, dots, ring, ball, bars, infinity]
  # @param size select [xs, sm, md, lg, xl]
  # @param color select [primary, secondary, accent, neutral, success, error, warning, info, base]
  def playground(style: :spinner, size: :md, color: :primary)
    render ::Decor::Suite::Spinner.new(style: style, size: size, color: color)
  end
end
