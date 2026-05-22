# @label Banner
class ::Decor::Suite::BannerPreview < ::Lookbook::Preview
  # Banner (Suite)
  # --------------
  #
  # Muted card-style banner. Optional leading icon, body via the bare block,
  # optional "Learn more" link, and optional CTA slot. Defaults to a centered
  # max-width body wrap.
  #
  # @group Examples
  # @label Info (default)
  def info
    render ::Decor::Suite::Banner.new(icon: "info-circle") do
      "Heads up — you can customise this dashboard at any time."
    end
  end

  # @group Examples
  # @label Success
  def success
    render ::Decor::Suite::Banner.new(color: :success, icon: "circle-check") do
      "Your import finished successfully."
    end
  end

  # @group Examples
  # @label Warning
  def warning
    render ::Decor::Suite::Banner.new(color: :warning, icon: "alert-triangle") do
      "Your payment method expires soon."
    end
  end

  # @group Examples
  # @label Error
  def error
    render ::Decor::Suite::Banner.new(color: :error, icon: "x") do
      "Something went wrong while saving your changes."
    end
  end

  # @group Examples
  # @label Neutral (no icon)
  def neutral
    render ::Decor::Suite::Banner.new(color: :neutral) do
      "Scheduled maintenance window: tonight 02:00 — 04:00 UTC."
    end
  end

  # @group Slots
  # @label With link
  def with_link
    render ::Decor::Suite::Banner.new(color: :info, icon: "info-circle", link: "/docs") do
      "We've shipped a new bulk-edit flow."
    end
  end

  # @group Slots
  # @label With call-to-action
  def with_call_to_action
    render ::Decor::Suite::Banner.new(color: :warning, icon: "alert-triangle") do |banner|
      banner.call_to_action do
        render ::Decor::Daisy::Button.new(label: "Verify now", color: :warning, size: :sm)
      end
      "Please verify your email address to continue."
    end
  end

  # @group Layout
  # @label Centered: false (full width)
  def centered_false
    render ::Decor::Suite::Banner.new(color: :info, icon: "info-circle", centered: false) do
      "This banner spans the full width of its container."
    end
  end

  # @group Playground
  # @param body text
  # @param icon select [~, info-circle, alert-triangle, circle-check, x, bell]
  # @param link text
  # @param centered toggle
  # @param color [Symbol] select [~, primary, success, error, warning, info, neutral]
  def playground(body: "Heads up — here's an important message.", icon: "info-circle", link: nil, centered: true, color: nil)
    render ::Decor::Suite::Banner.new(icon: icon, link: link, centered: centered, color: color) do
      body
    end
  end
end
