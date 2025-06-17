class Cloudstack::BillingController < ApplicationController
  # Show billing overview
  def index
    @current_period = mock_current_period
    @usage_summary = mock_usage_summary
    @recent_invoices = mock_recent_invoices
  end
  
  # Show detailed usage analytics
  def usage
    @usage_data = mock_detailed_usage
    @cost_breakdown = mock_cost_breakdown
  end
  
  # Show billing history with DataTableBuilder
  def history
    # TODO: Implement DataTableBuilder for billing history
    @invoices = mock_invoice_history
  end
  
  # Download invoice
  def download_invoice
    invoice_id = params[:id]
    # TODO: Implement actual invoice generation/download
    flash[:notice] = "Invoice #{invoice_id} download started"
    redirect_to cloudstack_billing_index_path
  end
  
  private
  
  def mock_current_period
    {
      period: "December 2024",
      current_charges: 234.56,
      projected_total: 280.00,
      usage_percentage: 78,
      days_remaining: 6
    }
  end
  
  def mock_usage_summary
    {
      compute: { cost: 156.80, percentage: 67 },
      storage: { cost: 45.20, percentage: 19 },
      network: { cost: 23.40, percentage: 10 },
      other: { cost: 9.16, percentage: 4 }
    }
  end
  
  def mock_recent_invoices
    [
      { id: "INV-2024-11", amount: 267.89, status: "paid", date: 1.month.ago },
      { id: "INV-2024-10", amount: 245.67, status: "paid", date: 2.months.ago },
      { id: "INV-2024-09", amount: 289.34, status: "paid", date: 3.months.ago }
    ]
  end
  
  def mock_detailed_usage
    {
      daily_costs: (1..30).map { |day| { date: day.days.ago.to_date, cost: rand(5.0..15.0).round(2) } },
      instance_costs: [
        { name: "web-server-01", cost: 89.50, percentage: 38 },
        { name: "database-primary", cost: 67.30, percentage: 29 },
        { name: "background-worker", cost: 45.20, percentage: 19 },
        { name: "backup-storage", cost: 32.56, percentage: 14 }
      ]
    }
  end
  
  def mock_cost_breakdown
    {
      compute_hours: { quantity: 720, unit_cost: 0.0464, total: 33.41 },
      storage_gb: { quantity: 500, unit_cost: 0.10, total: 50.00 },
      data_transfer: { quantity: 1024, unit_cost: 0.09, total: 92.16 },
      snapshots: { quantity: 15, unit_cost: 0.05, total: 0.75 }
    }
  end
  
  def mock_invoice_history
    (1..24).map do |month|
      date = month.months.ago
      {
        id: "INV-#{date.strftime('%Y-%m')}",
        invoice_number: "INV-#{date.strftime('%Y%m')}-#{rand(1000..9999)}",
        invoice_date: date.end_of_month,
        total_amount: rand(200.0..350.0).round(2),
        payment_status: ['paid', 'pending', 'overdue'].sample,
        description: "Monthly cloud services for #{date.strftime('%B %Y')}"
      }
    end
  end
end