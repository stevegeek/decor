#!/usr/bin/env ruby

require "pathname"
require "erb"
require "yaml"

class ComponentDocumentationGenerator
  attr_reader :components_dir, :previews_dir, :output_file

  def initialize
    @components_dir = Pathname.new("app/components/decor")
    @previews_dir = Pathname.new("test/components/previews/decor")
    @output_file = "test/components/docs/03_component_reference.md.erb"
    @components_data = {}
  end

  def generate
    puts "Collecting component data..."
    collect_all_component_data

    puts "Generating documentation..."
    output = generate_documentation

    puts "Writing to #{output_file}..."
    File.write(output_file, output)

    puts "Documentation generated successfully!"
  end

  private

  def collect_all_component_data
    # Get all component files
    component_files = Dir.glob(@components_dir.join("**/*.rb"))
      .reject { |f| f.include?("/concerns/") || f.include?("/tag_wrappers/") || f.include?("/validation_parsers/") }
      .reject { |f| f.include?("phlex_component.rb") || f.include?("action_view_form_builder.rb") }

    component_files.each do |component_file|
      component_name = extract_component_name(component_file)

      # Parse component file
      component_data = parse_component_file(component_file)

      # Find corresponding preview file
      preview_file = find_preview_file(component_name)
      if preview_file && File.exist?(preview_file)
        preview_data = parse_preview_file(preview_file)
        component_data.merge!(preview_data)
      end

      @components_data[component_name] = component_data

      # Debug output for Button
      if component_name == "Button"
        puts "Button component data:"
        puts "  defaults: #{component_data[:defaults].inspect}"
        puts "  standard_defaults: #{component_data[:standard_defaults].inspect}"
      end
    end
  end

  def extract_component_name(file_path)
    path = Pathname.new(file_path)
    relative_path = path.relative_path_from(@components_dir)

    # Convert file path to component name
    parts = relative_path.to_s.sub(/\.rb$/, "").split("/")

    if parts.length > 1
      parts.map { |p| p.split("_").map(&:capitalize).join }.join("::")
    else
      parts[0].split("_").map(&:capitalize).join
    end
  end

  def find_preview_file(component_name)
    # Convert component name to preview file name
    # E.g., "Forms::TextField" -> "forms/text_field_preview.rb"
    parts = component_name.split("::")
    if parts.length > 1
      namespace = parts[0..-2].map(&:downcase).join("/")
      filename = parts.last.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
      @previews_dir.join("#{namespace}/#{filename}_preview.rb")
    else
      filename = component_name.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
      @previews_dir.join("#{filename}_preview.rb")
    end
  end

  def parse_component_file(file_path)
    content = File.read(file_path)
    data = {
      file_path: file_path,
      props: [],
      slots: [],
      redefined: {},
      defaults: {},
      parent_class: nil,
      included_modules: [],
      accepts_block: false,
      block_usage: nil
    }

    # Extract parent class
    if (match = content.match(/class\s+\w+\s*<\s*(\S+)/))
      data[:parent_class] = match[1]
    end

    # Extract included modules
    content.scan(/include\s+(Decor::Concerns::\w+)/) do |module_name|
      data[:included_modules] << module_name.first
    end

    # Parse props from the component file
    extract_props_from_content(content, data[:props])

    # Parse props from included modules
    data[:included_modules].each do |module_name|
      module_props = parse_concern_module(module_name)
      data[:props].concat(module_props) if module_props.any?
    end

    # Extract default values (default_size, default_color, default_style)
    content.scan(/default_(\w+)\s+:(\w+)/) do |type, value|
      data[:defaults][type] = value
    end

    # Also extract standard defaults that apply to this component
    data[:standard_defaults] = {}
    # Check if component inherits from PhlexComponent (which includes the standard modules)
    if data[:parent_class] == "PhlexComponent"
      data[:standard_defaults][:size] = data[:defaults]["size"] if data[:defaults]["size"]
      data[:standard_defaults][:color] = data[:defaults]["color"] if data[:defaults]["color"]
      data[:standard_defaults][:style] = data[:defaults]["style"] if data[:defaults]["style"]
    end

    # Extract redefined values (handle single line)
    content.scan(/redefine_(\w+)\s+(.+)$/) do |type, values|
      # Extract symbols from the line
      data[:redefined][type] = values.scan(/:(\w+)/).flatten
    end

    # Extract slot methods
    content.scan(/def\s+(with_\w+)(?:\(.*?\))?/) do |method|
      data[:slots] << method.first
    end

    # Also check for renders_many/renders_one
    content.scan(/renders_(?:many|one)\s+:(\w+)/) do |slot|
      data[:slots] << "with_#{slot.first}"
    end

    # Detect block usage
    if content.match(/def\s+view_template\s*\(\s*&/) || content.match(/block_given\?/)
      data[:accepts_block] = true

      # Check if it uses vanish method with block
      if /vanish\s*\(&\)/.match?(content)
        data[:block_usage] = :slots_only
      # Check if it uses capture or yield
      elsif content.match(/capture\s*[({]?\s*&/) || content.match(/yield/)
        data[:block_usage] = :content
      # Check if block_given? is used
      elsif /block_given\?/.match?(content)
        data[:block_usage] = :content
      end
    end

    data
  end

  def extract_props_from_content(content, props_array)
    # Extract prop definitions
    content.scan(/prop\s+:(\w+),\s*(.+?)(?:(?=\n\s*(?:prop|def|private|public|protected|#|$))|$)/m) do |name, type_def|
      prop = {name: name, type: clean_type(type_def), required: true}

      # Check if nilable (makes it optional)
      if type_def.include?("_Nilable")
        prop[:required] = false
      end

      # Extract default value
      if (match = type_def.match(/default:\s*(.+?)(?:,|$)/))
        prop[:default] = clean_default(match[1])
        prop[:required] = false  # Has default value, so it's optional
      end

      # Extract description from comment above prop
      if (comment_match = content.match(/#\s*(.+?)\n\s*prop\s+:#{name}/))
        prop[:description] = comment_match[1].strip
      end

      props_array << prop
    end
  end

  def parse_concern_module(module_name)
    # Convert module name to file path
    # Decor::Concerns::ActsAsLink -> app/components/decor/concerns/acts_as_link.rb
    parts = module_name.split("::").map { |p| p.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase }
    module_path = Pathname.new("app/components/#{parts.join("/")}.rb")

    props = []

    if File.exist?(module_path)
      content = File.read(module_path)

      # Extract prop definitions from the included block
      if (included_block = content.match(/included\s+do\s*\n(.*?)\n\s*end/m))
        block_content = included_block[1]

        # Parse props within the included block
        block_content.scan(/prop\s+:(\w+),\s*(.+?)(?:(?=\n\s*(?:prop|#|$))|$)/m) do |name, type_def|
          prop = {name: name, type: clean_type(type_def), required: true}

          # Check if nilable (makes it optional)
          if type_def.include?("_Nilable")
            prop[:required] = false
          end

          # Extract default value
          if (match = type_def.match(/default:\s*(.+?)(?:,|$)/))
            prop[:default] = clean_default(match[1])
            prop[:required] = false  # Has default value, so it's optional
          end

          # Extract description from comment above prop
          if (comment_match = block_content.match(/#\s*(.+?)\n\s*prop\s+:#{name}/))
            prop[:description] = comment_match[1].strip
          end

          props << prop
        end
      end
    else
      puts "Warning: Could not find module file: #{module_path}"
    end

    props
  end

  def parse_preview_file(file_path)
    content = File.read(file_path)
    data = {
      description: nil,
      label: nil,
      examples: []
    }
    puts "\n--- #{file_path} ---\n"
    # Extract label from class comment
    if (match = content.match(/# @label (.+?)\n/))
      data[:label] = match[1]
    end

    # Extract description from comment block inside the class
    # Look for pattern: class ... < ...\n  # First line\n  # Second line\n  # etc.
    if (match = content.match(/class\s+.+?\s*<\s*.+?\n((?:\s*#.*\n)+)/))
      comment_block = match[1]

      puts "Comment block: #{comment_block.inspect}"
      lines = comment_block.split("\n").map { |l| l.scan(/^\s*#\s?(.*)$/) }.flatten
      puts "Lines: #{lines.inspect}"
      lines = lines.map(&:strip)  # Remove leading/trailing whitespace

      # Remove separator lines and empty lines
      lines = lines.reject { |l| l.match(/^-+$/) || l.empty? }

      # Skip @group, @label and other annotations
      lines = lines.reject { |l| l.match(/^\s*@!?\w+/) }
      # Join the remaining lines, treating # as a paragraph separator
      description = lines.join(" ")
        .gsub(/\s*#\s*/, "\n\n")  # Replace # with paragraph breaks
        .strip
      data[:description] = description unless description.empty?
      if data[:description]
        puts "> Description extracted: #{data[:description].inspect}"
      else
        puts "> No description found in #{file_path}"
      end
    end

    # Extract playground parameters to understand available options
    if (match = content.match(/def playground\((.*?)\)/m))
      params = match[1]
      data[:playground_params] = parse_playground_params(params)
    end

    data
  end

  def parse_playground_params(params_string)
    params = []
    params_string.scan(/(\w+):\s*(.+?)(?=,\s*\w+:|$)/m) do |name, default|
      param = {name: name, default: default.strip}

      # Check for @param comment
      if (match = params_string.match(/@param #{name}\s+(.+?)(?:\n|$)/))
        param[:type] = match[1].strip
      end

      params << param
    end
    params
  end

  def clean_type(type)
    type.gsub(/_Nilable\((.*?)\)/, '\1?')
      .gsub(/_Union\((.*?)\)/, 'Union[\1]')
      .gsub("_Boolean", "Boolean")
      .delete("_")
      .strip
  end

  def clean_default(default)
    return nil unless default
    default.strip.gsub(/^-> \{ (.+?) \}$/, '\1')
  end

  def generate_documentation
    template = ERB.new(template_content, trim_mode: "-")
    template.result(binding)
  end

  def format_values_list(values)
    values.map { |v| "`#{v}`" }.join(", ")
  end

  def format_prop_line(prop)
    line = "- `#{prop[:name]}` (#{prop[:type]})"
    line += prop[:required] ? " (required)" : " (optional)"
    line += " - #{prop[:description]}" if prop[:description]
    line += " - Default: `#{prop[:default]}`" if prop[:default]
    line
  end

  def group_components
    groups = {
      "Core Components" => [],
      "Form Components" => [],
      "Navigation Components" => [],
      "Data Display Components" => [],
      "Modal Components" => [],
      "Layout & Utility Components" => [],
      "Internal Components" => []
    }

    @components_data.each do |name, data|
      component = {name: name}.merge(data)

      # Skip internal/helper components
      if name.include?("::Builder::") || name.include?("::PagesToDisplay") ||
          %w[PhlexComponent FormChild FormField CardHeader].include?(name.split("::").last)
        groups["Internal Components"] << component
        next
      end

      case name
      when /^Forms::/
        groups["Form Components"] << component
      when /^Nav::/
        groups["Navigation Components"] << component
      when /^Tables::/
        groups["Data Display Components"] << component
      when /^Modals::/
        groups["Modal Components"] << component
      when /^(Button|Card|Badge|Avatar|Dropdown|Banner|Box|Carousel|FlowStep|Icon|Link|Progress|Spinner|Tag|Title|Tooltip|Flash|Notification)/
        groups["Core Components"] << component
      when /^(DataTable|Pagination|Stats?|Tabs)/
        groups["Data Display Components"] << component
      when /^Chat::/
        groups["Layout & Utility Components"] << component
      else
        groups["Layout & Utility Components"] << component
      end
    end

    groups.transform_values { |v| v.sort_by { |c| c[:name] } }
      .reject { |k, v| v.empty? || k == "Internal Components" }
  end

  def template_content
    <<~TXT
      ---
      title: Component Reference
      label: Component Reference
      ---
      
      # Component Reference
      
      Autogenerated complete reference for all Decor UI components with usage examples and parameters.

      If you find any issues or missing components, please open a PR to improve the documentation generation script.
      
      ---
      
      ## Table of Contents
      
      <% group_components.each do |group_name, components| -%>
      ### <%= group_name %>
      <% components.each do |component| -%>
      - [Decor::<%= component[:name] %>](#decor<%= component[:name].downcase.gsub('::', '') %>)
      <% end -%>
      
      <% end -%>
      ---
      
      ## Shared Component Properties
      
      Most Decor components inherit from `PhlexComponent` which includes the following shared property modules. These properties are available on all components unless explicitly redefined:
      
      ### Sizes
      
      Provides size variants for component sizing.
      
      **Property:** `size`
      
      **Default values:** `:xs`, `:sm`, `:md`, `:lg`, `:xl`
      
      **Size aliases:** 
      - `:small` → `:sm`
      - `:medium` → `:md`
      - `:large` → `:lg`
      - `:micro`, `:extra_small` → `:xs`
      - `:extra_large` → `:xl`
      
      ### Colors
      
      Provides semantic color variants following the DaisyUI color system.
      
      **Property:** `color`
      
      **Default values:** `:base`, `:primary`, `:secondary`, `:accent`, `:neutral`, `:success`, `:error`, `:warning`, `:info`
      
      ### Styles
      
      Provides visual style variants for component appearance.
      
      **Property:** `style`
      
      **Default values:** `:filled`, `:outlined`, `:ghost`
      
      **Note:** When a component redefines these values, it will be noted in that component's documentation section.
      
      ---
      
      <% group_components.each do |group_name, components| -%>
      ## <%= group_name %>
      
      <% components.each do |component| -%>
      ### Decor::<%= component[:name] %>

      <span id="decor<%= component[:name].downcase.gsub('::', '') %>"></span>

      <% if component[:description] -%>
      <%= component[:description] %>
      
      <% end -%>
      **Basic Usage:**
      ```ruby
      render Decor::<%= component[:name] %>.new<%= generate_example_params(component) %>
      ```
      
      <% if component[:redefined].any? -%>
      **Redefined Properties:**
      <% component[:redefined].each do |type, values| -%>
      - `<%= type %>`: <%= format_values_list(values) %>
      <% end -%>
      
      <% end -%>
      <% if component[:props].any? -%>
      **Key Attributes:**
      <% component[:props].each do |prop| -%>
      <%= format_prop_line(prop) %>
      <% end -%>

      <% if component[:parent_class] == "PhlexComponent" %>
      _(and the shared properties `size`, `color`, and `style` as described above)_
      <% end -%>

      <% end -%>
      <% if component[:standard_defaults] && component[:standard_defaults].any? -%>
      **Default Shared Properties Values:**
      <% component[:standard_defaults].each do |type, value| -%>
      - `<%= type %>`: `:<%= value %>`
      <% end -%>
      
      <% end -%>
      <% if component[:slots].any? -%>
      **Slot Methods:**
      <% component[:slots].each do |slot| -%>
      - `<%= slot %>`
      <% end -%>
      
      <% end -%>
      ---
      
      <% end -%>
      <% end -%>
    TXT
  end

  def generate_example_params(component)
    # Generate appropriate example parameters based on component type
    example_props = []

    # Only include required props
    component[:props].each do |prop|
      next unless prop[:required]

      # Generate appropriate example values based on property name
      example_props << case prop[:name]
      when "field_name"
        "field_name: \"field_name\""
      when "label"
        "label: \"Label\""
      when "title"
        "title: \"Title\""
      when "text"
        "text: \"Text content\""
      when "icon_name", "icon"
        "#{prop[:name]}: \"star\""
      when "name"
        # Check if this is likely an icon name based on parent component
        if component[:name].include?("Icon")
          "name: \"star\""
        else
          "name: \"field_name\""
        end
      when "href", "path", "url"
        "#{prop[:name]}: \"/path\""
      when "description"
        "description: \"Description text\""
      when "content"
        "content: \"Content here\""
      when "value"
        "value: \"value\""
      when "id"
        "id: \"unique_id\""
      when "key"
        "key: \"key_name\""
      when "type"
        "type: :default"
      when "method"
        "method: :post"
      when "action"
        "action: \"/submit\""
      else
        # For unknown property names, use a generic format
        "#{prop[:name]}: \"...\""
      end
    end

    # Format parameters and check for block usage
    params_str = if example_props.any?
      if example_props.length > 2
        "(\n  #{example_props.join(",\n  ")}\n)"
      else
        "(#{example_props.join(", ")})"
      end
    else
      ""
    end

    # Add block/slot example based on component's features
    if component[:slots].any? && component[:accepts_block]
      # Component has both slots and accepts block content
      slot_example = component[:slots].first
      if component[:block_usage] == :slots_only
        # Only slots (like DataTable with vanish)
        "#{params_str} do |c|\n  c.#{slot_example} do\n    # Slot content\n  end\nend"
      else
        # Both slots and content (like LayoutSection)
        "#{params_str} do |c|\n  c.#{slot_example} do\n    # Slot content\n  end\n  \"Content goes here\"\nend"
      end
    elsif component[:slots].any?
      # Only slots, no block content
      slot_example = component[:slots].first
      "#{params_str} do |c|\n  c.#{slot_example} do\n    # Slot content\n  end\nend"
    elsif component[:accepts_block]
      # Only block content, no slots
      "#{params_str} do\n  \"Content goes here\"\nend"
    else
      # No block or slots
      params_str
    end
  end
end

# Run the generator
generator = ComponentDocumentationGenerator.new
generator.generate
