# @label Footer
class ::Decor::Nav::FooterPreview < ::Lookbook::Preview
  # @!group Basic Examples

  # Default footer with link groups and social links
  def default
    render ::Decor::Nav::Footer.new(
      company_name: "Example Company",
      link_groups: [
        ::Decor::Nav::Footer::LinkGroup.new(
          title: "Products",
          links: [
            ::Decor::Nav::Footer::FooterLink.new(label: "Features", href: "/features"),
            ::Decor::Nav::Footer::FooterLink.new(label: "Pricing", href: "/pricing"),
            ::Decor::Nav::Footer::FooterLink.new(label: "Enterprise", href: "/enterprise")
          ]
        ),
        ::Decor::Nav::Footer::LinkGroup.new(
          title: "Resources",
          links: [
            ::Decor::Nav::Footer::FooterLink.new(label: "Documentation", href: "/docs"),
            ::Decor::Nav::Footer::FooterLink.new(label: "API Reference", href: "/api", external: true),
            ::Decor::Nav::Footer::FooterLink.new(label: "Support", href: "/support", icon: "support")
          ]
        ),
        ::Decor::Nav::Footer::LinkGroup.new(
          title: "Company",
          links: [
            ::Decor::Nav::Footer::FooterLink.new(label: "About", href: "/about"),
            ::Decor::Nav::Footer::FooterLink.new(label: "Blog", href: "/blog"),
            ::Decor::Nav::Footer::FooterLink.new(label: "Careers", href: "/careers")
          ]
        )
      ],
      social_links: [
        ::Decor::Nav::Footer::SocialLink.new(platform: :twitter, url: "https://twitter.com/example"),
        ::Decor::Nav::Footer::SocialLink.new(platform: :github, url: "https://github.com/example"),
        ::Decor::Nav::Footer::SocialLink.new(platform: :linkedin, url: "https://linkedin.com/company/example")
      ]
    )
  end

  # Footer with newsletter signup
  def with_newsletter
    render ::Decor::Nav::Footer.new(
      company_name: "Example Company",
      show_newsletter: true,
      leads_submit_path: "/leads",
      link_groups: [
        ::Decor::Nav::Footer::LinkGroup.new(
          title: "Quick Links",
          links: [
            ::Decor::Nav::Footer::FooterLink.new(label: "Home", href: "/"),
            ::Decor::Nav::Footer::FooterLink.new(label: "About", href: "/about"),
            ::Decor::Nav::Footer::FooterLink.new(label: "Contact", href: "/contact")
          ]
        )
      ],
      social_links: [
        ::Decor::Nav::Footer::SocialLink.new(platform: :facebook, url: "https://facebook.com/example"),
        ::Decor::Nav::Footer::SocialLink.new(platform: :instagram, url: "https://instagram.com/example")
      ]
    )
  end

  # Light theme footer
  def light_theme
    render ::Decor::Nav::Footer.new(
      company_name: "Example Company",
      theme: :light,
      link_groups: [
        ::Decor::Nav::Footer::LinkGroup.new(
          title: "Services",
          links: [
            ::Decor::Nav::Footer::FooterLink.new(label: "Web Development", href: "/web"),
            ::Decor::Nav::Footer::FooterLink.new(label: "Mobile Apps", href: "/mobile"),
            ::Decor::Nav::Footer::FooterLink.new(label: "Consulting", href: "/consulting")
          ]
        )
      ],
      social_links: [
        ::Decor::Nav::Footer::SocialLink.new(platform: :github, url: "https://github.com/example"),
        ::Decor::Nav::Footer::SocialLink.new(platform: :youtube, url: "https://youtube.com/@example")
      ]
    )
  end

  # @!endgroup
  # @!group Advanced Examples

  # Footer with custom content areas
  def custom_content
    render ::Decor::Nav::Footer.new(
      company_name: "Example Company",
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
          a(href: "/privacy", class: "link") { "Privacy Policy" }
          a(href: "/terms", class: "link") { "Terms of Service" }
        end
      end
    end
  end

  # Footer with hidden link groups
  def with_visibility_control
    render ::Decor::Nav::Footer.new(
      company_name: "Example Company",
      link_groups: [
        ::Decor::Nav::Footer::LinkGroup.new(
          title: "Visible Group",
          visible: true,
          links: [
            ::Decor::Nav::Footer::FooterLink.new(label: "Public Link", href: "/public")
          ]
        ),
        ::Decor::Nav::Footer::LinkGroup.new(
          title: "Hidden Group",
          visible: false,
          links: [
            ::Decor::Nav::Footer::FooterLink.new(label: "Hidden Link", href: "/hidden")
          ]
        )
      ],
      social_links: [
        ::Decor::Nav::Footer::SocialLink.new(platform: :twitter, url: "https://twitter.com/example", visible: true),
        ::Decor::Nav::Footer::SocialLink.new(platform: :facebook, url: "https://facebook.com/example", visible: false)
      ]
    )
  end

  # @!endgroup
  # @!group Playground

  # Interactive playground for testing
  def playground
    render ::Decor::Nav::Footer.new(
      company_name: "Example Company",
      theme: :dark,
      link_groups: [
        ::Decor::Nav::Footer::LinkGroup.new(
          title: "Company",
          links: [
            ::Decor::Nav::Footer::FooterLink.new(label: "About", href: "/about"),
            ::Decor::Nav::Footer::FooterLink.new(label: "Careers", href: "/careers")
          ]
        )
      ],
      social_links: [
        ::Decor::Nav::Footer::SocialLink.new(platform: :twitter, url: "https://twitter.com/company"),
        ::Decor::Nav::Footer::SocialLink.new(platform: :github, url: "https://github.com/company")
      ]
    )
  end

  # @!endgroup
end
