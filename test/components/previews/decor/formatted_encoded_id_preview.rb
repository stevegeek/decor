# @label FormattedEncodedId
class ::Decor::FormattedEncodedIdPreview < ::Lookbook::Preview
  # FormattedEncodedIdPreview
  # -------
  #
  # A component to render an encoded id with a prefix in a consistent format.
  #
  # @label Playground
  # @param prefix text
  # @param encoded_id text
  def playground(encoded_id: "prefix_9tns-29nt", prefix: nil)
    render ::Decor::FormattedEncodedId.new(
      encoded_id: encoded_id,
      prefix: prefix
    )
  end
end
