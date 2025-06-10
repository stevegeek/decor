# @label Chat List
class ::Decor::Chat::ListPreview < ::Lookbook::Preview
  # Chat List
  # ---------
  #
  # A chat list component using daisyUI chat styling for displaying conversations.
  # Supports different message types, avatars, timestamps, and empty states.
  #
  # @param chat_type [Symbol] select { choices: [empty, simple, conversation, mixed_users, time_formats] }
  def playground(chat_type: :simple)
    case chat_type
    when :empty
      render ::Decor::Chat::List.new do |list|
        list.with_empty_state_action do
          list.render ::Decor::Button.new(color: :primary) { "Start Conversation" }
        end
      end
    when :simple
      render ::Decor::Chat::List.new(
        messages: [
          ::Decor::Chat::ListMessage.new(
            author_name: "Obi-Wan Kenobi",
            message: "You were the Chosen One!",
            is_current_user: false,
            footer_text: "Seen",
            localised_created_at: Time.current - 36.hours
          ),
          ::Decor::Chat::ListMessage.new(
            author_name: "Obi-Wan Kenobi",
            message: "I loved you.",
            is_current_user: false,
            footer_text: "Delivered"
          )
        ]
      )
    when :conversation
      render ::Decor::Chat::List.new(
        messages: [
          ::Decor::Chat::ListMessage.new(
            author_name: "Obi-Wan Kenobi",
            author_profile_image_url: "https://img.daisyui.com/images/profile/demo/kenobee@192.webp",
            message: "It was said that you would, destroy the Sith, not join them.",
            is_current_user: false,
            show_timestamp: false
          ),
          ::Decor::Chat::ListMessage.new(
            author_name: "Obi-Wan Kenobi",
            author_profile_image_url: "https://img.daisyui.com/images/profile/demo/kenobee@192.webp",
            message: "It was you who would bring balance to the Force",
            is_current_user: false,
            show_timestamp: false
          ),
          ::Decor::Chat::ListMessage.new(
            author_name: "Obi-Wan Kenobi",
            author_profile_image_url: "https://img.daisyui.com/images/profile/demo/kenobee@192.webp",
            message: "Not leave it in Darkness",
            is_current_user: false,
            show_timestamp: false
          )
        ]
      )
    when :mixed_users
      render ::Decor::Chat::List.new(
        messages: [
          ::Decor::Chat::ListMessage.new(
            author_name: "Sarah Wilson",
            author_initials: "SW",
            author_profile_image_url: "https://images.unsplash.com/photo-1494790108755-2616b612b606?w=150",
            message: "Welcome to the team chat!",
            is_current_user: false
          ),
          ::Decor::Chat::ListMessage.new(
            author_name: "Mike Chen",
            author_initials: "MC",
            message: "Thanks! Excited to be working with everyone.",
            is_current_user: false
          ),
          ::Decor::Chat::ListMessage.new(
            author_name: "You",
            message: "Great to have you aboard! Let me know if you need anything.",
            is_current_user: true
          )
        ]
      )
    when :time_formats
      render ::Decor::Chat::List.new(
        messages: [
          ::Decor::Chat::ListMessage.new(
            author_name: "Alice",
            message: "This message is from 2 days ago",
            localised_created_at: 2.days.ago,
            is_current_user: false
          ),
          ::Decor::Chat::ListMessage.new(
            author_name: "Bob",
            message: "This message is from 1 day ago",
            localised_created_at: 1.day.ago,
            is_current_user: false
          ),
          ::Decor::Chat::ListMessage.new(
            author_name: "You",
            message: "This message is from 2 hours ago",
            localised_created_at: 2.hours.ago,
            is_current_user: true
          ),
          ::Decor::Chat::ListMessage.new(
            author_name: "Carol",
            message: "This message is recent (30 minutes ago)",
            localised_created_at: 30.minutes.ago,
            is_current_user: false
          )
        ]
      )
    end
  end

  # @!group Examples

  def basic_chat
    render ::Decor::Chat::List.new(
      messages: [
        ::Decor::Chat::ListMessage.new(
          author_name: "Obi-Wan Kenobi",
          message: "You were the Chosen One!",
          is_current_user: false,
          footer_text: "Seen"
        ),
        ::Decor::Chat::ListMessage.new(
          author_name: "Anakin",
          message: "...",
          is_current_user: true,
          footer_text: "Delivered"
        )
      ]
    )
  end

  def chat_with_avatars
    render ::Decor::Chat::List.new(
      messages: [
        ::Decor::Chat::ListMessage.new(
          author_name: "Emma Davis",
          author_profile_image_url: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150",
          message: "Check out this amazing sunset!",
          is_current_user: false
        ),
        ::Decor::Chat::ListMessage.new(
          author_name: "You",
          message: "Wow, that's beautiful! Where was this taken?",
          is_current_user: true
        )
      ]
    )
  end

  def empty_chat_state
    render ::Decor::Chat::List.new(
      empty_state_title: "No conversations yet",
      empty_state_description: "Start chatting by sending your first message."
    ) do |list|
      list.with_empty_state_action do
        list.render ::Decor::Button.new(color: :primary, size: :small) { "Send Message" }
      end
    end
  end

  def avatar_variations_example
    render ::Decor::Chat::List.new(
      messages: [
        ::Decor::Chat::ListMessage.new(
          author_name: "Alice Johnson",
          author_profile_image_url: "https://images.unsplash.com/photo-1494790108755-2616b612b606?w=150",
          message: "Using profile image URL with Decor::Avatar",
          is_current_user: false
        ),
        ::Decor::Chat::ListMessage.new(
          author_name: "Bob Smith",
          author_initials: "BS",
          message: "Using custom initials with Decor::Avatar",
          is_current_user: false
        ),
        ::Decor::Chat::ListMessage.new(
          author_name: "Carol Davis",
          message: "Using fallback (first letter) with Decor::Avatar",
          is_current_user: false
        ),
        ::Decor::Chat::ListMessage.new(
          author_name: "You",
          message: "Current user message (no avatar by default)",
          is_current_user: true
        )
      ]
    )
  end

  def timestamp_formatting_example
    render ::Decor::Chat::List.new(
      messages: [
        ::Decor::Chat::ListMessage.new(
          author_name: "Alice",
          message: "Old message (shows date)",
          localised_created_at: 3.days.ago,
          is_current_user: false,
          footer_text: "Read"
        ),
        ::Decor::Chat::ListMessage.new(
          author_name: "Bob",
          message: "Recent message (shows time)",
          localised_created_at: 30.minutes.ago,
          is_current_user: false,
          footer_text: "Delivered"
        ),
        ::Decor::Chat::ListMessage.new(
          author_name: "You",
          message: "Just now",
          localised_created_at: 5.minutes.ago,
          is_current_user: true
        )
      ]
    )
  end

  def daisyui_examples_combined
    render ::Decor::Chat::List.new(
      messages: [
        # Messages with header and footer (first daisyUI pattern)
        ::Decor::Chat::ListMessage.new(
          author_name: "Obi-Wan Kenobi",
          message: "You were the Chosen One!",
          is_current_user: false,
          footer_text: "Seen"
        ),
        ::Decor::Chat::ListMessage.new(
          author_name: "Obi-Wan Kenobi",
          message: "I loved you.",
          is_current_user: false,
          footer_text: "Delivered"
        ),

        # Messages with avatars (second daisyUI pattern)
        ::Decor::Chat::ListMessage.new(
          author_name: "Obi-Wan Kenobi",
          author_profile_image_url: "https://img.daisyui.com/images/profile/demo/kenobee@192.webp",
          message: "It was said that you would, destroy the Sith, not join them.",
          is_current_user: false,
          show_timestamp: false
        ),
        ::Decor::Chat::ListMessage.new(
          author_name: "Obi-Wan Kenobi",
          author_profile_image_url: "https://img.daisyui.com/images/profile/demo/kenobee@192.webp",
          message: "It was you who would bring balance to the Force",
          is_current_user: false,
          show_timestamp: false
        ),
        ::Decor::Chat::ListMessage.new(
          author_name: "Obi-Wan Kenobi",
          author_profile_image_url: "https://img.daisyui.com/images/profile/demo/kenobee@192.webp",
          message: "Not leave it in Darkness",
          is_current_user: false,
          show_timestamp: false
        )
      ]
    )
  end

  # @!endgroup
end
