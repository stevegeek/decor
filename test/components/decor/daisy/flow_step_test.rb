# frozen_string_literal: true

require "test_helper"

module Decor
  module Daisy
    class FlowStepTest < ActiveSupport::TestCase
      def test_renders_with_title_and_description
        fragment = render_fragment(Decor::Daisy::FlowStep.new(title: "Step Title", description: "Step description", step: 1))

        h4 = fragment.at_css("h4")
        refute_nil h4, "expected an h4 to be present"
        assert_equal "Step Title", h4.text.strip

        p = fragment.at_css("p")
        refute_nil p, "expected a p to be present"
        assert_equal "Step description", p.text.strip
      end

      def test_renders_with_step_number
        fragment = render_fragment(Decor::Daisy::FlowStep.new(title: "Step Title", step: 3))

        spans = fragment.css("span").map { |s| s.text.strip }
        assert_includes spans, "03"

        h4 = fragment.at_css("h4")
        refute_nil h4
        assert_equal "Step Title", h4.text.strip
      end

      def test_renders_with_icon_instead_of_step_number
        fragment = render_fragment(Decor::Daisy::FlowStep.new(title: "Step Title", icon: "check"))

        h4 = fragment.at_css("h4")
        refute_nil h4
        assert_equal "Step Title", h4.text.strip
      end

      def test_renders_without_description
        fragment = render_fragment(Decor::Daisy::FlowStep.new(title: "Step Title", step: 1))

        h4 = fragment.at_css("h4")
        refute_nil h4
        assert_equal "Step Title", h4.text.strip
        assert_nil fragment.at_css("p"), "expected no p element when description omitted"
      end

      def test_renders_with_content_block
        html = render_component(Decor::Daisy::FlowStep.new(title: "Step Title", step: 1)) do
          "Custom step content"
        end

        assert_includes html, "Step Title"
        assert_includes html, "Custom step content"
      end

      def test_default_color_is_info
        fragment = render_fragment(Decor::Daisy::FlowStep.new(title: "Test", step: 1))

        span = fragment.at_css("span[class~='decor:bg-info'][class~='decor:text-info-content']")
        refute_nil span, "expected step indicator span with bg-info + text-info-content"
      end

      def test_uses_daisyui_base_content_colors
        fragment = render_fragment(Decor::Daisy::FlowStep.new(title: "Test Title", description: "Test description", step: 1))

        h4 = fragment.at_css("h4[class~='decor:text-base-content']")
        refute_nil h4, "expected h4 with decor:text-base-content"

        p = fragment.at_css("p[class~='decor:text-base-content/70']")
        refute_nil p, "expected p with decor:text-base-content/70"
      end

      def test_step_indicator_has_correct_classes
        fragment = render_fragment(Decor::Daisy::FlowStep.new(title: "Test", step: 1))

        span = fragment.at_css(
          "span[class~='decor:flex-shrink-0'][class~='decor:flex'][class~='decor:items-center'][class~='decor:justify-center'][class~='decor:rounded-full']"
        )
        refute_nil span, "expected step indicator span with layout classes"
      end

      def test_main_container_has_correct_layout_classes
        fragment = render_fragment(Decor::Daisy::FlowStep.new(title: "Test", step: 1))

        root = fragment.at_css(
          "[class~='decor:flex'][class~='decor:gap-3'][class~='decor:md:gap-5'][class~='decor:mt-5'][class~='decor:border-b'][class~='decor:border-base-300'][class~='decor:mb-3'][class~='decor:pb-5']"
        )
        refute_nil root, "expected root container with layout classes"
      end

      def test_inherits_from_phlex_component
        component = Decor::Daisy::FlowStep.new(title: "Test", step: 1)
        assert_kind_of PhlexComponent, component
      end

      def test_modern_color_attribute
        fragment = render_fragment(Decor::Daisy::FlowStep.new(title: "Test", step: 1, color: :primary))

        span = fragment.at_css("span[class~='decor:bg-primary'][class~='decor:text-primary-content']")
        refute_nil span, "expected step indicator span with bg-primary + text-primary-content"
      end

      def test_modern_size_variants
        sizes_and_expected = {
          xs: "decor:w-6 decor:h-6",
          sm: "decor:w-8 decor:h-8",
          md: "decor:w-8 decor:h-8",
          lg: "decor:w-12 decor:h-12",
          xl: "decor:w-16 decor:h-16"
        }

        sizes_and_expected.each do |size, expected_classes|
          fragment = render_fragment(Decor::Daisy::FlowStep.new(title: "Test", step: 1, size: size))

          expected_classes.split.each do |css_class|
            span = fragment.at_css("span[class~='#{css_class}']")
            refute_nil span, "expected span with #{css_class} for size #{size}"
          end
        end
      end

      def test_modern_filled_variant
        fragment = render_fragment(Decor::Daisy::FlowStep.new(title: "Test", step: 1, color: :primary, style: :filled))

        span = fragment.at_css("span[class~='decor:bg-primary'][class~='decor:text-primary-content']")
        refute_nil span, "expected filled variant to have bg-primary + text-primary-content"
      end

      def test_modern_outlined_variant
        fragment = render_fragment(Decor::Daisy::FlowStep.new(title: "Test", step: 1, color: :primary, style: :outlined))

        span = fragment.at_css(
          "span[class~='decor:text-primary'][class~='decor:border-2'][class~='decor:border-primary']"
        )
        refute_nil span, "expected outlined variant to have text-primary + border-2 + border-primary"
      end

      def test_modern_ghost_variant
        fragment = render_fragment(Decor::Daisy::FlowStep.new(title: "Test", step: 1, color: :primary, style: :ghost))

        span = fragment.at_css(
          "span[class~='decor:text-primary'][class~='decor:border-2'][class~='decor:border-transparent']"
        )
        refute_nil span, "expected ghost variant to have text-primary + border-2 + border-transparent"
      end

      def test_uses_title_component_for_content
        fragment = render_fragment(Decor::Daisy::FlowStep.new(title: "Test Title", description: "Test description", step: 1))

        title_root = fragment.at_css(".decor--daisy--title")
        refute_nil title_root, "expected the daisy title wrapper to be rendered"

        h4 = fragment.at_css("h4[class~='decor:font-semibold'][class~='decor:text-base-content']")
        refute_nil h4, "expected h4 with font-semibold + text-base-content"
        assert_equal "Test Title", h4.text.strip

        p = fragment.at_css("p[class~='decor:text-base-content/70']")
        refute_nil p, "expected p with text-base-content/70"
        assert_equal "Test description", p.text.strip
      end
    end
  end
end
