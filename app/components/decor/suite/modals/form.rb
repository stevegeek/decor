# frozen_string_literal: true

module Decor
  module Suite
    module Modals
      # Suite skin of Modals::Form — a Suite Modal pre-wired with a Cancel/Submit
      # footer for the common "edit X" dialog pattern.
      #
      # The caller supplies the <form> body — either inline as the block body,
      # or lazily via `content_href:` (the form HTML is fetched from the server
      # on first open and injected into the modal body).
      #
      # Cancel + Submit buttons are pre-rendered in the modal footer. Because
      # the Submit button lives in the footer (outside the form's DOM), the
      # HTML5 `form="..."` attribute is used to associate it with the form.
      # The <form> element in the fragment must carry an `id:` matching
      # `form_id` (auto-derived from the Vident id; read it via `form_id`
      # wherever you need it).
      #
      # Inline example:
      #
      #   modal = ::Decor::Suite::Modals::Form.new(title: "Edit item")
      #   render modal do
      #     form_with url: item_path(@item), id: modal.form_id do |f|
      #       f.text_field :name
      #     end
      #   end
      #
      # Lazy-loaded (shared-modal) example:
      #
      #   edit_modal = ::Decor::Suite::Modals::Form.new(title: "Edit price")
      #   render edit_modal
      #
      #   render ::Decor::Suite::Modals::ModalOpenButton.new(
      #     modal_id: edit_modal.id,
      #     content_href: "/edit?form_id=#{edit_modal.form_id}",
      #     title: "Price: SKU-123",
      #     label: "Edit"
      #   )
      #
      # The fetched fragment must include `<form id="<%= params[:form_id] %>">`
      # so the footer Submit button can target it. The fragment must NOT
      # render its own Cancel/Submit — those are owned here.
      class Form < ::Decor::Components::Modals::Form
        def view_template(&body_block)
          modal = ::Decor::Suite::Modals::Modal.new(
            id: id,
            title: @title,
            description: @description,
            variant: @variant,
            size: @size,
            closeable: true,
            start_open: @start_open,
            content_href: @content_href,
            initial_content: @initial_content
          )

          modal.with_footer do
            # Destructive-action slot: empty by default; populated client-side
            # by ModalController when the loaded fragment contains a
            # <template data-modal-destructive-action>. `mr-auto` pins it left
            # regardless of population state.
            div(class: "decor:mr-auto", data: {modal_destructive_slot: true})
            render cancel_button
            render submit_button
          end

          if block_given?
            render modal, &body_block
          else
            render modal
          end
        end

        private

        def cancel_button
          ::Decor::Suite::Modals::ModalCloseButton.new(
            label: @cancel_label,
            size: :sm,
            color: :base,
            style: :outlined
          )
        end

        def submit_button
          ::Decor::Suite::Button.new(
            label: @submit_label,
            size: :sm,
            color: submit_button_color,
            style: :filled,
            html_options: {type: "submit", form: form_id}
          )
        end

        # Map Form's submit_color → Suite::Button's color vocabulary.
        # (Suite::Button uses `:error` rather than `:danger`.)
        def submit_button_color
          case @submit_color
          when :error then :error
          when :warning then :warning
          else :primary
          end
        end
      end
    end
  end
end
