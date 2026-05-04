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
                valid_label: @disabled ? "text-disabled" : "text-gray-900",
                invalid_label: "text-error-dark"
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
                  classes: "decor--image-upload--image-container shrink-0"
                )
              elsif @preview_type == :image
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
                div(class: "flex items-center") do
                  checkbox = ::Decor::Daisy::Forms::Checkbox.new(
                    name: field_name(@object_name, :"#{@method_name}_delete"),
                    disabled: @disabled,
                    collapsing_helper_text: true,
                    classes: "#{(@preview_layout == :inline) ? "md:pl-6" : ""} inline-block w-auto",
                    value: "true"
                  )
                  render checkbox
                  label(for: "#{checkbox.id}-control", class: "whitespace-nowrap text-low-emphasis text-sm") do
                    "Select to remove current file"
                  end
                end
              end

              render ::Decor::Daisy::Forms::ErrorIconSection.new(
                error_text: error_text,
                show_floating_message: floating_error_text?,
                classes: "#{errors? ? "" : "hidden"} right-3"
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
          classes << component_size_classes(@size).join(" ")
          classes << component_color_classes(@color).join(" ")
          classes << "file-input-error" if errors?
          classes.compact.join(" ").strip
        end

        def component_size_classes(size)
          case size
          when :xs then ["file-input-xs"]
          when :sm then ["file-input-sm"]
          when :md then [] # default
          when :lg then ["file-input-lg"]
          when :xl then ["file-input-xl"]
          else []
          end
        end

        def component_color_classes(color)
          case color
          when :primary then ["file-input-primary"]
          when :secondary then ["file-input-secondary"]
          when :accent then ["file-input-accent"]
          when :success then ["file-input-success"]
          when :error then ["file-input-error"]
          when :warning then ["file-input-warning"]
          when :info then ["file-input-info"]
          when :ghost then ["file-input-ghost"]
          when :neutral then ["file-input-neutral"]
          else [] # base/neutral
          end
        end

        def preview_classes
          case @preview_type
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
      end
    end
  end
end
