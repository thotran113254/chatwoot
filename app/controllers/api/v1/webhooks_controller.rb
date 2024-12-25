class Api::V1::WebhooksController < ApplicationController
  skip_before_action :authenticate_user!, raise: false
  skip_before_action :set_current_user

  def twitter_crc
    render json: { response_token: "sha256=#{twitter_client.generate_crc(params[:crc_token])}" }
  end

  def twitter_events
    twitter_consumer.consume
    head :ok
  rescue StandardError => e
    ChatwootExceptionTracker.new(e).capture_exception
    head :ok
  end

  def process_messaging_params
    return head :ok unless valid_facebook_webhook_params?

    params["entry"].each do |entry|
      entry["messaging"]&.each do |messaging|
        if messaging["postback"].present?
          process_postback_payload(messaging)
        elsif messaging["message"].present?
          process_message(messaging)
        end
      end
    end
    
    head :ok
  rescue StandardError => e
    ChatwootExceptionTracker.new(e).capture_exception
    head :ok
  end

  private

  def twitter_client
    Twitty::Facade.new do |config|
      config.consumer_secret = ENV.fetch('TWITTER_CONSUMER_SECRET', nil)
    end
  end

  def twitter_consumer
    @twitter_consumer ||= ::Webhooks::Twitter.new(params)
  end

  def process_message(messaging)
    begin
      sender_id = messaging["sender"]["id"]
      message = messaging["message"]
      
      channel = find_channel_from_messaging(messaging)
      contact = find_or_create_contact(channel, sender_id)
      conversation = find_or_create_conversation(channel, contact)
    rescue StandardError => e
      raise
    end
  end

  def process_postback_payload(messaging)
    begin
      postback = messaging["postback"]
      sender_id = messaging["sender"]["id"]
      
      channel = find_channel_from_messaging(messaging)
      contact = find_or_create_contact(channel, sender_id)
      conversation = find_or_create_conversation(channel, contact)

      create_postback_message(conversation, contact, postback, messaging)
    rescue StandardError => e
      raise
    end
  end

  def find_channel_from_messaging(messaging)
    fb_page_id = params["entry"]&.first&.dig("id")
    Channel::FacebookPage.find_by!(page_id: fb_page_id)
  end

  def find_or_create_contact(channel, sender_id)
    contact = Contact.find_by(source_id: sender_id)
    return contact if contact.present?

    Contact.create!(
      name: sender_id,
      account_id: channel.account_id,
      source_id: sender_id
    )
  end

  def find_or_create_conversation(channel, contact)
    conversation = Conversation.find_or_create_by!(
      inbox_id: channel.inbox.id,
      contact_id: contact.id
    ) do |conv|
      conv.status = :open
      conv.account_id = channel.account_id
    end
  end

  def create_postback_message(conversation, contact, postback, messaging)
    conversation.messages.create!(
      content: postback["payload"],
      account_id: conversation.account_id,
      inbox_id: conversation.inbox_id,
      message_type: :incoming,
      source_id: "#{messaging['timestamp']}_#{SecureRandom.uuid}",
      sender: contact,
      content_type: 'text',
      content_attributes: {
        postback_title: postback["title"],
        is_postback: true,
        timestamp: messaging["timestamp"],
        source: "facebook_postback"
      }
    )
  end

  def valid_facebook_webhook_params?
    return false unless params["entry"].present? && params["entry"].is_a?(Array)
    params["entry"].first["messaging"].present?
  end
end
