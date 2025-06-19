# frozen_string_literal: true

module Navigo
  class PageHeader < PhlexComponent
    no_stimulus_controller

    # Content attributes
    attribute :title, String
    attribute :subtitle, String
    attribute :description, String

    # Layout configuration
    attribute :layout, Symbol, default: :default, in: [:default, :centered, :minimal, :hero, :compact]
    attribute :size, Symbol, default: :md, in: [:xs, :sm, :md, :lg, :xl]  # Added :xs for consistency
    attribute :background, Symbol, default: :default, in: [:default, :hero, :gradient, :transparent]

    # Visual options
    attribute :border, :boolean, default: true
    attribute :padding, Symbol, default: :md, in: [:none, :sm, :md, :lg, :xl]  # Added :xl for consistency

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

    def view_template
      render parent_element do
        render_breadcrumbs if @breadcrumbs_content
        render_layout
      end
    end

    private

    def element_classes
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
        instance_exec(&@breadcrumbs_content) if @breadcrumbs_content
      end
    end

    def render_layout
      case @layout
      when :centered then render_centered_layout
      when :minimal then render_minimal_layout
      when :hero then render_hero_layout
      when :compact then render_compact_layout
      else render_default_layout
      end
    end

    def render_default_layout
      div(class: "flex flex-col lg:flex-row lg:items-center lg:justify-between gap-6") do
        div(class: "flex flex-col sm:flex-row items-start sm:items-center gap-4 min-w-0 flex-1") do
          render_avatar_section if @avatar_content
          render_content_section
        end
        render_actions_section if @actions_content || @secondary_actions_content
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
        instance_exec(&@avatar_content) if @avatar_content
      end
    end

    def render_content_section(centered: false, large: false, compact: false)
      classes = ["min-w-0"]
      classes << (centered ? "text-center" : "")

      div(class: classes.compact.join(" ")) do
        render_title_section(centered: centered, large: large, compact: compact)
        render_subtitle_section(centered: centered, compact: compact) if @subtitle.present?
        render_description_section(centered: centered, compact: compact) if @description.present?
        render_meta_section(centered: centered, compact: compact) if @meta_content
      end
    end

    def render_title_section(centered: false, large: false, compact: false)
      return render_title_only(compact: compact) unless @title_content

      if @title_content
        instance_exec(&@title_content)
      end
    end

    def render_title_only(compact: false)
      return unless @title.present?

      size_classes = if compact
        "text-lg font-semibold"
      else
        case @size
        when :xs then "text-lg font-bold"
        when :sm then "text-xl font-bold"
        when :md then "text-2xl font-bold"
        when :lg then "text-3xl font-bold"
        when :xl then "text-4xl font-bold"
        else "text-2xl font-bold"
        end
      end

      h1(class: "#{size_classes} text-base-content truncate") do
        plain @title
      end
    end

    def render_subtitle_section(centered: false, compact: false)
      return if compact && @subtitle.blank?

      classes = ["text-sm text-base-content/70 mt-1"]
      classes << (centered ? "text-center" : "")

      div(class: classes.compact.join(" ")) do
        plain @subtitle if @subtitle.present?
      end
    end

    def render_description_section(centered: false, compact: false)
      return if compact || @description.blank?

      classes = ["text-base text-base-content/80 mt-2"]
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
        instance_exec(&@meta_content) if @meta_content
      end
    end

    def render_actions_section(centered: false, large: false, compact: false)
      return unless @actions_content || @secondary_actions_content

      if centered
        div(class: "mt-6 flex flex-col sm:flex-row gap-3 justify-center") do
          render_action_buttons(large: large)
        end
      elsif compact
        div(class: "flex items-center gap-2") do
          render_action_buttons(compact: true)
        end
      else
        div(class: "flex flex-col sm:flex-row gap-3") do
          render_action_buttons
        end
      end
    end

    def render_action_buttons(large: false, compact: false)
      if @actions_content
        div(class: "flex gap-2") do
          instance_exec(&@actions_content)
        end
      end

      if @secondary_actions_content
        div(class: "flex gap-2") do
          instance_exec(&@secondary_actions_content)
        end
      end
    end

    def render_status_section(centered: false)
      return unless @status_content

      classes = ["mt-4"]
      classes << (centered ? "flex justify-center" : "")

      div(class: classes.compact.join(" ")) do
        instance_exec(&@status_content) if @status_content
      end
    end
  end
end
