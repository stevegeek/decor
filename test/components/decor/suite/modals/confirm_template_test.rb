# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Modals::ConfirmTemplateTest < ActiveSupport::TestCase
  test "inherits from Decor::PhlexComponent" do
    assert ::Decor::Suite::Modals::ConfirmTemplate.new.is_a?(::Decor::PhlexComponent)
  end

  test "mixes in ConfirmShared so the variant->class maps are reachable" do
    assert ::Decor::Suite::Modals::ConfirmTemplate.include?(::Decor::Suite::Modals::ConfirmShared)
  end

  test "renders a <dialog> root with cf-modal and cf-modal--confirm chrome" do
    html = render_component(::Decor::Suite::Modals::ConfirmTemplate.new)
    assert_includes html, "<dialog"
    assert_includes html, "cf-modal"
    assert_includes html, "cf-modal--confirm"
  end

  test "uses the suite-card radius and suite-default 420px width" do
    html = render_component(::Decor::Suite::Modals::ConfirmTemplate.new)
    assert_includes html, "decor:rounded-suite-card"
    assert_includes html, "decor:w-[420px]"
  end

  test "renders the accent bar target as initially hidden (controller un-hides for non-neutral variants)" do
    html = render_component(::Decor::Suite::Modals::ConfirmTemplate.new)
    fragment = Nokogiri::HTML5.fragment(html)
    accent = fragment.at_css("[data-decor--suite--modals--confirm-template-target='accent']")
    refute_nil accent, "expected an accent target element"
    assert accent.key?("hidden"), "expected accent target to render with hidden attribute"
  end

  test "exposes the header, title and message targets" do
    html = render_component(::Decor::Suite::Modals::ConfirmTemplate.new)
    fragment = Nokogiri::HTML5.fragment(html)
    refute_nil fragment.at_css("[data-decor--suite--modals--confirm-template-target='header']")
    refute_nil fragment.at_css("h3[data-decor--suite--modals--confirm-template-target='title']")
    refute_nil fragment.at_css("p[data-decor--suite--modals--confirm-template-target='message']")
  end

  # Stimulus targets get camelCased by the data-attribute name (snake_case
  # input -> camelCase identifier), so `:icon_info` lands as `iconInfo`.
  test "pre-renders one hidden icon target for every styled variant" do
    html = render_component(::Decor::Suite::Modals::ConfirmTemplate.new)
    fragment = Nokogiri::HTML5.fragment(html)
    ::Decor::Suite::Modals::ConfirmShared::VARIANT_ICON_NAMES.each_key do |variant|
      camel = "icon#{variant.to_s.capitalize}"
      el = fragment.at_css("[data-decor--suite--modals--confirm-template-target='#{camel}']")
      refute_nil el, "expected icon target for variant #{variant.inspect} (camel: #{camel})"
      assert el.key?("hidden"), "expected #{camel} target to render hidden"
    end
  end

  test "renders both cancel button targets (header close X + footer Cancel button)" do
    html = render_component(::Decor::Suite::Modals::ConfirmTemplate.new)
    fragment = Nokogiri::HTML5.fragment(html)
    cancels = fragment.css("[data-decor--suite--modals--confirm-template-target='cancelButton']")
    assert_equal 2, cancels.size, "expected the header X and footer Cancel to both be cancelButton targets"
  end

  test "renders the confirm button target inside the footer" do
    html = render_component(::Decor::Suite::Modals::ConfirmTemplate.new)
    fragment = Nokogiri::HTML5.fragment(html)
    confirm = fragment.at_css("[data-decor--suite--modals--confirm-template-target='confirmButton']")
    refute_nil confirm
    assert_equal "button", confirm.name
  end

  test "default confirm button chrome uses suite-primary-500 (controller may swap for destructive)" do
    html = render_component(::Decor::Suite::Modals::ConfirmTemplate.new)
    fragment = Nokogiri::HTML5.fragment(html)
    confirm = fragment.at_css("[data-decor--suite--modals--confirm-template-target='confirmButton']")
    assert_includes confirm["class"].to_s, "decor:bg-suite-primary-500"
  end

  test "header uses the suite-hairline divider and suite-section-title typography" do
    html = render_component(::Decor::Suite::Modals::ConfirmTemplate.new)
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:suite-section-title"
  end

  test "footer uses the suite-gray-25 surface and rounded-suite-control buttons" do
    html = render_component(::Decor::Suite::Modals::ConfirmTemplate.new)
    assert_includes html, "decor:bg-suite-gray-25"
    assert_includes html, "decor:rounded-suite-control"
  end

  test "stimulus classes API exposes every variant accent class to the cloning controller" do
    html = render_component(::Decor::Suite::Modals::ConfirmTemplate.new)
    [:info, :success, :warning, :danger, :destructive, :neutral].each do |variant|
      expected = ::Decor::Suite::Modals::ConfirmShared::VARIANT_ACCENT_CLASSES[variant]
      assert_includes html, expected, "expected accent class for #{variant} in template stimulus classes"
    end
  end

  test "stimulus classes API exposes destructive header/title classes sourced from Suite::Modals::Modal" do
    html = render_component(::Decor::Suite::Modals::ConfirmTemplate.new)
    assert_includes html, ::Decor::Suite::Modals::Modal::DESTRUCTIVE_HEADER_CLASSES.split.first
    assert_includes html, ::Decor::Suite::Modals::Modal::DESTRUCTIVE_TITLE_CLASSES
  end

  test "does not emit any daisyUI semantic colour tokens (Suite-only ports stay clean)" do
    html = render_component(::Decor::Suite::Modals::ConfirmTemplate.new)
    refute_includes html, "decor:bg-info"
    refute_includes html, "decor:bg-error"
    refute_includes html, "decor:bg-warning"
    refute_includes html, "decor:text-info"
    refute_includes html, "decor:text-error"
  end

  test "mounts its own stimulus controller so the cloning helper can read the classes API" do
    html = render_component(::Decor::Suite::Modals::ConfirmTemplate.new)
    assert_includes html, "decor--suite--modals--confirm-template"
  end
end
