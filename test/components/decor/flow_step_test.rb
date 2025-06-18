# frozen_string_literal: true

require "test_helper"

module Decor
  class FlowStepTest < ViewComponent::TestCase
    def test_renders_with_title_and_description
      render_inline(FlowStep.new(title: "Step Title", description: "Step description", step: 1))

      assert_selector "h4", text: "Step Title"
      assert_selector "p", text: "Step description"
    end

    def test_renders_with_step_number
      render_inline(FlowStep.new(title: "Step Title", step: 3))

      # Step number is rendered in span with step indicator classes
      assert_selector "span", text: "03"
      assert_selector "h4", text: "Step Title"
    end

    def test_renders_with_icon_instead_of_step_number
      render_inline(FlowStep.new(title: "Step Title", icon: "check"))

      assert_selector "h4", text: "Step Title"
      # Icon would be rendered but we can't easily test the specific icon content
    end

    def test_renders_without_description
      render_inline(FlowStep.new(title: "Step Title", step: 1))

      assert_selector "h4", text: "Step Title"
      assert_no_selector "p"
    end

    def test_renders_with_content_block
      render_inline(FlowStep.new(title: "Step Title", step: 1)) do
        "Custom step content"
      end

      assert_selector "h4", text: "Step Title"
      assert_text "Custom step content"
    end

    def test_default_color_is_info
      render_inline(FlowStep.new(title: "Test", step: 1))

      # Default uses info color and filled variant
      assert_selector "span.bg-info.text-info-content"
    end

    def test_uses_daisyui_base_content_colors
      render_inline(FlowStep.new(title: "Test Title", description: "Test description", step: 1))

      assert_selector "h4.text-base-content"
      assert_selector "p.text-base-content\\/70"
    end

    def test_step_indicator_has_correct_classes
      render_inline(FlowStep.new(title: "Test", step: 1))

      # Step indicator uses span with proper styling classes
      assert_selector "span.flex-shrink-0.flex.items-center.justify-center.rounded-full"
    end

    def test_main_container_has_correct_layout_classes
      render_inline(FlowStep.new(title: "Test", step: 1))

      assert_selector ".flex.gap-3.md\\:gap-5.mt-5.border-b.border-base-300.mb-3.pb-5"
    end

    def test_inherits_from_phlex_component
      component = FlowStep.new(title: "Test", step: 1)
      assert_kind_of PhlexComponent, component
    end

    # Tests for new modern attributes
    def test_modern_color_attribute
      render_inline(FlowStep.new(title: "Test", step: 1, color: :primary))

      # Modern color attribute uses filled variant by default
      assert_selector "span.bg-primary.text-primary-content"
    end

    def test_modern_size_variants  
      # Test span sizes for step indicators
      sizes_and_expected = {
        xs: "w-6 h-6",
        sm: "w-8 h-8",
        md: "w-8 h-8",
        lg: "w-12 h-12",
        xl: "w-16 h-16"
      }

      sizes_and_expected.each do |size, expected_classes|
        render_inline(FlowStep.new(title: "Test", step: 1, size: size))
        
        expected_classes.split.each do |css_class|
          assert_selector "span.#{css_class}"
        end
      end
    end

    def test_modern_filled_variant
      render_inline(FlowStep.new(title: "Test", step: 1, color: :primary, variant: :filled))

      # Filled variant styling on span
      assert_selector "span.bg-primary.text-primary-content"
    end

    def test_modern_outlined_variant
      render_inline(FlowStep.new(title: "Test", step: 1, color: :primary, variant: :outlined))

      # Outlined variant styling on span
      assert_selector "span.text-primary.border-2.border-primary"
    end

    def test_modern_ghost_variant
      render_inline(FlowStep.new(title: "Test", step: 1, color: :primary, variant: :ghost))

      # Ghost variant styling on span
      assert_selector "span.text-primary.border-2.border-transparent"
    end

    def test_uses_title_component_for_content
      render_inline(FlowStep.new(title: "Test Title", description: "Test description", step: 1))

      # Should use Title component for title/description rendering
      assert_selector ".decor--title"
      assert_selector "h4.font-semibold.text-base-content", text: "Test Title"
      assert_selector "p.text-base-content\\/70", text: "Test description"
    end
  end
end
