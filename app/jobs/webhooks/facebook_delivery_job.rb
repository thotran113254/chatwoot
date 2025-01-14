class Webhooks::FacebookDeliveryJob < ApplicationJob
  queue_as :low

  def perform(message)
    response = ::Integrations::Facebook::MessageParser.new(message)
    
    # Xử lý delivery status
    Integrations::Facebook::DeliveryStatus.new(params: response).perform
    
    # Xử lý typing status nếu có
    handle_typing_status(response) if response.typing_status?
  end

  private

  def handle_typing_status(response)
    conversation = Conversation.find_by(id: response.conversation_id)
    return if conversation.blank?

    Facebook::SendOnFacebookService.new(
      inbox: conversation.inbox,
      contact_inbox: conversation.contact_inbox
    ).send_typing_status(response.typing_status)
  end
end
