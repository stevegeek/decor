# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      class MultiImageUpload < ::Decor::Components::Forms::FormField
        include ::Phlex::Rails::Helpers::FieldName

        # Bind to the existing Daisy multi_image_upload Stimulus controller
        # (no Suite JS). Overriding stimulus_identifier_path makes Vident
        # emit `data-controller="decor--daisy--forms--multi-image-upload"`
        # plus all `…-target` / `…-value` data attrs under that identifier
        # — without this override, Vident emitted them under the Suite
        # path while the JS controller is registered under the Daisy path,
        # so `this.maxImagesValue` always resolved to 0 (the Stimulus-
        # Number-type default for a missing attribute) and the controller
        # alerted "Maximum of 0 images allowed".
        def self.stimulus_identifier_path
          "decor/daisy/forms/multi_image_upload"
        end

        DAISY_CTRL = "decor--daisy--forms--multi-image-upload"
        private_constant :DAISY_CTRL

        prop :existing_images, _Any, default: -> { [] }
        prop :max_size_in_mb, Integer, default: 5
        prop :file_mime_types, String, default: "image/png,image/gif,image/jpeg,image/webp"
        prop :max_images, Integer, default: 10
        prop :enable_crop, _Boolean, default: true
        prop :crop_aspect_w, _Nilable(Integer)
        prop :crop_aspect_h, _Nilable(Integer)

        stimulus do
          values_from_props :max_size_in_mb, :max_images, :file_mime_types
          values enable_crop: -> { @enable_crop },
            crop_aspect_w: -> { @crop_aspect_w || 0 },
            crop_aspect_h: -> { @crop_aspect_h || 0 }
        end

        def view_template
          root_element do
            render_label_section if @label.present?

            div(class: input_container_classes) do
              render_thumbnail_grid
              render_add_images_row
              render_hidden_inputs
              render_crop_modal if enable_crop?
            end

            render_helper_or_error_text
          end
        end

        private

        def root_element_classes
          [
            "decor--suite--forms--multi-image-upload",
            "decor:w-full",
            disabled? ? "decor:disabled" : nil,
            *grid_span_class
          ].compact.join(" ")
        end

        def enable_crop?
          @enable_crop
        end

        def input_container_classes
          "decor:mt-1"
        end

        def render_label_section
          div(class: "decor:mb-2") do
            label(
              for: "#{id}-control",
              class: label_classes
            ) { plain label_with_required }
            if @description.present?
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

        def render_thumbnail_grid
          div(
            data: target_data(:sortableContainer),
            class: "decor:grid decor:grid-cols-2 decor:sm:grid-cols-3 decor:md:grid-cols-4 decor:lg:grid-cols-5 decor:gap-3 decor:mb-3"
          ) do
            existing_image_data.each_with_index do |img, idx|
              render_existing_thumbnail(img, idx)
            end
          end
        end

        def render_existing_thumbnail(img, idx)
          div(
            class: thumbnail_wrapper_classes,
            data: {
              **target_data(:thumbnail),
              :"image-type" => "existing",
              :"signed-id" => img[:signed_id],
              :"blob-id" => img[:blob_id]
            }
          ) do
            img(
              src: img[:url],
              alt: img[:filename],
              crossorigin: "anonymous",
              class: "decor:w-full decor:h-full decor:object-cover",
              data: target_data(:thumbnailImage)
            )
            if idx == 0
              span(
                class: primary_badge_classes,
                data: target_data(:primaryBadge)
              ) { plain "Primary" }
            end
            div(class: "decor:absolute decor:inset-0 decor:bg-black/0 decor:group-hover:bg-black/20 decor:transition-colors decor:duration-suite-fast")
            render_action_buttons
          end
        end

        def render_action_buttons
          div(class: "decor:absolute decor:top-1 decor:right-1 decor:flex decor:gap-1 decor:opacity-0 decor:group-hover:opacity-100 decor:transition-opacity decor:duration-suite-fast") do
            if enable_crop?
              button(
                type: "button",
                class: crop_button_classes,
                title: "Crop image",
                data: {action: "click->#{DAISY_CTRL}#cropImage"}
              ) do
                render ::Decor::Icon.new(name: "scissors", html_options: {class: "decor:h-4 decor:w-4"})
              end
            end
            button(
              type: "button",
              class: remove_button_classes,
              title: "Remove image",
              data: {action: "click->#{DAISY_CTRL}#removeImage"}
            ) do
              render ::Decor::Icon.new(name: "x", html_options: {class: "decor:h-4 decor:w-4"})
            end
          end
        end

        def thumbnail_wrapper_classes
          "decor:relative decor:group decor:border decor:border-suite-hairline-strong decor:rounded-suite-control decor:overflow-hidden decor:bg-suite-gray-25 decor:aspect-square"
        end

        def primary_badge_classes
          "decor:absolute decor:top-1 decor:left-1 decor:bg-suite-primary-500 decor:text-white decor:text-xs decor:px-1.5 decor:py-0.5 decor:rounded-suite-control decor:font-medium"
        end

        def crop_button_classes
          "decor:p-1 decor:bg-white decor:rounded-suite-control decor:shadow decor:hover:bg-suite-gray-25 decor:text-gray-700 decor:transition-colors decor:duration-suite-fast"
        end

        def remove_button_classes
          "decor:p-1 decor:bg-white decor:rounded-suite-control decor:shadow decor:hover:bg-suite-danger-50 decor:text-suite-danger-500 decor:transition-colors decor:duration-suite-fast"
        end

        def render_add_images_row
          div(class: "decor:flex decor:items-center decor:gap-3") do
            render ::Decor::Suite::Button.new(
              label: "Add Images",
              icon: "plus",
              style: :outlined,
              color: :base,
              size: :sm,
              disabled: @disabled,
              html_options: {
                type: :button,
                data: {action: "click->#{DAISY_CTRL}#openFilePicker"}
              }
            )
            span(
              class: "decor:suite-body decor:text-gray-500",
              data: target_data(:imageCount)
            ) do
              plain "#{existing_image_data.size} / #{@max_images} images"
            end
          end
        end

        def render_hidden_inputs
          # The picker the user actually clicks through (cleared by the JS
          # after each selection so the same file can be re-picked).
          input(
            type: "file",
            multiple: true,
            accept: @file_mime_types,
            class: "decor:hidden",
            data: {
              :"#{DAISY_CTRL}-target" => "fileInput",
              :action => "change->#{DAISY_CTRL}#filesSelected"
            }
          )

          # Container the JS fills with image_order + remove_image_ids
          # hidden inputs every time the order or set changes.
          div(data: target_data(:hiddenFieldsContainer))

          # The actual file payload the server receives. The JS controller
          # stocks this via the DataTransfer API on every change so all
          # pending (picked + cropped) files ship with the form submit.
          input(
            type: "file",
            multiple: true,
            name: "#{field_name_for("new_images")}[]",
            class: "decor:hidden",
            data: target_data(:newFilesInput)
          )
        end

        def render_crop_modal
          div(
            class: "decor:fixed decor:inset-0 decor:z-50 decor:hidden",
            data: target_data(:cropModal)
          ) do
            div(class: "decor:absolute decor:inset-0 decor:bg-black/50")
            div(class: "decor:absolute decor:inset-4 decor:sm:inset-8 decor:md:inset-16 decor:bg-white decor:rounded-suite-control decor:shadow-xl decor:flex decor:flex-col") do
              render_crop_modal_header
              render_crop_modal_body
              render_crop_modal_footer
            end
          end
        end

        def render_crop_modal_header
          div(class: "decor:flex decor:items-center decor:justify-between decor:p-4 decor:border-b decor:border-suite-hairline-strong") do
            h3(class: "decor:suite-body decor:font-medium decor:text-gray-900") { plain "Crop Image" }
            button(
              type: "button",
              class: "decor:text-gray-400 decor:hover:text-gray-600 decor:transition-colors decor:duration-suite-fast",
              data: {action: "click->#{DAISY_CTRL}#cancelCrop"}
            ) do
              render ::Decor::Icon.new(name: "x", html_options: {class: "decor:h-6 decor:w-6"})
            end
          end
        end

        def render_crop_modal_body
          div(class: "decor:flex-1 decor:overflow-hidden decor:p-4") do
            img(
              src: "",
              alt: "Crop preview",
              class: "decor:max-w-full decor:max-h-full",
              data: target_data(:cropImage)
            )
          end
        end

        def render_crop_modal_footer
          div(class: "decor:flex decor:justify-end decor:gap-3 decor:p-4 decor:border-t decor:border-suite-hairline-strong") do
            render ::Decor::Suite::Button.new(
              label: "Cancel",
              style: :outlined,
              color: :base,
              html_options: {
                type: :button,
                data: {action: "click->#{DAISY_CTRL}#cancelCrop"}
              }
            )
            render ::Decor::Suite::Button.new(
              label: "Apply Crop",
              style: :filled,
              color: :primary,
              html_options: {
                type: :button,
                data: {action: "click->#{DAISY_CTRL}#applyCrop"}
              }
            )
          end
        end

        def render_helper_or_error_text
          return if silent_helper_and_error_text?

          if @helper_text.present? && !errors?
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

        def existing_image_data
          @existing_image_data ||= Array.wrap(@existing_images)
            .select { |img| img.respond_to?(:blob) && img.blob.present? }
            .map do |image|
              {
                signed_id: image.signed_id,
                blob_id: image.blob_id.to_s,
                url: helpers.rails_blob_path(image, only_path: true),
                filename: image.filename.to_s
              }
            end
        end

        def field_name_for(suffix)
          if @object_name.present?
            field_name(@object_name, suffix)
          else
            # No form-builder context — treat `name` as the object prefix so
            # the rendered name comes out `imgs[new_images][]`. The JS
            # controller strips `[new_images][]` to recover the object name.
            "#{@name}[#{suffix}]"
          end
        end

        def target_data(target_name)
          {:"#{DAISY_CTRL}-target" => target_name.to_s}
        end
      end
    end
  end
end
