class Cloudstack::ProfileController < ApplicationController
  # Show user profile
  def show
    @user = mock_user
    @account_activity = mock_account_activity
  end
  
  # Edit user profile
  def edit
    @user = mock_user
  end
  
  # Update user profile
  def update
    # TODO: Implement profile update logic
    flash[:notice] = "Profile updated successfully"
    redirect_to cloudstack_profile_path
  end
  
  private
  
  def mock_user
    {
      id: 1,
      name: "John Doe",
      email: "john.doe@company.com",
      role: "Administrator",
      account_tier: "Pro",
      avatar_url: "/images/pic.jpg",
      timezone: "UTC",
      notification_preferences: {
        email_alerts: true,
        sms_alerts: false,
        desktop_notifications: true
      },
      api_keys: [
        { name: "Production API", key: "ak_prod_1234567890abcdef", created_at: 1.month.ago },
        { name: "Development API", key: "ak_dev_0987654321fedcba", created_at: 2.weeks.ago }
      ]
    }
  end
  
  def mock_account_activity
    [
      { action: "Login from new device", ip: "203.0.113.1", time: 2.hours.ago },
      { action: "API key generated", details: "Development API", time: 2.weeks.ago },
      { action: "Password changed", details: nil, time: 1.month.ago },
      { action: "2FA enabled", details: nil, time: 2.months.ago }
    ]
  end
end