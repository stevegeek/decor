# frozen_string_literal: true

module Decor
  class PanelGroup < PhlexComponent
    no_stimulus_controller

    slot :cta

    attribute :title, String
    attribute :description, String
    attribute :panels, Array

    def view_template(&)
      render parent_element do
        render ::Decor::Card.new(html_options: {class: "shadow-lg border border-base-300 overflow-hidden"}) do |card|
          card.with_header do
            card.div(class: "p-4 lg:p-6") do
              card.div(class: "-ml-4 -mt-4 ml-4 mt-4") do
                card.render ::Decor::Title.new(
                  title: @title,
                  description: @description,
                  size: :md
                ) do
                  card.render cta_slot if cta_slot.present?
                end
              end
            end
          end

          @panels&.each_with_index do |panel_group, idx|
            div(class: section_classes(idx)) do
              div(class: "grid #{grid_size(panel_group)} gap-4 md:gap-5") do
                panel_group.each do |panel_config|
                  if panel_config.size > 1
                    render ::Decor::Panel.new(**panel_config.first) do
                      if panel_config.last.is_a?(String)
                        panel_config.last
                      elsif panel_config.last.respond_to?(:call)
                        instance_exec(&panel_config.last)
                      end
                    end
                  else
                    render ::Decor::Panel.new(**panel_config.first)
                  end
                end
              end
            end
          end

          div(&) if block_given?
        end
      end
    end

    private

    def element_classes
      "space-y-4"
    end

    def section_classes(idx)
      base_classes = "px-4 py-5 lg:px-6"
      if idx.odd?
        "#{base_classes} bg-base-100"
      else
        "#{base_classes} bg-base-200/50"
      end
    end

    def grid_size(panels_in_row)
      case panels_in_row.size
      when 1
        "md:grid-cols-1"
      when 2
        "md:grid-cols-2"
      when 3
        "md:grid-cols-3"
      when 4
        "md:grid-cols-4"
      when 5
        "md:grid-cols-5"
      else
        "md:grid-cols-6"
      end
    end
  end
end
