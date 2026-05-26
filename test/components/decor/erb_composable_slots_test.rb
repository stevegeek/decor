# frozen_string_literal: true

require "test_helper"

# A tiny test-only component that uses render_slot
class SlotTestComponent < ::Decor::PhlexComponent
  no_stimulus_controller

  def with_content(&block)
    @content_slot = block
  end

  def view_template
    div(class: "slot-test-wrapper") do
      render_slot(@content_slot)
    end
  end
end

class Decor::ErbComposableSlotsTest < ActiveSupport::TestCase
  # -----------------------------------------------------------------------
  # Unit tests for render_slot on a tiny throwaway component
  # -----------------------------------------------------------------------

  test "render_slot: Phlex style — block returns a PhlexComponent, which is rendered" do
    component = SlotTestComponent.new
    # Phlex style: block returns a component (emits nothing itself)
    component.with_content { ::Decor::Daisy::Title.new(title: "Phlex Title") }
    html = render_component(component)
    assert_includes html, "Phlex Title"
  end

  test "render_slot: plain string — block returns a plain string (gets plain-escaped)" do
    component = SlotTestComponent.new
    component.with_content { "plain text here" }
    html = render_component(component)
    assert_includes html, "plain text here"
  end

  test "render_slot: nil block — nothing renders, no error" do
    component = SlotTestComponent.new
    # No slot set — render_slot(nil) should silently do nothing
    html = render_component(component)
    assert_includes html, "slot-test-wrapper"
    refute_includes html, "nil"
  end

  test "render_slot: ERB style — block emits into buffer (captured output rendered unescaped)" do
    html = view_context.render(inline: <<~ERB, type: :erb)
      <%= render SlotTestComponent.new.tap { |c| c.with_content { "<span id='erb-slot'>ERB content</span>".html_safe } } %>
    ERB
    frag = Nokogiri::HTML5.fragment(html)
    assert frag.at_css("#erb-slot"), "ERB slot content should render unescaped"
    assert_equal "ERB content", frag.at_css("#erb-slot").text
  end

  # -----------------------------------------------------------------------
  # Acceptance tests — render REAL components from ERB via view_context
  # -----------------------------------------------------------------------

  test "Suite::Page with_header slot renders from ERB" do
    html = view_context.render(inline: <<~ERB, type: :erb)
      <%= render ::Decor::Suite::Page.new(include_flash: false) do |page| %>
        <% page.with_header do %>
          <%= render ::Decor::Suite::PageHeader.new(title: "Hello Header") %>
        <% end %>
        <p id="body-content">Body content</p>
      <% end %>
    ERB
    frag = Nokogiri::HTML5.fragment(html)
    assert frag.text.include?("Hello Header"), "header slot rendered from ERB should contain title text; got: #{frag.text.inspect}"
    assert frag.at_css("#body-content"), "body content should still render"
  end

  test "Suite::Page with_hero slot renders from ERB (no background)" do
    html = view_context.render(inline: <<~ERB, type: :erb)
      <%= render ::Decor::Suite::Page.new(include_flash: false) do |page| %>
        <% page.with_hero do %>
          <div id="hero-content">Hero here</div>
        <% end %>
        <p id="body-content">Body</p>
      <% end %>
    ERB
    frag = Nokogiri::HTML5.fragment(html)
    assert frag.at_css("#hero-content"), "hero slot rendered from ERB; got: #{html.inspect}"
  end

  test "Suite::Page with_hero slot renders from ERB (with background)" do
    html = view_context.render(inline: <<~ERB, type: :erb)
      <%= render ::Decor::Suite::Page.new(include_flash: false, background: :hero) do |page| %>
        <% page.with_hero do %>
          <div id="hero-bg-content">Hero with background</div>
        <% end %>
      <% end %>
    ERB
    frag = Nokogiri::HTML5.fragment(html)
    assert frag.at_css("#hero-bg-content"), "hero slot in background page renders from ERB; got: #{html.inspect}"
  end

  test "Suite::PageSection with_cta slot renders from ERB" do
    html = view_context.render(inline: <<~ERB, type: :erb)
      <% section = ::Decor::Suite::PageSection.new(title: "CTA Section") %>
      <% section.with_cta do %>
        <button id="cta-button">Click me</button>
      <% end %>
      <%= render section do %>
        <p id="section-body-2">body</p>
      <% end %>
    ERB
    frag = Nokogiri::HTML5.fragment(html)
    assert frag.at_css("#cta-button"), "CTA slot rendered from ERB; got: #{html.inspect}"
    assert frag.at_css("#section-body-2"), "section body rendered; got: #{html.inspect}"
  end

  test "Suite::PageHeader with_actions slot renders from ERB" do
    html = view_context.render(inline: <<~ERB, type: :erb)
      <% header = ::Decor::Suite::PageHeader.new(title: "Actions Header") %>
      <% header.with_actions do %>
        <button id="action-btn">Action</button>
      <% end %>
      <%= render header %>
    ERB
    frag = Nokogiri::HTML5.fragment(html)
    assert frag.at_css("#action-btn"), "actions slot rendered from ERB; got: #{html.inspect}"
    assert frag.text.include?("Actions Header"), "title still renders; got: #{frag.text.inspect}"
  end

  test "Suite::PageSection with_hero slot renders from ERB" do
    html = view_context.render(inline: <<~ERB, type: :erb)
      <% section = ::Decor::Suite::PageSection.new(title: "Hero Section") %>
      <% section.with_hero do %>
        <div id="section-hero">Section hero content</div>
      <% end %>
      <%= render section %>
    ERB
    frag = Nokogiri::HTML5.fragment(html)
    assert frag.at_css("#section-hero"), "hero slot in PageSection rendered from ERB; got: #{html.inspect}"
  end

  # Daisy variants
  test "Daisy::Page with_header slot renders from ERB" do
    html = view_context.render(inline: <<~ERB, type: :erb)
      <%= render ::Decor::Daisy::Page.new(include_flash: false) do |page| %>
        <% page.with_header do %>
          <%= render ::Decor::Daisy::PageHeader.new(title: "Daisy Header") %>
        <% end %>
        <p id="daisy-body">Daisy body</p>
      <% end %>
    ERB
    frag = Nokogiri::HTML5.fragment(html)
    assert frag.text.include?("Daisy Header"), "Daisy header slot rendered from ERB; got: #{frag.text.inspect}"
    assert frag.at_css("#daisy-body"), "Daisy body rendered"
  end

  test "Daisy::PageSection with_cta slot renders from ERB" do
    html = view_context.render(inline: <<~ERB, type: :erb)
      <% section = ::Decor::Daisy::PageSection.new(title: "Daisy CTA Section") %>
      <% section.with_cta do %>
        <button id="daisy-cta-btn">Daisy CTA</button>
      <% end %>
      <%= render section %>
    ERB
    frag = Nokogiri::HTML5.fragment(html)
    assert frag.at_css("#daisy-cta-btn"), "Daisy CTA slot rendered from ERB; got: #{html.inspect}"
  end
end
