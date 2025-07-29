# @label Flash Banner
class ::Decor::FlashPreview < ::Lookbook::Preview
  # 'Flash' or Alert banner
  # -------
  # A flash banner is displayed inline with other content. It's intention is to display prominent information
  # related to the content of the page.
  # A common use case for a flash banner is showing messages relating to form submissions (e.g. validation messages).
  #
  # @group Examples
  # @label Custom Content
  def example_custom_content
    render ::Decor::Flash.new(
      title: "Custom Flash",
      text: "This flash demonstrates custom content with additional elements.",
      color: :info,
      collapse_if_empty: false
    )
  end

  # @group Examples
  # @label Form Validation Error
  def example_form_validation
    render ::Decor::Flash.new(
      title: "Validation Error",
      text: "Please correct the errors below and try again.",
      color: :error,
      collapse_if_empty: false
    )
  end

  # @group Examples
  # @label Simple Notice
  def example_simple_notice
    render ::Decor::Flash.new(
      title: "Notice",
      text: "This is a simple notice message.",
      style: :notice,
      collapse_if_empty: false
    )
  end

  # @group Examples
  # Flash with custom content block
  # @label Custom Content
  def custom_content
    render ::Decor::Flash.new do |component|
      component.div(class: "alert alert-info") do
        component.div(class: "flex") do
          component.div(class: "flex-shrink-0") do
            component.render ::Decor::Icon.new(name: "information-circle", html_options: {class: "h-5 w-5"})
          end
          component.div(class: "ml-3") do
            component.h3(class: "text-md font-medium") { "Custom Flash Content" }
            component.div(class: "mt-2 text-md") do
              component.p { "This flash message uses a custom content block with additional elements." }
              component.div(class: "mt-3 flex gap-2") do
                component.render ::Decor::Button.new(label: "Action", color: :primary, size: :sm)
                component.render ::Decor::Button.new(label: "Cancel", style: :outlined, size: :sm)
              end
            end
          end
        end
      end
    end
  end

  # @group Playground
  # @param title text
  # @param text text
  # @param preserve_flash toggle
  # @param collapse_if_empty toggle
  # @param style [Symbol] select [~, warning, info, error, notice, success]
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  def playground(
    title: "Flash",
    text: "This is a flash banner",
    preserve_flash: false,
    collapse_if_empty: false,
    style: nil,
    size: nil,
    color: nil
  )
    render ::Decor::Flash.new(
      title: title,
      text: text,
      preserve_flash: preserve_flash,
      collapse_if_empty: collapse_if_empty,
      style: style,
      size: size,
      color: color
    )
  end

  # @group Variants
  # @label Success Variant
  def variant_success
    render ::Decor::Flash.new(
      title: "Success Message",
      text: "This is a success flash message example with daisyUI alert styling.",
      color: :success,
      collapse_if_empty: false
    )
  end

  # @group Variants
  # @label Error Variant
  def variant_error
    render ::Decor::Flash.new(
      title: "Error Message",
      text: "This is an error flash message example with daisyUI alert styling.",
      color: :error,
      collapse_if_empty: false
    )
  end

  # @group Variants
  # @label Warning Variant
  def variant_warning
    render ::Decor::Flash.new(
      title: "Warning Message",
      text: "This is a warning flash message example with daisyUI alert styling.",
      color: :warning,
      collapse_if_empty: false
    )
  end

  # @group Variants
  # @label Info Variant
  def variant_info
    render ::Decor::Flash.new(
      title: "Info Message",
      text: "This is an info flash message example with daisyUI alert styling.",
      color: :info,
      collapse_if_empty: false
    )
  end

  # @group Variants
  # @label Notice Variant
  def variant_notice
    render ::Decor::Flash.new(
      title: "Notice Message",
      text: "This is a notice flash message example with daisyUI alert styling.",
      style: :notice,
      collapse_if_empty: false
    )
  end

  # @group Default Titles
  # @label Success Default Title
  def default_title_success
    render ::Decor::Flash.new(
      text: "This flash uses the default title for success variant.",
      color: :success,
      collapse_if_empty: false
    )
  end

  # @group Default Titles
  # @label Error Default Title
  def default_title_error
    render ::Decor::Flash.new(
      text: "This flash uses the default title for error variant.",
      color: :error,
      collapse_if_empty: false
    )
  end

  # @group Default Titles
  # @label Warning Default Title
  def default_title_warning
    render ::Decor::Flash.new(
      text: "This flash uses the default title for warning variant.",
      color: :warning,
      collapse_if_empty: false
    )
  end

  # @group Default Titles
  # @label Info Default Title
  def default_title_info
    render ::Decor::Flash.new(
      text: "This flash uses the default title for info variant.",
      color: :info,
      collapse_if_empty: false
    )
  end

  # @group Default Titles
  # @label Notice Default Title
  def default_title_notice
    render ::Decor::Flash.new(
      text: "This flash uses the default title for notice variant.",
      style: :notice,
      collapse_if_empty: false
    )
  end
end
