# frozen_string_literal: true

module Decor
  class FormattedEncodedId < PhlexComponent
    no_stimulus_controller

    attribute :encoded_id, String, allow_blank: false
    attribute :prefix, String, allow_nil: true, allow_blank: true

    def view_template(&)
      # wrap the prefix in a span so we can style it separately
      render parent_element do
        span(class: "text-base-500 font-extralight mr-0.5") { prefix_combined } if prefix_combined
        span(class: "text-primary font-medium tracking-wide") { cleaned_encoded_id }
      end
    end

    private

    def element_classes
      "inline-flex items-center"
    end

    def root_element_attributes
      {
        element_tag: :p
      }
    end

    def prefix_combined
      sep = ::EncodedId::Rails.configuration.annotated_id_separator
      parts = @encoded_id.split(sep)
      return @prefix if parts.size <= 1

      "#{parts[0..-2].join(sep)}#{sep}"
    end

    def cleaned_encoded_id
      prefix = prefix_combined
      return @encoded_id if prefix.blank?
      @encoded_id.gsub(prefix, "")
    end
  end
end
