# @label SwitchingBox
class ::Decor::Suite::SwitchingBoxPreview < ::Lookbook::Preview
  # Minimal model stub for the "with switch" demo — has the
  # `:active` accessor + a stable model_name so the bound switch can
  # build a sensible name attribute.
  class TestModel
    include ActiveModel::Model

    attr_accessor :id, :active
    def self.model_name
      ActiveModel::Name.new(self, nil, "TestModel")
    end

    def persisted? = !id.nil?
  end

  # SwitchingBox (Suite)
  # --------------------
  #
  # Settings-row container with a title + description column on the left and a
  # form-bound switch on the right that submits on change. Use `stack: true`
  # on adjacent rows to collapse internal borders into a single grouped list.
  #
  # @group Examples
  # @label Title + description (no model)
  def title_and_description
    render ::Decor::Suite::SwitchingBox.new(
      title: "Email notifications",
      description: "Receive a digest of activity once per day."
    )
  end

  # @group Examples
  # @label With switch (model-bound)
  def with_switch
    render ::Decor::Suite::SwitchingBox.new(
      model: TestModel.new(id: 1, active: true),
      url: "/test/1",
      property_name: :active,
      title: "Two-factor authentication",
      description: "Require a verification code in addition to your password."
    )
  end

  # @group Examples
  # @label Stacked group
  def stacked_group
    render_with_template
  end

  # @group Playground
  # @param title text
  # @param description text
  # @param stack toggle
  def playground(title: "Setting title", description: "Helper description goes here.", stack: false)
    render ::Decor::Suite::SwitchingBox.new(title: title, description: description, stack: stack)
  end
end
