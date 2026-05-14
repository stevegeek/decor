# frozen_string_literal: true

module Decor
  module Daisy
    # 'Flash' or Alert banner. A flash banner is displayed inline with other
    # content. Its intention is to display prominent information related to
    # the content of the page. A common use case for a flash banner is showing
    # messages relating to form submissions (e.g. validation messages).
    class Flash < ::Decor::Components::Flash
      def view_template
        if block_given? && !show_initial?
          yield
        else
          root_element do
            if show_initial?
              div(class: "decor:d-alert #{alert_variant_class}") do
                div(class: "decor:flex") do
                  div(class: "decor:flex-shrink-0") do
                    render ::Decor::Icon.new(name: icon, html_options: {class: "decor:h-5 decor:w-5"})
                  end
                  div(class: "decor:ml-3") do
                    h3(class: "decor:text-md decor:font-medium") { title_with_defaults }
                    div(class: "decor:mt-2 decor:text-md") do
                      p { text_with_default }
                    end
                  end
                end
              end
            end
          end
        end
      end

      private

      def root_element_attributes
        {
          html_options: show_initial? ? {} : {hidden: true}
        }
      end

      def root_element_classes
        base_classes = ["decor:invisible decor:opacity-0"]
        base_classes << "decor:hidden" if @collapse_if_empty && !show_initial?
        base_classes.join(" ")
      end

      def alert_variant_class
        case resolved_color
        when :success then "decor:d-alert-success"
        when :error then "decor:d-alert-error"
        when :warning then "decor:d-alert-warning"
        when :info then "decor:d-alert-info"
        when :primary then "decor:d-alert-info"
        else ""
        end
      end
    end
  end
end
