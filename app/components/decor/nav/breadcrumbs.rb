# frozen_string_literal: true

module Decor
  module Nav
    class Breadcrumbs < PhlexComponent
      no_stimulus_controller

      class Breadcrumb < ::Literal::Data
        prop :name, String
        prop :path, String
        prop :current, _Boolean, default: false
        prop :icon, _Nilable(String)
        prop :disabled, _Boolean, default: false
      end

      attribute :breadcrumbs, Array, default: [].freeze
      attribute :show_home, :boolean, default: true
      attribute :home_path, String, default: "/"
      attribute :home_icon, String, default: "home"
      attribute :mobile_select, :boolean, default: true
      attribute :separator, String, default: "chevron-right"

      def initialize(**attrs)
        super
        convert_breadcrumbs
      end

      def view_template
        render parent_element do
          div(class: "breadcrumbs") do
            ul do
              render_home_item if @show_home
              render_breadcrumb_items
            end
          end

          if @mobile_select && @breadcrumbs.any?
            render_mobile_select
          end
        end
      end

      private

      def root_element_attributes
        {
          element_tag: :nav,
          html_options: {"aria-label" => "Breadcrumb"}
        }
      end

      def convert_breadcrumbs
        @breadcrumbs = @breadcrumbs.map do |crumb|
          case crumb
          when Hash
            # Support both name/path and label/href formats for backward compatibility
            name = crumb[:name] || crumb["name"] || crumb[:label] || crumb["label"]
            path = crumb[:path] || crumb["path"] || crumb[:href] || crumb["href"]
            current = crumb.fetch(:current, crumb.fetch("current", false))
            icon = crumb[:icon] || crumb["icon"]
            disabled = crumb.fetch(:disabled, crumb.fetch("disabled", false))

            Breadcrumb.new(
              name: name,
              path: path,
              current: current,
              icon: icon,
              disabled: disabled
            )
          when Breadcrumb
            crumb
          else
            # Handle any other object that responds to name and path (like legacy Loaf::Breadcrumb)
            if crumb.respond_to?(:name) && crumb.respond_to?(:path)
              Breadcrumb.new(
                name: crumb.name,
                path: crumb.path,
                current: crumb.respond_to?(:current) ? crumb.current : false,
                icon: crumb.respond_to?(:icon) ? crumb.icon : nil,
                disabled: crumb.respond_to?(:disabled) ? crumb.disabled : false
              )
            else
              crumb
            end
          end
        end
      end

      def render_home_item
        li do
          if @home_path == current_path
            span(class: "text-base-content/60", "aria-current": "page") do
              render_icon(@home_icon) if @home_icon.present?
              span(class: "sr-only") { "Home" }
            end
          else
            a(href: @home_path, class: "text-base-content/60 hover:text-base-content") do
              render_icon(@home_icon) if @home_icon.present?
              span(class: "sr-only") { "Home" }
            end
          end
        end
      end

      def render_breadcrumb_items
        @breadcrumbs.each_with_index do |crumb, index|
          li do
            if crumb.current || crumb.disabled || index == @breadcrumbs.size - 1
              span(
                class: crumb.current ? "text-base-content font-medium" : "text-base-content/60",
                aria_current: (crumb.current ? "page" : nil)
              ) do
                render_icon(crumb.icon) if crumb.icon.present?
                plain crumb.name
              end
            else
              a(
                href: crumb.path,
                class: "text-base-content/60 hover:text-base-content transition-colors"
              ) do
                render_icon(crumb.icon) if crumb.icon.present?
                plain crumb.name
              end
            end
          end
        end
      end

      def render_mobile_select
        div(class: "md:hidden mt-4") do
          div(class: "text-sm font-medium text-base-content mb-2") do
            plain "Mobile navigation:"
          end

          div(class: "space-y-1") do
            if @show_home
              a(
                href: @home_path,
                class: "block py-2 px-3 rounded-md text-sm #{(@home_path == current_path) ? "bg-primary text-primary-content" : "text-base-content hover:bg-base-300"}"
              ) do
                plain "Home"
              end
            end

            @breadcrumbs.each do |crumb|
              next if crumb.disabled

              if crumb.current || crumb.path == current_path
                div(class: "block py-2 px-3 rounded-md text-sm bg-primary text-primary-content") do
                  plain crumb.name
                end
              else
                a(
                  href: crumb.path,
                  class: "block py-2 px-3 rounded-md text-sm text-base-content hover:bg-base-300"
                ) do
                  plain crumb.name
                end
              end
            end
          end
        end
      end

      def render_icon(icon_name)
        return unless icon_name.present?

        begin
          render ::Decor::Icon.new(
            name: icon_name,
            html_options: {class: "w-4 h-4 mr-1 inline-block"}
          )
        rescue
          # Fallback if icon component fails
          span(class: "w-4 h-4 mr-1 inline-block") { plain ">" }
        end
      end

      def current_path
        # In a real application, this would get the current path
        # For preview/test purposes, we'll return nil
        nil
      end
    end
  end
end
