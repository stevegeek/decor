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

  # System tests drive a real browser against an in-process Puma server that
  # uses its own DB connection. Transactional fixtures are NOT visible to that
  # connection (the browser sees an empty table), and rows the browser creates
  # are committed rather than rolled back — so they would leak across tests.
  # We therefore disable the wrapping transaction and clear the table before
  # each test; every system test creates whatever data it needs through the UI.
  self.use_transactional_tests = false

  setup { Todo.delete_all }

  # Helper: the recorded event types in #event-log, in order.
  def event_log
    all("#event-log li").map { |li| li["data-event"] }
  end
end
