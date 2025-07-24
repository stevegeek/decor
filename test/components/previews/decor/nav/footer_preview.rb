# @label Footer
class ::Decor::Nav::FooterPreview < ::Lookbook::Preview
  # Footer
  # ------
  #
  # A comprehensive footer component for displaying company information, navigation links,
  # social media links, and newsletter signup forms. Supports multiple themes and layouts.
  #
  # @group Examples
  # @label Default Footer
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

  # @group Examples
  # @label Footer with Newsletter
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

  # @group Examples
  # @label Custom Content Areas
  def with_custom_content
    render ::Decor::Nav::Footer.new(
      company_name: "Example Company",
      show_newsletter: false
    ) do |component|
      component.with_logo do
        component.div(class: "mb-6") do
          component.h2(class: "text-2xl font-bold mb-2") { "Custom Logo Area" }
          component.p(class: "text-sm opacity-70") { "This is a custom logo section with additional branding content." }
        end
      end

      component.with_content do
        component.div(class: "space-y-4") do
          component.h3(class: "footer-title") { "Get in Touch" }
          component.p(class: "text-sm") { "Have questions? We'd love to hear from you." }
          component.div(class: "flex gap-2") do
            component.render ::Decor::Button.new(label: "Contact Us", color: :primary, size: :sm)
            component.render ::Decor::Button.new(label: "Schedule Demo", color: :secondary, style: :outlined, size: :sm)
          end
        end
      end

      component.with_links do
        component.div(class: "grid grid-cols-1 md:grid-cols-3 gap-6") do
          component.div do
            component.h3(class: "footer-title") { "Custom Links Section" }
            component.ul(class: "space-y-2") do
              component.li { component.a(href: "#", class: "link link-hover") { "Custom Link 1" } }
              component.li { component.a(href: "#", class: "link link-hover") { "Custom Link 2" } }
            end
          end
        end
      end

      component.with_copyright do
        component.p(class: "text-sm opacity-70 text-center") do
          component.a(href: "/privacy", class: "link") { "Privacy Policy" }
          component.a(href: "/terms", class: "link") { "Terms of Service" }
        end
      end
    end
  end

  # @group Playground
  # @param company_name text
  # @param theme select [dark, light]
  # @param show_newsletter toggle
  # @param show_social toggle
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(company_name: "Example Company", theme: :dark, show_newsletter: true, show_social: true, size: nil, color: nil, style: nil)
    render ::Decor::Nav::Footer.new(
      company_name: company_name,
      theme: theme,
      show_newsletter: show_newsletter,
      show_social: show_social,
      size: size,
      color: color,
      style: style,
      link_groups: [
        ::Decor::Nav::Footer::LinkGroup.new(
          title: "Company",
          links: [
            ::Decor::Nav::Footer::FooterLink.new(label: "About", href: "/about"),
            ::Decor::Nav::Footer::FooterLink.new(label: "Careers", href: "/careers")
          ]
        )
      ],
      social_links: show_social ? [
        ::Decor::Nav::Footer::SocialLink.new(platform: :twitter, url: "https://twitter.com/company"),
        ::Decor::Nav::Footer::SocialLink.new(platform: :github, url: "https://github.com/company")
      ] : []
    )
  end

  # @group Themes
  # @label Dark Theme
  def theme_dark
    render ::Decor::Nav::Footer.new(
      company_name: "Example Company",
      theme: :dark,
      link_groups: standard_link_groups,
      social_links: standard_social_links
    )
  end

  # @group Themes
  # @label Light Theme
  def theme_light
    render ::Decor::Nav::Footer.new(
      company_name: "Example Company",
      theme: :light,
      link_groups: standard_link_groups,
      social_links: standard_social_links
    )
  end

  # @group Link Visibility
  # @label Selective Visibility
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

  private

  def standard_link_groups
    [
      ::Decor::Nav::Footer::LinkGroup.new(
        title: "Services",
        links: [
          ::Decor::Nav::Footer::FooterLink.new(label: "Web Development", href: "/web"),
          ::Decor::Nav::Footer::FooterLink.new(label: "Mobile Apps", href: "/mobile"),
          ::Decor::Nav::Footer::FooterLink.new(label: "Consulting", href: "/consulting")
        ]
      )
    ]
  end

  def standard_social_links
    [
      ::Decor::Nav::Footer::SocialLink.new(platform: :github, url: "https://github.com/example"),
      ::Decor::Nav::Footer::SocialLink.new(platform: :youtube, url: "https://youtube.com/@example")
    ]
  end
end
