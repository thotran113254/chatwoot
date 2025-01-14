module Conversations
  class FacebookTypingStatusService
    def initialize(conversation, user, params)
      @conversation = conversation
      @user = user
      @params = params
      @contact_inbox = conversation.contact_inbox
    end

    def perform
      return unless @contact_inbox.inbox.facebook?

      if @params[:typing_status] == 'on'
        send_typing_on
      else
        send_typing_off
      end
    end

    private

    def send_typing_on
      Facebook::Messenger::Bot.deliver(
        {
          recipient: { id: @contact_inbox.source_id },
          sender_action: 'typing_on'
        },
        access_token: @contact_inbox.inbox.channel.page_access_token
      )
    end

    def send_typing_off
      Facebook::Messenger::Bot.deliver(
        {
          recipient: { id: @contact_inbox.source_id },
          sender_action: 'typing_off'
        },
        access_token: @contact_inbox.inbox.channel.page_access_token
      )
    end
  end
end 