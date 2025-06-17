# @label CompactFooter
class ::Navigo::CompactFooterPreview < ::Lookbook::Preview
  # @!group Basic Examples

  # Default compact footer with social links
  def default
    render ::Navigo::CompactFooter.new(
      supplier_name: "Example Company",
      supplier_support_email_address: "support@example.com",
      social_links: [
        {platform: :twitter, url: "https://twitter.com/example"},
        {platform: :github, url: "https://github.com/example"},
        {platform: :linkedin, url: "https://linkedin.com/company/example"}
      ],
      footer_links: [
        {label: "Support", href: "/support"},
        {label: "Privacy", href: "/privacy"},
        {label: "Terms", href: "/terms"}
      ]
    )
  end

  # Compact footer with all social platforms
  def all_social_platforms
    render ::Navigo::CompactFooter.new(
      supplier_name: "Example Company",
      supplier_support_email_address: "support@example.com",
      social_links: [
        {platform: :facebook, url: "https://facebook.com/example", label: "Follow us on Facebook"},
        {platform: :twitter, url: "https://twitter.com/example", label: "Follow us on Twitter"},
        {platform: :instagram, url: "https://instagram.com/example", label: "Follow us on Instagram"},
        {platform: :linkedin, url: "https://linkedin.com/company/example", label: "Connect on LinkedIn"},
        {platform: :youtube, url: "https://youtube.com/@example", label: "Subscribe on YouTube"},
        {platform: :github, url: "https://github.com/example", label: "View our code on GitHub"}
      ]
    )
  end

  # Dark theme compact footer
  def dark_theme
    render ::Navigo::CompactFooter.new(
      supplier_name: "Example Company",
      supplier_support_email_address: "support@example.com",
      theme: :dark,
      social_links: [
        {platform: :twitter, url: "https://twitter.com/example"},
        {platform: :github, url: "https://github.com/example"}
      ]
    )
  end

  # Compact footer without logo
  def without_logo
    render ::Navigo::CompactFooter.new(
      supplier_name: "Example Company",
      supplier_support_email_address: "support@example.com",
      show_logo: false,
      social_links: [
        {platform: :twitter, url: "https://twitter.com/example"},
        {platform: :linkedin, url: "https://linkedin.com/company/example"}
      ]
    )
  end

  # @!endgroup
  # @!group Advanced Examples

  # Compact footer with custom content areas
  def custom_content
    render ::Navigo::CompactFooter.new(
      supplier_name: "Example Company",
      supplier_support_email_address: "support@example.com",
      show_logo: false
    ) do |component|
      component.with_logo do
        div(class: "flex items-center justify-center mb-4") do
          div(class: "bg-primary text-primary-content rounded-full p-3 mr-3") do
            svg(class: "w-6 h-6 fill-current", viewBox: "0 0 24 24") do
              path(d: "M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z")
            end
          end
          span(class: "text-lg font-bold") { "Custom Brand" }
        end
      end

      component.with_links do
        nav(class: "flex flex-wrap justify-center gap-x-6 gap-y-2 mb-4") do
          a(href: "/help", class: "text-sm link link-hover") { "Help Center" }
          a(href: "/status", class: "text-sm link link-hover") { "Service Status" }
          a(href: "/api", class: "text-sm link link-hover") { "API Docs" }
        end
      end

      component.with_copyright do
        div(class: "text-center space-y-2") do
          p(class: "text-xs opacity-70") { "Built with ♥ by our amazing team" }
          p(class: "text-xs opacity-70") do
            a(href: "https://daisyui.com", class: "link", target: "_blank") { "daisyUI" }
          end
        end
      end
    end
  end

  # Compact footer with visibility controls
  def visibility_controls
    render ::Navigo::CompactFooter.new(
      supplier_name: "Example Company",
      supplier_support_email_address: "support@example.com",
      social_links: [
        {platform: :twitter, url: "https://twitter.com/example", visible: true},
        {platform: :facebook, url: "https://facebook.com/example", visible: false},
        {platform: :github, url: "https://github.com/example", visible: true}
      ],
      footer_links: [
        {label: "Support", href: "/support"},
        {label: "Privacy", href: "/privacy", external: true}
      ]
    )
  end

  # Legacy attribute support (backward compatibility)
  def legacy_attributes
    render ::Navigo::CompactFooter.new(
      supplier_name: "Example Company",
      supplier_support_email_address: "support@example.com",
      facebook_url: "https://www.facebook.com/example",
      instagram_url: "https://www.instagram.com/example",
      twitter_url: "https://www.twitter.com/example",
      youtube_url: "https://www.youtube.com/example",
      linkedin_url: "https://www.linkedin.com/example",
      github_url: "https://www.github.com/example",
      status_site_url: "https://www.status.example.com"
    )
  end

  # @!endgroup
  # @!group Playground

  # Interactive playground for testing
  def playground
    render ::Navigo::CompactFooter.new(
      supplier_name: "Example Company",
      supplier_support_email_address: "support@example.com",
      theme: :light,
      show_logo: true
    )
  end

  # @!endgroup
end
