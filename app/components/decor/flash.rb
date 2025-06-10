# frozen_string_literal: true

module Decor
  class Flash < PhlexComponent
    attribute :title, String
    attribute :text, String
    attribute :preserve_flash, :boolean, default: false
    attribute :collapse_if_empty, :boolean, default: true

    attribute :flash
    attribute :controller_path, String
    attribute :action_name, String

    attribute :variant, Symbol, in: %i[warning info error notice success], default: :info

    def view_template
      if block_given? && !show_initial?
        yield
      else
        render parent_element do
          if show_initial?
            div(class: "alert #{alert_variant_class}") do
              div(class: "flex") do
                div(class: "flex-shrink-0") do
                  render ::Decor::Icon.new(name: icon, html_options: {class: "h-5 w-5"})
                end
                div(class: "ml-3") do
                  h3(class: "text-md font-medium") { title_with_defaults }
                  div(class: "mt-2 text-md") do
                    p { text_with_default }
                  end
                end
              end
            end
          end
        end
      end
    end

    private

    def root_element_attributes
      {
        actions: [
          [:"decor-flash:open@window", :handle_show_event],
          [:"decor-flash:close@window", :handle_close_event]
        ],
        values: [show_initial? ? {show_initial: true} : {}],
        html_options: show_initial? ? {} : {hidden: true}
      }
    end

    def element_classes
      base_classes = ["invisible opacity-0"]
      base_classes << "hidden" if @collapse_if_empty && !show_initial?
      base_classes.join(" ")
    end

    def alert_variant_class
      case resolved_variant
      when :success then "alert-success"
      when :error then "alert-error"
      when :warning then "alert-warning"
      when :info then "alert-info"
      when :notice then "alert-info"
      else "alert-info"
      end
    end

    # Similar to https://guides.rubyonrails.org/i18n.html#lazy-lookup we provide a way to define a default title for
    # the flash based on the controller and action name
    def title_with_defaults
      return @title if @title.present?
      string_key = "#{@controller_path || @helpers.controller_path}.#{@action_name || helpers.action_name}.flash.title.#{resolved_variant}"
      return I18n.t(string_key) if I18n.exists?(string_key)

      case resolved_variant
      when :success
        "Success!"
      when :error
        "An error exists."
      when :warning
        "Attention needed"
      else
        "Notice"
      end
    end

    def icon
      case resolved_variant
      when :success
        "check-circle"
      when :error
        "x-circle"
      when :warning
        "exclamation"
      else
        "information-circle"
      end
    end

    def show_initial?
      text_with_default.present?
    end

    def text_with_default
      @text_with_default ||= if @text.present?
        @text
      else
        set_variant(flash)
        text_sentences(flash[:success], flash.notice, flash.alert, flash[:errors]).tap do
          flash.clear unless @preserve_flash
        end
      end
    end

    def text_sentences(*sections)
      sections.flatten.compact.map(&:to_s).join(". ")
    end

    def set_variant(flash)
      @forced_variant =
        if flash[:errors].present?
          :error
        elsif flash[:success].present?
          :success
        elsif flash.notice.present?
          :notice
        elsif flash.alert.present?
          :warning
        else
          :info
        end
    end

    def resolved_variant
      @forced_variant || @variant
    end

    def flash
      @flash || helpers.flash
    end
  end
end
