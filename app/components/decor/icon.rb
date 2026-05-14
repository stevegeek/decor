# frozen_string_literal: true

require "set"

module Decor
  # Sprite-based icon component. Renders <svg><use href="sprite.svg#id"></svg>
  # against Decor's bundled Tabler sprite (default) or Decor's small custom-glyph
  # sprite (:decor). No skin variation — both Daisy and Suite consumers use
  # this class directly.
  class Icon < ::Decor::PhlexComponent
    no_stimulus_controller
    with_cache_key

    register_element :use

    prop :name, String
    prop :title, _Nilable(String)

    STYLE_OPTIONS = %i[outline solid small_solid].freeze
    prop :style, _Union(*STYLE_OPTIONS), default: :outline

    SPRITE_OPTIONS = %i[tabler decor].freeze
    prop :sprite, _Union(*SPRITE_OPTIONS), default: :tabler, reader: :public

    prop :width, Integer, default: 24
    prop :height, Integer, default: 24
    prop :view_box, _Nilable(String), reader: :public
    prop :stroke_width, _Nilable(_Any), reader: :public

    def view_template
      root_element do
        use(href: sprite_path_with_id)
      end
    end

    private

    def root_element_attributes
      resolved = resolved_style
      outline_stroke = (resolved == :outline)
      {
        element_tag: :svg,
        html_options: {
          xmlns: "http://www.w3.org/2000/svg",
          fill: outline_stroke ? "none" : "currentColor",
          viewBox: @view_box || "0 0 24 24",
          stroke_width: outline_stroke ? (@stroke_width&.to_s || "1.5") : nil,
          stroke: outline_stroke ? "currentColor" : nil,
          aria_hidden: true,
          title: @title,
          width: @width,
          height: @height
        }.compact
      }
    end

    # Falls back to :outline when a requested filled variant does not exist in
    # the tabler filled sprite, so we never emit a broken <use> reference.
    def resolved_style
      return @style unless @style == :solid || @style == :small_solid
      TABLER_FILLED_ICONS.include?(@name) ? @style : :outline
    end

    # Built once at class load. Tabler has ~5,000 outline icons but only ~1,000
    # filled counterparts; using a filled variant for an icon without one renders
    # a broken <use> reference. We parse the filled sprite's ids at boot so we
    # can silently fall back to outline when a filled variant does not exist.
    TABLER_FILLED_ICONS = begin
      sprite_path = ::Decor::Engine.root.join("app/assets/images/sprites/tabler-filled.svg")
      if sprite_path.file?
        sprite_path.read.scan(/id="tabler-filled-([a-z0-9-]+)"/).flatten.to_set
      else
        Set.new
      end
    end.freeze

    def sprite_path_with_id
      if @sprite == :decor
        return "#{helpers.asset_path("sprites/decor.svg")}#decor-#{@name}"
      end

      resolved = resolved_style
      if resolved == :solid || resolved == :small_solid
        "#{helpers.asset_path("sprites/tabler-filled.svg")}#tabler-filled-#{@name}"
      else
        "#{helpers.asset_path("sprites/tabler-outline.svg")}#tabler-#{@name}"
      end
    end
  end
end
