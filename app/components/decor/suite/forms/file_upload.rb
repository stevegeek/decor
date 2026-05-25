# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      class FileUpload < ::Decor::Components::Forms::FileUpload
        # The Daisy controller identifier — the JS for drag/drop, file
        # validation and preview is registered under this name.
        DAISY_CTRL = "decor--daisy--forms--file-upload"
        DAISY_CTRL_PATH = "decor/daisy/forms/file_upload"
        private_constant :DAISY_CTRL, :DAISY_CTRL_PATH

        stimulus do
          controllers DAISY_CTRL_PATH
        end

        prop :variant, _Nilable(_Union(:file, :image, :avatar))

        def after_component_initialize
          @preview_type = @variant if @variant
        end

        def view_template
          root_element do
            render_label_section if @label.present?

            div(class: input_container_classes) do
              case @preview_type
              when :avatar
                render_avatar_variant
              when :image
                render_image_variant
              else
                render_file_variant
              end
            end

            render_helper_or_error_text
          end
        end

        private

        def root_element_classes
          [
            "decor--suite--forms--file-upload",
            "decor:w-full",
            disabled? ? "decor:disabled" : nil,
            *grid_span_class
          ].compact.join(" ")
        end

        def render_label_section
          div(class: "decor:mb-2") do
            label(
              for: "#{id}-control",
              class: label_classes
            ) { plain label_with_required }
            if @description.present? && @preview_type != :file
              # For :file variant the description is shown inside the drop
              # zone — don't double-render it.
              p(class: "decor:suite-field-help decor:text-gray-500") { plain @description }
            end
          end
        end

        def label_classes
          [
            "decor:block decor:suite-field-label",
            disabled? ? "decor:text-gray-400" : "decor:text-gray-900",
            errors? ? "decor:text-suite-danger-700" : nil
          ].compact.join(" ")
        end

        def render_avatar_variant
          render ::Decor::Suite::Avatar.new(
            initials: @initials,
            shape: @shape,
            size: :xl,
            url: file_url,
            classes: "decor:shrink-0"
          )

          label(class: "decor:block") do
            span(class: "decor:sr-only") { plain "Choose file to upload" }
            div(data: file_selected_action_data) do
              file_field(
                @object_name, @method_name,
                accept: @file_mime_types,
                required: @required,
                disabled: @disabled,
                name: @name,
                data: file_input_data,
                class: avatar_file_input_classes
              )
            end
          end

          if @clear_checkbox && (file_url || @existing_file_url.present?)
            render_clear_checkbox
          end
        end

        def avatar_file_input_classes
          [
            "decor:block decor:w-full decor:suite-body decor:text-gray-500",
            "decor:file:mr-4 decor:file:py-1.5 decor:file:px-3",
            "decor:file:rounded-suite-control decor:file:border",
            "decor:file:border-suite-hairline-strong",
            "decor:file:text-xs decor:file:font-medium",
            "decor:file:transition-colors decor:duration-suite-fast decor:ease-out",
            "decor:file:cursor-pointer",
            avatar_file_button_theme_classes
          ].join(" ")
        end

        def avatar_file_button_theme_classes
          if @theme == :primary
            if disabled?
              "decor:file:opacity-50 decor:file:bg-suite-primary-500 decor:file:text-white"
            else
              "decor:file:bg-suite-primary-500 decor:hover:file:bg-suite-primary-600 decor:file:text-white"
            end
          elsif disabled?
            "decor:file:bg-gray-50 decor:file:text-gray-400 decor:file:cursor-not-allowed"
          else
            "decor:file:bg-white decor:hover:file:bg-suite-gray-25 decor:file:text-gray-700"
          end
        end

        def render_image_variant
          div(class: "decor:flex decor:items-start decor:gap-4") do
            render_image_thumbnail
            div(class: "decor:flex decor:items-center decor:pt-1") do
              render ::Decor::Suite::Button.new(
                label: "Choose Image",
                icon: "plus",
                style: :outlined,
                color: :base,
                size: :sm,
                disabled: @disabled,
                html_options: {
                  type: :button,
                  data: stimulus_action_data(:open_file_picker)
                }
              )
            end
          end

          div(data: file_selected_action_data) do
            file_field(
              @object_name, @method_name,
              accept: @file_mime_types,
              required: @required,
              disabled: @disabled,
              name: @name,
              data: file_input_data,
              class: "decor:hidden"
            )
          end

          if @clear_checkbox
            input(
              type: "hidden",
              name: field_name(@object_name, :"#{@method_name}_delete"),
              value: "false",
              data: target_data(:deleteField)
            )
          end
        end

        def render_image_thumbnail
          if file_url
            div(
              class: image_thumb_wrapper_classes,
              data: target_data(:thumbnailWrapper)
            ) do
              img(
                src: file_url,
                class: "decor:w-full decor:h-full decor:object-cover",
                data: target_data(:thumbnailImage)
              )
              div(class: "decor:absolute decor:inset-0 decor:bg-black/0 decor:group-hover:bg-black/20 decor:transition-colors")
              unless disabled?
                div(class: "decor:absolute decor:top-1 decor:right-1 decor:flex decor:gap-1 decor:opacity-0 decor:group-hover:opacity-100 decor:transition-opacity") do
                  button(
                    type: "button",
                    class: image_remove_button_classes,
                    title: "Remove image",
                    data: {action: "click->#{DAISY_CTRL}#removeImage"}
                  ) do
                    render ::Decor::Icon.new(name: "x", html_options: {class: "decor:h-3.5 decor:w-3.5"})
                  end
                end
              end
            end
          else
            div(
              class: image_empty_wrapper_classes,
              data: target_data(:thumbnailWrapper)
            ) do
              render ::Decor::Icon.new(name: "photo", html_options: {class: "decor:h-7 decor:w-7 decor:mb-1 decor:text-gray-300"})
              span(class: "decor:suite-field-help decor:text-gray-400") { plain "No image" }
            end
          end
        end

        def image_thumb_wrapper_classes
          "decor:relative decor:group decor:border decor:border-suite-hairline decor:rounded-suite-control decor:overflow-hidden decor:bg-suite-gray-25 decor:w-28 decor:h-28"
        end

        def image_empty_wrapper_classes
          "decor:border decor:border-suite-hairline decor:rounded-suite-control decor:bg-suite-gray-25 decor:w-28 decor:h-28 decor:flex decor:flex-col decor:items-center decor:justify-center decor:text-gray-400"
        end

        def image_remove_button_classes
          "decor:p-1 decor:bg-white decor:rounded-suite-control decor:shadow decor:hover:bg-suite-danger-50 decor:text-suite-danger-500 decor:transition-colors decor:duration-suite-fast"
        end

        def render_file_variant
          label(class: "decor:block decor:cursor-pointer") do
            span(class: "decor:sr-only") { plain "Choose file to upload" }
            div(
              class: file_drop_zone_classes,
              data: file_drop_zone_data
            ) do
              div(class: "decor:w-8 decor:h-8 decor:mx-auto decor:mb-2 decor:text-gray-400") do
                raw safe(<<~SVG)
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="w-full h-full">
                    <path d="M12 16V4m0 0L8 8m4-4 4 4"/>
                    <path d="M20.39 18.39A5 5 0 0 0 18 9h-1.26A8 8 0 1 0 3 16.3"/>
                  </svg>
                SVG
              end
              p(class: "decor:suite-body decor:text-gray-800 decor:font-medium decor:m-0 decor:mb-[2px]") do
                span(class: "decor:text-suite-primary-500 decor:cursor-pointer") { plain "Click to upload" }
                plain " or drag and drop"
              end
              p(class: "decor:suite-field-help decor:text-gray-500 decor:m-0") { plain @description }

              div(data: file_selected_action_data) do
                file_field(
                  @object_name, @method_name,
                  accept: @file_mime_types,
                  required: @required,
                  disabled: @disabled,
                  name: @name,
                  data: file_input_data,
                  class: "decor:sr-only"
                )
              end
            end

            div(data: target_data(:fileList), class: "decor:mt-2 decor:space-y-1")
          end
        end

        def file_drop_zone_classes
          [
            "decor:border decor:border-dashed decor:border-suite-hairline-strong",
            "decor:rounded-suite-control decor:px-8 decor:py-6 decor:text-center",
            "decor:bg-suite-gray-25",
            "decor:transition-all decor:duration-suite-fast decor:ease-out",
            "decor:hover:border-suite-primary-500 decor:hover:bg-suite-primary-50",
            disabled? ? "decor:opacity-50 decor:cursor-not-allowed" : "decor:cursor-pointer"
          ].join(" ")
        end

        def file_drop_zone_data
          {
            "#{DAISY_CTRL}-target": "dropZone",
            action: "dragover->#{DAISY_CTRL}#onDragOver dragleave->#{DAISY_CTRL}#onDragLeave drop->#{DAISY_CTRL}#onDrop",
            "#{DAISY_CTRL}-drag-over-class": "decor:border-suite-primary-500 decor:bg-suite-primary-50"
          }
        end

        def render_clear_checkbox
          div(class: "decor:flex decor:items-center") do
            checkbox = ::Decor::Suite::Forms::Checkbox.new(
              name: field_name(@object_name, :"#{@method_name}_delete"),
              disabled: @disabled,
              collapsing_helper_text: true,
              classes: "#{"decor:md:pl-6" if @preview_layout == :inline} decor:inline-block decor:w-auto",
              value: "true"
            )
            render checkbox
            label(
              for: "#{checkbox.id}-control",
              class: "decor:whitespace-nowrap decor:text-gray-500 decor:suite-field-help"
            ) do
              plain "Select to remove current file"
            end
          end
        end

        def render_helper_or_error_text
          return if silent_helper_and_error_text?

          if @helper_text.present? && !errors? && @preview_type != :file
            # :file variant already shows the description inside the zone —
            # avoid stacking a second helper line.
            p(class: helper_text_classes) { plain @helper_text }
          end

          if errors?
            p(class: error_text_classes) { plain error_text }
          end
        end

        def silent_helper_and_error_text?
          @helper_text.blank? && !errors?
        end

        def helper_text_classes
          [
            "decor:suite-field-help",
            disabled? ? "decor:text-gray-400" : "decor:text-gray-500"
          ].join(" ")
        end

        def error_text_classes
          "decor:suite-field-help decor:text-suite-danger-500"
        end

        def input_container_classes
          base = (@preview_layout == :inline) ? "decor:flex decor:items-end decor:space-x-6" : "decor:space-y-2"
          "decor:relative #{base}"
        end

        def file_input_data
          {
            controller: form_control_controller,
            "#{DAISY_CTRL}-target": "input"
          }
        end

        def file_selected_action_data
          {action: "change->#{DAISY_CTRL}#fileSelected"}
        end

        def stimulus_action_data(action_name)
          {action: "click->#{DAISY_CTRL}##{action_name.to_s.camelize(:lower)}"}
        end

        def target_data(target_name)
          {"#{DAISY_CTRL}-target": target_name.to_s}
        end

        # Referenced by the inherited `stimulus do` block (classes image: -> { preview_classes }).
        def preview_classes
          case @preview_type
          when :image
            "decor:max-h-[200px] #{image_tag_classes}"
          when :avatar
            "#{(@shape == :circle) ? "decor:rounded-full" : "decor:rounded-suite-control"} #{image_tag_classes} decor:w-full"
          else
            ""
          end
        end

        def image_tag_classes
          "decor:h-full decor:object-cover decor:shrink-0 #{aspect_classes}"
        end
      end
    end
  end
end
