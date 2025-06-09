# @label Box
class ::Decor::BoxPreview < ::ViewComponent::Preview
  # Box
  # -------
  #
  # A daisyUI card-styled box component with title, description, and content areas.
  # Features light grey background for better visual separation.
  #
  # @label Playground
  # @param title text
  # @param description text
  # @param show_slots toggle
  def playground(title: "Card Title", description: "A card component has a figure, a body part, and inside body there are title and actions parts", show_slots: false)
    render ::Decor::Box.new(title: title, description: description) do |box|
      if show_slots
        box.with_left do
          content_tag :div, "Custom Left Content", class: "font-bold"
        end
        box.with_right do
          content_tag :div, class: "card-actions justify-end" do
            content_tag :button, "Buy Now", class: "btn btn-primary"
          end
        end
      else
        content_tag :div, class: "card-actions justify-end" do
          content_tag :button, "Buy Now", class: "btn btn-primary"
        end
      end
    end
  end

  # @label Simple Box
  def simple_box
    render ::Decor::Box.new(
      title: "Simple Box",
      description: "Just a title and description with light grey background."
    )
  end

  # @label Box with Actions
  def with_actions
    render ::Decor::Box.new(
      title: "Box with Actions",
      description: "This box has action buttons in the content area."
    ) do
      content_tag :div, class: "card-actions justify-end" do
        content_tag(:button, "Cancel", class: "btn btn-ghost") +
          content_tag(:button, "Save", class: "btn btn-primary")
      end
    end
  end
end
