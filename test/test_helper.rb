ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # Phlex component testing helper
    def render_component(component)
      controller = ApplicationController.new
      controller.request = ActionDispatch::TestRequest.create
      component.call(view_context: controller.view_context)
    end

    # Parse rendered HTML for testing
    def render_fragment(component)
      html = render_component(component)
      Nokogiri::HTML5.fragment(html)
    end

    def render_document(component)
      html = render_component(component)
      Nokogiri::HTML5(html)
    end
  end
end
