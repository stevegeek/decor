# frozen_string_literal: true

module Decor
  module Components
    module Tables
      # Abstract base for DataTableFooter. Owns the prop API + slot helpers +
      # nested FooterSummaryLine value object.
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus their visual-language overrides.
      class DataTableFooter < ::Decor::PhlexComponent
        no_stimulus_controller

        attr_reader :left, :right

        class FooterSummaryLine < ::Literal::Data
          prop :title, String
          prop :value, String
          prop :separator, _Nilable(_Union(:section, :final))

          def start_section?
            @separator == :section
          end

          def final_line?
            @separator == :final
          end
        end

        prop :summary_lines, _Nilable(_Array(FooterSummaryLine))
        prop :message, _Nilable(String)

        def with_left(&block)
          @left = block
          self
        end

        def with_right(&block)
          @right = block
          self
        end
      end
    end
  end
end
