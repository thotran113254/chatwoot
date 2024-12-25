# == Schema Information
#
# Table name: channel_facebook_pages
#
#  id                :integer          not null, primary key
#  page_access_token :string           not null
#  user_access_token :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :integer          not null
#  instagram_id      :string
#  page_id           :string           not null
#
# Indexes
#
#  index_channel_facebook_pages_on_page_id                 (page_id)
#  index_channel_facebook_pages_on_page_id_and_account_id  (page_id,account_id) UNIQUE
#

class Channel::FacebookPage < ApplicationRecord
  include Channelable
  include Reauthorizable

  self.table_name = 'channel_facebook_pages'

  validates :page_id, uniqueness: { scope: :account_id }

  after_create_commit :subscribe
  before_destroy :unsubscribe

  def name
    'Facebook'
  end

  def messaging_window_enabled?
    false
  end

  def create_contact_inbox(instagram_id, name)
    @contact_inbox = ::ContactInboxWithContactBuilder.new({
                                                            source_id: instagram_id,
                                                            inbox: inbox,
                                                            contact_attributes: { name: name }
                                                          }).perform
  end

  def subscribe
    # ref https://developers.facebook.com/docs/messenger-platform/reference/webhook-events
    Facebook::Messenger::Subscriptions.subscribe(
      access_token: page_access_token,
      subscribed_fields: %w[
        messages message_deliveries message_echoes message_reads standby messaging_handovers messaging_postbacks
      ]
    )
  rescue StandardError => e
    Rails.logger.error "Facebook::Subscribe Error: #{e.message}"
    true
  end

  def unsubscribe
    Facebook::Messenger::Subscriptions.unsubscribe(access_token: page_access_token)
  rescue StandardError => e
    Rails.logger.debug { "Rescued: #{e.inspect}" }
    true
  end

  # TODO: We will be removing this code after instagram_manage_insights is implemented
  def fetch_instagram_story_link(message)
    k = Koala::Facebook::API.new(page_access_token)
    result = k.get_object(message.source_id, fields: %w[story]) || {}
    story_link = result['story']['mention']['link']
    # If the story is expired then it raises the ClientError and if the story is deleted with valid story-id it responses with nil
    delete_instagram_story(message) if story_link.blank?
    story_link
  rescue Koala::Facebook::ClientError => e
    Rails.logger.debug { "Instagram Story Expired: #{e.inspect}" }
    delete_instagram_story(message)
  end

  def delete_instagram_story(message)
    message.attachments.destroy_all
    message.update(content: I18n.t('conversations.messages.instagram_deleted_story_content'), content_attributes: {})
  end

  def can_send_message?
    return false if page_access_token.blank?
    return false if authorization_error_count.to_i > 3
    true
  end

  def handle_postback(postback_payload)
    return if postback_payload.blank?
    
    begin
      # Xử lý postback payload tại đây
      # Ví dụ: cập nhật trạng thái conversation, gửi tin nhắn phản hồi...
      Rails.logger.info "Processing postback: #{postback_payload}"
    rescue StandardError => e
      Rails.logger.error "Error handling postback: #{e.message}"
    end
  end

  def find_active_conversation(contact_id)
    inbox.conversations.where(
      contact_id: contact_id,
      status: [:open, :pending]
    ).last
  end

  def ensure_conversation_exists(contact)
    conversation = find_active_conversation(contact.id)
    return conversation if conversation.present?

    Conversation.create!(
      account_id: account_id,
      inbox_id: inbox.id,
      contact_id: contact.id,
      status: :open
    )
  end
end
