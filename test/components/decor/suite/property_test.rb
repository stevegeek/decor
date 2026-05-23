# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::PropertyTest < ActiveSupport::TestCase
  test "renders root with suite property identifier" do
    html = render_component(::Decor::Suite::Property.new(label: "L", value: "V"))
    assert_includes html, "decor--suite--property"
  end

  test "default stack layout renders label and value vertically" do
    html = render_component(::Decor::Suite::Property.new(label: "Order #", value: "PO-1"))
    assert_includes html, "Order #"
    assert_includes html, "PO-1"
    assert_includes html, "decor:flex-col"
  end

  test "stack layout label uses suite-label typography" do
    html = render_component(::Decor::Suite::Property.new(label: "L", value: "V"))
    assert_includes html, "decor:suite-label"
  end

  test "stack layout value uses suite-dense-body typography and tabular-nums" do
    html = render_component(::Decor::Suite::Property.new(label: "L", value: "V"))
    assert_includes html, "decor:suite-dense-body"
    assert_includes html, "decor:tabular-nums"
  end

  test "row layout uses 10rem-label grid template" do
    html = render_component(::Decor::Suite::Property.new(label: "L", value: "V", layout: :row))
    assert_includes html, "decor:grid-cols-[10rem_1fr]"
  end

  test "row layout meta renders as block below value with suite-description" do
    html = render_component(::Decor::Suite::Property.new(label: "L", value: "V", layout: :row, meta: "M"))
    assert_includes html, "M"
    assert_includes html, "decor:suite-description"
    assert_includes html, "decor:block"
  end

  test "stack layout meta renders with suite-description typography" do
    html = render_component(::Decor::Suite::Property.new(label: "L", value: "V", meta: "+5%"))
    assert_includes html, "+5%"
    assert_includes html, "decor:suite-description"
  end

  test "icon prop renders an icon next to the label in stack layout" do
    html = render_component(::Decor::Suite::Property.new(label: "Customer", value: "Acme", icon: "user"))
    assert_includes html, "Customer"
    assert_includes html, "<svg"
  end

  test "block-rendered value is captured and emitted in place of value:" do
    html = render_component(::Decor::Suite::Property.new(label: "Status")) do
      '<span data-testid="rich-value">Active</span>'.html_safe
    end
    assert_includes html, "Status"
    assert_includes html, 'data-testid="rich-value"'
    assert_includes html, "Active"
  end

  test "without value or content the value span is omitted" do
    html = render_component(::Decor::Suite::Property.new(label: "L"))
    refute_includes html, "decor:suite-dense-body"
  end

  test "rejects unknown layout values" do
    assert_raises(Literal::TypeError) do
      ::Decor::Suite::Property.new(label: "L", value: "V", layout: :diagonal)
    end
  end
end
