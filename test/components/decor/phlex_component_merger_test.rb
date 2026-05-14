# frozen_string_literal: true

require "test_helper"

class Decor::PhlexComponentMergerTest < ActiveSupport::TestCase
  test "Decor components use Decor::ClassMerger" do
    component = Decor::Components::Button.new(label: "x")
    merger = component.send(:tailwind_merger)
    assert_instance_of Decor::ClassMerger, merger
  end
end
