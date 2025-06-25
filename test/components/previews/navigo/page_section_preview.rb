# @label PageSection
class ::Navigo::PageSectionPreview < ::Lookbook::Preview
  # @param title text
  # @param description text
  # @param show_hero_slot toggle
  # @param show_separator toggle
  # @param show_example_tag toggle
  # @param show_example_cta toggle
  # @param size select { choices: [xs, sm, md, lg, xl] }
  # @param background select { choices: [default, primary, secondary, neutral] }
  # @param padding select { choices: [none, sm, md, lg, xl] }
  def playground(
    title: "Page title",
    description: "Page description",
    show_hero_slot: false,
    show_separator: true,
    show_example_tag: false,
    show_example_cta: false,
    size: :md,
    background: :default,
    padding: :md
  )
    render_with_template(
      locals: {
        show_hero_slot: show_hero_slot,
        title: title,
        description: description,
        show_separator: show_separator,
        show_example_tag: show_example_tag,
        show_cta: show_example_cta,
        size: size,
        background: background,
        padding: padding
      }
    )
  end

  # @!group Sizes

  def extra_small
    render ::Navigo::PageSection.new(
      title: "Extra Small Section",
      description: "This is an extra small section with compact spacing and smaller text.",
      separator: true,
      size: :xs
    ) do |page|
      page.div { "Content with reduced spacing between elements" }
      page.div { "Another content block" }
    end
  end

  def small
    render ::Navigo::PageSection.new(
      title: "Small Section",
      description: "This is a small section with slightly reduced spacing.",
      separator: true,
      size: :sm
    ) do |page|
      page.div { "Content with small spacing" }
      page.div { "Another content block" }
    end
  end

  def medium
    render ::Navigo::PageSection.new(
      title: "Medium Section (Default)",
      description: "This is a medium section with standard spacing.",
      separator: true,
      size: :md
    ) do |page|
      page.div { "Content with normal spacing" }
      page.div { "Another content block" }
    end
  end

  def large
    render ::Navigo::PageSection.new(
      title: "Large Section",
      description: "This is a large section with increased spacing and larger text.",
      separator: true,
      size: :lg
    ) do |page|
      page.div { "Content with increased spacing" }
      page.div { "Another content block" }
    end
  end

  def extra_large
    render ::Navigo::PageSection.new(
      title: "Extra Large Section",
      description: "This is an extra large section with maximum spacing and largest text.",
      separator: true,
      size: :xl
    ) do |page|
      page.div { "Content with maximum spacing" }
      page.div { "Another content block" }
    end
  end

  # @!endgroup

  # @!group Backgrounds

  def with_primary_background
    render ::Navigo::PageSection.new(
      title: "Primary Background Section",
      description: "This section has a subtle primary color background.",
      background: :primary,
      separator: true
    ) do |page|
      page.div { "Content with primary background tint" }
    end
  end

  def with_secondary_background
    render ::Navigo::PageSection.new(
      title: "Secondary Background Section",
      description: "This section has a subtle secondary color background.",
      background: :secondary,
      separator: true
    ) do |page|
      page.div { "Content with secondary background tint" }
    end
  end

  def with_neutral_background
    render ::Navigo::PageSection.new(
      title: "Neutral Background Section",
      description: "This section has a subtle neutral color background.",
      background: :neutral,
      separator: true
    ) do |page|
      page.div { "Content with neutral background tint" }
    end
  end

  # @!endgroup

  # @!group Padding Variations

  def no_padding
    render ::Navigo::PageSection.new(
      title: "No Padding Section",
      description: "This section has no bottom padding.",
      padding: :none,
      separator: true
    ) do |page|
      page.div { "Content immediately follows the header" }
    end
  end

  def small_padding
    render ::Navigo::PageSection.new(
      title: "Small Padding Section",
      description: "This section has small bottom padding.",
      padding: :sm,
      separator: true
    ) do |page|
      page.div { "Content with small padding" }
    end
  end

  def large_padding
    render ::Navigo::PageSection.new(
      title: "Large Padding Section",
      description: "This section has large bottom padding.",
      padding: :lg,
      separator: true
    ) do |page|
      page.div { "Content with large padding" }
    end
  end

  # @!endgroup

  # @!group Complex Examples

  def with_all_features
    render ::Navigo::PageSection.new(
      title: "Feature-Rich Section",
      description: "This section demonstrates all available features.",
      separator: true,
      size: :lg,
      background: :primary,
      padding: :lg
    ) do |page|
      page.with_hero do
        page.div(class: "hero bg-base-200 rounded-lg p-8") do
          page.h2(class: "text-2xl font-bold") { "Hero Content" }
          page.p { "This is a hero slot content area" }
        end
      end

      page.with_tag(label: "Status", color: :success, size: :sm)
      page.with_tag(label: "Important", color: :warning, size: :sm)

      page.with_cta do
        render ::Decor::Button.new(label: "Take Action", color: :primary)
      end

      page.div(class: "grid grid-cols-1 md:grid-cols-2 gap-4") do
        page.div(class: "card bg-base-100 shadow-md p-4") do
          page.h4(class: "font-semibold") { "Card 1" }
          page.p { "Some content in the first card" }
        end
        page.div(class: "card bg-base-100 shadow-md p-4") do
          page.h4(class: "font-semibold") { "Card 2" }
          page.p { "Some content in the second card" }
        end
      end
    end
  end

  # @!endgroup
end
