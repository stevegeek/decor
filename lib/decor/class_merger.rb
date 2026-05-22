# frozen_string_literal: true

require "tailwind_merge"

module Decor
  class ClassMerger
    def initialize(prefix: "decor:", underlying: nil)
      @prefix = prefix
      @underlying = underlying || (Thread.current[:decor_tailwind_merger] ||= ::TailwindMerge::Merger.new)
    end

    def merge(class_string)
      return class_string if class_string.nil? || class_string.empty?

      tokens = class_string.split(/\s+/).reject(&:empty?)
      return class_string if tokens.length < 2

      prefix_map = {}
      stripped_tokens = tokens.map do |t|
        stripped = t.delete_prefix(@prefix)
        prefix_map[stripped] = t.start_with?(@prefix)
        stripped
      end

      merged = @underlying.merge(stripped_tokens.join(" "))

      merged.split(/\s+/).map do |tok|
        prefix_map.fetch(tok, false) ? "#{@prefix}#{tok}" : tok
      end.join(" ")
    end
  end
end
