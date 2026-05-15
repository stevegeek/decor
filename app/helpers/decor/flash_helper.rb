# frozen_string_literal: true

module Decor
  # View helper that bridges the Rails request context (flash hash + current
  # controller/action) to the pure `Decor::*::Flash` components. Auto-resolves
  # the visual skin from `Decor.default_skin` when `skin:` is omitted.
  module FlashHelper
    SKINS = {
      daisy: "::Decor::Daisy::Flash",
      suite: "::Decor::Suite::Flash"
    }.freeze

    def decor_flash(skin: ::Decor.default_skin, **opts, &block)
      klass_name = SKINS.fetch(skin) do
        raise ArgumentError, "Unknown decor flash skin: #{skin.inspect}. Expected one of #{SKINS.keys.inspect}."
      end
      klass = klass_name.constantize

      ctrl = respond_to?(:controller) ? controller : nil
      context_opts = {
        flash_data: respond_to?(:flash) ? flash : nil,
        controller_path: ctrl&.controller_path,
        action_name: ctrl&.action_name
      }.compact

      render klass.new(**context_opts.merge(opts), &block)
    end
  end
end
