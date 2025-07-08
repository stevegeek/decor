# frozen_string_literal: true

module Decor
  module Forms
    class Form < PhlexComponent
      include ::Phlex::Rails::Helpers::FormWith

      prop :model, _Any, default: -> { false }
      prop :url, _Nilable(String)
      prop :local, _Boolean, default: true
      prop :http_method, _Nilable(_Interface(:to_s))
      prop :form_builder_class, _Class(ActionView::Helpers::FormBuilder), default: -> { ActionViewFormBuilder }

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

      # The form builder is accessible as it is used to render the form fields of the form when rendering
      # component content blocks.
      attr_reader :builder

      def view_template(&block)
        raw(
          form_with(**form_with_helper_options) do |builder|
            content = ""
            unless locked_version.nil?
              hidden_field_html = builder.hidden_field(:lock_version)
              content += hidden_field_html.to_s if hidden_field_html
            end
            yielded_form = form_contents(builder, &block)
            content += yielded_form.to_s if yielded_form
            content
          end
        )
      end

      private

      def locked_version
        return @model.lock_version if @model.respond_to?(:lock_version)
        @model[:lock_version] if @model.is_a?(Hash) && @model&.key?(:lock_version)
      end

      def form_with_helper_options
        options = {
          url: @url,
          local: @local,
          method: @http_method,
          html: {role: "form"},
          data: {
            turbo: false,
            type: (@local != true) ? "json" : nil,
            **stimulus_data_attributes,
            **stimulus_actions(
              [stimulus_scoped_event(:submit), :handle_custom_submit_event],
               [stimulus_scoped_event(:validate), :handle_validate_fields_event],
              *(local? ? [[:submit, :handle_submit_event]] : remote_form_actions)
            )
          },
          builder: @form_builder_class,
          namespace: @namespace
        }

        # Only include model if it's not the default false value
        options[:model] = @model unless @model == false

        options
      end

      def local?
        @local == true || @local.nil?
      end

      def remote_form_actions
        actions = [
          ["turbo:submit_start", :handle_submit_event]
        ]

        # TODO: fix this stuff up for Turbo
        # Add callback actions if specified, though the callbacks need to check
        # event.detail.formSubmission and event.detail.success etc to see if they are relevant
        # https://turbo.hotwired.dev/reference/events#forms
        actions << ["turbo:submit_start", @on_before] if @on_before
        actions << ["turbo:before_fetch_request", @on_before_send] if @on_before_send
        actions << ["turbo:submit_start", @on_send] if @on_send
        actions << ["turbo:before_fetch_request", @on_stopped] if @on_stopped
        actions << ["turbo:submit_end", @on_success] if @on_success
        actions << ["turbo:submit_end", @on_error] if @on_error
        actions << ["turbo:submit_end", @on_complete] if @on_complete

        actions
      end

      def form_contents(builder)
        @builder = builder
        yield if block_given?
      end
    end
  end
end
