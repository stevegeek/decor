# frozen_string_literal: true

module Decor
  module Forms
    class ActionViewFormBuilder < ActionView::Helpers::FormBuilder
      METHODS_TO_PROXY = [
        :label,
        :color_field,
        :search_field,
        :telephone_field,
        :time_field,
        :datetime_field,
        :month_field,
        :week_field,
        :url_field,
        :range_field,
        :time_zone_select,
        :date_select,
        :time_select,
        :datetime_select
      ].freeze

      # We do this to be able to have a full set of form helper
      # methods available to us in the form component (as it checks for this classes instance
      # methods without the super defined ones to determine what helpers are available)
      METHODS_TO_PROXY.each do |method|
        define_method(method) do |*args, **options, &block|
          super(*args, **options, &block)
        end
      end

      # Below are all the form helper methods that are custom or overridden

      def collection_radio_buttons(
        method,
        collection,
        value_method,
        text_method,
        options = {},
        html_options = {},
        &block
      )
        elements = collection.map do |item|
          html = html_options.dup
          html[:skip_default_ids] = false
          field_options = options.merge(label: item.send(text_method), **html)
          radio_button(method, item.send(value_method), **field_options, &block)
        end
        elements.join.html_safe
      end

      def hidden_field(method, options = {})
        @emitted_hidden_id = true if method == :id
        create_tag(TagWrappers::HiddenField, method, options)
      end

      def radio_button(method, selected_value, **options, &)
        create_tag_with_value(TagWrappers::RadioButton, method, options, selected_value, &)
      end

      # Note: the ActionView::Helpers::FormBuilder implementation of the collection methods calls the underlying check_box
      # method on the view context @template (see implementation in in the ActionView::Helpers::FormHelper), ie it does not
      # call this form builder check_box helper method. Thus we need to implement it ourselves.
      # The options hash includes the ability normally to pass 'include_hidden' which adds a hidden input field
      # per checkbox. The html options hash is passed to the check_box tag. In our implementation
      # we are smashing all options together as we use the TagWrapper to parse the options. The collection is
      # wrapped by a Stimulus component which performs the required validation on the group
      def collection_check_boxes(
        method,
        collection,
        value_method,
        text_method,
        options = {},
        html_options = {},
        &block
      )
        elements =
          collection.map.with_index do |item, idx|
            html = html_options.dup
            html[:multiple] = true
            html[:skip_default_ids] = false
            if options[:hide_after_showing] && idx >= options[:hide_after_showing]
              html[:html_options] = {} unless html[:html_options]
              html[:html_options][:class] = "" unless html[:html_options][:class]
              html[:html_options][:class] += " hideable hidden"
            end
            field_options = options.merge(html).merge(label: item.send(text_method))
            check_box(method, field_options, item.send(value_method), &block)
          end
        head, *tail = elements
        boxes = tail.inject(head) { |e, m| m.concat(e) }
        component = ::Decor::Forms::ExpandingCheckboxCollection.new(
          **options.merge(name: "checkbox-collection-#{method}", size: collection.size)
        )
        component.instance_variable_set(:@checkboxes, boxes)
        @template.render component
      end

      def check_box(method, options = {}, checked_value = "true", unchecked_value = "", &block)
        @template.tag.div do
          create_tag_with_values(
            TagWrappers::CheckBox,
            method,
            options,
            checked_value,
            unchecked_value,
            &block
          )
        end
      end

      def avatar_upload(method, options = {})
        # If image upload used in forms, then form must be mutlipart: true
        self.multipart = true
        @template.render ::Decor::Forms::FileUpload.new(
          preview_type: :avatar,
          max_size_in_mb: 1,
          aspect_w: 1,
          aspect_h: 1,
          description: "Upload a .jpg or .png file, smaller than 1MB",
          file_mime_types: "image/png,image/gif,image/jpeg",
          name: field_name(object_name, method),
          object: @object,
          object_name: object_name,
          method_name: method,
          **options
        )
      end

      def image_upload(method, options = {})
        # If image upload used in forms, then form must be mutlipart: true
        self.multipart = true
        @template.render ::Decor::Forms::FileUpload.new(
          preview_type: :image,
          name: field_name(object_name, method),
          object: @object,
          object_name: object_name,
          method_name: method,
          **options
        )
      end

      def file_field(method, options = {})
        self.multipart = true
        @template.render ::Decor::Forms::FileUpload.new(
          name: field_name(object_name, method),
          object: @object,
          object_name: object_name,
          method_name: method,
          **options
        )
      end

      def select_with_search(method, choices, options = {}, html_options = {}, &block)
        attr = options[:multiple] ? {select_multiple_tags: true} : {select_searchable: true}
        options[:include_blank] ||=
          "Please search for and select #{options[:multiple] ? "some options" : "an option"}..."
        @template.render(
          ::Decor::Forms::FormFieldLayout.new(
            field_id: field_id_generator(options, "form_field_select_with_search"),
            **options
          )
        ) do
          @template.select(
            @object_name,
            method,
            choices,
            objectify_options(options),
            @default_html_options.merge(html_options.merge(multiple: options[:multiple], data: attr)),
            &block
          )
        end
      end

      def select(method, choices, options = {}, html_options = {}, &block)
        @template.capture(&block) if block
        TagWrappers::Select.new(
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

        TagWrappers::Select.new(
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
        choices =
          group_choices(
            collection,
            group_method,
            group_label_method,
            option_key_method,
            option_value_method
          )

        TagWrappers::Select.new(
          object_name,
          method,
          @template,
          choices,
          objectify_options(options),
          html_options
        ).render
      end

      def tag_field(method, options = {})
        options[:html_options] ||= {}
        options[:html_options][:class] ||= ""
        options[:html_options][:class] += " pb-6"
        @template.render(
          ::Decor::Forms::FormFieldLayout.new(
            field_id: field_id_generator(options, "form_field_tags"),
            **options
          )
        ) do
          @template.text_field(
            @object_name,
            method,
            objectify_options(options.merge(data: {input_multiple_tags: true}))
          )
        end
      end

      def date_field(method, options = {}, &)
        create_tag(TagWrappers::DateField, method, options, &)
      end

      def text_field(method, options = {}, &)
        create_tag(TagWrappers::TextField, method, options, &)
      end

      def text_area(method, options = {}, &)
        create_tag(TagWrappers::TextArea, method, options, &)
      end

      def rich_text_area(method, options = {})
        options[:html_options] ||= {}
        options[:html_options][:class] ||= ""
        options[:html_options][:class] += " w-full col-span-6"
        @template.render(
          ::Decor::Forms::FormFieldLayout.new(
            field_id: field_id_generator(options, "form_field_rich_text_area"),
            **options
          )
        ) do
          @template.rich_text_area(@object_name, method, objectify_options(options))
        end
      end

      def number_field(method, options = {}, &)
        create_tag(TagWrappers::NumberField, method, options, &)
      end

      def password_field(method, options = {}, &)
        create_tag(TagWrappers::PasswordField, method, options, &)
      end

      def email_field(method, options = {}, &)
        create_tag(TagWrappers::EmailField, method, options, &)
      end

      def switch(method, options = {}, checked_value = "true", unchecked_value = "false", &)
        create_tag_with_values(
          TagWrappers::Switch,
          method,
          options,
          checked_value,
          unchecked_value,
          &
        )
      end

      def switch_and_submit(method, options = {}, checked_value = "true", unchecked_value = "", &)
        switch(method, options.merge(submit_on_change: true), checked_value, unchecked_value, &)
      end

      def button(value = nil, options = {}, &)
        options[:label] = value if value
        @template.render(::Decor::Button.new({view_context: @template}.merge(options)), &)
      end

      def button_link_to(value, path, options = {}, &block)
        options, path, value = path, value, nil if block
        options ||= {}

        path = url_for(path) if path.is_a? Hash
        options[:label] = value if value && !block
        @template.render(::Decor::ButtonLink.new(href: path, http_method: options[:method], **options), &block)
      end

      def button_radio_group(method, choices, options = {}, html_options = {}, &block)
        @template.capture(&block) if block
        TagWrappers::ButtonRadioGroup.new(
          object_name,
          method,
          @template,
          choices,
          objectify_options(options),
          html_options
        ).render
      end

      def submit_primary(label = nil, options = {}, &)
        submit(label, options.merge(color: :primary), &)
      end

      def submit(label = nil, options = {}, &)
        options = {style: :filled, color: :secondary}.merge(options)
        html_options = options.fetch(:html_options, {})
        options[:html_options] = {type: :submit, name: "commit", value: label || submit_default_value}.merge(html_options)
        options[:id] ||= field_id_generator(options, "submit")
        @template.render(::Decor::Button.new(label: label || "Submit", **options), &)
      end

      private

      def group_choices(
        collection,
        group_method,
        group_label_method,
        option_key_method,
        option_value_method
      )
        collection.map do |el|
          group_label = el.send(group_label_method)
          group = el.send(group_method)
          group_options =
            group.map { |gel| [gel.send(option_key_method), gel.send(option_value_method)] }
          [group_label, group_options]
        end
      end

      def create_tag(klass, method, options, &block)
        @template.capture(&block) if block

        # Here the `render` method is the one on ActionView::Helpers::Tags::TextField and so on
        klass.new(object_name, method, @template, objectify_options(options)).render
      end

      def create_tag_with_value(klass, method, options, tag_value, &block)
        @template.capture(&block) if block

        # Here the `render` method is the one on ActionView::Helpers::Tags::TextField and so on
        klass.new(object_name, method, @template, tag_value, objectify_options(options)).render
      end

      def create_tag_with_values(klass, method, options, checked_value, unchecked_value, &block)
        @template.capture(&block) if block
        klass.new(
          object_name,
          method,
          @template,
          checked_value,
          unchecked_value,
          objectify_options(options)
        ).render
      end

      def field_id_generator(options, *)
        with_defaults = objectify_options(options)
        @template.field_id(@object_name, @method_name, *, index: with_defaults[:index], namespace: with_defaults[:namespace])
      end
    end
  end
end
