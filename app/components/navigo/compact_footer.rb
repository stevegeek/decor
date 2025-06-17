# frozen_string_literal: true

module Navigo
  class CompactFooter < PhlexComponent
    include Phlex::Rails::Helpers::ImagePath
    no_stimulus_controller

    class SocialLink < ::Literal::Data
      prop :platform, Symbol
      prop :url, String
      prop :label, _Nilable(String)
      prop :visible, _Boolean, default: true
    end

    class FooterLink < ::Literal::Data
      prop :label, String
      prop :href, String
      prop :external, _Boolean, default: false, predicate: :public
    end

    attribute :supplier_name, String, allow_blank: false
    attribute :supplier_support_email_address, String, allow_blank: false
    attribute :facebook_url, String
    attribute :instagram_url, String
    attribute :twitter_url, String
    attribute :youtube_url, String
    attribute :linkedin_url, String
    attribute :github_url, String
    attribute :status_site_url, String
    attribute :social_links, Array, default: [].freeze
    attribute :footer_links, Array, default: [].freeze
    attribute :theme, Symbol, default: :light, in: [:light, :dark]
    attribute :show_logo, :boolean, default: true

    def with_logo(&block)
      @logo_content = block
    end

    def with_links(&block)
      @custom_links = block
    end

    def with_copyright(&block)
      @copyright_content = block
    end

    def initialize(**attrs)
      super
      convert_data_structures
    end

    def view_template
      render parent_element do
        div(class: "container mx-auto px-4 py-6") do
          render_social_section
          render_links_section
          render_logo_section
          render_copyright_section
        end
      end
    end

    private

    def element_classes
      classes = ["footer", "footer-center"]
      classes << ((@theme == :dark) ? "bg-neutral text-neutral-content" : "bg-base-200")
      classes.join(" ")
    end

    def render_social_section
      return unless show_social_links?

      div(class: "flex justify-center space-x-4 mb-4") do
        social_links_to_render.each do |social_link|
          render_social_link(social_link)
        end
      end
    end

    def render_links_section
      return unless show_footer_links?

      nav(class: "flex flex-wrap justify-center gap-x-6 gap-y-2 mb-4", aria_label: "Footer") do
        if @custom_links
          render @custom_links
        else
          footer_links_to_render.each do |link|
            render_footer_link(link)
          end
        end
      end
    end

    def render_logo_section
      return unless @show_logo

      div(class: "mb-4") do
        if @logo_content
          render @logo_content
        else
          div(class: "mx-auto h-16 w-auto flex items-center justify-center bg-primary text-primary-content rounded") do
            span(class: "font-bold text-lg") { @supplier_name }
          end
        end
      end
    end

    def render_copyright_section
      div(class: "text-center") do
        if @copyright_content
          render @copyright_content
        else
          p(class: "text-xs opacity-70") do
            plain "© #{Time.zone.today.year} #{@supplier_name}. All rights reserved."
          end
        end
      end
    end

    def render_social_link(social_link)
      a(
        href: social_link.url,
        class: "btn btn-ghost btn-circle btn-sm",
        aria_label: social_link.label || social_link.platform.to_s.capitalize,
        target: "_blank",
        rel: "noopener noreferrer"
      ) do
        render_social_icon(social_link.platform)
      end
    end

    def render_footer_link(link)
      a(
        href: link.href,
        class: "text-sm link link-hover",
        target: (link.external? ? "_blank" : nil),
        rel: (link.external? ? "noopener noreferrer" : nil)
      ) { link.label }
    end

    def show_social_links?
      @social_links.any? || legacy_social_links.any?
    end

    def show_footer_links?
      @footer_links.any? || legacy_footer_links.any?
    end

    def social_links_to_render
      if @social_links.any?
        @social_links.select(&:visible)
      else
        legacy_social_links
      end
    end

    def footer_links_to_render
      if @footer_links.any?
        @footer_links
      else
        legacy_footer_links
      end
    end

    def legacy_social_links
      links = []
      links << SocialLink.new(platform: :facebook, url: @facebook_url) if @facebook_url.present?
      links << SocialLink.new(platform: :instagram, url: @instagram_url) if @instagram_url.present?
      links << SocialLink.new(platform: :twitter, url: @twitter_url) if @twitter_url.present?
      links << SocialLink.new(platform: :youtube, url: @youtube_url) if @youtube_url.present?
      links << SocialLink.new(platform: :linkedin, url: @linkedin_url) if @linkedin_url.present?
      links << SocialLink.new(platform: :github, url: @github_url) if @github_url.present?
      links
    end

    def legacy_footer_links
      links = []
      links << FooterLink.new(label: "Get Support", href: "/support")
      links << FooterLink.new(label: "Status", href: @status_site_url) if @status_site_url.present?
      links << FooterLink.new(label: "Privacy", href: "https://www.example.com/privacy/", external: true)
      links << FooterLink.new(label: "Terms", href: "https://www.example.com/terms/", external: true)
      links
    end

    def render_social_icon(platform)
      case platform
      when :facebook
        svg(class: "w-4 h-4 fill-current", viewBox: "0 0 24 24") do |s|
          s.path(d: "M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z")
        end
      when :twitter
        svg(class: "w-4 h-4 fill-current", viewBox: "0 0 24 24") do |s|
          s.path(d: "M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z")
        end
      when :instagram
        svg(class: "w-4 h-4 fill-current", viewBox: "0 0 24 24") do |s|
          s.path(d: "M12.315 2c2.43 0 2.784.013 3.808.06 1.064.049 1.791.218 2.427.465a4.902 4.902 0 011.772 1.153 4.902 4.902 0 011.153 1.772c.247.636.416 1.363.465 2.427.048 1.067.06 1.407.06 4.123v.08c0 2.643-.012 2.987-.06 4.043-.049 1.064-.218 1.791-.465 2.427a4.902 4.902 0 01-1.153 1.772 4.902 4.902 0 01-1.772 1.153c-.636.247-1.363.416-2.427.465-1.067.048-1.407.06-4.123.06h-.08c-2.643 0-2.987-.012-4.043-.06-1.064-.049-1.791-.218-2.427-.465a4.902 4.902 0 01-1.772-1.153 4.902 4.902 0 01-1.153-1.772c-.247-.636-.416-1.363-.465-2.427-.047-1.024-.06-1.379-.06-3.808v-.63c0-2.43.013-2.784.06-3.808.049-1.064.218-1.791.465-2.427a4.902 4.902 0 011.153-1.772A4.902 4.902 0 715.45 2.525c.636-.247 1.363-.416 2.427-.465C8.901 2.013 9.256 2 11.685 2h.63zm-.081 1.802h-.468c-2.456 0-2.784.011-3.807.058-.975.045-1.504.207-1.857.344-.467.182-.8.398-1.15.748-.35.35-.566.683-.748 1.15-.137.353-.3.882-.344 1.857-.047 1.023-.058 1.351-.058 3.807v.468c0 2.456.011 2.784.058 3.807.045.975.207 1.504.344 1.857.182.466.399.8.748 1.15.35.35.683.566 1.15.748.353.137.882.3 1.857.344 1.054.048 1.37.058 4.041.058h.08c2.597 0 2.917-.01 3.96-.058.976-.045 1.505-.207 1.858-.344.466-.182.8-.398 1.15-.748.35-.35.566-.683.748-1.15.137-.353.3-.882.344-1.857.048-1.055.058-1.37.058-4.041v-.08c0-2.597-.01-2.917-.058-3.96-.045-.976-.207-1.505-.344-1.858a3.097 3.097 0 00-.748-1.15 3.098 3.098 0 00-1.15-.748c-.353-.137-.882-.3-1.857-.344-1.023-.047-1.351-.058-3.807-.058zM12 6.865a5.135 5.135 0 110 10.27 5.135 5.135 0 010-10.27zm0 1.802a3.333 3.333 0 100 6.666 3.333 3.333 0 000-6.666zm5.338-3.205a1.2 1.2 0 110 2.4 1.2 1.2 0 010-2.4z")
        end
      when :linkedin
        svg(class: "w-4 h-4 fill-current", viewBox: "0 0 24 24") do |s|
          s.path(d: "M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z")
        end
      when :youtube
        svg(class: "w-4 h-4 fill-current", viewBox: "0 0 24 24") do |s|
          s.path(d: "M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z")
        end
      when :github
        svg(class: "w-4 h-4 fill-current", viewBox: "0 0 24 24") do |s|
          s.path(d: "M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z")
        end
      end
    end

    def convert_data_structures
      @social_links = @social_links.map do |link|
        case link
        when Hash
          SocialLink.new(
            platform: (link[:platform] || link["platform"]).to_sym,
            url: link[:url] || link["url"],
            label: link[:label] || link["label"],
            visible: link.fetch(:visible, link.fetch("visible", true))
          )
        when SocialLink
          link
        else
          link
        end
      end

      @footer_links = @footer_links.map do |link|
        case link
        when Hash
          FooterLink.new(
            label: link[:label] || link["label"],
            href: link[:href] || link["href"],
            external: link.fetch(:external, link.fetch("external", false))
          )
        when FooterLink
          link
        else
          link
        end
      end
    end
  end
end
