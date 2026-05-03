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
              div(class: "alert #{alert_variant_class}") do
                div(class: "flex") do
                  div(class: "flex-shrink-0") do
                    render ::Decor::Daisy::Icon.new(name: icon, html_options: {class: "h-5 w-5"})
                  end
                  div(class: "ml-3") do
                    h3(class: "text-md font-medium") { title_with_defaults }
                    div(class: "mt-2 text-md") do
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
        base_classes = ["invisible opacity-0"]
        base_classes << "hidden" if @collapse_if_empty && !show_initial?
        base_classes.join(" ")
      end

      def alert_variant_class
        case resolved_color
        when :success then "alert-success"
        when :error then "alert-error"
        when :warning then "alert-warning"
        when :info then "alert-info"
        when :primary then "alert-info"
        else ""
        end
      end
    end
  end
end
