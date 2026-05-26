require "test_helper"
require "capybara/cuprite"

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [1400, 1400],
    headless: ENV["HEADLESS"] != "false",
    process_timeout: 30,
    timeout: 30,
    js_errors: false
  )
end

Capybara.default_max_wait_time = 5

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :cuprite

  # Helper: the recorded event types in #event-log, in order.
  def event_log
    all("#event-log li").map { |li| li["data-event"] }
  end
end
