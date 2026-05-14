# @label Chat Message
class ::Decor::Daisy::Chat::ListMessagePreview < ::Lookbook::Preview
  # Chat Message
  # ------------
  #
  # Individual chat message component using daisyUI styling.
  # Supports different message types, avatars, attachments, and user positioning.
  #
  # @!group Examples

  def basic_incoming_message
    render ::Decor::Daisy::Chat::ListMessage.new(
      author_name: "Bob Smith",
      author_initials: "BS",
      message: "Hello there!",
      is_current_user: false
    )
  end

  def basic_outgoing_message
    render ::Decor::Daisy::Chat::ListMessage.new(
      author_name: "You",
      message: "Hi! How can I help you?",
      is_current_user: true
    )
  end

  def message_with_profile_image
    render ::Decor::Daisy::Chat::ListMessage.new(
      author_name: "Emma Davis",
      author_profile_image_url: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150",
      message: "Thanks for the quick response!",
      is_current_user: false
    )
  end

  def message_with_attachment
    render ::Decor::Daisy::Chat::ListMessage.new(
      author_name: "Mike Chen",
      author_initials: "MC",
      message: "Here's the document you requested:",
      is_current_user: false
    ) do |message|
      message.attachment do
        div(class: "decor:bg-base-200 decor:rounded-lg decor:p-3 decor:border decor:border-base-300") do
          div(class: "decor:flex decor:items-center decor:space-x-2") do
            render ::Decor::Daisy::Icon.new(name: "document-text", style: :outline, html_options: {class: "decor:w-6 decor:h-6 decor:text-primary"})
            div do
              p(class: "decor:font-medium decor:text-sm") { "Project_Requirements.pdf" }
              p(class: "decor:text-xs decor:text-base-content/70") { "1.8 MB" }
            end
          end
        end
      end
    end
  end

  def long_conversation_example
    render ::Decor::Daisy::Chat::List.new(
      messages: [
        ::Decor::Daisy::Chat::ListMessage.new(
          author_name: "Team Lead",
          author_initials: "TL",
          message: "Good morning team! Ready for today's standup?",
          is_current_user: false
        ),
        ::Decor::Daisy::Chat::ListMessage.new(
          author_name: "You",
          message: "Yes! I've completed the user authentication module and started working on the dashboard.",
          is_current_user: true
        ),
        ::Decor::Daisy::Chat::ListMessage.new(
          author_name: "Team Lead",
          author_initials: "TL",
          message: "Excellent progress! Any blockers?",
          is_current_user: false
        ),
        ::Decor::Daisy::Chat::ListMessage.new(
          author_name: "You",
          message: "No blockers currently. Everything is on track for the sprint goal.",
          is_current_user: true
        )
      ]
    )
  end

  # @!endgroup

  # @param message_type [Symbol] select { choices: [incoming, outgoing, with_avatar, with_attachment] }
  def playground(message_type: :incoming)
    case message_type
    when :incoming
      render ::Decor::Daisy::Chat::List.new(
        messages: [
          ::Decor::Daisy::Chat::ListMessage.new(
            author_name: "Sarah Wilson",
            author_initials: "SW",
            message: "Hey! How's the project coming along?",
            is_current_user: false
          )
        ]
      )
    when :outgoing
      render ::Decor::Daisy::Chat::List.new(
        messages: [
          ::Decor::Daisy::Chat::ListMessage.new(
            author_name: "You",
            message: "It's going great! Almost finished with the first milestone.",
            is_current_user: true
          )
        ]
      )
    when :with_avatar
      render ::Decor::Daisy::Chat::List.new(
        messages: [
          ::Decor::Daisy::Chat::ListMessage.new(
            author_name: "John Doe",
            author_profile_image_url: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150",
            message: "The design looks fantastic!",
            is_current_user: false
          )
        ]
      )
    when :with_attachment
      render ::Decor::Daisy::Chat::List.new(
        messages: [
          ::Decor::Daisy::Chat::ListMessage.new(
            author_name: "Alice Johnson",
            author_initials: "AJ",
            message: "Here's the updated mockup for review:",
            is_current_user: false
          ) do |message|
            message.attachment do
              div(class: "decor:d-card decor:bg-base-200 decor:p-4 decor:max-w-sm") do
                h4(class: "decor:font-semibold") { "Design_Mockup_v2.png" }
                p(class: "decor:text-sm decor:text-base-content/70") { "2.1 MB • PNG Image" }
                div(class: "decor:mt-2") do
                  render ::Decor::Daisy::Button.new(size: :sm, color: :primary) { "Download" }
                end
              end
            end
          end
        ]
      )
    end
  end
end
