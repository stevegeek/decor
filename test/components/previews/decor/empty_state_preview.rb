# frozen_string_literal: true

class Decor::EmptyStatePreview < Lookbook::Preview
  # @param icon_name text
  # @param title text
  # @param description text
  # @param primary_action_label text
  # @param primary_action_href text
  # @param secondary_action_label text
  # @param secondary_action_href text
  def default(
    icon_name: "inbox",
    title: "No items found",
    description: "There are no items to display at the moment. Try creating a new item or adjusting your filters.",
    primary_action_label: "Create New Item",
    primary_action_href: "#",
    secondary_action_label: "Clear Filters",
    secondary_action_href: "#"
  )
    render Decor::EmptyState.new(
      icon_name: icon_name,
      title: title,
      description: description,
      primary_action_label: primary_action_label,
      primary_action_href: primary_action_href,
      secondary_action_label: secondary_action_label,
      secondary_action_href: secondary_action_href
    )
  end

  # @!group States
  def no_secondary_action
    render Decor::EmptyState.new(
      icon_name: "check-circle",
      title: "All tasks completed",
      description: "Great job! You've completed all your tasks.",
      primary_action_label: "Add New Task",
      primary_action_href: "#"
    )
  end

  def search_results
    render Decor::EmptyState.new(
      icon_name: "magnifying-glass",
      title: "No search results",
      description: "We couldn't find any items matching your search criteria. Try adjusting your search terms.",
      primary_action_label: "Clear Search",
      primary_action_href: "#",
      secondary_action_label: "Browse All",
      secondary_action_href: "#"
    )
  end

  def error_state
    render Decor::EmptyState.new(
      icon_name: "exclamation-triangle",
      title: "Unable to load data",
      description: "There was an error loading your data. Please try again or contact support.",
      primary_action_label: "Retry",
      primary_action_href: "#",
      secondary_action_label: "Contact Support",
      secondary_action_href: "#"
    )
  end
  # @!endgroup
end
