# @label Tooltip
class ::Decor::Suite::TooltipPreview < ::Lookbook::Preview
  # @group Examples
  # @label Default (top)
  def example_default
    render ::Decor::Suite::Tooltip.new(tip_text: "Helpful hint") do |t|
      t.render ::Decor::Daisy::Button.new(label: "Hover me")
    end
  end

  # @group Examples
  # @label Rich tip content via block
  def example_rich_content
    render ::Decor::Suite::Tooltip.new do |t|
      t.with_tip_content do
        t.div(class: "decor:flex decor:flex-col decor:gap-1") do
          t.strong { "Title" }
          t.span(class: "decor:opacity-75") { "Multi-line tip body with detail." }
        end
      end
      t.render ::Decor::Daisy::Button.new(label: "Hover for rich tip")
    end
  end

  # @group Placement
  # @label Top
  def placement_top
    render ::Decor::Suite::Tooltip.new(tip_text: "Top tip", position: :top) do |t|
      t.render ::Decor::Daisy::Button.new(label: "Top")
    end
  end

  # @group Placement
  # @label Bottom
  def placement_bottom
    render ::Decor::Suite::Tooltip.new(tip_text: "Bottom tip", position: :bottom) do |t|
      t.render ::Decor::Daisy::Button.new(label: "Bottom")
    end
  end

  # @group Placement
  # @label Left
  def placement_left
    render ::Decor::Suite::Tooltip.new(tip_text: "Left tip", position: :left) do |t|
      t.render ::Decor::Daisy::Button.new(label: "Left")
    end
  end

  # @group Placement
  # @label Right
  def placement_right
    render ::Decor::Suite::Tooltip.new(tip_text: "Right tip", position: :right) do |t|
      t.render ::Decor::Daisy::Button.new(label: "Right")
    end
  end

  # @group Placement
  # @label Top-start
  def placement_top_start
    render ::Decor::Suite::Tooltip.new(tip_text: "Aligned to start edge", position: :"top-start") do |t|
      t.render ::Decor::Daisy::Button.new(label: "Top-start")
    end
  end

  # @group Placement
  # @label Bottom-end
  def placement_bottom_end
    render ::Decor::Suite::Tooltip.new(tip_text: "Aligned to end edge", position: :"bottom-end") do |t|
      t.render ::Decor::Daisy::Button.new(label: "Bottom-end")
    end
  end

  # @group Options
  # @label Without arrow
  def options_no_arrow
    render ::Decor::Suite::Tooltip.new(tip_text: "No arrow", arrow: false) do |t|
      t.render ::Decor::Daisy::Button.new(label: "No arrow")
    end
  end

  # @group Options
  # @label Custom offset
  def options_custom_offset
    render ::Decor::Suite::Tooltip.new(tip_text: "16px away", offset: 16) do |t|
      t.render ::Decor::Daisy::Button.new(label: "Far offset")
    end
  end

  # @group Playground
  # @param tip_text text
  # @param position [Symbol] select [~, top, bottom, left, right, top-start, top-end, bottom-start, bottom-end, left-start, left-end, right-start, right-end]
  # @param offset number
  # @param arrow toggle
  def playground(tip_text: "Tooltip body", position: :top, offset: 8, arrow: true)
    render ::Decor::Suite::Tooltip.new(tip_text: tip_text, position: position, offset: offset, arrow: arrow) do |t|
      t.render ::Decor::Daisy::Button.new(label: "Hover for tooltip")
    end
  end
end
