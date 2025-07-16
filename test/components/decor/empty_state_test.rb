# frozen_string_literal: true

require "test_helper"

class Decor::EmptyStateTest < ActiveSupport::TestCase
  def test_renders_with_all_required_props
    component = Decor::EmptyState.new(
      icon_name: "inbox",
      title: "No messages",
      description: "You don't have any messages yet",
      primary_action_label: "Send a message",
      primary_action_href: "/messages/new"
    )

    rendered = render_fragment(component)

    # Check icon is rendered
    icon = rendered.css("svg").first
    assert icon
    assert_includes rendered.to_html, "inbox"

    # Check title
    title = rendered.css("h3").first
    assert title
    assert_equal "No messages", title.text

    # Check description
    description = rendered.css("p").first
    assert description
    assert_equal "You don't have any messages yet", description.text

    # Check primary action button
    primary_button = rendered.css("a").first
    assert primary_button
    assert_includes primary_button.text, "Send a message"
    assert_equal "/messages/new", primary_button["href"]
  end

  def test_renders_with_secondary_action
    component = Decor::EmptyState.new(
      icon_name: "document",
      title: "No documents",
      description: "Start by creating your first document",
      primary_action_label: "Create document",
      primary_action_href: "/documents/new",
      secondary_action_label: "Import existing",
      secondary_action_href: "/documents/import"
    )

    rendered = render_fragment(component)

    # Should have two action buttons
    buttons = rendered.css("a")
    assert_equal 2, buttons.length

    # Check secondary action (should be first in DOM)
    secondary_button = buttons.first
    assert_includes secondary_button.text, "Import existing"
    assert_equal "/documents/import", secondary_button["href"]
    assert_includes secondary_button["class"], "btn-outline"

    # Check primary action
    primary_button = buttons.last
    assert_includes primary_button.text, "Create document"
    assert_equal "/documents/new", primary_button["href"]
    assert_includes primary_button["class"], "btn-primary"
  end

  def test_renders_without_secondary_action
    component = Decor::EmptyState.new(
      icon_name: "users",
      title: "No team members",
      description: "Invite people to collaborate",
      primary_action_label: "Invite members",
      primary_action_href: "/team/invite"
    )

    rendered = render_fragment(component)

    # Should only have one action button
    buttons = rendered.css("a")
    assert_equal 1, buttons.length

    # Check it's the primary action
    primary_button = buttons.first
    assert_includes primary_button.text, "Invite members"
    assert_includes primary_button["class"], "btn-primary"
  end

  def test_applies_correct_classes
    component = Decor::EmptyState.new(
      icon_name: "star",
      title: "No favorites",
      description: "Star items to access them quickly",
      primary_action_label: "Browse items",
      primary_action_href: "/items"
    )

    rendered = render_fragment(component)

    # Check root element has correct classes
    root = rendered.children.first
    assert_includes root["class"], "text-center"
    assert_includes root["class"], "py-12"
  end

  def test_icon_has_correct_size_and_styling
    component = Decor::EmptyState.new(
      icon_name: "bell",
      title: "No notifications",
      description: "You're all caught up!",
      primary_action_label: "Go to dashboard",
      primary_action_href: "/dashboard"
    )

    rendered = render_fragment(component)

    # Icon should have xl size and specific styling classes
    assert_includes rendered.to_html, "text-base-content/60"
    assert_includes rendered.to_html, "mx-auto"
    assert_includes rendered.to_html, "mb-4"
  end

  def test_text_styling_classes
    component = Decor::EmptyState.new(
      icon_name: "search",
      title: "No results found",
      description: "Try adjusting your search criteria",
      primary_action_label: "Clear filters",
      primary_action_href: "/search"
    )

    rendered = render_fragment(component)

    # Check title styling
    title = rendered.css("h3").first
    assert_includes title["class"], "text-lg"
    assert_includes title["class"], "font-semibold"
    assert_includes title["class"], "text-base-content"
    assert_includes title["class"], "mb-2"

    # Check description styling
    description = rendered.css("p").first
    assert_includes description["class"], "text-base-content/70"
    assert_includes description["class"], "mb-6"
  end

  def test_action_buttons_layout
    component = Decor::EmptyState.new(
      icon_name: "folder",
      title: "Empty folder",
      description: "This folder doesn't contain any files",
      primary_action_label: "Upload files",
      primary_action_href: "/upload",
      secondary_action_label: "Create folder",
      secondary_action_href: "/folders/new"
    )

    rendered = render_fragment(component)

    # Check buttons are in a flex container
    button_container = rendered.css("div").select { |div| div["class"]&.include?("flex") }.first
    assert button_container
    assert_includes button_container["class"], "flex"
    assert_includes button_container["class"], "justify-center"
    assert_includes button_container["class"], "gap-4"
  end
end