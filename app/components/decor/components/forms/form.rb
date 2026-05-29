# frozen_string_literal: true

module Decor
  module Components
    module Forms
      class Form < ::Decor::PhlexComponent
        include ::Phlex::Rails::Helpers::FormWith

        prop :model, _Nilable(_Any), default: -> { false }
        prop :url, _Nilable(String)
        # Passed through to Rails' form_with for namespacing field names when
        # the model isn't its own implicit scope (e.g. devise resource_name).
        prop :scope, _Nilable(_Union(Symbol, String))
        prop :local, _Boolean, default: true
        prop :http_method, _Nilable(_Interface(:to_s))

        # Hint whether this form participates in Turbo Drive. `nil` (default)
        # omits the attribute so the form inherits Turbo behavior from the
        # nearest `data-turbo` ancestor — which, in a Turbo Drive app, means the
        # page/layout decides. `true` forces `data-turbo="true"`; `false` forces
        # `data-turbo="false"` to opt a single form out of Drive (e.g. on a
        # carve-out page or a legacy flow). Turbo handles submits natively and
        # wires Turbo.config.forms.confirm for `data-turbo-confirm` on submit
        # buttons.
        prop :turbo, _Nilable(_Boolean), default: nil
        prop :form_builder_class, _Class(ActionView::Helpers::FormBuilder), default: -> { ::Decor::Forms::ActionViewFormBuilder }

        prop :on_before, _Nilable(_Interface(:to_s))
        prop :on_before_send, _Nilable(_Interface(:to_s))
        prop :on_send, _Nilable(_Interface(:to_s))
        prop :on_stopped, _Nilable(_Interface(:to_s))
        prop :on_success, _Nilable(_Interface(:to_s))
        prop :on_error, _Nilable(_Interface(:to_s))
        prop :on_complete, _Nilable(_Interface(:to_s))

        prop :namespace, _Nilable(_Interface(:to_s))

        stimulus do
          targets :form
        end

        attr_reader :builder

        private

        def locked_version
          return @model.lock_version if @model.respond_to?(:lock_version)
          @model[:lock_version] if @model.is_a?(Hash) && @model&.key?(:lock_version)
        end

        def form_with_helper_options
          html = {role: "form"}
          html[:class] = @html_options[:class] if @html_options.is_a?(Hash) && @html_options[:class].present?
          # Propagate `id:` to the <form> tag so Modal::Form's footer Submit
          # button can target it via the HTML5 form="<id>" attribute.
          html[:id] = @id if @id

          own_actions = {**stimulus_actions(
            [stimulus_scoped_event(:submit), :handle_custom_submit_event],
            [stimulus_scoped_event(:validate), :handle_validate_fields_event],
            *(local? ? [[:submit, :handle_submit_event]] : remote_form_actions)
          )}

          data = {
            type: (@local != true && !turbo?) ? "json" : nil,
            **root_element_data_attributes
          }
          # Merge the form's own actions with any caller-supplied `stimulus_actions:`
          # (already aggregated by Vident into root_element_data_attributes[:action]).
          # A bare spread of own_actions would share the `:action` key and clobber
          # the caller's actions, silently dropping cross-controller listeners.
          data[:action] = [data[:action], own_actions[:action]].compact.reject(&:blank?).join(" ")
          data[:turbo] = @turbo unless @turbo.nil?

          options = {
            url: @url,
            local: @local,
            method: @http_method,
            html: html,
            data: data,
            builder: @form_builder_class,
            namespace: @namespace
          }

          options[:model] = @model unless @model == false
          options[:scope] = @scope if @scope

          options
        end

        def local?
          @local == true || @local.nil?
        end

        def turbo?
          @turbo == true
        end

        # Vident's parser treats bare Strings as controller paths, so event
        # names must be quoted Symbols (`:"turbo:submit_end"`). Symbol form
        # also lets Vident's `[Symbol, Action]` overload survive a parent
        # passing `on_success: stimulus_action(:foo)` cross-controller.
        def remote_form_actions
          actions = [
            [:"turbo:submit_start", :handle_submit_event]
          ]

          # TODO: fix this stuff up for Turbo
          # Add callback actions if specified, though the callbacks need to check
          # event.detail.formSubmission and event.detail.success etc to see if they are relevant
          # https://turbo.hotwired.dev/reference/events#forms
          actions << action_pair(:"turbo:submit_start", @on_before) if @on_before
          actions << action_pair(:"turbo:before_fetch_request", @on_before_send) if @on_before_send
          actions << action_pair(:"turbo:submit_start", @on_send) if @on_send
          actions << action_pair(:"turbo:before_fetch_request", @on_stopped) if @on_stopped
          actions << action_pair(:"turbo:submit_end", @on_success) if @on_success
          actions << action_pair(:"turbo:submit_end", @on_error) if @on_error
          actions << action_pair(:"turbo:submit_end", @on_complete) if @on_complete

          actions
        end

        # Shared action-pair builder. Passes a Vident::Stimulus::Action through
        # untouched so its cross-controller routing survives — stringifying
        # via `.to_s.to_sym` collapses `parent--ctrl#method` into a single
        # bogus method name on the form controller.
        def action_pair(event, value)
          return [event, value] if defined?(::Vident::Stimulus::Action) && value.is_a?(::Vident::Stimulus::Action)
          [event, value.is_a?(Symbol) ? value : value.to_s.to_sym]
        end

        def form_contents(builder)
          @builder = builder
          yield if block_given?
        end
      end
    end
  end
end
