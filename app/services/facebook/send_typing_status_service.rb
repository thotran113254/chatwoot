class Facebook::SendTypingStatusService
  def initialize(conversation:, status:)
    @conversation = conversation
    @status = status # "typing_on" hoặc "typing_off"
    @contact = conversation.contact
    @channel = conversation.inbox.channel
  end

  def perform
    return unless @channel.is_a?(Channel::FacebookPage)

    send_typing_status
  rescue Facebook::Messenger::FacebookError => e
    Rails.logger.error "Facebook::SendTypingStatusService Error: #{e.message}"
    handle_facebook_error(e)
  end

  private

  def send_typing_status
    Facebook::Messenger::Bot.deliver(
      {
        recipient: { id: @contact.get_source_id(@conversation.inbox.id) },
        sender_action: @status,
        messaging_type: 'RESPONSE'
      },
      page_id: @channel.page_id
    )
  end

  def handle_facebook_error(exception)
    error_message = exception.message
    
    if error_message.include?('Error validating access token') || 
       error_message.include?('Invalid OAuth access token')
      @channel.authorization_error!
      raise exception
    end
  end
end 