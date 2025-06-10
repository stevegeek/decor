## @label Card
class ::Decor::CardPreview < ::ViewComponent::Preview
  # Card
  # -------
  #
  # A card is a container for content which has a border and a shadow.
  # Cards can have a title attribute or use a header slot for more complex headers.
  #
  # @param card_type [Symbol] select { choices: [basic, with_title, with_header_slot, with_image_top, with_image_left, with_image_right, with_image_bottom] }
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
    when :with_image_top
      render ::Decor::Card.new(
        title: "Mountain Adventure",
        image_url: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=400&fit=crop",
        image_position: :top
      ) do
        "Experience breathtaking mountain views and hiking trails. Perfect for outdoor enthusiasts looking for their next adventure."
      end
    when :with_image_left
      render ::Decor::Card.new(
        title: "Product Showcase",
        image_url: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=300&fit=crop",
        image_position: :left
      ) do |card|
        card.plain("Premium quality product with excellent ratings.")
        card.br
        card.strong { "Price: $99.99" }
        card.br
        card.strong { "Rating: ⭐⭐⭐⭐⭐" }
      end
    when :with_image_right
      render ::Decor::Card.new(
        title: "Team Member",
        image_url: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=300&fit=crop",
        image_position: :right
      ) do |card|
        card.strong { "John Doe" }
        card.br
        card.plain("Senior Developer")
        card.br
        card.plain("john.doe@company.com")
        card.br
        card.plain("Specialized in full-stack development")
      end
    when :with_image_bottom
      render ::Decor::Card.new(
        title: "Article Preview",
        image_url: "https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800&h=400&fit=crop",
        image_position: :bottom
      ) do
        "Discover the latest trends in technology and innovation. This comprehensive article covers emerging technologies and their impact on various industries."
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
    render ::Decor::Card.new(title: "User Profile") do |card|
      card.plain("Name: John Doe")
      card.br
      card.plain("Email: john@example.com")
      card.br
      card.plain("Role: Administrator")
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

  def card_with_top_image
    render ::Decor::Card.new(
      title: "Nature Photography",
      image_url: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800&h=400&fit=crop",
      image_position: :top
    ) do
      "Stunning landscape photography capturing the beauty of untouched wilderness. Perfect for nature lovers and photography enthusiasts."
    end
  end

  def card_with_left_image
    render ::Decor::Card.new(
      title: "Tech Gadget",
      image_url: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=300&fit=crop",
      image_position: :left
    ) do |card|
      card.plain("Latest wireless headphones with noise cancellation.")
      card.br
      card.br
      card.strong { "Features:" }
      card.br
      card.plain("• Wireless connectivity")
      card.br
      card.plain("• 30-hour battery life")
      card.br
      card.plain("• Active noise cancellation")
    end
  end

  def card_with_right_image
    render ::Decor::Card.new(
      title: "Sarah Johnson",
      image_url: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800&h=400&fit=crop",
      image_position: :right
    ) do |card|
      card.strong { "UX Designer" }
      card.br
      card.plain("sarah.johnson@company.com")
      card.br
      card.br
      card.plain("Passionate about creating intuitive user experiences with 8+ years in design.")
    end
  end

  def card_with_bottom_image
    render ::Decor::Card.new(
      title: "How to Build Better Apps",
      image_url: "https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800&h=400&fit=crop",
      image_position: :bottom
    ) do
      "Learn the essential principles and best practices for developing modern applications. This guide covers architecture, design patterns, and development workflows that lead to maintainable and scalable software."
    end
  end

  def card_with_image_and_header_slot
    render ::Decor::Card.new(
      image_url: "https://images.unsplash.com/photo-1557804506-669a67965ba0?w=800&h=400&fit=crop",
      image_position: :top
    ) do |card|
      card.with_header do
        card.div(class: "flex items-center justify-between p-4") do
          card.div do
            card.h3(class: "text-lg font-semibold") { "Company Dashboard" }
            card.p(class: "text-sm text-gray-600") { "Real-time analytics" }
          end
          card.span(class: "badge badge-success") { "Live" }
        end
      end
      "Monitor your business metrics with real-time data visualization and comprehensive reporting tools."
    end
  end

  # @!endgroup
end
