class CloudstackController < ApplicationController
  # Main dashboard showing system overview, metrics, and activity
  def dashboard
    # TODO: Add real data loading
    @metrics = {
      active_instances: 12,
      cpu_usage: 68,
      memory_usage: 45,
      monthly_cost: 234.56
    }
    
    @recent_activities = [
      { action: "Instance created", instance: "web-server-01", time: "2 minutes ago" },
      { action: "Instance stopped", instance: "background-worker", time: "1 hour ago" },
      { action: "Backup completed", instance: "database-primary", time: "3 hours ago" }
    ]
  end
end