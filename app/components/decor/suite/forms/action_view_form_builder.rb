# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      # Suite-skinned FormBuilder. Inherits from the Daisy-defaulted
      # `Decor::Forms::ActionViewFormBuilder` and overrides each helper that
      # has a Suite counterpart so callers driving the builder from ERB
      # (`form_component.builder.text_field :name`) get Suite chrome
      # instead of Daisy chrome.
      #
      # Methods without a Suite counterpart (file_field, rich_text_area,
      # tag_field, select_with_search, image_upload, avatar_upload,
      # collection_check_boxes) fall through to the parent and render
      # the Daisy component for now — the visual mismatch is accepted
      # until those components get a Suite port.
      class ActionViewFormBuilder < ::Decor::Forms::ActionViewFormBuilder
        def text_field(method, options = {}, &)
          create_tag(::Decor::Forms::TagWrappers::Suite::TextField, method, options, &)
        end

        def email_field(method, options = {}, &)
          create_tag(::Decor::Forms::TagWrappers::Suite::EmailField, method, options, &)
        end

        def password_field(method, options = {}, &)
          create_tag(::Decor::Forms::TagWrappers::Suite::PasswordField, method, options, &)
        end

        def date_field(method, options = {}, &)
          create_tag(::Decor::Forms::TagWrappers::Suite::DateField, method, options, &)
        end

        def hidden_field(method, options = {})
          @emitted_hidden_id = true if method == :id
          create_tag(::Decor::Forms::TagWrappers::Suite::HiddenField, method, options)
        end

        def text_area(method, options = {}, &)
          create_tag(::Decor::Forms::TagWrappers::Suite::TextArea, method, options, &)
        end

        def number_field(method, options = {}, &)
          create_tag(::Decor::Forms::TagWrappers::Suite::NumberField, method, options, &)
        end

        def button_radio_group(method, choices, options = {}, html_options = {}, &block)
          @template.capture(&block) if block
          ::Decor::Forms::TagWrappers::Suite::ButtonRadioGroup.new(
            object_name,
            method,
            @template,
            choices,
            objectify_options(options),
            html_options
          ).render
        end

        def check_box(method, options = {}, checked_value = "true", unchecked_value = "", &block)
          @template.tag.div do
            create_tag_with_values(
              ::Decor::Forms::TagWrappers::Suite::CheckBox,
              method,
              options,
              checked_value,
              unchecked_value,
              &block
            )
          end
        end

        def switch(method, options = {}, checked_value = "true", unchecked_value = "false", &)
          create_tag_with_values(
            ::Decor::Forms::TagWrappers::Suite::Switch,
            method,
            options,
            checked_value,
            unchecked_value,
            &
          )
        end

        def radio_button(method, selected_value, **options, &)
          create_tag_with_value(::Decor::Forms::TagWrappers::Suite::RadioButton, method, options, selected_value, &)
        end

        def select(method, choices, options = {}, html_options = {}, &block)
          @template.capture(&block) if block
          ::Decor::Forms::TagWrappers::Suite::Select.new(
            object_name,
            method,
            @template,
            choices,
            objectify_options(options),
            html_options
          ).render
        end

        def collection_select(
          method,
          collection,
          value_method,
          text_method,
          options = {},
          html_options = {}
        )
          choices = collection.map { |el| [el.send(text_method), el.send(value_method)] }
          ::Decor::Forms::TagWrappers::Suite::Select.new(
            object_name,
            method,
            @template,
            choices,
            objectify_options(options),
            html_options
          ).render
        end

        def grouped_collection_select(
          method,
          collection,
          group_method,
          group_label_method,
          option_key_method,
          option_value_method,
          options = {},
          html_options = {}
        )
          choices = send(:group_choices, collection, group_method, group_label_method, option_key_method, option_value_method)
          ::Decor::Forms::TagWrappers::Suite::Select.new(
            object_name,
            method,
            @template,
            choices,
            objectify_options(options),
            html_options
          ).render
        end

        def button(value = nil, options = {}, &)
          options = normalize_legacy_button_kwargs(options)
          options[:label] = value if value
          @template.render(::Decor::Suite::Button.new({view_context: @template}.merge(options)), &)
        end

        def button_link_to(value, path, options = {}, &block)
          options, path, value = path, value, nil if block
          options ||= {}
          options = normalize_legacy_button_kwargs(options)
          path = url_for(path) if path.is_a? Hash
          options[:label] = value if value && !block
          @template.render(::Decor::Suite::ButtonLink.new(href: path, http_method: options[:method], **options), &block)
        end

        def submit(label = nil, options = {}, &)
          options = normalize_legacy_button_kwargs(options)
          options = {style: :filled, color: :base}.merge(options)
          html_options = options.fetch(:html_options, {})
          options[:html_options] = {type: :submit, name: "commit", value: label || submit_default_value}.merge(html_options)
          options[:id] ||= field_id_generator(options, "submit")
          @template.render(::Decor::Suite::Button.new(label: label || "Submit", **options), &)
        end

        def submit_primary(label = nil, options = {}, &)
          submit(label, options.merge(color: :primary), &)
        end

        # `f.searchable_select(:foo, choices: …, search_url: …, label: …)` —
        # renders a Suite SearchableSelect bound to the form field. Mirrors
        # the ConfinusUI builder method of the same name so callers don't
        # need rewriting.
        #
        # Optional `label_resolver:` (Proc) lets the caller compute the
        # displayed label for the current value at render time — useful for
        # search-URL-backed selects where `choices:` isn't supplied and the
        # only thing the builder knows is an encoded_id. Resolver receives
        # the current value and must return `{id:, label:}` or `nil`.
        def searchable_select(method, options = {})
          options = options.dup
          options[:name] ||= "#{object_name}[#{method}]"
          resolver = options.delete(:label_resolver)
          options[:selected_item] ||= resolve_selected_item(method, options.delete(:selected_item), resolver)
          @template.render(::Decor::Suite::Forms::SearchableSelect.new(**options))
        end

        # `f.searchable_multi_select(:foo, choices: …, selected_items: […])` —
        # multi-select variant.
        def searchable_multi_select(method, options = {})
          options = options.dup
          options[:name] ||= "#{object_name}[#{method}][]"
          @template.render(::Decor::Suite::Forms::SearchableMultiSelect.new(**options))
        end

        private

        # Resolve `selected_item:` for the searchable_select(s):
        #   1. caller-supplied `selected_item:` always wins
        #   2. caller-supplied `label_resolver:` runs against current value
        #   3. fall back to a bare `{id: current_value}` (no label)
        # The bare-id fallback is enough for choices-backed selects (the
        # component looks up label in its `choices` array client-side); for
        # URL-backed selects without a resolver, the label will render blank
        # until the user opens the dropdown.
        def resolve_selected_item(method, explicit, resolver = nil)
          return explicit if explicit
          return nil unless @object.respond_to?(method)
          value = @object.public_send(method)
          return nil if value.blank?
          if resolver
            resolved = resolver.call(value)
            return resolved if resolved
          end
          {id: value}
        end

        # Translate the legacy ConfinusUI button vocabulary
        # (`theme:`/`variant:`/`icon_style:` with `:contained/:text/:secondary/
        # :danger/:small/:micro/:large/:medium` values) into the Suite
        # vocabulary (`color:`/`style:`/`icon_variant:` with
        # `:filled/:ghost/:base/:error/:sm/:xs/:lg/:md`). Lets the hundreds
        # of `f.button`/`f.submit`/`f.button_link_to` callers that pre-date
        # the migration keep working without touching every call site.
        # Drop this method when all callers are confirmed migrated.
        def normalize_legacy_button_kwargs(opts)
          return opts unless opts.is_a?(Hash)
          opts = opts.dup
          if opts.key?(:theme)
            opts[:color] ||= LEGACY_THEME_TO_COLOR.fetch(opts.delete(:theme)) { opts.delete(:theme) }
          end
          if opts.key?(:variant)
            opts[:style] ||= LEGACY_VARIANT_TO_STYLE.fetch(opts.delete(:variant)) { opts.delete(:variant) }
          end
          if opts.key?(:icon_style)
            opts[:icon_variant] ||= opts.delete(:icon_style)
          end
          if opts.key?(:size)
            opts[:size] = LEGACY_SIZE_REMAP.fetch(opts[:size], opts[:size])
          end
          opts
        end

        LEGACY_THEME_TO_COLOR = {
          secondary: :base,
          danger: :error
        }.freeze
        private_constant :LEGACY_THEME_TO_COLOR

        LEGACY_VARIANT_TO_STYLE = {
          contained: :filled,
          text: :ghost
        }.freeze
        private_constant :LEGACY_VARIANT_TO_STYLE

        LEGACY_SIZE_REMAP = {
          small: :sm,
          micro: :xs,
          large: :lg,
          medium: :md
        }.freeze
        private_constant :LEGACY_SIZE_REMAP
      end
    end
  end
end
