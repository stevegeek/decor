# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      # Suite skin of FormChild — the abstract ancestor of every Suite form
      # building block (FormFieldLayout, FormField and their concrete inputs).
      #
      # FormChild is intentionally abstract: it defines no `view_template`,
      # owns no Suite-specific CSS, and exists only so the Suite skin has a
      # parallel inheritance spine to the Daisy skin. The shared prop API
      # (`label_position`, `grid_span`) plus the label-position predicates and
      # `grid_span_class` helper live on the Components base — concrete Suite
      # subclasses inherit them as-is and supply their own view templates and
      # `decor:`-prefixed class strings.
      class FormChild < ::Decor::Components::Forms::FormChild
      end
    end
  end
end
