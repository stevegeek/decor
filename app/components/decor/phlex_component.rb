# frozen_string_literal: true

module Decor
  class PhlexComponent < ::Vident::Typed::Phlex::HTML
    include ::Vident::Caching
    include ::Vident::Tailwind

    include Phlex::Rails::Helpers::Routes
    include Phlex::Rails::Helpers::ImagePath

    # TODO: deprecate these?
    include ::Phlex::Rails::Helpers::T
    include ::Phlex::Rails::Helpers::ImageTag
    include ::Phlex::Rails::Helpers::LinkTo
    include ::Phlex::Rails::Helpers::FormWith
    include ::Phlex::Rails::Helpers::ContentTag
    include ::Phlex::Rails::Helpers::OptionsForSelect

    # TODO: part of transition to Literal
    class << self
      alias_method :prop_names, :attribute_names
    end

    def target_data_attributes(el, name, controller: nil)
      return {} unless el
      attrs = el.send(:parse_targets, [name])
      attrs[:controller] = controller if controller
      el.send(:build_target_data_attributes, attrs)
    end

    def action_data_attributes(el, *event_name_pairs)
      return {} unless el
      {
        action: el.send(:parse_actions, event_name_pairs).join(" ")
      }
    end
  end
end
