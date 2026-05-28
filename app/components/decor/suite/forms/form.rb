# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      class Form < ::Decor::Components::Forms::Form
        prop :on_before, _Nilable(_Interface(:to_s))
        prop :on_before_send, _Nilable(_Interface(:to_s))
        prop :on_send, _Nilable(_Interface(:to_s))
        prop :on_stopped, _Nilable(_Interface(:to_s))
        prop :on_success, _Nilable(_Interface(:to_s))
        prop :on_error, _Nilable(_Interface(:to_s))
        prop :on_complete, _Nilable(_Interface(:to_s))

        prop :form_builder_class,
          _Class(ActionView::Helpers::FormBuilder),
          default: -> { ::Decor::Suite::Forms::ActionViewFormBuilder }

        stimulus do
          targets :form
        end

        def after_component_initialize
          super if defined?(super)

          @actions_block = nil

          # Outlets to all FormField subclasses. Eager-load Suite/Components form
          # field files in development so that descendants reflects everything
          # actually shipped, not just whatever's been autoloaded by this request.
          if Rails.env.development?
            base = File.expand_path("../../components/forms", __dir__)
            Dir.glob(File.join(base, "*.rb")).each { |f| require_dependency f }
          end
          ::Decor::Components::Forms::FormField.descendants.each do |klass|
            add_stimulus_outlets(klass)
          end
        end

        # Deferred footer slot. Buttons passed here render in a separated,
        # right-aligned footer at the bottom of the form (inside the <form>, so
        # submit works) rather than inline where the call appears:
        #
        #   <%= render Suite::Forms::Form.new(...) do |f| %>
        #     <%= f.builder.text_field :title %>
        #     <% f.with_actions do %>
        #       <%= f.builder.submit "Save" %>
        #     <% end %>
        #   <% end %>
        def with_actions(&block)
          @actions_block = block
          self
        end

        def view_template(&block)
          raw(
            form_with(**form_with_helper_options) do |phlex_builder|
              # Unwrap to the raw Rails FormBuilder (the configured
              # `form_builder_class`). Leaves call `.hidden_field`,
              # `.text_field`, ... on this and expect a SafeBuffer return so
              # ERB's `<%= %>` prints it. The phlex-rails Builder wrapper
              # would instead push to a phlex buffer and return nil, which
              # would break ERB-driven leaves.
              @builder = phlex_builder.respond_to?(:unwrap) ? phlex_builder.unwrap : phlex_builder

              # Write the body straight into form_with's output buffer instead
              # of building a string via a nested `capture`. A nested capture
              # returns blank whenever this Form is rendered inside another
              # capturing slot (PageSection / Box / Card / PropertyList) or a
              # layout's content_for chain, silently dropping the form body
              # (the submit button et al). Writing inline lets ActionView's own
              # form_with capture collect the body exactly as it does for a
              # plain Rails form, which is reentrant across that nesting.
              vc = helpers

              unless locked_version.nil?
                hidden = @builder.hidden_field(:lock_version)
                vc.safe_concat(hidden) if hidden
              end

              block&.call(self)

              # Footer runs AFTER the body block (which is when `with_actions`
              # registers it) so its buttons land in the footer region
              # regardless of where the caller placed the `with_actions` call.
              if @actions_block
                vc.safe_concat(%(<div class="#{actions_footer_classes}">))
                @actions_block.call
                vc.safe_concat("</div>")
              end

              nil
            end
          )
        end

        private

        # Separated, right-aligned action region: a top hairline + spacing
        # divides it from the field stack; buttons flow end-aligned with a gap.
        def actions_footer_classes
          "decor:mt-4 decor:pt-4 decor:border-t decor:border-suite-hairline " \
            "decor:flex decor:flex-wrap decor:items-center decor:justify-end decor:gap-2"
        end

        # Vident's Action.parse expects Symbol events (not bare Strings —
        # those parse as controller paths), so use the quoted-symbol form.
        #
        # When `turbo: true`, defer to the base implementation which emits
        # turbo:* lifecycle events that Turbo Drive actually fires. When
        # `turbo: false` (default for Suite forms, preserving UJS callbacks),
        # emit the ajax:* event names UJS dispatches.
        def remote_form_actions
          return super if turbo?

          actions = [
            [:"ajax:beforeSend", :handle_submit_event]
          ]
          actions << action_pair(:"ajax:before", @on_before) if @on_before
          actions << action_pair(:"ajax:beforeSend", @on_before_send) if @on_before_send
          actions << action_pair(:"ajax:send", @on_send) if @on_send
          actions << action_pair(:"ajax:stopped", @on_stopped) if @on_stopped
          actions << action_pair(:"ajax:success", @on_success) if @on_success
          actions << action_pair(:"ajax:error", @on_error) if @on_error
          actions << action_pair(:"ajax:complete", @on_complete) if @on_complete
          actions
        end

      end
    end
  end
end
