# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::SettingsList::ScopeInfoTest < ActiveSupport::TestCase
  ScopeInfo = ::Decor::Suite::SettingsList::ScopeInfo

  test "is a Literal::Data subclass" do
    assert ScopeInfo < ::Literal::Data
  end

  test "requires a label and tooltip" do
    assert_raises(ArgumentError) { ScopeInfo.new }
    assert_raises(ArgumentError) { ScopeInfo.new(label: "From parent") }
    assert_raises(ArgumentError) { ScopeInfo.new(tooltip: "Inherited") }
  end

  test "constructs with label and tooltip and defaults link_path to nil" do
    scope = ScopeInfo.new(label: "From parent", tooltip: "Inherited from parent catalog")
    assert_equal "From parent", scope.label
    assert_equal "Inherited from parent catalog", scope.tooltip
    assert_nil scope.link_path
  end

  test "accepts an optional link_path" do
    scope = ScopeInfo.new(label: "From parent", tooltip: "Inherited", link_path: "/parent")
    assert_equal "/parent", scope.link_path
  end

  test "rejects a non-String label" do
    assert_raises(Literal::TypeError) { ScopeInfo.new(label: 1, tooltip: "ok") }
  end

  test "rejects a non-String tooltip" do
    assert_raises(Literal::TypeError) { ScopeInfo.new(label: "ok", tooltip: 1) }
  end

  test "rejects a non-String link_path when supplied" do
    assert_raises(Literal::TypeError) do
      ScopeInfo.new(label: "ok", tooltip: "ok", link_path: 42)
    end
  end

  test "is namespaced under Decor::Suite::SettingsList" do
    assert_equal "Decor::Suite::SettingsList::ScopeInfo", ScopeInfo.name
  end
end
