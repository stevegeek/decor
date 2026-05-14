# @label Suite FlowStep
class ::Decor::Suite::FlowStepPreview < ::Lookbook::Preview
  # FlowStep (Suite)
  # ----------------
  #
  # Muted step indicator + card-chromed child block. Used to scaffold
  # multi-step admin import forms.
  #
  # @group Examples
  # @label Numbered step with form-field block
  def numbered_step_with_block
    render ::Decor::Suite::FlowStep.new(
      step: 1,
      title: "Select Completed Price Matrix file to upload",
      description: "Select your Price Matrix XLS file to upload and process."
    ) do
      "<form-field-placeholder>".html_safe
    end
  end

  # @group Examples
  # @label Icon step (download)
  def icon_step_download
    render ::Decor::Suite::FlowStep.new(
      icon: "download",
      title: "Download New Customer Import Template (CSV)",
      description: "This CSV template must be used to import new customer entities."
    ) do
      "<download-button-placeholder>".html_safe
    end
  end

  # @group Examples
  # @label Icon step (upload)
  def icon_step_upload
    render ::Decor::Suite::FlowStep.new(
      icon: "upload",
      title: "Upload the Product Data CSV",
      description: "Please select a CSV file that contains the product data."
    ) do
      "<file-field-placeholder>".html_safe
    end
  end

  # @group Examples
  # @label No child block
  def no_child_block
    render ::Decor::Suite::FlowStep.new(
      step: 3,
      title: "Apply uploaded prices",
      description: "Choose to publish the prices immediately or schedule them."
    )
  end

  # @group Colors
  # @label Success
  def color_success
    render ::Decor::Suite::FlowStep.new(step: 1, title: "Done", color: :success) { "ok".html_safe }
  end

  # @group Colors
  # @label Error
  def color_error
    render ::Decor::Suite::FlowStep.new(step: 1, title: "Failed", color: :error) { "ok".html_safe }
  end

  # @group Colors
  # @label Warning
  def color_warning
    render ::Decor::Suite::FlowStep.new(step: 1, title: "Heads up", color: :warning) { "ok".html_safe }
  end

  # @group Colors
  # @label Neutral
  def color_neutral
    render ::Decor::Suite::FlowStep.new(step: 1, title: "Neutral", color: :neutral) { "ok".html_safe }
  end

  # @group Playground
  # @param step number
  # @param icon select [~, upload, download, check, x, info]
  # @param title text
  # @param description text
  # @param color [Symbol] select [~, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  def playground(step: 1, icon: nil, title: "Step title", description: "Step description", color: nil, style: nil, size: nil)
    render ::Decor::Suite::FlowStep.new(
      step: icon ? nil : step,
      icon: icon,
      title: title,
      description: description,
      color: color,
      style: style,
      size: size
    ) { "<child-block>".html_safe }
  end
end
