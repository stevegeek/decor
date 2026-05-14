# frozen_string_literal: true

require "test_helper"

class Decor::Suite::SpinnerTest < ActiveSupport::TestCase
  test "inherits Decor::Daisy::Spinner" do
    assert_operator Decor::Suite::Spinner, :<, Decor::Daisy::Spinner
  end

  test "renders daisyUI spinner classes" do
    rendered = render_component(Decor::Suite::Spinner.new)
    assert_includes rendered, "loading"
    assert_includes rendered, "loading-spinner"
  end
end
