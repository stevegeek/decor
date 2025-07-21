# frozen_string_literal: true

module Decor
  class PageHeader < PhlexComponent
    no_stimulus_controller

    # Content attributes
    prop :title, _Nilable(String)
    prop :subtitle, _Nilable(String)
    prop :description, _Nilable(String)

    # Layout configuration
    prop :layout, _Union(:default, :centered, :minimal, :hero, :compact, :page_like), default: :default
    prop :background, _Union(:default, :hero, :gradient, :transparent), default: :default
    
    default_size :md

    # Visual options
    prop :border, _Boolean, default: true
    prop :padding, _Union(:none, :sm, :md, :lg, :xl), default: :md
    prop :cta_snap_large, _Boolean, default: false

    def with_avatar(&block)
      @avatar_content = block
    end

    def with_title_content(&block)
      @title_content = block
    end

    def with_meta_content(&block)
      @meta_content = block
    end

    def with_actions(&block)
      @actions_content = block
    end

    def with_secondary_actions(&block)
      @secondary_actions_content = block
    end

    def with_breadcrumbs(&block)
      @breadcrumbs_content = block
    end

    def with_status(&block)
      @status_content = block
    end

    def with_cta(&block)
      @cta_content = block
    end

    # Manual many relationship implementations
    def with_badge(**attributes, &block)
      @badges ||= []
      badge = ::Decor::Badge.new(**attributes)
      @badges << badge
      badge
    end

    def with_tag(**attributes, &block)
      @tags ||= []
      tag = ::Decor::Tag.new(**attributes)
      @tags << tag
      tag
    end

    def view_template(&)
      vanish(&)
      root_element do
        render_breadcrumbs if @breadcrumbs_content
        render_layout
      end
    end

    private

    def root_element_attributes
      {element_tag: :header}
    end

    def root_element_classes
      classes = ["page-header"]
      classes << background_classes
      classes << padding_classes
      classes << border_classes
      classes.compact.join(" ")
    end

    def background_classes
      case @background
      when :hero then "bg-base-200"
      when :gradient then "bg-gradient-to-r from-primary to-secondary text-primary-content"
      when :transparent then ""
      else "bg-base-100"
      end
    end

    def padding_classes
      case @padding
      when :none then ""
      when :sm then "p-4"
      when :md then "p-6 lg:p-8"
      when :lg then "p-8 lg:p-12"
      when :xl then "p-12 lg:p-16"
      else "p-6 lg:p-8"
      end
    end

    def border_classes
      @border ? "border-b border-base-300" : ""
    end

    def render_breadcrumbs
      div(class: "mb-4") do
        render @breadcrumbs_content if @breadcrumbs_content
      end
    end

    def render_layout
      case @layout
      when :centered then render_centered_layout
      when :minimal then render_minimal_layout
      when :hero then render_hero_layout
      when :compact then render_compact_layout
      when :page_like then render_page_like_layout
      else render_default_layout
      end
    end

    def render_default_layout
      div(class: "flex flex-col lg:flex-row lg:items-center lg:justify-between gap-6") do
        div(class: "flex flex-col sm:flex-row items-start sm:items-center gap-4 min-w-0 flex-1") do
          render_avatar_section if @avatar_content
          render_content_section
        end
        render_actions_section if @actions_content || @secondary_actions_content || @cta_content
      end
    end

    def render_page_like_layout
      classes = ["bg-base-100"]
      classes << (@cta_snap_large ? "xl:flex" : "md:flex")
      classes << (@cta_snap_large ? "xl:items-center" : "md:items-center")
      classes << (@cta_snap_large ? "xl:justify-between" : "md:justify-between")

      div(class: classes.join(" ")) do
        div(class: "space-y-2.5 #{@cta_snap_large ? "xl:pr-6" : "md:pr-6"} pb-4 sm:pb-0 border-b sm:border-b-0 border-base-300") do
          render_avatar_section if @avatar_content
          render_content_section
        end
        render_actions_section if @actions_content || @secondary_actions_content || @cta_content
      end
    end

    def render_centered_layout
      div(class: "text-center max-w-4xl mx-auto") do
        render_avatar_section(centered: true) if @avatar_content
        render_content_section(centered: true)
        render_actions_section(centered: true) if @actions_content || @secondary_actions_content
        render_status_section(centered: true) if @status_content
      end
    end

    def render_minimal_layout
      div(class: "flex items-center justify-between") do
        div(class: "min-w-0 flex-1") do
          render_title_only
        end
        render_actions_section if @actions_content
      end
    end

    def render_hero_layout
      div(class: "hero") do
        div(class: "hero-content text-center") do
          div(class: "max-w-5xl") do
            render_avatar_section(centered: true, large: true) if @avatar_content
            render_content_section(centered: true, large: true)
            render_actions_section(centered: true, large: true) if @actions_content || @secondary_actions_content
            render_status_section(centered: true) if @status_content
          end
        end
      end
    end

    def render_compact_layout
      div(class: "flex items-center justify-between py-2") do
        div(class: "flex items-center gap-3 min-w-0 flex-1") do
          render_avatar_section(compact: true) if @avatar_content
          render_content_section(compact: true)
        end
        render_actions_section(compact: true) if @actions_content
      end
    end

    def render_avatar_section(centered: false, large: false, compact: false)
      classes = ["flex-shrink-0"]
      classes << (centered ? "mb-4" : "")

      div(class: classes.compact.join(" ")) do
        render @avatar_content if @avatar_content
      end
    end

    def render_content_section(centered: false, large: false, compact: false)
      classes = ["min-w-0"]
      classes << (centered ? "text-center" : "")

      div(class: classes.compact.join(" ")) do
        if @layout == :page_like
          # Page-like layout: Title and badges together
          div(class: "sm:flex items-center sm:space-x-3") do
            render_title_section(centered: centered, large: large, compact: compact)
            render_badges_section
          end

          render_subtitle_section(centered: centered, compact: compact) if @subtitle.present?

          # Description and tags together
          div(class: "sm:flex items-center sm:space-x-3") do
            render_description_section(centered: centered, compact: compact) if @description.present?
            render_tags_section
          end
        else
          # Default layout: simpler structure
          render_title_section(centered: centered, large: large, compact: compact)
          render_subtitle_section(centered: centered, compact: compact) if @subtitle.present?
          render_description_section(centered: centered, compact: compact) if @description.present?
        end

        render_meta_section(centered: centered, compact: compact) if @meta_content
      end
    end

    def render_title_section(centered: false, large: false, compact: false)
      return render_title_only(compact: compact) unless @title_content

      if @title_content
        render @title_content
      end
    end

    def render_title_only(compact: false)
      return unless @title.present?

      size_classes = if compact
        "text-lg font-semibold"
      elsif @layout == :page_like
        # Page-like layout uses different size mapping
        case @size
        when :xs then "text-sm"
        when :sm then "text-base"
        when :md then "text-lg"
        when :lg then "text-xl"
        when :xl then "text-2xl"
        else "text-lg"
        end
      else
        # Original PageHeader size mapping
        case @size
        when :xs then "text-lg font-bold"
        when :sm then "text-xl font-bold"
        when :md then "text-2xl font-bold"
        when :lg then "text-3xl font-bold"
        when :xl then "text-4xl font-bold"
        else "text-2xl font-bold"
        end
      end

      tag_name = (@layout == :page_like) ? :h3 : :h1
      font_weight = (@layout == :page_like) ? "font-medium" : ""

      public_send(tag_name, class: "#{size_classes} text-base-content #{font_weight} truncate".strip) do
        plain @title
      end
    end

    def render_subtitle_section(centered: false, compact: false)
      return if compact && @subtitle.blank?

      size_classes = case @size
      when :xs then "text-xs"
      when :sm then "text-xs"
      when :md then "text-xs"
      when :lg then "text-sm"
      when :xl then "text-base"
      else "text-xs"
      end

      classes = ["py-2 sm:py-0 text-base-content/70 #{size_classes}"]
      classes << (centered ? "text-center" : "")

      h4(class: classes.compact.join(" ")) do
        plain @subtitle if @subtitle.present?
      end
    end

    def render_description_section(centered: false, compact: false)
      return if compact || @description.blank?

      size_classes = case @size
      when :xs then "text-xs"
      when :sm then "text-sm"
      when :md then "text-sm"
      when :lg then "text-base"
      when :xl then "text-lg"
      else "text-sm"
      end

      classes = ["text-base-content/70 #{size_classes}"]
      classes << (centered ? "text-center" : "")

      p(class: classes.compact.join(" ")) do
        plain @description
      end
    end

    def render_meta_section(centered: false, compact: false)
      return unless @meta_content

      classes = ["mt-3"]
      classes << (centered ? "flex justify-center" : "")

      div(class: classes.compact.join(" ")) do
        render @meta_content if @meta_content
      end
    end

    def render_actions_section(centered: false, large: false, compact: false)
      return unless @actions_content || @secondary_actions_content || @cta_content

      classes = ["mt-4"]
      classes << (@cta_snap_large ? "xl:mt-0" : "md:mt-0")

      if centered
        div(class: "mt-6 flex flex-col sm:flex-row gap-3 justify-center") do
          render_action_buttons(large: large)
        end
      elsif compact
        div(class: "flex items-center gap-2") do
          render_action_buttons(compact: true)
        end
      else
        div(class: classes.join(" ")) do
          render_action_buttons
        end
      end
    end

    def render_action_buttons(large: false, compact: false)
      if @actions_content
        div(class: "flex gap-2") do
          render @actions_content
        end
      end

      if @secondary_actions_content
        div(class: "flex gap-2") do
          render @secondary_actions_content
        end
      end

      if @cta_content
        render @cta_content
      end
    end

    def render_status_section(centered: false)
      return unless @status_content

      classes = ["mt-4"]
      classes << (centered ? "flex justify-center" : "")

      div(class: classes.compact.join(" ")) do
        render @status_content if @status_content
      end
    end

    def render_badges_section
      return unless @badges&.any?

      @badges.each do |badge|
        render badge
      end
    end

    def render_tags_section
      return unless @tags&.any?

      @tags.each do |tag|
        render tag
      end
    end
  end
end
