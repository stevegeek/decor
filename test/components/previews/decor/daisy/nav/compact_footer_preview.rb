# @label CompactFooter
class ::Decor::Daisy::Nav::CompactFooterPreview < ::Lookbook::Preview
  # CompactFooter
  # -------------
  #
  # A minimal footer component optimized for small spaces and mobile views.
  # Includes company name, social links, and essential footer links in a compact layout.
  #
  # @group Examples
  # @label Default Compact Footer
  def default
    render ::Decor::Daisy::Nav::CompactFooter.new(
      company_name: "Example Company",
      social_links: [
        ::Decor::Daisy::Nav::Footer::SocialLink.new(platform: :twitter, url: "https://twitter.com/example"),
        ::Decor::Daisy::Nav::Footer::SocialLink.new(platform: :github, url: "https://github.com/example"),
        ::Decor::Daisy::Nav::Footer::SocialLink.new(platform: :linkedin, url: "https://linkedin.com/company/example")
      ],
      footer_links: [
        ::Decor::Daisy::Nav::Footer::FooterLink.new(label: "Support", href: "/support"),
        ::Decor::Daisy::Nav::Footer::FooterLink.new(label: "Privacy", href: "/privacy"),
        ::Decor::Daisy::Nav::Footer::FooterLink.new(label: "Terms", href: "/terms")
      ]
    )
  end

  # @group Examples
  # @label All Social Platforms
  def all_social_platforms
    render ::Decor::Daisy::Nav::CompactFooter.new(
      company_name: "Example Company",
      social_links: [
        ::Decor::Daisy::Nav::Footer::SocialLink.new(platform: :facebook, url: "https://facebook.com/example"),
        ::Decor::Daisy::Nav::Footer::SocialLink.new(platform: :twitter, url: "https://twitter.com/example"),
        ::Decor::Daisy::Nav::Footer::SocialLink.new(platform: :instagram, url: "https://instagram.com/example"),
        ::Decor::Daisy::Nav::Footer::SocialLink.new(platform: :linkedin, url: "https://linkedin.com/company/example"),
        ::Decor::Daisy::Nav::Footer::SocialLink.new(platform: :youtube, url: "https://youtube.com/@example"),
        ::Decor::Daisy::Nav::Footer::SocialLink.new(platform: :github, url: "https://github.com/example")
      ]
    )
  end

  # @group Examples
  # @label Custom Content
  def custom_content
    render ::Decor::Daisy::Nav::CompactFooter.new(
      company_name: "Example Company",
      show_logo: false
    ) do |component|
      component.with_logo do
        component.div(class: "decor:flex decor:items-center decor:justify-center decor:mb-4") do
          component.div(class: "decor:bg-primary decor:text-primary-content decor:rounded-full decor:p-3 decor:mr-3") do
            component.svg(class: "decor:w-6 decor:h-6 decor:fill-current", viewBox: "0 0 24 24") do |s|
              s.path(d: "M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z")
            end
          end
          component.span(class: "decor:text-lg decor:font-bold") { "Custom Brand" }
        end
      end

      component.with_copyright do
        component.div(class: "decor:text-center decor:space-y-2") do
          component.p(class: "decor:text-xs decor:opacity-70") { "Built with ♥ by our amazing team" }
        end
      end
    end
  end

  # @group Playground
  # @param company_name text
  # @param theme select [dark, light]
  # @param show_logo toggle
  # @param show_social toggle
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(
    company_name: "Example Company",
    theme: :light,
    show_logo: true,
    show_social: true,
    size: nil,
    color: nil,
    style: nil
  )
    render ::Decor::Daisy::Nav::CompactFooter.new(
      company_name: company_name,
      theme: theme,
      show_logo: show_logo,
      size: size,
      color: color,
      style: style,
      social_links: show_social ? standard_social_links : [],
      footer_links: standard_footer_links
    )
  end

  # @group Themes
  # @label Dark Theme
  def theme_dark
    render ::Decor::Daisy::Nav::CompactFooter.new(
      company_name: "Example Company",
      theme: :dark,
      social_links: standard_social_links,
      footer_links: standard_footer_links
    )
  end

  # @group Themes
  # @label Light Theme
  def theme_light
    render ::Decor::Daisy::Nav::CompactFooter.new(
      company_name: "Example Company",
      theme: :light,
      social_links: standard_social_links,
      footer_links: standard_footer_links
    )
  end

  # @group Logo Display
  # @label Without Logo
  def without_logo
    render ::Decor::Daisy::Nav::CompactFooter.new(
      company_name: "Example Company",
      show_logo: false,
      social_links: standard_social_links,
      footer_links: standard_footer_links
    )
  end

  private

  def standard_social_links
    [
      ::Decor::Daisy::Nav::Footer::SocialLink.new(platform: :twitter, url: "https://twitter.com/example"),
      ::Decor::Daisy::Nav::Footer::SocialLink.new(platform: :github, url: "https://github.com/example"),
      ::Decor::Daisy::Nav::Footer::SocialLink.new(platform: :linkedin, url: "https://linkedin.com/company/example")
    ]
  end

  def standard_footer_links
    [
      ::Decor::Daisy::Nav::Footer::FooterLink.new(label: "Support", href: "/support"),
      ::Decor::Daisy::Nav::Footer::FooterLink.new(label: "Privacy", href: "/privacy"),
      ::Decor::Daisy::Nav::Footer::FooterLink.new(label: "Terms", href: "/terms")
    ]
  end
end
