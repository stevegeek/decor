# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      # Suite Form — top-level form wrapper. Renders Rails' `form_with` and
      # exposes the underlying Rails FormBuilder (the configured
      # `form_builder_class`) via `form_component.builder` so block callers
      # can drive ERB-style `<%= form_component.builder.text_field :foo %>`.
      #
      # Behaviors preserved from the historical Suite identity:
      # - Yields `self` (the Form component) as the block argument so callers
      #   can use `form_component.builder.x` from ERB and Phlex alike.
      # - Wires up an outlet per FormField descendant for client-side
      #   validation orchestration by the Stimulus controller.
      # - Sets `novalidate` on the <form> element via JS so the browser
      #   doesn't fire native validation alongside our own.
      # - Local forms route the native `submit` event through the controller
      #   for validation. Remote forms (`local: false`) wire jQuery-UJS-style
      #   `ajax:*` lifecycle callbacks (on_before / on_send / on_success /
      #   on_error / on_complete / ...) — not Turbo's `turbo:*` events.
      class Form < ::Decor::Components::Forms::Form
        prop :on_before, _Nilable(_Interface(:to_s))
        prop :on_before_send, _Nilable(_Interface(:to_s))
        prop :on_send, _Nilable(_Interface(:to_s))
        prop :on_stopped, _Nilable(_Interface(:to_s))
        prop :on_success, _Nilable(_Interface(:to_s))
        prop :on_error, _Nilable(_Interface(:to_s))
        prop :on_complete, _Nilable(_Interface(:to_s))

        # Default the Suite Form to the Suite-skinned FormBuilder so leaf
        # calls like `form_component.builder.text_field :name` render Suite
        # components, not Daisy.
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
                # Yield `self` (the Form component) so callers can do
                # `do |form_component| form_component.builder.x end`. ERB
                # callers `<%= form_component.builder.x %>` and Phlex
                # callers `form_component.raw(...)` are both supported:
                # we capture the block via Phlex's capture so any buffer
                # writes during the block are returned as a SafeBuffer,
                # while non-buffer-returning blocks fall through to their
                # return value.
                captured = capture { block.call(self) }
                content << captured.to_s if captured.present?
              end

              content.html_safe
            end
          )
        end

        private

        # Override the abstract base's Turbo-flavored remote actions with the
        # jQuery-UJS-style `ajax:*` lifecycle that the Suite controller is
        # written against. Vident's Action.parse expects Symbol events (not
        # bare Strings — those parse as controller paths), so use the
        # quoted-symbol form.
        def remote_form_actions
          actions = [
            [:"ajax:beforeSend", :handle_submit_event]
          ]
          actions << [:"ajax:before", to_action_method(@on_before)] if @on_before
          actions << [:"ajax:beforeSend", to_action_method(@on_before_send)] if @on_before_send
          actions << [:"ajax:send", to_action_method(@on_send)] if @on_send
          actions << [:"ajax:stopped", to_action_method(@on_stopped)] if @on_stopped
          actions << [:"ajax:success", to_action_method(@on_success)] if @on_success
          actions << [:"ajax:error", to_action_method(@on_error)] if @on_error
          actions << [:"ajax:complete", to_action_method(@on_complete)] if @on_complete
          actions
        end

        def to_action_method(value)
          value.is_a?(Symbol) ? value : value.to_s.to_sym
        end
      end
    end
  end
end
