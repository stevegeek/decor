# frozen_string_literal: true

module Decor
  module Components
    class SettingsList < ::Decor::PhlexComponent
      no_stimulus_controller

      # Inheritance/override metadata for a setting defined elsewhere.
      class ScopeInfo < ::Literal::Data
        prop :label, String
        prop :tooltip, String
        prop :link_path, _Nilable(String), default: nil
      end

      # Data carrier for one row. `value` is a String (plain), nil
      # (em-dash), or any object responding to `render_in` (rendered).
      class Row < ::Literal::Data
        prop :title, String
        prop :description, _Nilable(String), default: nil
        prop :value, _Nilable(_Any), default: nil
        prop :active, _Boolean, default: false
        prop :edit_path, _Nilable(String), default: nil
        prop :scope_info, _Nilable(ScopeInfo), default: nil
      end

      # A section of related rows. `name` doubles as the section header
      # label. The anonymous-group sentinel keeps a single render path.
      class Group < ::Literal::Data
        prop :name, String
        prop :icon, _Nilable(String), default: nil
        prop :description, _Nilable(String), default: nil
        prop :rows, _Array(Row), default: -> { [] }
      end

      ANONYMOUS_GROUP_NAME = "__anonymous__"

      prop :title, _Nilable(String), default: nil, reader: :public
      prop :groups, _Nilable(_Array(Group)), default: nil, reader: :public
      prop :rows, _Nilable(_Array(Row)), default: nil, reader: :public
      # Optional label override for the per-row Edit affordance.
      prop :edit_label, String, default: "Edit"

      def after_component_initialize
        validate_groups_xor_rows!
      end

      private

      # Returns the materialised list of groups to render — collapsing
      # nil/empty inputs and wrapping a bare `rows:` array in a single
      # anonymous group.
      def rendered_groups
        source = @groups || (@rows ? [anonymous_group_for_rows] : [])
        source.reject { |g| g.rows.empty? }
      end

      def anonymous_group_for_rows
        Group.new(name: ANONYMOUS_GROUP_NAME, rows: @rows || [])
      end

      def anonymous_group?(group)
        group.name == ANONYMOUS_GROUP_NAME
      end

      def expandable_row?(row)
        row.description.present? || row.edit_path.present?
      end

      def validate_groups_xor_rows!
        both = !@groups.nil? && !@rows.nil?
        neither = @groups.nil? && @rows.nil?
        if both || neither
          raise ArgumentError,
            "Decor::Components::SettingsList requires exactly one of `groups:` or `rows:`"
        end
      end
    end
  end
end
