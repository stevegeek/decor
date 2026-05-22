# frozen_string_literal: true

module Decor
  module Suite
    module Modals
      class ModalTrigger < ::Decor::Components::Modals::ModalTrigger
        redefine_sizes :xs, :sm, :md, :lg, :xl, :wide, :link

        # Override the abstract base's required modal_id so bundled-mode
        # callers don't have to invent one — we auto-wire to the sibling
        # Modal's id below.
        prop :modal_id, _Nilable(String), reader: :public

        prop :label, _Nilable(String)
        prop :color, _Nilable(Symbol)
        prop :style, _Nilable(Symbol)
        prop :icon, _Nilable(String)
        prop :icon_variant, _Nilable(Symbol)
        prop :full_width, _Boolean, default: false, predicate: :public
        prop :disabled, _Boolean, default: false, predicate: :public
        prop :button_classes, _Union(String, _Array(String)), default: -> { [] }

        prop :modal_title, _Nilable(String)
        prop :modal_description, _Nilable(String)
        prop :modal_variant, _Nilable(Symbol)
        prop :modal_size, _Nilable(Symbol)
        prop :modal_closeable, _Boolean, default: true, predicate: :public
        prop :modal_content_href, _Nilable(String)
        prop :modal_initial_content, _Nilable(::ActiveSupport::SafeBuffer)
        prop :modal_icon, _Nilable(_Union(FalseClass, String))

        def view_template(&)
          @content_block = capture(&) if block_given?
          if bundled_mode?
            render_bundled
          else
            render_transparent
          end
        end

        private

        def bundled_mode?
          @modal_title.present? || @modal_description.present? || @modal_content_href.present? ||
            @modal_initial_content.present? || @label.present? || @icon.present? ||
            @color.present? || @style.present?
        end

        def render_bundled
          modal_opts = {
            initial_content: @modal_initial_content,
            content_href: @modal_content_href,
            closeable: modal_closeable?
          }
          modal_opts[:title] = @modal_title if @modal_title
          modal_opts[:description] = @modal_description if @modal_description
          modal_opts[:variant] = @modal_variant if @modal_variant
          modal_opts[:size] = @modal_size if @modal_size
          modal_opts[:icon] = @modal_icon unless @modal_icon.nil?

          modal = ::Decor::Suite::Modals::Modal.new(**modal_opts)

          button_opts = {modal_id: modal.id}
          button_opts[:label] = @label if @label
          button_opts[:color] = @color if @color
          button_opts[:style] = @style if @style
          button_opts[:size] = @size if @size
          button_opts[:icon] = @icon if @icon
          button_opts[:icon_variant] = @icon_variant if @icon_variant
          button_opts[:full_width] = true if full_width?
          button_opts[:disabled] = true if disabled?
          button_opts[:classes] = @button_classes if @button_classes.present?

          render ::Decor::Suite::Modals::ModalOpenButton.new(**button_opts)

          if @content_block.present?
            render(modal) { raw safe(@content_block) }
          else
            render modal
          end
        end

        def render_transparent
          root_element do
            raw @content_block if @content_block.present?
          end
        end

        def root_element_attributes
          {
            element_tag: :span,
            html_options: {
              role: "button",
              tabindex: "0"
            }
          }
        end

        def root_element_classes
          [
            "decor:inline-block decor:cursor-pointer",
            "decor:rounded-suite-control",
            "decor:transition-all decor:duration-suite-fast decor:ease-out",
            "decor:focus-visible:outline-hidden",
            "decor:focus-visible:shadow-[0_0_0_3px_var(--color-suite-primary-100)]"
          ].join(" ")
        end
      end
    end
  end
end
