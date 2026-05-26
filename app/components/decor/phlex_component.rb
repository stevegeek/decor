# frozen_string_literal: true

module Decor
  class PhlexComponent < ::Vident::Phlex::HTML
    include ActiveSupport::Configurable

    include ::Vident::Caching

    include Phlex::Rails::Helpers::Routes
    include Phlex::Rails::Helpers::ImagePath
    include Phlex::Rails::Helpers::AssetPath

    # TODO: deprecate these?
    include ::Phlex::Rails::Helpers::T
    include ::Phlex::Rails::Helpers::ImageTag
    include ::Phlex::Rails::Helpers::LinkTo
    include ::Phlex::Rails::Helpers::ContentTag

    # Shared attribute helpers
    include Decor::Concerns::SizeClasses
    include Decor::Concerns::ColorClasses
    include Decor::Concerns::StyleClasses

    register_output_helper :decor_flash

    # Render a stored slot block, supporting three caller styles:
    #   Phlex — block returns a renderable component (emits nothing itself)
    #   ERB   — block emits markup into the captured buffer
    #   safe  — block returns an html_safe String / SafeBuffer (rendered unescaped)
    #   plain — block returns a plain String (HTML-escaped)
    #
    # Slots are stored as procs (captured via `&block`), so calling with `self`
    # is safe for zero-arg blocks and also lets ERB callers receive the component
    # via `do |component|` if they want it.
    def render_slot(block)
      return if block.nil?
      result = nil
      captured = capture { result = block.call(self) }
      if result.is_a?(::Decor::PhlexComponent) || result.is_a?(::Phlex::SGML)
        render result
      elsif captured.present?
        raw captured
      elsif result.is_a?(::Phlex::SGML::SafeObject)
        raw result
      elsif result.is_a?(::String)
        plain result
      end
    end

    private

    def tailwind_merger
      ::Decor.configuration.class_merger
    end
  end
end
