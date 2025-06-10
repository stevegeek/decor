# @label ClickToCopy
class ::Decor::ClickToCopyPreview < ::Lookbook::Preview
  # ClickToCopy
  # -------
  #
  # A simple tag component which can be used to copy-on-click whatever text it is wrapped around
  #
  # @label Playground
  def playground(position: :top)
    render ::Decor::ClickToCopy.new do
      "Click to copy me!"
    end
  end
end
