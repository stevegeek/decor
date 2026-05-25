# @label ModalLayout
#
# A layout component for modals that provides a consistent structure with header, body, and footer sections.
# Supports customizable icons, titles, descriptions, and various styling options.
class ::Decor::Daisy::Modals::ModalLayoutPreview < ::Lookbook::Preview
  # @!group Examples

  # @label Default
  def default
    render ::Decor::Daisy::Modals::ModalLayout.new(
      icon: "info-circle",
      title: "Modal Title",
      description: "This is a modal description",
      classes: "decor:opacity-100"
    ) do
      "Modal content goes here"
    end
  end

  # @label With Slots
  def with_slots
    modal = ::Decor::Daisy::Modals::ModalLayout.new(size: :lg, color: :primary, classes: "decor:opacity-100")
    modal.with_header do
      modal.h2(class: "decor:text-xl decor:font-bold") { "Custom Header" }
    end
    modal.with_body do
      modal.p(class: "decor:py-4") { "This is the modal body content using slots!" }
    end
    modal.with_footer do
      modal.button(class: "decor:d-btn") { "Close" }
      modal.button(class: "decor:d-btn decor:d-btn-primary") { "Save changes" }
    end
    render modal
  end

  # @label Confirmation Dialog
  def confirmation_dialog
    render_with_template
  end

  # @!endgroup

  # @!group Playground

  # @label Playground
  # @param icon text
  # @param title text
  # @param description text
  # @param size [Symbol] select [~, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(
    icon: "info-circle",
    title: "My modal title",
    description: "Wow such modal!",
    size: nil,
    color: nil,
    style: nil
  )
    render ::Decor::Daisy::Modals::ModalLayout.new(
      icon: icon,
      title: title,
      description: description,
      size: size,
      color: color,
      style: style,
      classes: "decor:opacity-100"
    ) do
      "This is where content goes"
    end
  end

  # @!endgroup

  # @!group Sizes

  # @label Size Variants
  def size_variants
    render_with_template(
      locals: {
        modals: %i[sm md lg xl].map do |size|
          {
            modal: ::Decor::Daisy::Modals::ModalLayout.new(
              size: size,
              title: "#{size.to_s.upcase} Modal",
              description: "This modal uses the #{size} size variant",
              classes: "decor:opacity-100"
            ),
            content: "Content for #{size} modal"
          }
        end
      }
    )
  end

  # @!endgroup

  # @!group Colors

  # @label Color Variants
  def color_variants
    render_with_template(
      locals: {
        modals: %i[primary secondary accent info success warning error].map do |color|
          ::Decor::Daisy::Modals::ModalLayout.new(
            color: color,
            title: "#{color.to_s.capitalize} Modal",
            description: "This is a #{color} colored modal",
            classes: "decor:opacity-100"
          )
        end
      }
    )
  end

  # @!endgroup

  # @!group Styles

  # @label Style Variants
  def style_variants
    render_with_template(
      locals: {
        modals: %i[filled outlined ghost].map do |style|
          ::Decor::Daisy::Modals::ModalLayout.new(
            style: style,
            color: :primary,
            title: "#{style.to_s.capitalize} Style",
            description: "This is a #{style} style modal",
            classes: "decor:opacity-100"
          )
        end
      }
    )
  end

  # @!endgroup
end
