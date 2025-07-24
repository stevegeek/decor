# @label ModalLayout
#
# A layout component for modals that provides a consistent structure with header, body, and footer sections.
# Supports customizable icons, titles, descriptions, and various styling options.
class ::Decor::Modals::ModalLayoutPreview < ::Lookbook::Preview
  # @!group Examples

  # @label Default
  def default
    render ::Decor::Modals::ModalLayout.new(
      icon: "information-circle",
      title: "Modal Title",
      description: "This is a modal description",
      classes: "opacity-100"
    ) do
      "Modal content goes here"
    end
  end

  # @label With Slots
  def with_slots
    modal = ::Decor::Modals::ModalLayout.new(size: :lg, color: :primary, classes: "opacity-100")
    modal.with_header do
      modal.h2(class: "text-xl font-bold") { "Custom Header" }
    end
    modal.with_body do
      modal.p(class: "py-4") { "This is the modal body content using slots!" }
    end
    modal.with_footer do
      modal.button(class: "btn") { "Close" }
      modal.button(class: "btn btn-primary") { "Save changes" }
    end
    render modal
  end

  # @label Confirmation Dialog
  def confirmation_dialog
    render ::Decor::Modals::ModalLayout.new(
      icon: "exclamation-triangle",
      color: :warning,
      title: "Are you sure?",
      description: "This action cannot be undone.",
      classes: "opacity-100"
    ) do
      render ::Decor::Element.new(html_options: {class: "flex gap-4 justify-end"}) do
        render ::Decor::Button.new(label: "Cancel", style: :ghost)
        render ::Decor::Button.new(label: "Continue", color: :warning)
      end
    end
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
    icon: "information-circle",
    title: "My modal title",
    description: "Wow such modal!",
    size: nil,
    color: nil,
    style: nil
  )
    render ::Decor::Modals::ModalLayout.new(
      icon: icon,
      title: title,
      description: description,
      size: size,
      color: color,
      style: style,
      classes: "opacity-100"
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
            modal: ::Decor::Modals::ModalLayout.new(
              size: size,
              title: "#{size.to_s.upcase} Modal",
              description: "This modal uses the #{size} size variant",
              classes: "opacity-100"
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
          ::Decor::Modals::ModalLayout.new(
            color: color,
            title: "#{color.to_s.capitalize} Modal",
            description: "This is a #{color} colored modal",
            classes: "opacity-100"
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
          ::Decor::Modals::ModalLayout.new(
            style: style,
            color: :primary,
            title: "#{style.to_s.capitalize} Style",
            description: "This is a #{style} style modal",
            classes: "opacity-100"
          )
        end
      }
    )
  end

  # @!endgroup
end
