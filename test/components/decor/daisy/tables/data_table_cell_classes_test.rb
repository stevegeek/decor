# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::Tables::DataTableCellClassesTest < ActiveSupport::TestCase
  # Minimal host that exposes the mixin's private API via the @ivars the
  # module reads on its including class.
  class Host
    include ::Decor::Daisy::Tables::DataTableCellClasses

    def initialize(color: nil, emphasis: :regular, weight: :regular, row_height: :standard, numeric: false)
      @color = color
      @emphasis = emphasis
      @weight = weight
      @row_height = row_height
      @numeric = numeric
    end
  end

  test "daisyui_color_class is nil for base/no color" do
    assert_nil Host.new.daisyui_color_class
    assert_nil Host.new(color: :base).daisyui_color_class
  end

  test "daisyui_color_class maps each daisyUI semantic color" do
    {
      primary: "decor:text-primary",
      secondary: "decor:text-secondary",
      accent: "decor:text-accent",
      neutral: "decor:text-neutral",
      info: "decor:text-info",
      success: "decor:text-success",
      warning: "decor:text-warning",
      error: "decor:text-error"
    }.each do |color, klass|
      assert_equal klass, Host.new(color: color).daisyui_color_class
    end
  end

  test "typography_classes uses gray-900 for regular emphasis when no daisy color" do
    classes = Host.new(emphasis: :regular).typography_classes
    assert_includes classes, "decor:text-gray-900"
  end

  test "typography_classes uses gray-500 for low emphasis when no daisy color" do
    classes = Host.new(emphasis: :low).typography_classes
    assert_includes classes, "decor:text-gray-500"
  end

  test "typography_classes drops the gray fallback when a daisy color is set" do
    classes = Host.new(color: :primary, emphasis: :low).typography_classes
    refute_includes classes, "decor:text-gray-500"
    assert_includes classes, "decor:text-primary"
  end

  test "weight :light adds font-light, :medium adds font-medium, :regular adds font-normal" do
    assert_includes Host.new(weight: :light).typography_classes, "decor:font-light"
    assert_includes Host.new(weight: :medium).typography_classes, "decor:font-medium"
    assert_includes Host.new(weight: :regular).typography_classes, "decor:font-normal"
  end

  test "row_height_classes: :tight uses px-3 py-1 text-xs" do
    assert_equal "decor:px-3 decor:py-1 decor:text-xs", Host.new(row_height: :tight).row_height_classes
  end

  test "row_height_classes: :comfortable uses px-4 py-4 text-sm" do
    assert_equal "decor:px-4 decor:py-4 decor:text-sm", Host.new(row_height: :comfortable).row_height_classes
  end

  test "row_height_classes: :standard (default) uses px-3 py-2 text-sm" do
    assert_equal "decor:px-3 decor:py-2 decor:text-sm", Host.new(row_height: :standard).row_height_classes
  end

  test "row_height_classes returns the standard fallback for an unknown value" do
    assert_equal "decor:px-3 decor:py-2 decor:text-sm", Host.new(row_height: :nonsense).row_height_classes
  end
end
