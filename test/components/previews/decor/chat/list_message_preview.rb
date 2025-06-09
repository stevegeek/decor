# @label Chat Message
class ::Decor::Chat::ListMessagePreview < ::ViewComponent::Preview
  # Chat Message
  # ------------
  #
  # Individual chat message component using daisyUI styling.
  # Supports different message types, avatars, attachments, and user positioning.
  #
  # @param message_type [Symbol] select { choices: [incoming, outgoing, with_avatar, with_attachment] }
  def playground(message_type: :incoming)
    case message_type
    when :incoming
      render ::Decor::Chat::List.new(
        messages: [
          ::Decor::Chat::ListMessage.new(
            author_name: "Sarah Wilson",
            author_initials: "SW",
            message: "Hey! How's the project coming along?",
            is_current_user: false
          )
        ]
      )
    when :outgoing
      render ::Decor::Chat::List.new(
        messages: [
          ::Decor::Chat::ListMessage.new(
            author_name: "You",
            message: "It's going great! Almost finished with the first milestone.",
            is_current_user: true
          )
        ]
      )
    when :with_avatar
      render ::Decor::Chat::List.new(
        messages: [
          ::Decor::Chat::ListMessage.new(
            author_name: "John Doe",
            author_profile_image_url: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150",
            message: "The design looks fantastic!",
            is_current_user: false
          )
        ]
      )
    when :with_attachment
      render ::Decor::Chat::List.new(
        messages: [
          ::Decor::Chat::ListMessage.new(
            author_name: "Alice Johnson",
            author_initials: "AJ",
            message: "Here's the updated mockup for review:",
            is_current_user: false
          ) do |message|
            message.with_attachment do
              message.div(class: "card bg-base-200 p-4 max-w-sm") do
                message.h4(class: "font-semibold") { "Design_Mockup_v2.png" }
                message.p(class: "text-sm text-base-content/70") { "2.1 MB • PNG Image" }
                message.div(class: "mt-2") do
                  message.render ::Decor::Button.new(size: :small, color: :primary) { "Download" }
                end
              end
            end
          end
        ]
      )
    end
  end

  # @!group Examples

  def basic_incoming_message
    render ::Decor::Chat::ListMessage.new(
      author_name: "Bob Smith",
      author_initials: "BS",
      message: "Hello there!",
      is_current_user: false
    )
  end

  def basic_outgoing_message
    render ::Decor::Chat::ListMessage.new(
      author_name: "You",
      message: "Hi! How can I help you?",
      is_current_user: true
    )
  end

  def message_with_profile_image
    render ::Decor::Chat::ListMessage.new(
      author_name: "Emma Davis",
      author_profile_image_url: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150",
      message: "Thanks for the quick response!",
      is_current_user: false
    )
  end

  def message_with_attachment
    render ::Decor::Chat::ListMessage.new(
      author_name: "Mike Chen",
      author_initials: "MC",
      message: "Here's the document you requested:",
      is_current_user: false
    ) do |message|
      message.with_attachment do
        message.div(class: "bg-base-200 rounded-lg p-3 border border-base-300") do
          message.div(class: "flex items-center space-x-2") do
            message.render ::Decor::Icon.new(name: "document-text", variant: :outline, html_options: {class: "w-6 h-6 text-primary"})
            message.div do
              message.p(class: "font-medium text-sm") { "Project_Requirements.pdf" }
              message.p(class: "text-xs text-base-content/70") { "1.8 MB" }
            end
          end
        end
      end
    end
  end

  def long_conversation_example
    render ::Decor::Chat::List.new(
      messages: [
        ::Decor::Chat::ListMessage.new(
          author_name: "Team Lead",
          author_initials: "TL",
          message: "Good morning team! Ready for today's standup?",
          is_current_user: false
        ),
        ::Decor::Chat::ListMessage.new(
          author_name: "You",
          message: "Yes! I've completed the user authentication module and started working on the dashboard.",
          is_current_user: true
        ),
        ::Decor::Chat::ListMessage.new(
          author_name: "Team Lead",
          author_initials: "TL",
          message: "Excellent progress! Any blockers?",
          is_current_user: false
        ),
        ::Decor::Chat::ListMessage.new(
          author_name: "You",
          message: "No blockers currently. Everything is on track for the sprint goal.",
          is_current_user: true
        )
      ]
    )
  end

  # @!endgroup
end
