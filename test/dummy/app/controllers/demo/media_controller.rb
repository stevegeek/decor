require "base64"

class Demo::MediaController < ApplicationController
  layout "demo"

  def index
    colors = ["#ef4444", "#10b981", "#3b82f6"]
    @slides = colors.each_with_index.map do |color, i|
      n = i + 1
      svg = %(<svg xmlns="http://www.w3.org/2000/svg" width="600" height="220">) +
        %(<rect width="600" height="220" fill="#{color}"/>) +
        %(<text x="300" y="125" font-size="44" fill="white" text-anchor="middle" font-family="sans-serif">Slide #{n}</text></svg>)
      {url: "data:image/svg+xml;base64,#{Base64.strict_encode64(svg)}", alt: "Slide #{n}"}
    end
  end
end
