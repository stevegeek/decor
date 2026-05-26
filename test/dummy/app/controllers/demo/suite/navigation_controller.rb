class Demo::Suite::NavigationController < ApplicationController
  layout "demo"

  def index
    # No-flash restore: render the rail already collapsed (and shift the page
    # content) when the persisted cookie says so.
    @collapsed = cookies[:decor_side_navbar_collapsed] == "true"
  end
end
