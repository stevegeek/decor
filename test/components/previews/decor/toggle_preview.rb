# @label Toggle
class ::Decor::TogglePreview < ::Lookbook::Preview
  # Toggle
  # -------
  #
  # A switch that can be toggled on or off and POSTs to a URL on change.
  #
  # @param url text
  # @param http_method select [~, get, post, put, patch, delete]
  # @param checked toggle
  def playground(url: "#", http_method: :patch, checked: false)
    render ::Decor::Toggle.new(
      property_name: :testing,
      url: url,
      http_method: http_method,
      model: Class.new {
        include ActiveModel::Model
        def self.name = "TestToggle"
        attr_accessor :testing
      }.new(testing: checked)
    )
  end
end
