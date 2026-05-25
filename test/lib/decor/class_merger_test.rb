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

  test "fuzz: same stripped-token N times survives at most once with last-occurrence prefix" do
    inputs = [
      ["decor:p-4 p-4 decor:p-4 p-4", false],
      ["p-4 decor:p-4 p-4 decor:p-4", true],
      ["decor:p-2 decor:p-4 p-8 decor:p-12", true]
    ]
    inputs.each do |input, expect_prefix|
      output = @merger.merge(input)
      occurrences = output.scan(/(?:decor:)?p-\d+/)
      assert_equal 1, occurrences.length, "expected exactly one padding token in #{output}"
      if expect_prefix
        assert output.split(/\s+/).any? { |t| t.start_with?("decor:") && t =~ /p-\d+\z/ },
          "expected last-occurrence prefix retained in #{output}"
      end
    end
  end
end
