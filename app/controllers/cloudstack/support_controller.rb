class Cloudstack::SupportController < ApplicationController
  # Support center overview
  def index
    @ticket_summary = mock_ticket_summary
    @popular_articles = mock_popular_articles
    @system_status = mock_system_status
  end
  
  # Show documentation
  def docs
    @doc_categories = mock_doc_categories
    @featured_guides = mock_featured_guides
  end
  
  # Support tickets list with DataTableBuilder
  def tickets
    # TODO: Implement DataTableBuilder for support tickets
    @tickets = mock_support_tickets
  end
  
  # Show individual ticket
  def show_ticket
    @ticket = mock_ticket_detail(params[:id])
    @ticket_messages = mock_ticket_messages(params[:id])
  end
  
  # Create new support ticket
  def new_ticket
    # TODO: Implement ticket creation form
  end
  
  # Handle ticket creation
  def create_ticket
    # TODO: Implement ticket creation logic
    flash[:notice] = "Support ticket created successfully"
    redirect_to cloudstack_support_tickets_path
  end
  
  # Add message to ticket
  def add_message
    # TODO: Implement message addition
    flash[:notice] = "Message added to ticket"
    redirect_to cloudstack_support_ticket_path(params[:ticket_id])
  end
  
  private
  
  def mock_ticket_summary
    {
      open: 2,
      in_progress: 1,
      waiting_customer: 0,
      resolved: 5
    }
  end
  
  def mock_popular_articles
    [
      { title: "Getting Started with CloudStack Pro", views: 1250 },
      { title: "How to Configure Auto-Scaling", views: 890 },
      { title: "Understanding Billing and Usage", views: 745 },
      { title: "Security Best Practices", views: 623 },
      { title: "Backup and Recovery Guide", views: 567 }
    ]
  end
  
  def mock_system_status
    {
      overall_status: "operational",
      services: [
        { name: "Compute API", status: "operational" },
        { name: "Storage Service", status: "operational" },
        { name: "Network Gateway", status: "operational" },
        { name: "Billing System", status: "degraded_performance" }
      ]
    }
  end
  
  def mock_doc_categories
    [
      { name: "Getting Started", article_count: 12 },
      { name: "Instance Management", article_count: 23 },
      { name: "Networking", article_count: 18 },
      { name: "Security", article_count: 15 },
      { name: "Billing & Usage", article_count: 9 },
      { name: "API Reference", article_count: 45 }
    ]
  end
  
  def mock_featured_guides
    [
      { title: "Complete Setup Guide", description: "Step-by-step guide to get your first instance running" },
      { title: "Production Deployment", description: "Best practices for deploying to production" },
      { title: "Cost Optimization", description: "Tips to reduce your cloud infrastructure costs" }
    ]
  end
  
  def mock_support_tickets
    [
      {
        id: "TKT-001",
        subject: "Instance not starting after reboot",
        status: "open",
        priority: "high",
        category: "technical",
        created_at: 2.hours.ago,
        updated_at: 1.hour.ago,
        unread_by_customer: true
      },
      {
        id: "TKT-002", 
        subject: "Billing discrepancy in November invoice",
        status: "in_progress",
        priority: "medium",
        category: "billing",
        created_at: 1.day.ago,
        updated_at: 4.hours.ago,
        unread_by_customer: false
      },
      {
        id: "TKT-003",
        subject: "Feature request: IPv6 support",
        status: "resolved",
        priority: "low",
        category: "feature_request",
        created_at: 1.week.ago,
        updated_at: 2.days.ago,
        unread_by_customer: false
      }
    ]
  end
  
  def mock_ticket_detail(id)
    mock_support_tickets.find { |t| t[:id] == id } || mock_support_tickets.first
  end
  
  def mock_ticket_messages(ticket_id)
    [
      {
        author: "John Doe",
        author_type: "customer",
        content: "My instance i-1234567890abcdef0 won't start after I rebooted it this morning. It's stuck in 'pending' state.",
        created_at: 2.hours.ago
      },
      {
        author: "Support Team",
        author_type: "support",
        content: "Hi John, thanks for reaching out. I can see the instance in our system. Let me check the underlying host status and get back to you shortly.",
        created_at: 1.hour.ago
      }
    ]
  end
end