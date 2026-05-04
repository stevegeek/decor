# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      # Daisy skin for FormField. Still abstract — concrete input subclasses
      # (TextField, Select, Checkbox, ...) supply `view_template`.
      #
      # All would-be-daisy-skin methods (root_element_classes,
      # input_classes, input_container_classes) live on the abstract
      # Components::Forms::FormField because input subclasses inherit from
      # there, not from this class. This subclass exists for namespace
      # consistency only — there is currently no Daisy-specific FormField
      # behaviour distinct from the abstract base.
      class FormField < ::Decor::Components::Forms::FormField
      end
    end
  end
end
