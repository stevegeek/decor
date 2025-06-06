# @label Banner
class ::Decor::BannerPreview < ::ViewComponent::Preview
  # Banner
  # -------
  #
  # A banner is a large header that is used to display a message to the user.
  #
  # @label Playground
  # @param body text
  # @param centered toggle
  # @param icon select [~, check-circle, x, check, download, play]
  # @param link select [~, "https://example.com"]
  # @param style select [warning, info, error, notice, success]
  def playground(body: "Hi!", centered: nil, icon: nil, link: nil, style: :notice)
    render ::Decor::Banner.new(link: link, centered: centered, icon: icon, style: style) do
      body
    end
  end
end
