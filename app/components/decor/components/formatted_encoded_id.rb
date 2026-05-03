# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for FormattedEncodedId. Owns the prop API and value-only
    # helpers (prefix splitting / id cleaning). Concrete skins provide
    # `view_template` and any CSS class string composition.
    class FormattedEncodedId < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :encoded_id, _String(&:present?)
      prop :prefix, _Nilable(String)

      private

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
end
