# frozen_string_literal: true

require "test_helper"

class ::Decor::Daisy::Forms::FormChildTest < ActiveSupport::TestCase
  class Probe < ::Decor::Daisy::Forms::FormChild
    def view_template
      root_element { plain "probe" }
    end

    public :label_left?, :label_right?, :label_inline?, :label_inside?, :label_top?, :grid_span_class
  end

  test "inherits from the Components FormChild abstract base" do
    assert ::Decor::Daisy::Forms::FormChild < ::Decor::Components::Forms::FormChild
  end

  test "defines no view_template of its own" do
    refute_includes ::Decor::Daisy::Forms::FormChild.instance_methods(false), :view_template
  end

  test "default label_position is :top" do
    probe = Probe.new
    assert probe.label_top?
    refute probe.label_left?
    refute probe.label_right?
    refute probe.label_inline?
    refute probe.label_inside?
  end

  test "label_position :left flips the corresponding predicate" do
    probe = Probe.new(label_position: :left)
    assert probe.label_left?
    refute probe.label_top?
  end

  test "label_position :right, :inline, :inside each flip exactly one predicate" do
    {
      right: :label_right?,
      inline: :label_inline?,
      inside: :label_inside?
    }.each do |position, predicate|
      probe = Probe.new(label_position: position)
      assert probe.public_send(predicate), "expected #{predicate} for label_position: #{position}"
      refute probe.label_top?, "label_top? should be false for label_position: #{position}"
    end
  end

  test "rejects unknown label_position values" do
    assert_raises(Literal::TypeError) do
      Probe.new(label_position: :diagonal)
    end
  end

  test "grid_span defaults to nil and yields an empty class list" do
    probe = Probe.new
    assert_nil probe.instance_variable_get(:@grid_span)
    assert_equal [], probe.grid_span_class
  end

  test "grid_span :span_half emits a half-width 6/3 col-span pair with decor: prefix" do
    classes = Probe.new(grid_span: :span_half).grid_span_class.join(" ")
    assert_includes classes, "decor:sm:col-span-6"
    assert_includes classes, "decor:lg:col-span-3"
  end

  test "grid_span :span_full spans the full grid on both breakpoints" do
    classes = Probe.new(grid_span: :span_full).grid_span_class.join(" ")
    assert_includes classes, "decor:sm:col-span-6"
    assert_includes classes, "decor:lg:col-span-6"
  end

  test "every grid_span option maps to a non-empty class list" do
    %i[span_1 span_2 span_half span_4 span_5 span_full].each do |span|
      classes = Probe.new(grid_span: span).grid_span_class
      refute_empty classes, "expected grid_span_class for #{span} to be non-empty"
      assert(classes.join(" ").include?("decor:"), "expected decor: prefix in classes for #{span}")
    end
  end

  test "concrete subclass renders without error" do
    html = render_component(Probe.new)
    assert_includes html, "probe"
  end
end
