# frozen_string_literal: true

require "test_helper"
require "decor/class_merger"

class Decor::ClassMergerTest < ActiveSupport::TestCase
  setup { @merger = Decor::ClassMerger.new(prefix: "decor:") }

  test "consumer unprefixed overrides gem default" do
    assert_equal "decor:m-4 p-8", @merger.merge("decor:m-4 decor:p-4 p-8")
  end

  test "both prefixed: last wins; prefix retained" do
    assert_equal "decor:p-8", @merger.merge("decor:p-4 decor:p-8")
  end

  test "mixed input: last wins" do
    assert_equal "decor:p-8", @merger.merge("p-4 decor:p-8")
  end

  test "variant-aware merging" do
    assert_equal "hover:p-8", @merger.merge("decor:hover:p-4 hover:p-8")
  end

  test "daisyUI classes pass through both surviving" do
    result = @merger.merge("decor:d-btn decor:d-btn-primary")
    assert_includes result, "decor:d-btn"
    assert_includes result, "decor:d-btn-primary"
  end

  test "empty string no-op" do
    assert_equal "", @merger.merge("")
  end

  test "nil no-op" do
    assert_nil @merger.merge(nil)
  end

  test "single token unchanged" do
    assert_equal "decor:p-4", @merger.merge("decor:p-4")
  end
end
