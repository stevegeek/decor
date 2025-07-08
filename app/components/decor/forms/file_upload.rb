# frozen_string_literal: true

module Decor
  module Forms
    class FileUpload < FormField
      include ::Phlex::Rails::Helpers::FileField
      include ::Phlex::Rails::Helpers::FieldName

      prop :preview_layout, _Union(:stacked, :inline), default: :inline
      prop :description, String, default: "Upload a .jpg or .png file, smaller than 5MB"
      prop :file_mime_types, String, default: "image/png,image/gif,image/jpeg"

      prop :aspect_w, _Nilable(Integer)
      prop :aspect_h, _Nilable(Integer)

      prop :clear_checkbox, _Boolean, default: true

      prop :existing_file_url, _Nilable(String)
      prop :file, _Nilable(_Any)

      prop :variant, _Union(:file, :image, :avatar), default: :file

      prop :theme, _Union(:primary, :secondary), default: :secondary

      prop :initials, _Nilable(String)
      prop :shape, _Union(:circle, :square), default: :circle

      prop :max_size_in_mb, Integer, default: 5

      stimulus do
        values_from_props :max_size_in_mb
        classes image: -> { preview_classes }
      end

      def view_template
        root_element do |el|
          layout = ::Decor::Forms::FormFieldLayout.new(
            **form_field_layout_options(el),
            stimulus_classes: {
              valid_label: @disabled ? "text-disabled" : "text-gray-900",
              invalid_label: "text-error-dark"
            }
          )

          layout.helper_text_section do
            render ::Decor::Forms::HelperTextSection.new(
              helper_text: @helper_text,
              error_text: error_text,
              disabled: @disabled,
              error_section: !floating_error_text?,
              collapsing_helper_text: @collapsing_helper_text
            )
          end

          render layout do
            if @variant == :avatar
              render ::Decor::Avatar.new(
                initials: @initials,
                shape: @shape,
                size: :lg,
                url: file_url,
                html_options: {
                  class: "decor--image-upload--image-container shrink-0"
                }
              )
            elsif @variant == :image
              div(class: "decor--image-upload--image-container") do
                if file_url
                  img(src: file_url, class: class_list_for_stimulus_classes(:image))
                else
                  div(class: "bg-white relative block border-2 border-gray-200 border-dashed rounded-md py-12 text-center hover:border-gray-300") do
                    span(class: "mt-2 block text-sm text-low-emphasis") { "No image selected..." }
                  end
                end
              end
            end

            label(class: "block") do
              span(class: "sr-only") { "Choose file to upload" }
              div(data: {**el.stimulus_action(:change, :file_selected)}) do
                raw(
                  file_field(
                    attribute(:object_name),
                    attribute(:method_name),
                    accept: @file_mime_types,
                    required: @required,
                    disabled: @disabled,
                    name: @name,
                    data: {
                      :controller => form_control_controller,
                      "#{stimulus_identifier}-target" => "input"
                    },
                    class: file_input_classes
                  )
                )
              end
            end

            if @clear_checkbox && (file_url || @existing_file_url.present?)
              div(class: "flex items-center") do
                checkbox = ::Decor::Forms::Checkbox.new(
                  name: field_name(attribute(:object_name), :"#{attribute(:method_name)}_delete"),
                  disabled: @disabled,
                  collapsing_helper_text: true,
                  html_options: {
                    class: "#{(@preview_layout == :inline) ? "md:pl-6" : ""} inline-block w-auto"
                  },
                  value: "true"
                )
                render checkbox
                label(for: "#{checkbox.id}-control", class: "whitespace-nowrap text-low-emphasis text-sm") do
                  "Select to remove current file"
                end
              end
            end

            render ::Decor::Forms::ErrorIconSection.new(
              error_text: error_text,
              show_floating_message: floating_error_text?,
              html_options: {
                class: "#{errors? ? "" : "hidden"} right-3"
              }
            )
          end
        end
      end

      private

      def input_container_classes
        "#{(@preview_layout == :inline) ? "flex items-end space-x-6" : "space-y-2"} relative " + super
      end

      def file_input_classes
        classes = ["file-input", "w-full"]
        classes << file_input_color_class if @color && @color != :primary
        classes << file_input_size_class unless @size == :md
        classes << "file-input-error" if errors?
        classes.compact.join(" ")
      end

      def file_input_color_class
        case @color
        when :secondary then "file-input-secondary"
        when :accent then "file-input-accent"
        when :success then "file-input-success"
        when :error then "file-input-error"
        when :warning then "file-input-warning"
        when :info then "file-input-info"
        when :ghost then "file-input-ghost"
        when :neutral then "file-input-neutral"
        else ""
        end
      end

      def file_input_size_class
        case @size
        when :xs then "file-input-xs"
        when :sm then "file-input-sm"
        when :lg then "file-input-lg"
        when :xl then "file-input-xl"
        else ""
        end
      end

      def preview_classes
        case @variant
        when :image
          "max-h-[200px] #{image_tag_classes}"
        when :avatar
          "#{(@shape == :circle) ? "rounded-full" : "rounded-md"} #{image_tag_classes} w-full"
        else
          ""
        end
      end

      def image_tag_classes
        "h-full object-cover shrink-0 #{aspect_classes}"
      end

      def aspect_classes
        if @aspect_w == 1 && @aspect_h == 1
          "aspect-square"
        elsif @aspect_w == 3 && @aspect_h == 2
          "aspect-[3/2]"
        elsif @aspect_w == 4 && @aspect_h == 3
          "aspect-[4/3]"
        elsif @aspect_w == 16 && @aspect_h == 9
          "aspect-[16/9]"
        elsif @aspect_w == 2 && @aspect_h == 3
          "aspect-[2/3]"
        elsif @aspect_w == 3 && @aspect_h == 4
          "aspect-[3/4]"
        elsif @aspect_w == 9 && @aspect_h == 16
          "aspect-[9/16]"
        end
      end

      def file_url
        if @file.is_a?(String) || @existing_file_url.present?
          @file || @existing_file_url
        elsif @file.is_a?(::ActionDispatch::Http::UploadedFile)
          # We are given the tempfile of the uploaded file in cases where we are rendering from param data, but this
          # isnt useful as image isnt persisted to activestorage and cant be set again on form field.
          nil
        elsif @file.present?
          rails_blob_path(@file, only_path: true)
        end
      end
    end
  end
end
