# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class FileUpload < ::Decor::Components::Forms::FileUpload
        def view_template
          root_element do |el|
            layout = ::Decor::Daisy::Forms::FormFieldLayout.new(
              **form_field_layout_options(el),
              stimulus_classes: {
                valid_label: @disabled ? "decor:text-disabled" : "decor:text-gray-900",
                invalid_label: "decor:text-error-dark"
              }
            )

            layout.helper_text_section do
              render ::Decor::Daisy::Forms::HelperTextSection.new(
                helper_text: @helper_text,
                error_text: error_text,
                disabled: @disabled,
                error_section: !floating_error_text?,
                collapsing_helper_text: @collapsing_helper_text
              )
            end

            render layout do
              if @preview_type == :avatar
                render ::Decor::Daisy::Avatar.new(
                  initials: @initials,
                  shape: @shape,
                  size: :lg,
                  url: file_url,
                  classes: "decor:decor--image-upload--image-container decor:shrink-0"
                )
              elsif @preview_type == :image
                div(class: "decor:decor--image-upload--image-container") do
                  if file_url
                    img(src: file_url, class: class_list_for_stimulus_classes(:image))
                  else
                    div(class: "decor:bg-white decor:relative decor:block decor:border-2 decor:border-gray-200 decor:border-dashed decor:rounded-md decor:py-12 decor:text-center decor:hover:border-gray-300") do
                      span(class: "decor:mt-2 decor:block decor:text-sm decor:text-low-emphasis") { "No image selected..." }
                    end
                  end
                end
              end

              label(class: "decor:block") do
                span(class: "decor:sr-only") { "Choose file to upload" }
                div(data: {**el.stimulus_action(:change, :file_selected)}) do
                  raw(
                    file_field(
                      @object_name,
                      @method_name,
                      accept: @file_mime_types,
                      required: @required,
                      disabled: @disabled,
                      name: @name,
                      data: {
                        **stimulus_controllers(form_control_controller),
                        **stimulus_target(:input)
                      },
                      class: file_input_classes
                    )
                  )
                end
              end

              if @clear_checkbox && (file_url || @existing_file_url.present?)
                div(class: "decor:flex decor:items-center") do
                  checkbox = ::Decor::Daisy::Forms::Checkbox.new(
                    name: field_name(@object_name, :"#{@method_name}_delete"),
                    disabled: @disabled,
                    collapsing_helper_text: true,
                    classes: "#{(@preview_layout == :inline) ? "decor:md:pl-6" : ""} decor:inline-block decor:w-auto",
                    value: "true"
                  )
                  render checkbox
                  label(for: "#{checkbox.id}-control", class: "decor:whitespace-nowrap decor:text-low-emphasis decor:text-sm") do
                    "Select to remove current file"
                  end
                end
              end

              render ::Decor::Daisy::Forms::ErrorIconSection.new(
                error_text: error_text,
                show_floating_message: floating_error_text?,
                classes: "#{errors? ? "" : "decor:hidden"} decor:right-3"
              )
            end
          end
        end

        private

        def input_container_classes
          "#{(@preview_layout == :inline) ? "decor:flex decor:items-end decor:space-x-6" : "decor:space-y-2"} decor:relative " + super
        end

        def file_input_classes
          classes = ["decor:d-file-input", "decor:w-full"]
          classes << component_size_classes(@size).join(" ")
          classes << component_color_classes(@color).join(" ")
          classes << "decor:d-file-input-error" if errors?
          classes.compact.join(" ").strip
        end

        def component_size_classes(size)
          case size
          when :xs then ["decor:d-file-input-xs"]
          when :sm then ["decor:d-file-input-sm"]
          when :md then [] # default
          when :lg then ["decor:d-file-input-lg"]
          when :xl then ["decor:d-file-input-xl"]
          else []
          end
        end

        def component_color_classes(color)
          case color
          when :primary then ["decor:d-file-input-primary"]
          when :secondary then ["decor:d-file-input-secondary"]
          when :accent then ["decor:d-file-input-accent"]
          when :success then ["decor:d-file-input-success"]
          when :error then ["decor:d-file-input-error"]
          when :warning then ["decor:d-file-input-warning"]
          when :info then ["decor:d-file-input-info"]
          when :ghost then ["decor:d-file-input-ghost"]
          when :neutral then ["decor:d-file-input-neutral"]
          else [] # base/neutral
          end
        end

        def preview_classes
          case @preview_type
          when :image
            # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
            "decor:max-h-[200px] #{image_tag_classes}"
          when :avatar
            # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
            "#{(@shape == :circle) ? "decor:rounded-full" : "decor:rounded-md"} #{image_tag_classes} decor:w-full"
          else
            ""
          end
        end

        def image_tag_classes
          # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
          "decor:h-full decor:object-cover decor:shrink-0 #{aspect_classes}"
        end
      end
    end
  end
end
