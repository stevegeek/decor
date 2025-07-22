# @label EmptyState
class ::Decor::EmptyStatePreview < ::Lookbook::Preview
  # EmptyState
  # ----------
  #
  # An empty state component for displaying when there's no content to show.
  # Typically includes an icon, title, description, and optional action buttons.
  # Used for search results, empty lists, error states, and success confirmations.
  #
  # @group Examples
  # @label No Items Found
  def no_items_found
    render ::Decor::EmptyState.new(
      icon_name: "inbox",
      title: "No items found",
      description: "There are no items to display at the moment.",
      primary_action_label: "Create New Item",
      primary_action_href: "#"
    )
  end

  # @group Examples
  # @label Search Results Empty
  def search_results_empty
    render ::Decor::EmptyState.new(
      icon_name: "magnifying-glass",
      title: "No search results",
      description: "We couldn't find any items matching your search criteria.",
      primary_action_label: "Clear Search",
      primary_action_href: "#",
      secondary_action_label: "Browse All",
      secondary_action_href: "#"
    )
  end

  # @group Examples
  # @label Success State
  def success_state
    render ::Decor::EmptyState.new(
      icon_name: "check-circle",
      title: "All tasks completed",
      description: "Great job! You've completed all your tasks.",
      primary_action_label: "Add New Task",
      primary_action_href: "#"
    )
  end

  # @group Playground
  # @param icon_name text
  # @param title text
  # @param description text
  # @param primary_action_label text
  # @param primary_action_href text
  # @param secondary_action_label text
  # @param secondary_action_href text
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(
    icon_name: "inbox",
    title: "No items found",
    description: "There are no items to display at the moment. Try creating a new item or adjusting your filters.",
    primary_action_label: "Create New Item",
    primary_action_href: "#",
    secondary_action_label: "Clear Filters",
    secondary_action_href: "#",
    size: nil,
    color: nil,
    style: nil
  )
    render ::Decor::EmptyState.new(
      icon_name: icon_name,
      title: title,
      description: description,
      primary_action_label: primary_action_label,
      primary_action_href: primary_action_href,
      secondary_action_label: secondary_action_label,
      secondary_action_href: secondary_action_href,
      size: size,
      color: color,
      style: style
    )
  end

  # @group States
  # @label Error State
  def error_state
    render ::Decor::EmptyState.new(
      icon_name: "exclamation-triangle",
      title: "Unable to load data",
      description: "There was an error loading your data. Please try again or contact support.",
      primary_action_label: "Retry",
      primary_action_href: "#",
      secondary_action_label: "Contact Support",
      secondary_action_href: "#"
    )
  end

  # @group States
  # @label No Network Connection
  def no_network
    render ::Decor::EmptyState.new(
      icon_name: "wifi",
      title: "No internet connection",
      description: "Please check your internet connection and try again.",
      primary_action_label: "Retry",
      primary_action_href: "#"
    )
  end

  # @group States
  # @label Access Denied
  def access_denied
    render ::Decor::EmptyState.new(
      icon_name: "lock-closed",
      title: "Access denied",
      description: "You don't have permission to view this content.",
      primary_action_label: "Request Access",
      primary_action_href: "#",
      secondary_action_label: "Go Back",
      secondary_action_href: "#"
    )
  end

  # @group States
  # @label Coming Soon
  def coming_soon
    render ::Decor::EmptyState.new(
      icon_name: "clock",
      title: "Coming soon",
      description: "This feature is under development and will be available soon.",
      primary_action_label: "Get Notified",
      primary_action_href: "#"
    )
  end

  # @group Variations
  # @label No Secondary Action
  def no_secondary_action
    render ::Decor::EmptyState.new(
      icon_name: "folder-open",
      title: "Folder is empty",
      description: "This folder doesn't contain any files yet.",
      primary_action_label: "Upload Files",
      primary_action_href: "#"
    )
  end

  # @group Variations
  # @label No Actions
  def no_actions
    render ::Decor::EmptyState.new(
      icon_name: "information-circle",
      title: "No data available",
      description: "There is no data to display for the selected time period."
    )
  end

  # @group Variations
  # @label Long Description
  def long_description
    render ::Decor::EmptyState.new(
      icon_name: "document-text",
      title: "No documents found",
      description: "We couldn't find any documents in your account. Documents help you organize and share important information with your team. You can upload PDFs, Word documents, spreadsheets, and more.",
      primary_action_label: "Upload Document",
      primary_action_href: "#",
      secondary_action_label: "Learn More",
      secondary_action_href: "#"
    )
  end
end
