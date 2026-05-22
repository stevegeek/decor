# frozen_string_literal: true

module Decor
  module Suite
    module Modals
      class ConfirmTemplate < ::Decor::PhlexComponent
        include ConfirmShared

        stimulus do
          classes accent_info: ConfirmShared::VARIANT_ACCENT_CLASSES[:info],
            accent_success: ConfirmShared::VARIANT_ACCENT_CLASSES[:success],
            accent_warning: ConfirmShared::VARIANT_ACCENT_CLASSES[:warning],
            accent_danger: ConfirmShared::VARIANT_ACCENT_CLASSES[:danger],
            accent_destructive: ConfirmShared::VARIANT_ACCENT_CLASSES[:destructive],
            accent_neutral: ConfirmShared::VARIANT_ACCENT_CLASSES[:neutral],
            icon_color_info: ConfirmShared::VARIANT_ICON_COLOR_CLASSES[:info],
            icon_color_success: ConfirmShared::VARIANT_ICON_COLOR_CLASSES[:success],
            icon_color_warning: ConfirmShared::VARIANT_ICON_COLOR_CLASSES[:warning],
            icon_color_danger: ConfirmShared::VARIANT_ICON_COLOR_CLASSES[:danger],
            icon_color_destructive: ConfirmShared::VARIANT_ICON_COLOR_CLASSES[:destructive],
            destructive_header: ::Decor::Suite::Modals::Modal::DESTRUCTIVE_HEADER_CLASSES,
            destructive_title: ::Decor::Suite::Modals::Modal::DESTRUCTIVE_TITLE_CLASSES
        end

        def view_template
          root_element do
            render_accent_bar
            render_header
            render_body
            render_footer
          end
        end

        private

        def root_element_attributes
          {
            element_tag: :dialog,
            html_options: {
              tabindex: "-1"
            }
          }
        end

        def root_element_classes
          # `decor:open:flex` not `decor:flex` — the template lives inside a
          # `<template>` tag in source, but spawnConfirmDialog clones it and
          # appends to <body> before calling showModal(). If `display: flex`
          # is set unconditionally, the cloned dialog would render visible
          # without `showModal()`. Scoping to the open state mirrors the
          # browser's default `dialog:not([open]) { display: none }`.
          "cf-modal cf-modal--confirm decor:open:flex decor:flex-col decor:relative decor:bg-white decor:rounded-suite-card decor:shadow-2xl decor:p-0 decor:overflow-hidden decor:w-[420px] decor:max-w-[calc(100vw-32px)] decor:max-h-[calc(100vh-32px)] decor:m-auto"
        end

        def render_accent_bar
          child_element(
            :div,
            class: "decor:absolute decor:left-0 decor:top-0 decor:bottom-0 decor:w-[3px]",
            hidden: true,
            stimulus_target: :accent
          )
        end

        def render_header
          child_element(
            :div,
            class: "cf-modal__header decor:flex decor:items-center decor:gap-2.5 decor:px-5 decor:pt-3.5 decor:pb-3 decor:border-b decor:border-suite-hairline",
            stimulus_target: :header
          ) do
            render_icons
            div(class: "decor:flex-1 decor:min-w-0") do
              child_element(
                :h3,
                class: "cf-modal__title decor:suite-section-title decor:leading-[1.4]",
                stimulus_target: :title
              )
            end
            render_close_button
          end
        end

        # Pre-render every variant icon as a hidden sibling. The controller
        # un-hides exactly one based on the requested variant, which keeps the
        # SVG markup server-rendered and removes the need for an icon SVG map
        # on the JS side.
        def render_icons
          ConfirmShared::VARIANT_ICON_NAMES.each do |variant_key, icon_name|
            child_element(
              :span,
              class: "decor:shrink-0",
              hidden: true,
              stimulus_target: :"icon_#{variant_key}"
            ) do
              render ::Decor::Icon.new(name: icon_name, html_options: {class: "decor:w-4 decor:h-4"})
            end
          end
        end

        def render_close_button
          child_element(
            :button,
            type: "button",
            class: "decor:w-[22px] decor:h-[22px] decor:inline-flex decor:items-center decor:justify-center decor:rounded-suite-control decor:text-gray-400 decor:hover:bg-gray-100 decor:hover:text-gray-900 decor:shrink-0",
            aria_label: "Close",
            stimulus_target: :cancel_button
          ) do
            render ::Decor::Icon.new(name: "x-mark", html_options: {class: "decor:w-3.5 decor:h-3.5"})
          end
        end

        def render_body
          div(class: "cf-modal__body decor:px-5 decor:pt-3 decor:pb-4 decor:suite-description decor:text-gray-500 decor:leading-[1.55]") do
            child_element(:p, stimulus_target: :message)
          end
        end

        def render_footer
          div(class: "cf-modal__footer decor:flex decor:justify-end decor:gap-1.5 decor:px-5 decor:py-3 decor:bg-suite-gray-25 decor:border-t decor:border-suite-hairline") do
            child_element(
              :button,
              type: "button",
              class: "decor:inline-flex decor:items-center decor:justify-center decor:rounded-suite-control decor:font-medium decor:transition-all decor:duration-suite-fast decor:suite-description decor:px-3 decor:py-1.5 decor:border decor:border-suite-hairline-strong decor:bg-white decor:text-gray-700 decor:hover:bg-gray-50 decor:hover:text-gray-800",
              stimulus_target: :cancel_button
            )
            child_element(
              :button,
              type: "button",
              class: "decor:inline-flex decor:items-center decor:justify-center decor:rounded-suite-control decor:font-medium decor:transition-all decor:duration-suite-fast decor:suite-description decor:px-3 decor:py-1.5 decor:bg-suite-primary-500 decor:text-white decor:hover:bg-suite-primary-700",
              stimulus_target: :confirm_button
            )
          end
        end
      end
    end
  end
end
