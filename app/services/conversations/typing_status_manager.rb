class Conversations::TypingStatusManager
  include Events::Types

  attr_reader :conversation, :user, :params

  def initialize(conversation, user, params)
    @conversation = conversation
    @user = user
    @params = params
  end

  def trigger_typing_event(event, is_private)
    user = @user.presence || @resource
    Rails.configuration.dispatcher.dispatch(event, Time.zone.now, conversation: @conversation, user: user, is_private: is_private)
    
    # Gửi typing status tới Facebook/Instagram nếu là inbox tương ứng
    send_provider_typing_status if should_send_provider_status?
  end

  def toggle_typing_status
    case params[:typing_status]
    when 'on'
      trigger_typing_event(CONVERSATION_TYPING_ON, params[:is_private])
    when 'off'
      trigger_typing_event(CONVERSATION_TYPING_OFF, params[:is_private])
    end
  end

  private

  def should_send_provider_status?
    %w[Channel::FacebookPage Channel::Instagram].include?(@conversation.inbox.channel_type)
  end

  def send_provider_typing_status
    case @conversation.inbox.channel_type
    when 'Channel::FacebookPage'
      Facebook::SendOnFacebookService.new(message: nil, inbox: @conversation.inbox).send_typing_status(params[:typing_status])
    when 'Channel::Instagram' 
      Instagram::SendOnInstagramService.new(message: nil, inbox: @conversation.inbox).send_typing_status(params[:typing_status])
    end
  end
end
