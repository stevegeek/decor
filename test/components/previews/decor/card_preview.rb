## @label Card
class ::Decor::CardPreview < ::Lookbook::Preview
  # Card
  # -------
  #
  # A card is a container for content which has a border and a shadow.
  # Cards can have a title attribute or use a header slot for more complex headers.
  # They support images in different positions, various colors, sizes, and styles.
  #
  # @group Examples
  # @label Basic Card
  def basic_card
    render ::Decor::Card.new do
      "A simple card with just content"
    end
  end

  # @group Examples
  # @label Card with Title
  def card_with_title_example
    render ::Decor::Card.new(title: "User Profile") do |card|
      card.plain("Name: John Doe")
      card.br
      card.plain("Email: john@example.com")
      card.br
      card.plain("Role: Administrator")
    end
  end

  # @group Examples
  # @label Card with Image
  def card_with_image_example
    render ::Decor::Card.new(
      title: "Mountain Adventure",
      image_url: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=400&fit=crop",
      image_position: :top
    ) do
      "Experience breathtaking mountain views and hiking trails."
    end
  end

  # @group Examples
  # @label Card with Image and Header
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

  # @group Examples
  # @label Card with Color and Image
  def card_with_color_and_image
    render ::Decor::Card.new(
      title: "Featured Product",
      image_url: "https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=800&h=400&fit=crop",
      image_position: :top,
      color: :primary,
      style: :filled
    ) do
      "Limited edition sunglasses with UV protection and polarized lenses."
    end
  end

  # @group Examples
  # @label Card with Outlined Style and Image
  def outlined_card_with_image
    render ::Decor::Card.new(
      title: "Team Leader",
      image_url: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop",
      image_position: :left,
      color: :secondary,
      style: :outlined,
      size: :lg
    ) do |card|
      card.strong { "Michael Chen" }
      card.br
      card.plain("Engineering Manager")
      card.br
      card.plain("10+ years experience")
    end
  end

  # @group Examples
  # @label Compact Info Card
  def compact_info_card
    render ::Decor::Card.new(
      title: "Quick Tip",
      color: :info,
      size: :xs,
      style: :filled
    ) do
      "Press Ctrl+K to open the command palette."
    end
  end

  # @!endgroup

  # @group Playground
  # @param card_type select [basic, with_title, with_header_slot, with_image_top, with_image_left, with_image_right, with_image_bottom]
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(card_type: :basic, size: nil, color: nil, style: nil)
    case card_type
    when :with_title
      render ::Decor::Card.new(title: "Card with Title", size: size, color: color, style: style) do
        "This card uses the title attribute to display a simple title header."
      end
    when :with_header_slot
      render ::Decor::Card.new(size: size, color: color, style: style) do |card|
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
        image_position: :top,
        size: size,
        color: color,
        style: style
      ) do
        "Experience breathtaking mountain views and hiking trails. Perfect for outdoor enthusiasts looking for their next adventure."
      end
    when :with_image_left
      render ::Decor::Card.new(
        title: "Product Showcase",
        image_url: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=300&fit=crop",
        image_position: :left,
        size: size,
        color: color,
        style: style
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
        image_position: :right,
        size: size,
        color: color,
        style: style
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
        image_position: :bottom,
        size: size,
        color: color,
        style: style
      ) do
        "Discover the latest trends in technology and innovation. This comprehensive article covers emerging technologies and their impact on various industries."
      end
    else
      render ::Decor::Card.new(size: size, color: color, style: style) do
        "This is a basic card with just body content and no header."
      end
    end
  end

  # @!group Colors

  def primary_card
    render ::Decor::Card.new(title: "Primary Card", color: :primary) do
      "This card uses the primary color scheme"
    end
  end

  def secondary_card
    render ::Decor::Card.new(title: "Secondary Card", color: :secondary) do
      "This card uses the secondary color scheme"
    end
  end

  def accent_card
    render ::Decor::Card.new(title: "Accent Card", color: :accent) do
      "This card uses the accent color scheme"
    end
  end

  def success_card
    render ::Decor::Card.new(title: "Success Card", color: :success) do
      "This card indicates a successful operation"
    end
  end

  def error_card
    render ::Decor::Card.new(title: "Error Card", color: :error) do
      "This card indicates an error state"
    end
  end

  def warning_card
    render ::Decor::Card.new(title: "Warning Card", color: :warning) do
      "This card shows a warning message"
    end
  end

  def info_card
    render ::Decor::Card.new(title: "Info Card", color: :info) do
      "This card provides informational content"
    end
  end

  def neutral_card
    render ::Decor::Card.new(title: "Neutral Card", color: :neutral) do
      "This card uses the neutral color scheme"
    end
  end

  # @!endgroup

  # @!group Sizes

  def extra_small_card
    render ::Decor::Card.new(title: "XS Card", size: :xs) do
      "Extra small card with compact styling"
    end
  end

  def small_card
    render ::Decor::Card.new(title: "Small Card", size: :sm) do
      "Small card size for tighter spaces"
    end
  end

  def medium_card
    render ::Decor::Card.new(title: "Medium Card", size: :md) do
      "Medium card - the default size"
    end
  end

  def large_card
    render ::Decor::Card.new(title: "Large Card", size: :lg) do
      "Large card with more breathing room"
    end
  end

  def extra_large_card
    render ::Decor::Card.new(title: "XL Card", size: :xl) do
      "Extra large card for prominent content"
    end
  end

  # @!endgroup

  # @!group Styles

  def filled_card
    render ::Decor::Card.new(title: "Filled Card", style: :filled) do
      "Default filled card with shadow"
    end
  end

  def outlined_card
    render ::Decor::Card.new(title: "Outlined Card", style: :outlined) do
      "Card with border outline instead of shadow"
    end
  end

  def ghost_card
    render ::Decor::Card.new(title: "Ghost Card", style: :ghost) do
      "Minimal card with no shadow or border"
    end
  end

  def outlined_colored_card
    render ::Decor::Card.new(title: "Outlined Primary", style: :outlined, color: :primary) do
      "Outlined card with primary color border"
    end
  end

  # @!endgroup

  # @group Examples
  # @label Card with Custom Header
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

  # @!group Images

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

  # @!endgroup
end
