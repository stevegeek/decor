# frozen_string_literal: true

module Decor
  module Components
    module Forms
      class FileUpload < ::Decor::Components::Forms::FormField
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

        prop :preview_type, _Union(:file, :image, :avatar), default: :file

        prop :theme, _Union(:primary, :secondary), default: :secondary

        prop :initials, _Nilable(String)
        prop :shape, _Union(:circle, :square), default: :circle

        prop :max_size_in_mb, Integer, default: 5

        stimulus do
          values_from_props :max_size_in_mb
          classes image: -> { preview_classes }
        end

        private

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
end
