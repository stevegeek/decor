# @label SwitchingBox
class ::Decor::SwitchingBoxPreview < ::Lookbook::Preview
  # SwitchingBox
  # -------
  #
  # A switching box is a Box which shows content and contains a form and switch
  # rendered on the right which submits on change. Used for switching things on and off
  # outside of a form.
  #
  # @label Playground
  # @param title text
  # @param description text
  # @param show_slot toggle
  # @param switch_options_checked toggle
  # @param property_name text
  def playground(title: "Hi!", description: "This is a description", show_slot: false, switch_options_checked: false, property_name: :switch)
    render ::Decor::SwitchingBox.new(
      title: title,
      description: description,
      switch_options: {checked: switch_options_checked},
      property_name: property_name,
      model: Class.new {
               include ActiveModel::Model
               def self.name = "Test"
               attr_accessor :switch
             }.new(property_name => switch_options_checked),
      url: "#"
    ) do |box|
      if show_slot
        box.left do
          "left"
        end
      end
    end
  end
end
