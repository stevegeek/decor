# frozen_string_literal: true

module Decor
  module Forms
    class Form < PhlexComponent
      attribute :model, default: proc { false }
      attribute :url, String
      attribute :local, :boolean, default: true
      attribute :http_method, Set[Symbol, String]
      attribute :form_builder_class, ActionView::Helpers::FormBuilder, default: ActionViewFormBuilder

      attribute :on_before, Set[Symbol, String]
      attribute :on_before_send, Set[Symbol, String]
      attribute :on_send, Set[Symbol, String]
      attribute :on_stopped, Set[Symbol, String]
      attribute :on_success, Set[Symbol, String]
      attribute :on_error, Set[Symbol, String]
      attribute :on_complete, Set[Symbol, String]

      attribute :namespace, Set[Symbol, String]

      # The form builder is accessible as it is used to render the form fields of the form when rendering
      # component content blocks.
      attr_reader :builder

      def view_template(&block)
        raw(
          helpers.form_with(**form_with_helper_options) do |builder|
            content = ""
            unless locked_version.nil?
              content += builder.hidden_field(:lock_version)
            end
            yielded_form = form_contents(builder, &block)
            content += yielded_form if yielded_form
            content
          end
        )
      end

      private

      def before_initialise(attrs)
        # mixin our standard actions etc
        attrs[:targets] ||= []
        attrs[:targets] << :form

        attrs[:actions] ||= []
        raise StandardError, "Actions should be an array" unless attrs[:actions].is_a?(Array)
        identifier = stimulus_identifier
        # common form actions

        # The following events are so we can trigger submit or validate programmatically,
        # via `decor--forms--form:submit` and `decor--forms--form:validate`
        attrs[:actions] << ["#{identifier}:submit", identifier, "handleCustomSubmitEvent"]
        attrs[:actions] << ["#{identifier}:validate", identifier, "handleValidateFieldsEvent"]

        # local vs remote form actions
        if attrs[:local] == true || attrs[:local].nil?
          attrs[:actions] << ["submit", identifier, "handleSubmitEvent"]
        else
          # UJS triggers `ajax:` events that we use to trigger our own events
          attrs[:actions] << ["ajax:beforeSend", identifier, "handleSubmitEvent"]

          attrs[:actions] << "ajax:before->#{attrs[:on_before]}" if attrs[:on_before]
          attrs[:actions] << "ajax:beforeSend->#{attrs[:on_before_send]}" if attrs[:on_before_send]
          attrs[:actions] << "ajax:send->#{attrs[:on_send]}" if attrs[:on_send]
          attrs[:actions] << "ajax:stopped->#{attrs[:on_stopped]}" if attrs[:on_stopped]

          attrs[:actions] << "ajax:success->#{attrs[:on_success]}" if attrs[:on_success]
          attrs[:actions] << "ajax:error->#{attrs[:on_error]}" if attrs[:on_error]
          attrs[:actions] << "ajax:complete->#{attrs[:on_complete]}" if attrs[:on_complete]
        end
      end

      def locked_version
        return @model.lock_version if @model.respond_to?(:lock_version)
        @model[:lock_version] if @model.is_a?(Hash) && @model&.key?(:lock_version)
      end

      def form_with_helper_options
        resolved_stimulus_options = stimulus_options_for_component({})
        root_component = ::Vident::Phlex::RootComponent.new(**resolved_stimulus_options)
        options = {
          model: @model,
          url: @url,
          local: @local,
          method: @http_method,
          html: {role: "form"},
          class: resolved_stimulus_options[:html_options]&.fetch(:class, nil),
          data: {
            turbo: false,
            type: (@local != true) ? "json" : nil,
            **root_component.send(:tag_data_attributes)
          },
          builder: @form_builder_class,
          namespace: @namespace
        }
        options[:id] = resolved_stimulus_options[:id] if resolved_stimulus_options[:id]
        options
      end

      def form_contents(builder)
        @builder = builder
        yield
      end
    end
  end
end
