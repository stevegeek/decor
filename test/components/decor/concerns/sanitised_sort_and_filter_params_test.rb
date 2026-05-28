require "test_helper"

class Decor::SanitisedSortAndFilterParamsTest < ActiveSupport::TestCase
  class TestSortComponent < Decor::PhlexComponent
    include Decor::Concerns::SanitisedSortAndFilterParams

    no_stimulus_controller

    prop :test_sorting_keys, _Array(Symbol), default: -> { [] }
    prop :test_default_sort_by, _Nilable(Symbol)

    def sorting_keys
      @test_sorting_keys
    end

    def default_sort_by
      @test_default_sort_by
    end
  end

  test "returns sort_by when it is in sorting_keys" do
    component = TestSortComponent.new(
      sort_by: :name,
      test_sorting_keys: [:name, :email]
    )
    assert_equal :name, component.send(:sanitised_sort_by)
  end

  test "returns nil when sort_by is not in sorting_keys" do
    component = TestSortComponent.new(
      sort_by: :unknown,
      test_sorting_keys: [:name, :email]
    )
    assert_nil component.send(:sanitised_sort_by)
  end

  test "falls back to default_sort_by when sort_by is nil" do
    component = TestSortComponent.new(
      test_sorting_keys: [:name, :email],
      test_default_sort_by: :name
    )
    assert_equal :name, component.send(:sanitised_sort_by)
  end

  test "returns nil when sort_by and default_sort_by are both nil" do
    component = TestSortComponent.new(
      test_sorting_keys: [:name, :email]
    )
    assert_nil component.send(:sanitised_sort_by)
  end

  test "returns nil when default_sort_by is not in sorting_keys" do
    component = TestSortComponent.new(
      test_sorting_keys: [:name, :email],
      test_default_sort_by: :unknown
    )
    assert_nil component.send(:sanitised_sort_by)
  end

  test "regression: sorting_keys method on includer is consulted, not the deleted @sorting_keys ivar" do
    component = TestSortComponent.new(
      sort_by: :name,
      test_sorting_keys: [:name]
    )
    refute_includes component.instance_variables, :@sorting_keys
    assert_equal :name, component.send(:sanitised_sort_by)
  end
end
