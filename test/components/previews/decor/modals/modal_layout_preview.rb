# @label ModalLayout
class ::Decor::Modals::ModalLayoutPreview < ::Lookbook::Preview
  # ModalLayout
  # -------
  #
  # A layout to use for modals. Includes a sort of header with icon.
  #
  # @label Playground
  # @param style select [info, warning, error, success, edit, new]
  # @param title text
  # @param description text
  # @param color select [base, primary, secondary, accent, info, success, warning, error, neutral]
  # @param variant select [filled, outlined, ghost]
  # @param size select [small, medium, large, extra_large]
  def playground(
    style: :info,
    title: "My modal title",
    description: "Wow such modal!",
    color: :base,
    variant: :filled,
    size: :medium
  )
    render ::Decor::Modals::ModalLayout.new(
      style: style,
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
      style: :warning,
      title: "Are you sure?",
      description: "This action cannot be undone."
    ) do
      div(class: "flex gap-4 justify-end") do
        button(class: "btn btn-ghost") { "Cancel" }
        button(class: "btn btn-warning") { "Continue" }
      end
    end
  end

  # @label Color Variants
  def color_variants
    div(class: "space-y-4") do
      %i[primary secondary accent info success warning error].each do |color|
        render ::Decor::Modals::ModalLayout.new(
          color: color,
          title: "#{color.to_s.capitalize} Modal",
          description: "This is a #{color} colored modal"
        )
      end
    end
  end

  # @label Size Variants
  def size_variants
    div(class: "space-y-4") do
      %i[small medium large extra_large].each do |size|
        render ::Decor::Modals::ModalLayout.new(
          size: size,
          title: "#{size.to_s.humanize} Modal",
          description: "This modal uses the #{size} size variant"
        ) do
          "Content for #{size} modal"
        end
      end
    end
  end

  # @label Variant Styles
  def variant_styles
    div(class: "space-y-4") do
      %i[filled outlined ghost].each do |variant|
        render ::Decor::Modals::ModalLayout.new(
          variant: variant,
          color: :primary,
          title: "#{variant.to_s.capitalize} Variant",
          description: "This is a #{variant} style modal"
        )
      end
    end
  end
end
