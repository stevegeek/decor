# @label SwitchingBox
class ::Decor::Suite::SwitchingBoxPreview < ::Lookbook::Preview
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
    raw <<~HTML.html_safe
      <div>
        #{render ::Decor::Suite::SwitchingBox.new(
          stack: true,
          title: "Marketing emails",
          description: "Receive product update emails."
        )}
        #{render ::Decor::Suite::SwitchingBox.new(
          stack: true,
          title: "Transactional emails",
          description: "Order confirmations and receipts."
        )}
        #{render ::Decor::Suite::SwitchingBox.new(
          stack: true,
          title: "System alerts",
          description: "Security warnings and account changes."
        )}
      </div>
    HTML
  end

  # @group Playground
  # @param title text
  # @param description text
  # @param stack toggle
  def playground(title: "Setting title", description: "Helper description goes here.", stack: false)
    render ::Decor::Suite::SwitchingBox.new(title: title, description: description, stack: stack)
  end
end
