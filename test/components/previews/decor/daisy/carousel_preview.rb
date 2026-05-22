# @label Carousel
class ::Decor::Daisy::CarouselPreview < ::Lookbook::Preview
  # Carousel
  # -------
  #
  # A swipable container component for displaying a series of elements. Perfect for image galleries,
  # testimonials, product showcases, or any content that benefits from horizontal scrolling.
  # Built with DaisyUI carousel styling and supports both images and custom content.
  #
  # @group Examples
  # @label Basic Image Carousel
  def basic_carousel
    render ::Decor::Daisy::Carousel.new(
      images: [
        {url: "https://picsum.photos/400/300?random=1", alt: "Slide 1"},
        {url: "https://picsum.photos/400/300?random=2", alt: "Slide 2"},
        {url: "https://picsum.photos/400/300?random=3", alt: "Slide 3"}
      ],
      max_height: 300
    )
  end

  # @group Examples
  # @label Multiple Slides Per View
  def multiple_slides
    render ::Decor::Daisy::Carousel.new(
      images: [
        {url: "https://picsum.photos/300/200?random=4", alt: "Product 1"},
        {url: "https://picsum.photos/300/200?random=5", alt: "Product 2"},
        {url: "https://picsum.photos/300/200?random=6", alt: "Product 3"},
        {url: "https://picsum.photos/300/200?random=7", alt: "Product 4"},
        {url: "https://picsum.photos/300/200?random=8", alt: "Product 5"}
      ],
      slides_per_view: 3,
      max_height: 200
    )
  end

  # @group Examples
  # @label Custom Card Content
  def custom_content_carousel
    render ::Decor::Daisy::Carousel.new(slides_per_view: 2, max_height: 250) do |carousel|
      carousel.with_slide do
        content_tag :div, class: "decor:d-card decor:bg-primary decor:text-primary-content" do
          content_tag :div, class: "decor:d-card-body" do
            safe_join([
              content_tag(:h2, "Card 1", class: "decor:d-card-title"),
              content_tag(:p, "Custom content in a carousel card")
            ])
          end
        end
      end

      carousel.with_slide do
        content_tag :div, class: "decor:d-card decor:bg-secondary decor:text-secondary-content" do
          content_tag :div, class: "decor:d-card-body" do
            safe_join([
              content_tag(:h2, "Card 2", class: "decor:d-card-title"),
              content_tag(:p, "Another custom carousel item")
            ])
          end
        end
      end

      carousel.with_slide do
        content_tag :div, class: "decor:d-card decor:bg-accent decor:text-accent-content" do
          content_tag :div, class: "decor:d-card-body" do
            safe_join([
              content_tag(:h2, "Card 3", class: "decor:d-card-title"),
              content_tag(:p, "Third custom content card")
            ])
          end
        end
      end
    end
  end

  # @group Examples
  # @label Product Gallery
  def product_gallery
    render ::Decor::Daisy::Carousel.new(slides_per_view: 1, max_height: 400) do |carousel|
      [1, 2, 3, 4].each do |i|
        carousel.with_slide do
          content_tag :div, class: "decor:relative" do
            safe_join([
              image_tag("https://picsum.photos/600/400?random=#{30 + i}", alt: "Product image #{i}", class: "decor:w-full"),
              content_tag(:div, class: "decor:absolute decor:bottom-0 decor:left-0 decor:right-0 decor:bg-gradient-to-t decor:from-black/70 decor:to-transparent decor:p-4") do
                safe_join([
                  content_tag(:h3, "Product #{i}", class: "decor:text-white decor:text-lg decor:font-bold"),
                  content_tag(:p, "$#{99 + i * 50}.00", class: "decor:text-white")
                ])
              end
            ])
          end
        end
      end
    end
  end

  # @group Examples
  # @label Testimonials
  def testimonial_carousel
    render ::Decor::Daisy::Carousel.new(slides_per_view: 1, max_height: 200) do |carousel|
      [
        {name: "Sarah Johnson", role: "CEO", quote: "This product has transformed our business operations."},
        {name: "Mike Chen", role: "Developer", quote: "The best tool I've used for rapid development."},
        {name: "Emily Davis", role: "Designer", quote: "Beautiful interface and incredibly intuitive."}
      ].each do |testimonial|
        carousel.with_slide do
          content_tag :div, class: "decor:d-card decor:bg-base-200" do
            content_tag :div, class: "decor:d-card-body" do
              safe_join([
                content_tag(:p, "\"#{testimonial[:quote]}\"", class: "decor:text-lg decor:italic"),
                content_tag(:div, class: "decor:mt-4") do
                  safe_join([
                    content_tag(:p, testimonial[:name], class: "decor:font-bold"),
                    content_tag(:p, testimonial[:role], class: "decor:text-sm decor:text-base-content/70")
                  ])
                end
              ])
            end
          end
        end
      end
    end
  end

  # @group Examples
  # @label Feature Showcase
  def feature_showcase
    render ::Decor::Daisy::Carousel.new(slides_per_view: 3, max_height: 250) do |carousel|
      [
        {icon: "lightning-bolt", title: "Fast Performance", desc: "Lightning fast load times"},
        {icon: "shield-check", title: "Secure", desc: "Bank-level security"},
        {icon: "device-mobile", title: "Mobile Ready", desc: "Works on all devices"},
        {icon: "users", title: "Team Collaboration", desc: "Work together seamlessly"},
        {icon: "chart-bar", title: "Analytics", desc: "Detailed insights"}
      ].each do |feature|
        carousel.with_slide do
          content_tag :div, class: "decor:d-card decor:bg-primary decor:text-primary-content" do
            content_tag :div, class: "decor:d-card-body decor:items-center decor:text-center" do
              safe_join([
                content_tag(:div, class: "decor:text-4xl decor:mb-2") { "🚀" },
                content_tag(:h3, feature[:title], class: "decor:d-card-title"),
                content_tag(:p, feature[:desc])
              ])
            end
          end
        end
      end
    end
  end

  # @group Playground
  # @param slides_per_view number
  # @param max_height number
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(slides_per_view: 1, max_height: 200, size: nil, color: nil, style: nil)
    render ::Decor::Daisy::Carousel.new(
      images: [
        {path: "logo.png", alt: "Image 1"},
        {path: "pic.jpg", alt: "Image 2"},
        {url: "https://cataas.com/cat", alt: "Image 3"},
        {url: "https://i.pravatar.cc/300", alt: "Image 4"}
      ],
      slides_per_view: slides_per_view,
      max_height: max_height,
      size: size,
      color: color,
      style: style
    )
  end

  # @group Slides Per View
  # @label Single Slide
  def single_slide_view
    render ::Decor::Daisy::Carousel.new(
      images: [
        {url: "https://picsum.photos/600/400?random=10", alt: "Full width slide 1"},
        {url: "https://picsum.photos/600/400?random=11", alt: "Full width slide 2"},
        {url: "https://picsum.photos/600/400?random=12", alt: "Full width slide 3"}
      ],
      slides_per_view: 1,
      max_height: 400
    )
  end

  # @group Slides Per View
  # @label Two Slides
  def two_slides_view
    render ::Decor::Daisy::Carousel.new(
      images: [
        {url: "https://picsum.photos/350/250?random=13", alt: "Item 1"},
        {url: "https://picsum.photos/350/250?random=14", alt: "Item 2"},
        {url: "https://picsum.photos/350/250?random=15", alt: "Item 3"},
        {url: "https://picsum.photos/350/250?random=16", alt: "Item 4"}
      ],
      slides_per_view: 2,
      max_height: 250
    )
  end

  # @group Slides Per View
  # @label Four Slides
  def four_slides_view
    render ::Decor::Daisy::Carousel.new(
      images: [
        {url: "https://picsum.photos/200/150?random=17", alt: "Thumbnail 1"},
        {url: "https://picsum.photos/200/150?random=18", alt: "Thumbnail 2"},
        {url: "https://picsum.photos/200/150?random=19", alt: "Thumbnail 3"},
        {url: "https://picsum.photos/200/150?random=20", alt: "Thumbnail 4"},
        {url: "https://picsum.photos/200/150?random=21", alt: "Thumbnail 5"},
        {url: "https://picsum.photos/200/150?random=22", alt: "Thumbnail 6"}
      ],
      slides_per_view: 4,
      max_height: 150
    )
  end

  # @group Heights
  # @label Small Height
  def height_small
    render ::Decor::Daisy::Carousel.new(
      images: [
        {url: "https://picsum.photos/300/150?random=23", alt: "Small 1"},
        {url: "https://picsum.photos/300/150?random=24", alt: "Small 2"},
        {url: "https://picsum.photos/300/150?random=25", alt: "Small 3"}
      ],
      max_height: 150
    )
  end

  # @group Heights
  # @label Medium Height
  def height_medium
    render ::Decor::Daisy::Carousel.new(
      images: [
        {url: "https://picsum.photos/400/300?random=26", alt: "Medium 1"},
        {url: "https://picsum.photos/400/300?random=27", alt: "Medium 2"},
        {url: "https://picsum.photos/400/300?random=28", alt: "Medium 3"}
      ],
      max_height: 300
    )
  end

  # @group Heights
  # @label Large Height
  def height_large
    render ::Decor::Daisy::Carousel.new(
      images: [
        {url: "https://picsum.photos/800/500?random=29", alt: "Large 1"},
        {url: "https://picsum.photos/800/500?random=30", alt: "Large 2"},
        {url: "https://picsum.photos/800/500?random=31", alt: "Large 3"}
      ],
      max_height: 500
    )
  end
end
