# @label Spinner
# @display bg_color gray
class ::Decor::SpinnerPreview < ::Lookbook::Preview
  # Spinner
  # -------
  #
  # Spinning SVG icon.
  # @param white toggle
  def playground(white: false)
    render ::Decor::Spinner.new(color: white ? :white : :black)
  end
end
