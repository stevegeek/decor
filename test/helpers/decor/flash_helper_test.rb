# frozen_string_literal: true

require "test_helper"

class ::Decor::FlashHelperTest < ActionView::TestCase
  include ::Decor::FlashHelper

  setup do
    @original_skin = ::Decor.default_skin
  end

  teardown do
    ::Decor.default_skin = @original_skin
  end

  test "renders Daisy skin when default_skin is :daisy" do
    ::Decor.default_skin = :daisy
    html = decor_flash(title: "T", text: "X").to_s
    assert_match(/decor:d-alert/, html)
  end

  test "renders Suite skin when default_skin is :suite" do
    ::Decor.default_skin = :suite
    html = decor_flash(title: "T", text: "X").to_s
    assert_match(/decor:bg-info\/10/, html)
  end

  test "explicit skin: param overrides default" do
    ::Decor.default_skin = :daisy
    html = decor_flash(skin: :suite, title: "T", text: "X").to_s
    assert_match(/decor:bg-info\/10/, html)
  end

  test "raises on unknown skin" do
    assert_raises(ArgumentError) { decor_flash(skin: :unknown, title: "T", text: "X") }
  end
end
