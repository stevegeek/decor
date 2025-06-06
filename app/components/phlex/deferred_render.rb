# Was removed from Phlex in v2, but is needed by `phlex-slotable`
module Phlex
  module DeferredRender
    def before_template(&)
      vanish(&)
      super
    end
  end
end
