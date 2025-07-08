#!/usr/bin/env ruby
# frozen_string_literal: true

# Script to test all preview methods and log errors
# Usage: ruby test_previews.rb

require_relative "config/environment"

class PreviewTester
  def initialize
    @results = {
      passed: [],
      failed: [],
      total: 0
    }
  end

  def run
    puts "🔍 Testing all preview methods..."
    puts "=" * 60
    
    # Get all preview classes
    preview_classes = find_preview_classes
    
    preview_classes.each do |preview_class|
      test_preview_class(preview_class)
    end
    
    print_summary
  end

  private

  def find_preview_classes
    # Load all preview files
    Dir.glob("test/components/previews/**/*_preview.rb").each do |file|
      require_relative file
    end
    
    # Find all classes that inherit from Lookbook::Preview
    ObjectSpace.each_object(Class).select do |klass|
      klass < Lookbook::Preview
    end.sort_by(&:name)
  end

  def test_preview_class(preview_class)
    puts "\n📋 Testing #{preview_class.name}"
    puts "-" * 40
    
    # Get all public instance methods that don't start with _ and aren't inherited
    preview_methods = preview_class.instance_methods(false).reject do |method|
      method.to_s.start_with?('_') || 
      method.to_s == 'initialize' ||
      [:render_component, :render_with_template, :render].include?(method)
    end
    
    preview_methods.each do |method_name|
      test_preview_method(preview_class, method_name)
    end
  end

  def test_preview_method(preview_class, method_name)
    @results[:total] += 1
    
    begin
      # Create a proper ActionView context with Rails application context
      controller = ActionController::Base.new
      controller.request = ActionDispatch::TestRequest.create
      view_context = controller.view_context
      
      # Create an instance of the preview class
      preview_instance = preview_class.new
      
      # Try to call the method
      result = preview_instance.send(method_name)
      
      # If it's a component, try to render it with view context
      if result.is_a?(Hash) && result[:component]
        # Use Rails render method with view context
        view_context.render(result[:component])
      elsif result.respond_to?(:call)
        # For direct component instances
        view_context.render(result)
      end
      
      @results[:passed] << "#{preview_class.name}##{method_name}"
      puts "  ✅ #{method_name}"
      
    rescue => e
      @results[:failed] << {
        method: "#{preview_class.name}##{method_name}",
        error: e.class.name,
        message: e.message,
        backtrace: e.backtrace.first(5)
      }
      puts "  ❌ #{method_name} - #{e.class.name}: #{e.message}"
    end
  end

  def print_summary
    puts "\n" + "=" * 60
    puts "📊 SUMMARY"
    puts "=" * 60
    puts "Total methods tested: #{@results[:total]}"
    puts "Passed: #{@results[:passed].length} (#{(@results[:passed].length.to_f / @results[:total] * 100).round(1)}%)"
    puts "Failed: #{@results[:failed].length} (#{(@results[:failed].length.to_f / @results[:total] * 100).round(1)}%)"
    
    if @results[:failed].any?
      puts "\n🚨 FAILED METHODS:"
      puts "-" * 40
      
      @results[:failed].each do |failure|
        puts "\n❌ #{failure[:method]}"
        puts "   Error: #{failure[:error]}"
        puts "   Message: #{failure[:message]}"
        puts "   Backtrace:"
        failure[:backtrace].each do |line|
          puts "     #{line}"
        end
      end
      
      puts "\n📋 FAILURE CATEGORIES:"
      puts "-" * 40
      
      # Group failures by error type
      failures_by_error = @results[:failed].group_by { |f| f[:error] }
      failures_by_error.each do |error_type, failures|
        puts "\n#{error_type} (#{failures.length} failures):"
        failures.each do |failure|
          puts "  - #{failure[:method]}"
        end
      end
    end
    
    puts "\n✅ PASSED METHODS:" if @results[:passed].any?
    @results[:passed].each do |method|
      puts "  - #{method}"
    end
  end
end

# Run the tester
if __FILE__ == $0
  PreviewTester.new.run
end