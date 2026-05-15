# @label Box
class ::Decor::Suite::BoxPreview < ::Lookbook::Preview
  # Box (Suite)
  # -----------
  #
  # Horizontal row container with a title + description column on the left and
  # an optional actions cluster on the right. Use for settings rows, summary
  # strips, and list-item-like layouts.
  #
  # @group Examples
  # @label Title + description
  def title_and_description
    render ::Decor::Suite::Box.new(
      title: "Email notifications",
      description: "Receive a digest of activity once per day."
    )
  end

  # @group Examples
  # @label With right actions
  def with_right_actions
    render ::Decor::Suite::Box.new(
      title: "API key",
      description: "Used to authenticate webhook deliveries."
    ) do |box|
      box.right { "<button class=\"decor:px-3 decor:py-1 decor:rounded-suite-control decor:border decor:border-suite-hairline\">Rotate</button>".html_safe }
    end
  end

  # @group Examples
  # @label Block content (right cluster)
  def with_block_content
    render ::Decor::Suite::Box.new(
      title: "Plan",
      description: "Currently on the Pro plan."
    ) do
      "<span class=\"decor:suite-caption decor:text-suite-primary-700\">PRO</span>".html_safe
    end
  end

  # @group Examples
  # @label HTML title
  def with_html_title
    render ::Decor::Suite::Box.new(
      description: "Custom heading markup via the html_title slot."
    ) do |box|
      box.html_title { "<span>Advanced <em>settings</em></span>".html_safe }
    end
  end

  # @group Examples
  # @label Left slot replaces title column
  def with_left_slot
    render ::Decor::Suite::Box.new do |box|
      box.left { "<div class=\"decor:flex decor:items-center decor:gap-3\"><span class=\"decor:suite-section-title decor:text-gray-900\">Custom left content</span><span class=\"decor:suite-description decor:text-gray-500\">Anything you want here.</span></div>".html_safe }
      box.right { "<button class=\"decor:px-3 decor:py-1 decor:rounded-suite-control decor:border decor:border-suite-hairline\">Action</button>".html_safe }
    end
  end

  # @group Playground
  # @param title text
  # @param description text
  # @param right_text text
  def playground(title: "Row title", description: "Helper description goes here.", right_text: "Action")
    render ::Decor::Suite::Box.new(title: title, description: description) do |box|
      if right_text.present?
        box.right { "<button class=\"decor:px-3 decor:py-1 decor:rounded-suite-control decor:border decor:border-suite-hairline\">#{ERB::Util.html_escape(right_text)}</button>".html_safe }
      end
    end
  end
end
