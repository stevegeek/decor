# frozen_string_literal: true

module Decor
  module Daisy
    class PageHeader < ::Decor::Components::PageHeader
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
        classes = ["decor:page-header"]
        classes << background_classes
        classes << padding_classes
        classes << border_classes
        classes.compact.join(" ")
      end

      def background_classes
        case @background
        when :hero then "decor:bg-base-200"
        when :gradient then "decor:bg-gradient-to-r decor:from-primary decor:to-secondary decor:text-primary-content"
        when :transparent then ""
        else "decor:bg-base-100"
        end
      end

      def padding_classes
        case @padding
        when :none then ""
        when :sm then "decor:p-4"
        when :md then "decor:p-6 decor:lg:p-8"
        when :lg then "decor:p-8 decor:lg:p-12"
        when :xl then "decor:p-12 decor:lg:p-16"
        else "decor:p-6 decor:lg:p-8"
        end
      end

      def border_classes
        @border ? "decor:border-b decor:border-base-300" : ""
      end

      def render_breadcrumbs
        div(class: "decor:mb-4") do
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
        div(class: "decor:flex decor:flex-col decor:lg:flex-row decor:lg:items-center decor:lg:justify-between decor:gap-6") do
          div(class: "decor:flex decor:flex-col decor:sm:flex-row decor:items-start decor:sm:items-center decor:gap-4 decor:min-w-0 decor:flex-1") do
            render_avatar_section if @avatar_content
            render_content_section
          end
          render_actions_section if @actions_content || @secondary_actions_content || @cta_content
        end
      end

      def render_page_like_layout
        classes = ["decor:bg-base-100"]
        classes << (@cta_snap_large ? "decor:xl:flex" : "decor:md:flex")
        classes << (@cta_snap_large ? "decor:xl:items-center" : "decor:md:items-center")
        classes << (@cta_snap_large ? "decor:xl:justify-between" : "decor:md:justify-between")

        div(class: classes.join(" ")) do
          div(class: "decor:space-y-2.5 #{@cta_snap_large ? "decor:xl:pr-6" : "decor:md:pr-6"} decor:pb-4 decor:sm:pb-0 decor:border-b decor:sm:border-b-0 decor:border-base-300") do
            render_avatar_section if @avatar_content
            render_content_section
          end
          render_actions_section if @actions_content || @secondary_actions_content || @cta_content
        end
      end

      def render_centered_layout
        div(class: "decor:text-center decor:max-w-4xl decor:mx-auto") do
          render_avatar_section(centered: true) if @avatar_content
          render_content_section(centered: true)
          render_actions_section(centered: true) if @actions_content || @secondary_actions_content
          render_status_section(centered: true) if @status_content
        end
      end

      def render_minimal_layout
        div(class: "decor:flex decor:items-center decor:justify-between") do
          div(class: "decor:min-w-0 decor:flex-1") do
            render_title_only
          end
          render_actions_section if @actions_content
        end
      end

      def render_hero_layout
        div(class: "decor:d-hero") do
          div(class: "decor:d-hero-content decor:text-center") do
            div(class: "decor:max-w-5xl") do
              render_avatar_section(centered: true, large: true) if @avatar_content
              render_content_section(centered: true, large: true)
              render_actions_section(centered: true, large: true) if @actions_content || @secondary_actions_content
              render_status_section(centered: true) if @status_content
            end
          end
        end
      end

      def render_compact_layout
        div(class: "decor:flex decor:items-center decor:justify-between decor:py-2") do
          div(class: "decor:flex decor:items-center decor:gap-3 decor:min-w-0 decor:flex-1") do
            render_avatar_section(compact: true) if @avatar_content
            render_content_section(compact: true)
          end
          render_actions_section(compact: true) if @actions_content
        end
      end

      def render_avatar_section(centered: false, large: false, compact: false)
        classes = ["decor:flex-shrink-0"]
        classes << (centered ? "decor:mb-4" : "")

        div(class: classes.compact.join(" ")) do
          render @avatar_content if @avatar_content
        end
      end

      def render_content_section(centered: false, large: false, compact: false)
        classes = ["decor:min-w-0"]
        classes << (centered ? "decor:text-center" : "")

        div(class: classes.compact.join(" ")) do
          if @layout == :page_like
            div(class: "decor:sm:flex decor:items-center decor:sm:space-x-3") do
              render_title_section(centered: centered, large: large, compact: compact)
              render_badges_section
            end

            render_subtitle_section(centered: centered, compact: compact) if @subtitle.present?

            div(class: "decor:sm:flex decor:items-center decor:sm:space-x-3") do
              render_description_section(centered: centered, compact: compact) if @description.present?
              render_tags_section
            end
          else
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

        title_size = map_title_size(compact: compact)

        tag_name = (@layout == :page_like) ? :h3 : :h1

        render ::Decor::Daisy::Title.new(
          title: @title,
          size: title_size,
          element_tag: tag_name
        )
      end

      def map_title_size(compact: false)
        if compact
          :md
        elsif @layout == :page_like
          case @size
          when :xs then :xs
          when :sm then :sm
          when :md then :md
          when :lg then :lg
          when :xl then :xl
          else :md
          end
        else
          case @size
          when :xs then :md
          when :sm then :lg
          when :md then :xl
          when :lg then :xl
          when :xl then :xl
          else :xl
          end
        end
      end

      def render_subtitle_section(centered: false, compact: false)
        return if compact && @subtitle.blank?

        size_classes = case @size
        when :xs then "decor:text-xs"
        when :sm then "decor:text-xs"
        when :md then "decor:text-xs"
        when :lg then "decor:text-sm"
        when :xl then "decor:text-base"
        else "decor:text-xs"
        end

        classes = ["decor:py-2 decor:sm:py-0 decor:text-base-content/70 #{size_classes}"]
        classes << (centered ? "decor:text-center" : "")

        h4(class: classes.compact.join(" ")) do
          plain @subtitle if @subtitle.present?
        end
      end

      def render_description_section(centered: false, compact: false)
        return if compact || @description.blank?

        size_classes = case @size
        when :xs then "decor:text-xs"
        when :sm then "decor:text-sm"
        when :md then "decor:text-sm"
        when :lg then "decor:text-base"
        when :xl then "decor:text-lg"
        else "decor:text-sm"
        end

        classes = ["decor:text-base-content/70 #{size_classes}"]
        classes << (centered ? "decor:text-center" : "")

        p(class: classes.compact.join(" ")) do
          plain @description
        end
      end

      def render_meta_section(centered: false, compact: false)
        return unless @meta_content

        classes = ["decor:mt-3"]
        classes << (centered ? "decor:flex decor:justify-center" : "")

        div(class: classes.compact.join(" ")) do
          render @meta_content if @meta_content
        end
      end

      def render_actions_section(centered: false, large: false, compact: false)
        return unless @actions_content || @secondary_actions_content || @cta_content

        classes = ["decor:mt-4"]
        classes << (@cta_snap_large ? "decor:xl:mt-0" : "decor:md:mt-0")

        if centered
          div(class: "decor:mt-6 decor:flex decor:flex-col decor:sm:flex-row decor:gap-3 decor:justify-center") do
            render_action_buttons(large: large)
          end
        elsif compact
          div(class: "decor:flex decor:items-center decor:gap-2") do
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
          div(class: "decor:flex decor:gap-2") do
            render @actions_content
          end
        end

        if @secondary_actions_content
          div(class: "decor:flex decor:gap-2") do
            render @secondary_actions_content
          end
        end

        if @cta_content
          render @cta_content
        end
      end

      def render_status_section(centered: false)
        return unless @status_content

        classes = ["decor:mt-4"]
        classes << (centered ? "decor:flex decor:justify-center" : "")

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
end
