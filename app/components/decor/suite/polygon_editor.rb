# frozen_string_literal: true

module Decor
  module Suite
    # Suite-only PolygonEditor — embeds a Google Maps Drawing Manager for
    # drawing/editing a single polygon (used for geo-fencing / serviceability
    # regions). The current polygon is serialised to GeoJSON MultiPolygon and
    # stashed in a hidden input for form submission.
    #
    # No Daisy peer or abstract base — this is a Suite-specific component.
    class PolygonEditor < ::Decor::PhlexComponent
      prop :api_key, _Nilable(String), reader: :public
      prop :center, Hash, default: -> { {} }, reader: :public
      prop :zoom, Integer, default: 10, reader: :public
      prop :initial_polygon, _Nilable(String), reader: :public
      prop :input_name, String, reader: :public
      prop :input_id, String, reader: :public

      stimulus do
        actions :clear_polygon
        targets :map_container, :geo_json_input
        values api_key: -> { api_key },
          zoom: -> { zoom },
          center: -> { center_json },
          initial_polygon: -> { initial_polygon }
      end

      def view_template
        root_element do
          div(class: "decor:space-y-4") do
            div(class: "decor:suite-description decor:text-gray-500") do
              p(class: "decor:mb-2") do
                plain "Click the polygon tool on the map to draw your service area. You can edit the polygon by dragging its vertices."
              end
              button(
                type: "button",
                class: "decor:text-suite-primary-500 decor:hover:text-suite-primary-700 decor:underline decor:suite-description",
                data: {**stimulus_action(:click, :clear_polygon)}
              ) { "Clear and redraw polygon" }
            end

            div(
              class: "decor:w-full decor:h-96 decor:bg-suite-gray-25 decor:border decor:border-suite-hairline decor:rounded-suite-card",
              data: {**stimulus_target(:map_container)}
            )

            input(
              type: "hidden",
              name: input_name,
              id: input_id,
              value: initial_polygon,
              data: {**stimulus_target(:geo_json_input)}
            )
          end
        end
      end

      private

      def center_json
        return nil if center.empty?
        center.to_json
      end

      def root_element_classes
        "decor:w-full"
      end
    end
  end
end
