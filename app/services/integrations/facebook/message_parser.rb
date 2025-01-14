module Integrations::Facebook
  class MessageParser
    def typing_status?
      @message['sender_action'].present?
    end

    def typing_status
      @message['sender_action']
    end

    def conversation_id
      @message['conversation_id']
    end
  end
end 