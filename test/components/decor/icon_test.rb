# frozen_string_literal: true

require "test_helper"

class Decor::IconTest < ActiveSupport::TestCase
  test "renders <svg> with <use> reference to tabler-outline sprite by default" do
    rendered = render_component(Decor::Icon.new(name: "copy"))
    assert_includes rendered, "<svg"
    assert_includes rendered, "tabler-outline"
    assert_includes rendered, "#tabler-copy"
  end

  test ":style :solid produces filled sprite reference when filled exists" do
    rendered = render_component(Decor::Icon.new(name: "copy", style: :solid))
    if Decor::Icon::TABLER_FILLED_ICONS.include?("copy")
      assert_includes rendered, "tabler-filled"
      assert_includes rendered, "#tabler-filled-copy"
    else
      assert_includes rendered, "tabler-outline"
    end
  end

  test ":style :solid falls back to :outline when filled variant absent" do
    fake_name = "definitely-not-a-real-tabler-icon-name"
    rendered = render_component(Decor::Icon.new(name: fake_name, style: :solid))
    assert_includes rendered, "tabler-outline"
    assert_includes rendered, "#tabler-#{fake_name}"
  end

  test ":sprite :decor uses the decor sprite path" do
    rendered = render_component(Decor::Icon.new(name: "check-tick", sprite: :decor, view_box: "0 0 12 10"))
    assert_includes rendered, "sprites/decor"
    assert_includes rendered, "#decor-check-tick"
  end

  test ":view_box override applied" do
    rendered = render_component(Decor::Icon.new(name: "x", view_box: "0 0 16 16"))
    assert_includes rendered, 'viewBox="0 0 16 16"'
  end

  test ":title prop sets svg title attribute" do
    rendered = render_component(Decor::Icon.new(name: "x", title: "Close"))
    assert_includes rendered, 'title="Close"'
  end

  test "outline variant uses stroke" do
    rendered = render_component(Decor::Icon.new(name: "x", style: :outline))
    assert_includes rendered, 'stroke="currentColor"'
    assert_includes rendered, "stroke-width"
  end

  test "filled variant uses fill or falls back to outline stroke" do
    rendered = render_component(Decor::Icon.new(name: "x", style: :solid))
    assert(rendered.include?('fill="currentColor"') || rendered.include?('stroke="currentColor"'))
  end
end
