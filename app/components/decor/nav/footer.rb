# frozen_string_literal: true

module Decor
  module Nav
    class Footer < PhlexComponent
      no_stimulus_controller

      class FooterLink < ::Literal::Data
        prop :label, String
        prop :href, String
        prop :external, _Boolean, default: false, predicate: :public
        prop :icon, _Nilable(String)
      end

      class LinkGroup < ::Literal::Data
        prop :title, String
        prop :links, Array, default: [].freeze
        prop :visible, _Boolean, default: true
      end

      class SocialLink < ::Literal::Data
        prop :platform, Symbol
        prop :url, String
        prop :label, _Nilable(String)
        prop :visible, _Boolean, default: true
      end

      prop :company_name, _String(_Predicate("present", &:present?))
      prop :leads_model, _Nilable(Object)
      prop :leads_submit_path, _Nilable(String)
      prop :link_groups, Array, default: [].freeze
      prop :social_links, Array, default: [].freeze
      prop :theme, _Union(:light, :dark), default: :dark
      prop :show_newsletter, _Boolean, default: true
      prop :show_social, _Boolean, default: true

      def with_logo(&block)
        @logo_content = block
      end

      def with_content(&block)
        @custom_content = block
      end

      def with_links(&block)
        @custom_links = block
      end

      def with_copyright(&block)
        @copyright_content = block
      end

      def view_template(&)
        vanish(&)
        root_element do
          div(class: "container mx-auto px-4 py-8 lg:py-12") do
            div(class: "grid grid-cols-1 lg:grid-cols-3 gap-8") do
              render_content_section
              render_links_section
            end
            render_bottom_section
          end
        end
      end

      private

      def element_classes
        classes = ["footer"]
        classes << ((@theme == :dark) ? "bg-neutral text-neutral-content" : "bg-base-200")
        classes.join(" ")
      end

      def render_content_section
        div(class: "lg:col-span-1") do
          if @logo_content
            render @logo_content
          end

          if @custom_content
            render @custom_content
          elsif @show_newsletter && @leads_model && @leads_submit_path
            render_newsletter_section
          end
        end
      end

      def render_newsletter_section
        div(class: "mt-6") do
          h3(class: "footer-title") { "Subscribe to our newsletter" }
          p(class: "text-sm opacity-70 mb-4") { "Stay in the loop with the latest features, updates, and efficiency-boosting tips." }

          render ::Decor::Forms::Form.new(model: @leads_model, local: true, url: @leads_submit_path, html: {class: "flex flex-col sm:flex-row gap-2"}) do |form|
            raw(form.builder.hidden_field(:from_entry_point, value: "corp_site_footer").html_safe)
            raw(form.builder.email_field(:email, label_position: :inside, required: true, placeholder: "Enter your email", class: "input input-bordered flex-1").html_safe)
            raw(form.builder.submit("Subscribe", class: "btn btn-primary").html_safe)
          end
        end
      end

      def render_links_section
        div(class: "lg:col-span-2") do
          if @custom_links
            render @custom_links
          elsif @link_groups.any?
            div(class: "grid grid-cols-2 md:grid-cols-#{[4, @link_groups.size].min} gap-6") do
              @link_groups.each do |group|
                next unless group.visible
                render_link_group(group)
              end
            end
          end
        end
      end

      def render_link_group(group)
        div do
          h3(class: "footer-title") { group.title }
          ul(class: "space-y-2") do
            group.links.each do |link|
              li do
                a(
                  href: link.href,
                  class: "link link-hover",
                  target: (link.external? ? "_blank" : nil),
                  rel: (link.external? ? "noopener noreferrer" : nil)
                ) do
                  if link.icon.present?
                    render ::Decor::Icon.new(name: link.icon, html_options: {class: "inline-block w-4 h-4 mr-2"})
                  end
                  plain link.label
                end
              end
            end
          end
        end
      end

      def render_bottom_section
        div(class: "footer footer-center mt-8 pt-6 border-t border-base-300") do
          if @show_social && @social_links.any?
            div(class: "flex flex-wrap justify-center gap-4 mb-4") do
              @social_links.each do |social_link|
                next unless social_link.visible
                render_social_link(social_link)
              end
            end
          end

          div do
            if @copyright_content
              render @copyright_content
            else
              p(class: "text-sm opacity-70") do
                plain "© #{Time.zone.today.year} #{@company_name}. All rights reserved."
              end
            end
          end
        end
      end

      def render_social_link(social_link)
        a(
          href: social_link.url,
          class: "btn btn-ghost btn-circle",
          aria_label: social_link.label || social_link.platform.to_s.capitalize,
          target: "_blank",
          rel: "noopener noreferrer"
        ) do
          render_social_icon(social_link.platform)
        end
      end

      def render_social_icon(platform)
        case platform
        when :facebook
          svg(class: "w-5 h-5 fill-current", viewBox: "0 0 24 24") do |s|
            s.path(d: "M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z")
          end
        when :twitter
          svg(class: "w-5 h-5 fill-current", viewBox: "0 0 24 24") do |s|
            s.path(d: "M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z")
          end
        when :instagram
          svg(class: "w-5 h-5 fill-current", viewBox: "0 0 24 24") do |s|
            s.path(d: "M12.017 0C5.396 0 .029 5.367.029 11.987c0 6.62 5.367 11.987 11.988 11.987 6.62 0 11.987-5.367 11.987-11.987C24.014 5.367 18.647.001 12.017.001zM8.449 16.988c-2.458 0-4.467-2.01-4.467-4.468 0-2.458 2.009-4.467 4.467-4.467s4.468 2.009 4.468 4.467c0 2.458-2.01 4.468-4.468 4.468zm7.679 0c-2.458 0-4.467-2.01-4.467-4.468 0-2.458 2.009-4.467 4.467-4.467s4.467 2.009 4.467 4.467c0 2.458-2.009 4.468-4.467 4.468z")
          end
        when :linkedin
          svg(class: "w-5 h-5 fill-current", viewBox: "0 0 24 24") do |s|
            s.path(d: "M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z")
          end
        when :youtube
          svg(class: "w-5 h-5 fill-current", viewBox: "0 0 24 24") do |s|
            s.path(d: "M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z")
          end
        when :github
          svg(class: "w-5 h-5 fill-current", viewBox: "0 0 24 24") do |s|
            s.path(d: "M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z")
          end
        end
      end
    end
  end
end
