# frozen_string_literal: true

require "test_helper"

module Decor
  class FlashTest < ViewComponent::TestCase
    def test_renders_flash_with_title_and_text
      render_inline(Flash.new(title: "Flash Title", text: "Flash message", variant: :success))

      assert_selector ".alert.alert-success"
      assert_selector "h3", text: "Flash Title"
      assert_selector "p", text: "Flash message"
    end

    def test_renders_different_variants
      variants = {
        success: "alert-success",
        error: "alert-error",
        warning: "alert-warning",
        info: "alert-info",
        notice: "alert-info"
      }

      variants.each do |variant, expected_class|
        render_inline(Flash.new(
          text: "Test message",
          variant: variant,
          controller_path: "test",
          action_name: "show"
        ))
        assert_selector ".alert.#{expected_class}"
      end
    end

    def test_renders_appropriate_icons_for_variants
      icon_mapping = {
        success: "check-circle",
        error: "x-circle",
        warning: "exclamation",
        info: "information-circle",
        notice: "information-circle"
      }

      icon_mapping.each do |variant, expected_icon|
        component = Flash.new(text: "Test", variant: variant)
        assert_equal expected_icon, component.send(:icon)
      end
    end

    def test_default_titles_for_variants
      expected_titles = {
        success: "Success!",
        error: "An error exists.",
        warning: "Attention needed",
        info: "Notice",
        notice: "Notice"
      }

      expected_titles.each do |variant, expected_title|
        component = Flash.new(
          text: "Test",
          variant: variant,
          controller_path: "test",
          action_name: "show"
        )
        # Test the default title by ensuring no I18n key exists
        assert_equal expected_title, component.send(:title_with_defaults)
      end
    end

    def test_uses_custom_title_when_provided
      render_inline(Flash.new(title: "Custom Title", text: "Message", variant: :success))

      assert_selector "h3", text: "Custom Title"
    end

    def test_hides_when_collapse_if_empty_and_no_content
      component = Flash.new(collapse_if_empty: true)
      render_inline(component)

      # Check if the component has hidden class when collapsed and empty
      assert_match(/hidden/, component.send(:root_element_classes))
    end

    def test_shows_when_collapse_if_empty_false_and_no_content
      render_inline(Flash.new(collapse_if_empty: false))

      assert_no_selector ".hidden"
    end

    def test_renders_with_content_block_when_no_initial_flash
      render_inline(Flash.new) do
        "Custom content block"
      end

      assert_text "Custom content block"
    end

    def test_default_variant_is_info
      component = Flash.new(
        text: "Test message",
        controller_path: "test",
        action_name: "show"
      )
      render_inline(component)

      assert_selector ".alert.alert-info"
    end

    def test_invisible_opacity_classes_applied
      render_inline(Flash.new(
        text: "Test",
        controller_path: "test",
        action_name: "show"
      ))

      assert_selector ".invisible.opacity-0"
    end

    def test_preserves_backward_compatibility_with_original_attributes
      # Test that all original attribute names still work
      component = Flash.new(
        title: "Test Title",
        text: "Test Text",
        preserve_flash: true,
        collapse_if_empty: false,
        variant: :warning
      )

      assert_equal "Test Title", component.instance_variable_get(:@title)
      assert_equal "Test Text", component.instance_variable_get(:@text)
      assert_equal true, component.instance_variable_get(:@preserve_flash)
      assert_equal false, component.instance_variable_get(:@collapse_if_empty)
      assert_equal :warning, component.instance_variable_get(:@variant)
    end

    def test_inherits_from_phlex_component
      component = Flash.new(text: "Test")
      assert_kind_of PhlexComponent, component
    end
  end
end
