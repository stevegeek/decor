## @label Card
class ::Decor::CardPreview < ::ViewComponent::Preview
  # Card
  # -------
  #
  # A card is a container for content which has a border and a shadow.
  # Cards can have a title attribute or use a header slot for more complex headers.
  #
  # @param card_type [Symbol] select { choices: [basic, with_title, with_header_slot] }
  def playground(card_type: :basic)
    case card_type
    when :with_title
      render ::Decor::Card.new(title: "Card with Title") do
        "This card uses the title attribute to display a simple title header."
      end
    when :with_header_slot
      render ::Decor::Card.new do |card|
        card.with_header do
          card.render ::Decor::Progress.new(
            current_step: 1,
            i18n_key: "registration.steps.progress",
            steps: [{label_key: "first"}, {label_key: "second"}, {label_key: "third"}, {label_key: "complete"}]
          )
        end
        "This card uses a header slot for complex header content like a progress bar."
      end
    else
      render ::Decor::Card.new do
        "This is a basic card with just body content and no header."
      end
    end
  end

  # @!group Examples

  def basic_card
    render ::Decor::Card.new do
      "A simple card with just content"
    end
  end

  def card_with_title
    render ::Decor::Card.new(title: "User Profile") do
      "Name: John Doe<br>Email: john@example.com<br>Role: Administrator".html_safe
    end
  end

  def card_with_custom_header
    render ::Decor::Card.new do |card|
      card.with_header do
        card.div(class: "flex items-center justify-between p-4 border-b") do
          card.h3(class: "text-lg font-semibold") { "Custom Header" }
          card.span(class: "badge badge-primary") { "New" }
        end
      end
      "This card demonstrates a custom header with multiple elements and styling."
    end
  end

  # @!endgroup
end
