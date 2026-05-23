# frozen_string_literal: true

require "test_helper"

module Decor
  module Daisy
    class FlashTest < ActiveSupport::TestCase
      def test_renders_flash_with_title_and_text
        rendered = render_fragment(Decor::Daisy::Flash.new(title: "Flash Title", text: "Flash message", color: :success))

        assert rendered.css('[class~="decor:d-alert"][class~="decor:d-alert-success"]').any?
        h3 = rendered.css("h3").first
        assert h3
        assert_equal "Flash Title", h3.text
        p = rendered.css("p").first
        assert p
        assert_equal "Flash message", p.text
      end

      def test_renders_different_variants
        variants = {
          success: "decor:d-alert-success",
          error: "decor:d-alert-error",
          warning: "decor:d-alert-warning",
          info: "decor:d-alert-info"
        }

        variants.each do |variant, expected_class|
          rendered = render_fragment(Decor::Daisy::Flash.new(
            text: "Test message",
            color: variant,
            controller_path: "test",
            action_name: "show"
          ))
          assert rendered.css(%([class~="decor:d-alert"][class~="#{expected_class}"])).any?, "Expected #{expected_class} for #{variant}"
        end
      end

      def test_renders_appropriate_icons_for_variants
        icon_mapping = {
          success: "circle-check",
          error: "circle-x",
          warning: "exclamation-mark",
          info: "info-circle"
        }

        icon_mapping.each do |variant, expected_icon|
          component = Decor::Daisy::Flash.new(text: "Test", color: variant)
          assert_equal expected_icon, component.send(:icon)
        end
      end

      def test_default_titles_for_variants
        expected_titles = {
          success: "Success!",
          error: "An error exists.",
          warning: "Attention needed",
          info: "Notice"
        }

        expected_titles.each do |variant, expected_title|
          component = Decor::Daisy::Flash.new(
            text: "Test",
            color: variant,
            controller_path: "test",
            action_name: "show"
          )
          assert_equal expected_title, component.send(:title_with_defaults)
        end
      end

      def test_uses_custom_title_when_provided
        rendered = render_fragment(Decor::Daisy::Flash.new(title: "Custom Title", text: "Message", color: :success))

        h3 = rendered.css("h3").first
        assert h3
        assert_equal "Custom Title", h3.text
      end

      def test_hides_when_collapse_if_empty_and_no_content
        component = Decor::Daisy::Flash.new(collapse_if_empty: true)
        render_fragment(component)

        assert_match(/hidden/, component.send(:root_element_classes))
      end

      def test_shows_when_collapse_if_empty_false_and_no_content
        rendered = render_fragment(Decor::Daisy::Flash.new(collapse_if_empty: false))

        assert_empty rendered.css('[class~="decor:hidden"]')
      end

      def test_renders_with_content_block_when_no_initial_flash
        rendered = render_fragment(Decor::Daisy::Flash.new) do
          "Custom content block"
        end

        assert_includes rendered.text, "Custom content block"
      end

      def test_default_variant_is_info
        component = Decor::Daisy::Flash.new(
          text: "Test message",
          controller_path: "test",
          action_name: "show"
        )
        rendered = render_fragment(component)

        assert rendered.css('[class~="decor:d-alert"][class~="decor:d-alert-info"]').any?
      end

      def test_invisible_opacity_classes_applied
        rendered = render_fragment(Decor::Daisy::Flash.new(
          text: "Test",
          controller_path: "test",
          action_name: "show"
        ))

        assert rendered.css('[class~="decor:invisible"][class~="decor:opacity-0"]').any?
      end

      def test_preserves_backward_compatibility_with_original_attributes
        component = Decor::Daisy::Flash.new(
          title: "Test Title",
          text: "Test Text",
          preserve_flash: true,
          collapse_if_empty: false,
          color: :warning
        )

        assert_equal "Test Title", component.instance_variable_get(:@title)
        assert_equal "Test Text", component.instance_variable_get(:@text)
        assert_equal true, component.instance_variable_get(:@preserve_flash)
        assert_equal false, component.instance_variable_get(:@collapse_if_empty)
        assert_equal :warning, component.instance_variable_get(:@color)
      end

      def test_inherits_from_phlex_component
        component = Decor::Daisy::Flash.new(text: "Test")
        assert_kind_of PhlexComponent, component
      end
    end
  end
end
