# frozen_string_literal: true

module Decor
  module Suite
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
        classes.compact.reject(&:empty?).join(" ")
      end

      def background_classes
        case @background
        when :hero, :gradient then "decor:bg-suite-gray-25"
        when :transparent then ""
        else "decor:bg-white"
        end
      end

      def padding_classes
        case @padding
        when :none then ""
        when :sm then "decor:px-4 decor:py-3"
        when :md then "decor:suite-section-pad"
        when :lg then "decor:px-6 decor:py-8 decor:lg:px-8 decor:lg:py-10"
        when :xl then "decor:px-8 decor:py-10 decor:lg:px-10 decor:lg:py-12"
        else "decor:suite-section-pad"
        end
      end

      def border_classes
        @border ? "decor:border-b decor:border-suite-hairline" : ""
      end

      def render_breadcrumbs
        div(class: "decor:mb-3 decor:suite-description decor:text-gray-500") do
          render_slot(@breadcrumbs_content)
        end
      end

      def render_layout
        case @layout
        when :centered, :hero then render_centered_layout
        when :minimal then render_minimal_layout
        when :compact then render_compact_layout
        when :page_like then render_page_like_layout
        else render_default_layout
        end
      end

      def render_default_layout
        div(class: "decor:flex decor:flex-col decor:lg:flex-row decor:lg:items-center decor:lg:justify-between decor:gap-4") do
          div(class: "decor:flex decor:flex-col decor:sm:flex-row decor:items-start decor:sm:items-center decor:gap-3 decor:min-w-0 decor:flex-1") do
            render_avatar_section if @avatar_content
            render_content_section
          end
          render_actions_section if has_actions?
        end
      end

      def render_page_like_layout
        snap = @cta_snap_large ? "xl" : "md"
        wrap_classes = "decor:bg-white decor:#{snap}:flex decor:#{snap}:items-center decor:#{snap}:justify-between"

        div(class: wrap_classes) do
          left_classes = "decor:space-y-1.5 decor:pb-3 decor:#{snap}:pb-0 decor:#{snap}:pr-6 decor:border-b decor:#{snap}:border-b-0 decor:border-suite-hairline"
          div(class: left_classes) do
            render_avatar_section if @avatar_content
            render_content_section
          end
          render_actions_section if has_actions?
        end
      end

      def render_centered_layout
        div(class: "decor:text-center decor:max-w-3xl decor:mx-auto") do
          render_avatar_section(centered: true) if @avatar_content
          render_content_section(centered: true)
          render_actions_section(centered: true) if has_actions?
          render_status_section(centered: true) if @status_content
        end
      end

      def render_minimal_layout
        div(class: "decor:flex decor:items-center decor:justify-between decor:gap-3") do
          div(class: "decor:min-w-0 decor:flex-1") { render_title_only }
          render_actions_section if @actions_content
        end
      end

      def render_compact_layout
        div(class: "decor:flex decor:items-center decor:justify-between decor:gap-3 decor:py-1") do
          div(class: "decor:flex decor:items-center decor:gap-2.5 decor:min-w-0 decor:flex-1") do
            render_avatar_section(compact: true) if @avatar_content
            render_content_section(compact: true)
          end
          render_actions_section(compact: true) if @actions_content
        end
      end

      def has_actions?
        @actions_content || @secondary_actions_content || @cta_content
      end

      def render_avatar_section(centered: false, compact: false)
        classes = ["decor:shrink-0"]
        classes << "decor:mb-3" if centered
        div(class: classes.join(" ")) { render_slot(@avatar_content) }
      end

      def render_content_section(centered: false, compact: false)
        wrap_classes = ["decor:min-w-0"]
        wrap_classes << "decor:text-center" if centered

        div(class: wrap_classes.join(" ")) do
          render_title_section(centered: centered, compact: compact)
          render_badges_inline if @badges&.any? && !centered
          render_subtitle_section(centered: centered, compact: compact) if @subtitle.present?
          render_description_section(centered: centered, compact: compact) if @description.present? && !compact
          render_tags_inline if @tags&.any? && !compact
          render_meta_section(centered: centered) if @meta_content
        end
      end

      def render_title_section(centered: false, compact: false)
        if @title_content
          render_slot(@title_content)
        else
          render_title_only(compact: compact)
        end
      end

      def render_title_only(compact: false)
        return unless @title.present?

        tag_name = (@layout == :page_like) ? :h3 : :h1
        size_class = if compact
          "decor:text-base"
        else
          case @size
          when :xs then "decor:text-base"
          when :sm then "decor:text-lg"
          when :md then "decor:text-xl"
          when :lg then "decor:text-2xl"
          when :xl then "decor:text-3xl"
          else "decor:text-xl"
          end
        end

        send(tag_name, class: "decor:suite-section-title decor:text-gray-900 decor:m-0 #{size_class}") { plain @title }
      end

      def render_subtitle_section(centered: false, compact: false)
        classes = ["decor:suite-description", "decor:text-gray-500", "decor:m-0"]
        classes << "decor:mt-1" unless compact
        classes << "decor:text-center" if centered

        p(class: classes.join(" ")) { plain @subtitle }
      end

      def render_description_section(centered: false, compact: false)
        classes = ["decor:suite-description", "decor:text-gray-600", "decor:m-0", "decor:mt-1.5"]
        classes << "decor:text-center" if centered

        p(class: classes.join(" ")) { plain @description }
      end

      def render_meta_section(centered: false)
        classes = ["decor:mt-2.5"]
        classes << "decor:flex decor:justify-center" if centered
        div(class: classes.join(" ")) { render_slot(@meta_content) }
      end

      def render_actions_section(centered: false, compact: false)
        return unless has_actions?

        wrap_classes = if centered
          "decor:mt-4 decor:flex decor:flex-col decor:sm:flex-row decor:gap-2 decor:justify-center"
        elsif compact
          "decor:flex decor:items-center decor:gap-2"
        else
          snap = @cta_snap_large ? "xl" : "md"
          "decor:mt-3 decor:#{snap}:mt-0 decor:flex decor:items-center decor:gap-2"
        end

        div(class: wrap_classes) { render_action_buttons }
      end

      def render_action_buttons
        if @actions_content
          div(class: "decor:flex decor:gap-2") { render_slot(@actions_content) }
        end
        if @secondary_actions_content
          div(class: "decor:flex decor:gap-2") { render_slot(@secondary_actions_content) }
        end
        render_slot(@cta_content) if @cta_content
      end

      def render_status_section(centered: false)
        classes = ["decor:mt-3"]
        classes << "decor:flex decor:justify-center" if centered
        div(class: classes.join(" ")) { render_slot(@status_content) }
      end

      def render_badges_inline
        div(class: "decor:inline-flex decor:items-center decor:gap-1.5 decor:ml-2 decor:align-middle") do
          @badges.each { |b| render b }
        end
      end

      def render_tags_inline
        div(class: "decor:flex decor:flex-wrap decor:items-center decor:gap-1.5 decor:mt-2") do
          @tags.each { |t| render t }
        end
      end
    end
  end
end
