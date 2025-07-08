# @label ModalLayout
class ::Decor::Modals::ModalLayoutPreview < ::Lookbook::Preview
  # ModalLayout
  # -------
  #
  # A layout to use for modals. Includes a sort of header with icon.
  #
  # @label Playground
  # @param icon text
  # @param title text
  # @param description text
  # @param color select [base, primary, secondary, accent, info, success, warning, error, neutral]
  # @param variant select [filled, outlined, ghost]
  # @param size select [small, medium, large, extra_large]
  def playground(
    icon: "information-circle",
    title: "My modal title",
    description: "Wow such modal!",
    color: :base,
    variant: :filled,
    size: :medium
  )
    render ::Decor::Modals::ModalLayout.new(
      icon: icon,
      title: title,
      description: description,
      color: color,
      variant: variant,
      size: size
    ) do
      "This is where content goes"
    end
  end

  # @label With Slots
  def with_slots
    modal = ::Decor::Modals::ModalLayout.new(size: :large, color: :primary)
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

  # @label Legacy Style
  def legacy_style
    render ::Decor::Modals::ModalLayout.new(
      icon: "exclamation-triangle",
      color: :warning,
      title: "Are you sure?",
      description: "This action cannot be undone."
    ) do
      render ::Decor::Element.new(html_options: {class: "flex gap-4 justify-end"}) do
        render ::Decor::Button.new(label: "Cancel", variant: :ghost)
        render ::Decor::Button.new(label: "Continue", color: :warning)
      end
    end
  end

  # @label Color Variants
  def color_variants
    render_with_template(
      locals: {
        modals: %i[primary secondary accent info success warning error].map do |color|
          ::Decor::Modals::ModalLayout.new(
            color: color,
            title: "#{color.to_s.capitalize} Modal",
            description: "This is a #{color} colored modal"
          )
        end
      }
    )
  end

  # @label Size Variants
  def size_variants
    render_with_template(
      locals: {
        modals: %i[small medium large extra_large].map do |size|
          {
            modal: ::Decor::Modals::ModalLayout.new(
              size: size,
              title: "#{size.to_s.humanize} Modal",
              description: "This modal uses the #{size} size variant"
            ),
            content: "Content for #{size} modal"
          }
        end
      }
    )
  end

  # @label Variant Styles
  def variant_styles
    render_with_template(
      locals: {
        modals: %i[filled outlined ghost].map do |variant|
          ::Decor::Modals::ModalLayout.new(
            variant: variant,
            color: :primary,
            title: "#{variant.to_s.capitalize} Variant",
            description: "This is a #{variant} style modal"
          )
        end
      }
    )
  end
end
