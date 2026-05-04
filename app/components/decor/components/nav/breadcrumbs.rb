# frozen_string_literal: true

module Decor
  module Components
    module Nav
      # Abstract base for Breadcrumbs. Owns the prop API + the Breadcrumb
      # value-object inner class plus the breadcrumbs prop's normalisation
      # block (Hash / String-key Hash / Loaf-style duck-typed objects).
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus class-builder overrides for their visual language.
      class Breadcrumbs < ::Decor::PhlexComponent
        no_stimulus_controller

        class Breadcrumb < ::Literal::Data
          prop :name, _Nilable(String)
          prop :path, _Nilable(String)
          prop :current, _Boolean, default: false
          prop :icon, _Nilable(String)
          prop :disabled, _Boolean, default: false
        end

        prop(:breadcrumbs, _Array(Breadcrumb), default: -> { [] }) do |crumbs|
          crumbs.map do |crumb|
            case crumb
            when Hash
              # Support both name/path and label/href formats for backward compatibility
              # TODO: get rid of this backward compatibility in the future
              name = crumb[:name] || crumb["name"] || crumb[:label] || crumb["label"] || crumb[:title] || crumb["title"]
              path = crumb[:path] || crumb["path"] || crumb[:href] || crumb["href"]
              current = crumb.fetch(:current, crumb.fetch("current", false))
              icon = crumb[:icon] || crumb["icon"]
              disabled = crumb.fetch(:disabled, crumb.fetch("disabled", false))

              Breadcrumb.new(
                name: name,
                path: path,
                current: current,
                icon: icon,
                disabled: disabled
              )
            when Breadcrumb
              crumb
            else
              # Handle any other object that responds to name and path (like legacy Loaf::Breadcrumb)
              if crumb.respond_to?(:name) && crumb.respond_to?(:path)
                Breadcrumb.new(
                  name: crumb.name,
                  path: crumb.path,
                  current: crumb.respond_to?(:current) ? crumb.current : false,
                  icon: crumb.respond_to?(:icon) ? crumb.icon : nil,
                  disabled: crumb.respond_to?(:disabled) ? crumb.disabled : false
                )
              else
                crumb
              end
            end
          end
        end
        prop :show_home, _Boolean, default: true
        prop :home_path, String, default: "/"
        prop :home_icon, String, default: "home"
        prop :mobile_select, _Boolean, default: true
        prop :separator, String, default: "chevron-right"
      end
    end
  end
end
