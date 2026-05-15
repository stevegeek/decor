# frozen_string_literal: true

module Decor
  module Suite
    # Suite Notification — toast-style transient message.
    #
    # Two rendering modes share the same DOM structure so a future controller
    # can clone it as a `<template>`:
    #
    # - Populated: pass real props; populated slots render visibly, empty slots
    #   render with `hidden`.
    # - Template: every slot element is always present in the DOM, addressed by
    #   `data-notification-slot=...` so JS can fill + un-hide them.
    #
    # Chrome: left accent stripe in the variant color, a header row with title
    # + dismiss-X, a body row with descriptive text + optional destination link,
    # a footer row with optional action buttons, and an optional progress bar.
    class Notification < ::Decor::Components::Notification
      default_color :neutral

      def view_template
        root_element do
          # Left accent stripe — always present; variant color via Tailwind class.
          div(
            class: "decor:absolute decor:left-0 decor:top-0 decor:bottom-0 decor:w-[3px] decor:shrink-0 #{accent_color_class}",
            data: {"notification-slot": "accent"}
          )

          # Header — hidden when no title
          div(
            class: "decor:flex decor:items-center decor:justify-between decor:gap-2 decor:px-3.5 decor:py-2.5 #{header_separator_class}",
            data: {"notification-slot": "header"},
            hidden: @title.nil? ? "" : nil
          ) do
            span(
              class: "decor:flex-1 decor:suite-section-title decor:leading-[1.35] decor:pl-[3px] decor:text-gray-900",
              data: {"notification-slot": "title"}
            ) { plain @title.to_s }

            button(
              type: "button",
              class: "decor:inline-flex decor:items-center decor:justify-center decor:shrink-0 decor:w-6 decor:h-6 decor:rounded-suite-control decor:p-0 decor:bg-transparent decor:border-0 decor:cursor-pointer decor:text-gray-400 decor:hover:text-gray-900 decor:transition-colors decor:duration-suite-fast decor:ease-out",
              aria_label: "Dismiss",
              data: {"notification-slot": "close"}
            ) do
              render ::Decor::Icon.new(name: "x", html_options: {class: "decor:w-3.5 decor:h-3.5"})
            end
          end

          # Body — hidden when no body AND no destination
          div(
            class: "decor:relative decor:flex decor:items-baseline decor:justify-between decor:gap-2 decor:px-3.5 decor:py-2.5 decor:pl-4",
            data: {"notification-slot": "body"},
            hidden: (body_text.nil? && @destination.nil?) ? "" : nil
          ) do
            span(
              class: "decor:suite-dense-body decor:font-normal decor:text-gray-800 decor:leading-[1.55]",
              data: {"notification-slot": "body-text"}
            ) { plain body_text.to_s }

            a(
              class: "decor:shrink-0 decor:suite-description decor:font-medium decor:text-suite-primary-700 decor:no-underline decor:whitespace-nowrap decor:hover:underline",
              href: @destination&.fetch(:href, "#") || "#",
              data: {"notification-slot": "destination"},
              hidden: @destination.nil? ? "" : nil
            ) { plain @destination ? @destination[:text].to_s : "" }
          end

          # Footer — actions row; hidden when empty
          div(
            class: "decor:flex decor:items-center decor:justify-end decor:gap-1 decor:border-t decor:border-suite-hairline decor:px-3 decor:py-1",
            data: {"notification-slot": "actions"},
            hidden: @actions.empty? ? "" : nil
          ) do
            @actions.each do |action|
              style_key = action[:style]&.to_sym || :ghost
              action_classes = "#{action_base_classes} #{action_variant_classes(style_key)}"

              if action[:href]
                a(href: action[:href], class: action_classes) { plain action[:text].to_s }
              else
                button(
                  type: "button",
                  class: action_classes,
                  data: (action[:event_name] ? {"notification-action-event": action[:event_name].to_s} : {})
                ) { plain action[:text].to_s }
              end
            end

            # Hidden <template> the controller clones per dynamically-added action
            template(data: {"notification-slot": "action-template"}) do
              button(type: "button", class: action_base_classes) { plain "" }
            end
          end

          # Progress bar — hidden when sticky or show_progress is false
          div(
            class: "decor:absolute decor:bottom-0 decor:left-0 decor:right-0 decor:h-0.5 decor:origin-left #{accent_color_class}",
            data: {"notification-slot": "progress"},
            hidden: (@sticky || !@show_progress) ? "" : nil
          )
        end
      end

      private

      def root_element_classes
        "decor:relative decor:flex decor:flex-col decor:w-[360px] decor:bg-white decor:border decor:border-suite-hairline-strong decor:rounded-suite-control decor:shadow-lg decor:overflow-hidden decor:pointer-events-auto"
      end

      # `body` is the Suite-shape prop; the abstract base also exposes
      # `description` (Daisy heritage) — accept either.
      def body_text
        @body || @description
      end

      def accent_color_class
        case resolved_color
        when :success then "decor:bg-suite-success-500"
        when :error then "decor:bg-suite-danger-500"
        when :warning then "decor:bg-suite-warning-500"
        when :info, :primary then "decor:bg-suite-primary-500"
        else "decor:bg-gray-400"
        end
      end

      # Suite aliases :info → :primary intentionally; expose the resolved key.
      def resolved_color
        case @color
        when :info, :primary then :primary
        when :success, :error, :warning then @color
        else :neutral
        end
      end

      def header_separator_class
        return "" if @title.nil?
        return "" if body_text.nil? && @destination.nil? && @actions.empty?
        "decor:border-b decor:border-suite-hairline"
      end

      def action_base_classes
        "decor:inline-flex decor:items-center decor:justify-center decor:text-xs decor:font-medium decor:leading-none decor:px-2 decor:py-1 decor:rounded-suite-control decor:border-0 decor:bg-transparent decor:cursor-pointer decor:no-underline decor:transition-colors decor:duration-suite-fast decor:ease-out"
      end

      def action_variant_classes(style_key)
        case style_key
        when :primary then "decor:text-suite-primary-700 decor:hover:bg-suite-primary-50"
        else "decor:text-gray-600 decor:hover:bg-gray-100"
        end
      end
    end
  end
end
