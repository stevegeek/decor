# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::SettingsList::GroupTest < ActiveSupport::TestCase
  Group = ::Decor::Suite::SettingsList::Group
  Row = ::Decor::Components::SettingsList::Row

  test "is a Literal::Data subclass" do
    assert Group < ::Literal::Data
  end

  test "requires a name" do
    assert_raises(ArgumentError) { Group.new }
  end

  test "constructs with only a name and defaults the rest" do
    group = Group.new(name: "Pricing")
    assert_equal "Pricing", group.name
    assert_nil group.icon
    assert_nil group.description
    assert_equal [], group.rows
  end

  test "accepts an icon name" do
    group = Group.new(name: "Pricing", icon: "currency-dollar")
    assert_equal "currency-dollar", group.icon
  end

  test "accepts a description" do
    group = Group.new(name: "Pricing", description: "Tax and currency setup")
    assert_equal "Tax and currency setup", group.description
  end

  test "accepts an array of Row instances" do
    rows = [
      Row.new(title: "Tax rate", value: "10%", active: true),
      Row.new(title: "Currency", value: "USD", active: true)
    ]
    group = Group.new(name: "Pricing", rows: rows)
    assert_equal 2, group.rows.size
    assert_equal "Tax rate", group.rows.first.title
  end

  test "rejects non-Row entries in rows" do
    assert_raises(Literal::TypeError) do
      Group.new(name: "Bad", rows: [{title: "Not a Row"}])
    end
  end

  test "rejects a non-String name" do
    assert_raises(Literal::TypeError) { Group.new(name: 123) }
  end

  test "is namespaced under Decor::Suite::SettingsList" do
    assert_equal "Decor::Suite::SettingsList::Group", Group.name
  end
end
