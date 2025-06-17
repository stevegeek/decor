# @label Footer
class ::Navigo::FooterPreview < ::Lookbook::Preview
  # @!group Basic Examples
  
  # Default footer with link groups and social links
  def default
    render ::Navigo::Footer.new(
      supplier_name: "Example Company",
      link_groups: [
        {
          title: "Products",
          links: [
            { label: "Features", href: "/features" },
            { label: "Pricing", href: "/pricing" },
            { label: "Enterprise", href: "/enterprise" }
          ]
        },
        {
          title: "Resources",
          links: [
            { label: "Documentation", href: "/docs" },
            { label: "API Reference", href: "/api", external: true },
            { label: "Support", href: "/support", icon: "support" }
          ]
        },
        {
          title: "Company",
          links: [
            { label: "About", href: "/about" },
            { label: "Blog", href: "/blog" },
            { label: "Careers", href: "/careers" }
          ]
        }
      ],
      social_links: [
        { platform: :twitter, url: "https://twitter.com/example" },
        { platform: :github, url: "https://github.com/example" },
        { platform: :linkedin, url: "https://linkedin.com/company/example" }
      ]
    )
  end

  # Footer with newsletter signup
  def with_newsletter
    render ::Navigo::Footer.new(
      supplier_name: "Example Company",
      show_newsletter: true,
      leads_submit_path: "/leads",
      link_groups: [
        {
          title: "Quick Links",
          links: [
            { label: "Home", href: "/" },
            { label: "About", href: "/about" },
            { label: "Contact", href: "/contact" }
          ]
        }
      ],
      social_links: [
        { platform: :facebook, url: "https://facebook.com/example" },
        { platform: :instagram, url: "https://instagram.com/example" }
      ]
    )
  end

  # Light theme footer
  def light_theme
    render ::Navigo::Footer.new(
      supplier_name: "Example Company",
      theme: :light,
      link_groups: [
        {
          title: "Services",
          links: [
            { label: "Web Development", href: "/web" },
            { label: "Mobile Apps", href: "/mobile" },
            { label: "Consulting", href: "/consulting" }
          ]
        }
      ],
      social_links: [
        { platform: :github, url: "https://github.com/example" },
        { platform: :youtube, url: "https://youtube.com/@example" }
      ]
    )
  end

  # @!endgroup
  # @!group Advanced Examples

  # Footer with custom content areas
  def custom_content
    render ::Navigo::Footer.new(
      supplier_name: "Example Company",
      show_newsletter: false
    ) do |component|
      component.with_logo do
        div(class: "mb-6") do
          h2(class: "text-2xl font-bold mb-2") { "Custom Logo Area" }
          p(class: "text-sm opacity-70") { "This is a custom logo section with additional branding content." }
        end
      end
      
      component.with_content do
        div(class: "space-y-4") do
          h3(class: "footer-title") { "Get in Touch" }
          p(class: "text-sm") { "Have questions? We'd love to hear from you." }
          div(class: "flex gap-2") do
            render ::Decor::Button.new(label: "Contact Us", color: :primary, size: :small)
            render ::Decor::Button.new(label: "Schedule Demo", color: :secondary, variant: :outlined, size: :small)
          end
        end
      end

      component.with_links do
        div(class: "grid grid-cols-1 md:grid-cols-3 gap-6") do
          div do
            h3(class: "footer-title") { "Custom Links Section" }
            ul(class: "space-y-2") do
              li { a(href: "#", class: "link link-hover") { "Custom Link 1" } }
              li { a(href: "#", class: "link link-hover") { "Custom Link 2" } }
            end
          end
        end
      end

      component.with_copyright do
        p(class: "text-sm opacity-70 text-center") do
          "© 2024 Custom Copyright. All rights reserved. | "
          a(href: "/privacy", class: "link") { "Privacy Policy" }
          " | "
          a(href: "/terms", class: "link") { "Terms of Service" }
        end
      end
    end
  end

  # Footer with hidden link groups
  def with_visibility_control
    render ::Navigo::Footer.new(
      supplier_name: "Example Company",
      link_groups: [
        {
          title: "Visible Group",
          visible: true,
          links: [
            { label: "Public Link", href: "/public" }
          ]
        },
        {
          title: "Hidden Group",
          visible: false,
          links: [
            { label: "Hidden Link", href: "/hidden" }
          ]
        }
      ],
      social_links: [
        { platform: :twitter, url: "https://twitter.com/example", visible: true },
        { platform: :facebook, url: "https://facebook.com/example", visible: false }
      ]
    )
  end

  # @!endgroup
  # @!group Playground

  # Interactive playground for testing
  def playground
    render ::Navigo::Footer.new(
      supplier_name: "Example Company",
      theme: :dark,
      link_groups: [
        {
          title: "Company",
          links: [
            { label: "About", href: "/about" },
            { label: "Careers", href: "/careers" }
          ]
        }
      ],
      social_links: [
        { platform: :twitter, url: "https://twitter.com/company" },
        { platform: :github, url: "https://github.com/company" }
      ]
    )
  end

  # @!endgroup
end
