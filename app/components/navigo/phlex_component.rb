# frozen_string_literal: true

module Navigo
  class PhlexComponent < ::Vident::Typed::Phlex::HTML
    include ::Vident::Caching
    include ::Vident::Tailwind

    include Phlex::Rails::Helpers::Routes
    include Phlex::Rails::Helpers::ImagePath

    def target_data_attributes(el, name, controller: nil)
      return {} unless el
      attrs = el.send(:parse_targets, [name])
      attrs[:controller] = controller if controller
      el.send(:build_target_data_attributes, attrs)
    end

    def action_data_attributes(el, *event_name_pairs)
      {
        action: el.send(:parse_actions, event_name_pairs).join(" ")
      }
    end
  end
end
