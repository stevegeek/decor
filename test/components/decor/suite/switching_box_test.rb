# frozen_string_literal: true

require "test_helper"
require_relative "../../../support/example_form"

class ::Decor::Suite::SwitchingBoxTest < ActiveSupport::TestCase
  def setup
    @model = TestModel.new(id: 1, active: true)
    @url = "/test/1"
  end

  test "root has suite surface chrome with white bg and hairline border" do
    html = render_component(::Decor::Suite::SwitchingBox.new(title: "T"))
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:rounded-suite-card"
    assert_includes html, "decor:flex"
    assert_includes html, "decor:items-center"
    assert_includes html, "decor:justify-between"
  end

  test "applies transition + hover hairline-strong" do
    html = render_component(::Decor::Suite::SwitchingBox.new(title: "T"))
    assert_includes html, "decor:transition-colors"
    assert_includes html, "decor:duration-suite-fast"
    assert_includes html, "decor:hover:border-suite-hairline-strong"
  end

  test "renders title with suite-section-title typography" do
    html = render_component(::Decor::Suite::SwitchingBox.new(title: "My Toggle"))
    assert_includes html, "My Toggle"
    assert_includes html, "decor:suite-section-title"
    assert_includes html, "decor:text-gray-900"
  end

  test "renders description with suite-description typography" do
    html = render_component(::Decor::Suite::SwitchingBox.new(title: "T", description: "Helper text"))
    assert_includes html, "Helper text"
    assert_includes html, "decor:suite-description"
    assert_includes html, "decor:text-gray-500"
  end

  test "stack mode collapses borders and applies first/last side restorations" do
    html = render_component(::Decor::Suite::SwitchingBox.new(title: "T", stack: true))
    assert_includes html, "decor:border-b"
    assert_includes html, "decor:border-l-0"
    assert_includes html, "decor:border-r-0"
    assert_includes html, "decor:border-t-0"
    assert_includes html, "decor:rounded-none"
    assert_includes html, "decor:first:border-t"
    assert_includes html, "decor:first:rounded-t-suite-card"
    assert_includes html, "decor:last:rounded-b-suite-card"
  end

  test "non-stack mode uses full border + rounded-suite-card" do
    html = render_component(::Decor::Suite::SwitchingBox.new(title: "T", stack: false))
    assert_includes html, "decor:border decor:border-suite-hairline"
    assert_includes html, "decor:rounded-suite-card"
    refute_includes html, "decor:rounded-none"
    refute_includes html, "decor:first:border-t"
  end

  test "stack? predicate reflects the prop" do
    refute ::Decor::Suite::SwitchingBox.new(title: "T").stack?
    assert ::Decor::Suite::SwitchingBox.new(title: "T", stack: true).stack?
  end

  test "model-bound row renders a form and a switch input" do
    html = render_component(::Decor::Suite::SwitchingBox.new(
      model: @model,
      url: @url,
      property_name: :active,
      title: "Two-factor auth"
    ))
    assert_includes html, "Two-factor auth"
    assert_includes html, "<form"
    assert_includes html, "test_model[active]"
  end

  test "right? is false when no model is provided" do
    component = ::Decor::Suite::SwitchingBox.new(title: "T")
    refute component.right?
  end

  test "right? is true when a model is provided" do
    component = ::Decor::Suite::SwitchingBox.new(
      model: @model,
      url: @url,
      property_name: :active
    )
    assert component.right?
  end

  test "renders without a form when model is nil" do
    html = render_component(::Decor::Suite::SwitchingBox.new(title: "Alone", description: "No model"))
    assert_includes html, "Alone"
    assert_includes html, "No model"
    refute_includes html, "<form"
  end

  test "left slot replaces the title + description column" do
    html = render_component(::Decor::Suite::SwitchingBox.new(title: "hidden-title", description: "hidden-desc")) do |sb|
      sb.with_left { "custom-left-content" }
    end
    assert_includes html, "custom-left-content"
    refute_includes html, "hidden-title"
    refute_includes html, "hidden-desc"
  end

  test "uses suite tokens only (no daisy semantic chrome or raw shorthands)" do
    html = render_component(::Decor::Suite::SwitchingBox.new(
      model: @model,
      url: @url,
      property_name: :active,
      title: "T",
      description: "D"
    ))
    refute_includes html, "decor:rounded-md"
    refute_includes html, "decor:rounded-lg"
    refute_includes html, "decor:border-black/10"
    refute_includes html, "decor:bg-base-100"
    refute_includes html, "decor:d-card-bordered"
    refute_includes html, "decor:duration-150"
  end

  test "exposes reader props from the abstract base" do
    component = ::Decor::Suite::SwitchingBox.new(
      model: @model,
      url: @url,
      property_name: :active
    )
    assert_equal @model, component.model
    assert_equal @url, component.url
    assert_equal :active, component.property_name
  end
end
