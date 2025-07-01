# frozen_string_literal: true

module Decor
  module Forms
    module Concerns
      module CheckableFormField
        extend ActiveSupport::Concern

        included do
          attribute :checked, :boolean, default: false, convert: true

          attribute :in_group, :boolean, default: false
        end

        def label_with_required
          (label || "") + ((required_individual? && !@hide_required_asterisk) ? " *" : "")
        end

        def required_individual?
          required? && !in_group?
        end

        def in_group?
          @in_group
        end

        def cursor_classes
          disabled? ? "cursor-not-allowed" : "cursor-pointer disabled:cursor-not-allowed"
        end
      end
    end
  end
end
