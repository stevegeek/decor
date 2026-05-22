# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::EmptyStateTest < ActiveSupport::TestCase
  def base_attrs
    {
      icon_name: "database",
      title: "No data",
      description: "There is nothing to show yet."
    }
  end

  test "renders title in an h3 with the suite-section-title token" do
    html = render_component(::Decor::Suite::EmptyState.new(**base_attrs))
    assert_includes html, "<h3"
    assert_includes html, "decor:suite-section-title"
    assert_includes html, "No data"
  end

  test "renders description in a p with the suite-description token" do
    html = render_component(::Decor::Suite::EmptyState.new(**base_attrs))
    assert_includes html, "<p"
    assert_includes html, "decor:suite-description"
    assert_includes html, "There is nothing to show yet."
  end

  test "omits the description paragraph when description is blank" do
    html = render_component(
      ::Decor::Suite::EmptyState.new(**base_attrs.merge(description: ""))
    )
    refute_includes html, "decor:suite-description"
  end

  test "renders the named icon using the Tabler sprite with muted gray-400" do
    html = render_component(::Decor::Suite::EmptyState.new(**base_attrs))
    assert_includes html, "tabler-database"
    assert_includes html, "decor:text-gray-400"
    assert_includes html, "decor:mx-auto"
  end

  test "root element carries the Suite dashed-callout chrome" do
    html = render_component(::Decor::Suite::EmptyState.new(**base_attrs))
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:border-dashed"
    assert_includes html, "decor:rounded-suite-card"
  end

  test "root element hover darkens to hairline-strong with suite-fast transition" do
    html = render_component(::Decor::Suite::EmptyState.new(**base_attrs))
    assert_includes html, "decor:hover:border-suite-hairline-strong"
    assert_includes html, "decor:duration-suite-fast"
  end

  test "renders no action buttons when neither action is configured" do
    html = render_component(::Decor::Suite::EmptyState.new(**base_attrs))
    refute_includes html, "<a "
  end

  test "renders a single primary action button when only primary is configured" do
    html = render_component(::Decor::Suite::EmptyState.new(
      **base_attrs.merge(
        primary_action_label: "Create item",
        primary_action_href: "/items/new"
      )
    ))
    frag = Nokogiri::HTML5.fragment(html)
    links = frag.css("a")
    assert_equal 1, links.length
    assert_equal "/items/new", links.first["href"]
    assert_includes links.first.text, "Create item"
  end

  test "primary action uses the suite-primary filled palette" do
    html = render_component(::Decor::Suite::EmptyState.new(
      **base_attrs.merge(
        primary_action_label: "Create item",
        primary_action_href: "/items/new"
      )
    ))
    assert_includes html, "decor:bg-suite-primary-500"
    assert_includes html, "decor:text-white"
  end

  test "renders both action buttons with secondary before primary in DOM order" do
    html = render_component(::Decor::Suite::EmptyState.new(
      **base_attrs.merge(
        primary_action_label: "Create item",
        primary_action_href: "/items/new",
        secondary_action_label: "Import",
        secondary_action_href: "/items/import"
      )
    ))
    frag = Nokogiri::HTML5.fragment(html)
    links = frag.css("a")
    assert_equal 2, links.length
    assert_equal "/items/import", links.first["href"]
    assert_equal "/items/new", links.last["href"]
  end

  test "secondary action uses the outlined Suite style" do
    html = render_component(::Decor::Suite::EmptyState.new(
      **base_attrs.merge(
        primary_action_label: "Create item",
        primary_action_href: "/items/new",
        secondary_action_label: "Import",
        secondary_action_href: "/items/import"
      )
    ))
    assert_includes html, "decor:border-suite-hairline-strong"
  end

  test "action row is a flex container with centered alignment and gap" do
    html = render_component(::Decor::Suite::EmptyState.new(
      **base_attrs.merge(
        primary_action_label: "Go",
        primary_action_href: "/go"
      )
    ))
    assert_includes html, "decor:flex"
    assert_includes html, "decor:justify-center"
    assert_includes html, "decor:gap-2"
  end

  test "every Tailwind class on the rendered output carries the decor: prefix" do
    html = render_component(::Decor::Suite::EmptyState.new(
      **base_attrs.merge(
        primary_action_label: "Go",
        primary_action_href: "/go",
        secondary_action_label: "Skip",
        secondary_action_href: "/skip"
      )
    ))
    frag = Nokogiri::HTML5.fragment(html)
    frag.css("[class]").each do |node|
      classes = node["class"].to_s.split(/\s+/).reject(&:empty?)
      offenders = classes.reject do |c|
        c.start_with?("decor:") || c.start_with?("decor--")
      end
      assert_empty offenders,
        "Expected every utility class to carry the decor: prefix on <#{node.name}>, " \
        "but found: #{offenders.inspect}"
    end
  end
end
