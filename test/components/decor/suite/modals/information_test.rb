# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Modals::InformationTest < ActiveSupport::TestCase
  test "inherits from Components::Modals::Information" do
    assert ::Decor::Suite::Modals::Information.new(title: "X").is_a?(::Decor::Components::Modals::Information)
  end

  test "defaults close_label to 'Close'" do
    info = ::Decor::Suite::Modals::Information.new(title: "Terms")
    assert_equal "Close", info.instance_variable_get(:@close_label)
  end

  test "defaults variant to :neutral and size to :default" do
    info = ::Decor::Suite::Modals::Information.new(title: "Terms")
    assert_equal :neutral, info.instance_variable_get(:@variant)
    assert_equal :default, info.instance_variable_get(:@size)
  end

  test "defaults start_open to false" do
    info = ::Decor::Suite::Modals::Information.new(title: "Terms")
    refute info.instance_variable_get(:@start_open)
  end

  test "accepts all variant options" do
    ::Decor::Components::Modals::Information::VARIANT_OPTIONS.each do |variant|
      assert_nothing_raised do
        ::Decor::Suite::Modals::Information.new(title: "X", variant: variant)
      end
    end
  end

  test "accepts all size options" do
    ::Decor::Components::Modals::Information::SIZE_OPTIONS.each do |size|
      assert_nothing_raised do
        ::Decor::Suite::Modals::Information.new(title: "X", size: size)
      end
    end
  end

  test "title is required" do
    assert_raises(ArgumentError) do
      ::Decor::Suite::Modals::Information.new
    end
  end

  test "close button uses Suite::Modals::ModalCloseButton with outlined neutral chrome" do
    info = ::Decor::Suite::Modals::Information.new(title: "Terms", close_label: "Dismiss")
    btn = info.send(:close_button)

    assert_kind_of ::Decor::Suite::Modals::ModalCloseButton, btn
    assert_equal "Dismiss", btn.instance_variable_get(:@label)
    assert_equal :sm, btn.instance_variable_get(:@size)
    assert_equal :outlined, btn.instance_variable_get(:@style)
    assert_equal :base, btn.instance_variable_get(:@color)
  end

  test "does not emit its own Stimulus controller (composition-only wrapper)" do
    refute ::Decor::Suite::Modals::Information.stimulus_controller?
  end

  test "renders a Suite Modal as the outer chrome" do
    html = render_component(::Decor::Suite::Modals::Information.new(title: "Terms"))
    assert_includes html, "<dialog"
    assert_includes html, "decor--suite--modals--modal"
  end

  test "renders the title in the modal header" do
    html = render_component(::Decor::Suite::Modals::Information.new(title: "Terms of Service"))
    assert_includes html, "Terms of Service"
  end

  test "renders the description when provided" do
    html = render_component(::Decor::Suite::Modals::Information.new(title: "Terms", description: "Please read carefully."))
    assert_includes html, "Please read carefully."
  end

  test "renders the footer Close button by default" do
    html = render_component(::Decor::Suite::Modals::Information.new(title: "Terms"))
    assert_includes html, "Close"
  end

  test "honours a custom close_label" do
    html = render_component(::Decor::Suite::Modals::Information.new(title: "Terms", close_label: "Got it"))
    assert_includes html, "Got it"
  end

  test "yields a block as the body content" do
    html = render_component(::Decor::Suite::Modals::Information.new(title: "Terms")) do
      "<p>Body content here.</p>".html_safe
    end
    assert_includes html, "Body content here."
  end

  test "renders without a body block" do
    assert_nothing_raised do
      render_component(::Decor::Suite::Modals::Information.new(title: "Terms"))
    end
  end

  test "renders with start_open set" do
    html = render_component(::Decor::Suite::Modals::Information.new(title: "Terms", start_open: true))
    assert_includes html, "<dialog"
  end
end
