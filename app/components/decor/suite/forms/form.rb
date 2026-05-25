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

          # Outlets to all FormField subclasses. Eager-load Suite/Components form
          # field files in development so that descendants reflects everything
          # actually shipped, not just whatever's been autoloaded by this request.
          if Rails.env.development?
            base = File.expand_path("../../components/forms", __dir__)
            Dir.glob(File.join(base, "*.rb")).each { |f| require_dependency f }
          end
          ::Decor::Components::Forms::FormField.descendants.each do |klass|
            add_stimulus_outlets(klass.stimulus_identifier)
          end
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

              content = +""

              unless locked_version.nil?
                hidden = @builder.hidden_field(:lock_version)
                content << hidden.to_s if hidden
              end

              if block
                captured = capture { block.call(self) }
                content << captured.to_s if captured.present?
              end

              content.html_safe
            end
          )
        end

        private

        # Vident's Action.parse expects Symbol events (not bare Strings —
        # those parse as controller paths), so use the quoted-symbol form.
        def remote_form_actions
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

        # Vident::Stimulus::Action carries its own controller/method routing,
        # so pass it through untouched and let Vident's [event, Action]
        # parsing add the event. Stringifying it would collapse the routing
        # into a bogus method name like `parent--ctrl#method`.
        def action_pair(event, value)
          return [event, value] if defined?(::Vident::Stimulus::Action) && value.is_a?(::Vident::Stimulus::Action)
          [event, value.is_a?(Symbol) ? value : value.to_s.to_sym]
        end
      end
    end
  end
end
