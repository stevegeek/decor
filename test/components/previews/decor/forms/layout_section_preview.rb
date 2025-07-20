# @label LayoutSection
class ::Decor::Forms::LayoutSectionPreview < ::Lookbook::Preview
  # LayoutSection
  # -------
  #
  # A form section is a group of fields that are displayed in a form.
  # Form sections can have a title, description, CTA, an optional hero section and the Flash component.
  #
  # @param title text
  # @param description text
  # @param stacked_layout toggle
  # @param include_flash toggle
  # @param include_hero toggle
  # @param include_cta toggle
  def playground(title: "Your details", description: "Please enter details.", stacked_layout: false, include_flash: true, include_hero: false, include_cta: false)
    render ::Decor::Forms::LayoutSection.new(
      title: title,
      description: description,
      stacked: stacked_layout,
      flash: include_flash
    ) do |section|
      if include_hero
        section.with_hero do
          "<h1 class=\"text-3xl\">Hero!</h1>".html_safe
        end
      end
      if include_cta
        section.with_cta do
          section.render ::Decor::Button.new(label: "CTA!")
        end
      end

      if stacked_layout
        "<div>Stacked section content...</div><div>More content...</div>".html_safe
      else
        "<div class=\"sm:col-span-4\">Form section content...</div><div class=\"sm:col-span-2\">More content...</div>".html_safe
      end
    end
  end
end
