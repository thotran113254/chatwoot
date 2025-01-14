class Instagram::SendOnInstagramService < Base::SendOnChannelService
  include HTTParty

  pattr_initialize [:message!]

  base_uri 'https://graph.facebook.com/v11.0/me'

  private

  delegate :additional_attributes, to: :contact

  def channel_class
    Channel::FacebookPage
  end

  def perform_reply
    if contains_url?(message.content)
      send_to_facebook_page(url_message_params) 
    elsif message.content_type == 'input_select'
      send_to_facebook_page(instagram_select_message_params)
    elsif message.content_type == 'cards'
      send_to_facebook_page(instagram_card_message_params) 
    elsif message.content.present?
      send_to_facebook_page(message_params)
    end
    
    # Handle attachments
    if message.attachments.present?
      message.attachments.each do |attachment|
        send_to_facebook_page(attachment_message_params(attachment))
      end
    end
  rescue StandardError => e
    handle_instagram_error(e)
    message.update!(status: :failed, external_error: e.message)
  end

  def message_params
    params = {
      recipient: { id: contact.get_source_id(inbox.id) },
      message: {
        text: message.content
      }
    }

    merge_human_agent_tag(params)
  end

  def attachment_message_params(attachment)
    params = {
      recipient: { id: contact.get_source_id(inbox.id) },
      message: {
        attachment: {
          type: attachment_type(attachment),
          payload: {
            url: attachment.download_url
          }
        }
      }
    }

    merge_human_agent_tag(params)
  end

  # Deliver a message with the given payload.
  # @see https://developers.facebook.com/docs/messenger-platform/instagram/features/send-message
  def send_to_facebook_page(message_content)
    access_token = channel.page_access_token
    app_secret_proof = calculate_app_secret_proof(GlobalConfigService.load('FB_APP_SECRET', ''), access_token)
    query = { access_token: access_token }
    query[:appsecret_proof] = app_secret_proof if app_secret_proof

    # url = "https://graph.facebook.com/v11.0/me/messages?access_token=#{access_token}"

    response = HTTParty.post(
      'https://graph.facebook.com/v11.0/me/messages',
      body: message_content,
      query: query
    )

    if response[:error].present?
      Rails.logger.error("Instagram response: #{response['error']} : #{message_content}")
      message.status = :failed
      message.external_error = external_error(response)
    end

    message.source_id = response['message_id'] if response['message_id'].present?
    message.save!

    response
  end

  def external_error(response)
    # https://developers.facebook.com/docs/instagram-api/reference/error-codes/
    error_message = response[:error][:message]
    error_code = response[:error][:code]

    "#{error_code} - #{error_message}"
  end

  def calculate_app_secret_proof(app_secret, access_token)
    Facebook::Messenger::Configuration::AppSecretProofCalculator.call(
      app_secret, access_token
    )
  end

  def attachment_type(attachment)
    return attachment.file_type if %w[image audio video file].include? attachment.file_type

    'file'
  end

  def conversation_type
    conversation.additional_attributes['type']
  end

  def sent_first_outgoing_message_after_24_hours?
    # we can send max 1 message after 24 hour window
    conversation.messages.outgoing.where('id > ?', conversation.last_incoming_message.id).count == 1
  end

  def config
    Facebook::Messenger.config
  end

  def merge_human_agent_tag(params)
    global_config = GlobalConfig.get('ENABLE_MESSENGER_CHANNEL_HUMAN_AGENT')

    return params unless global_config['ENABLE_MESSENGER_CHANNEL_HUMAN_AGENT']

    params[:messaging_type] = 'MESSAGE_TAG'
    params[:tag] = 'HUMAN_AGENT'
    params
  end

  def handle_instagram_error(exception)
    error_message = exception.message
    
    if error_message.include?('The session has been invalidated') || 
       error_message.include?('Error validating access token') ||
       error_message.include?('Invalid OAuth access token')
      channel.authorization_error!
      raise exception
    elsif error_message.include?('Invalid parameter') && message.content.present? && URI.extract(message.content).any?
      # Retry với template button nếu gửi link thất bại
      send_to_facebook_page(url_message_params)
      return
    end

    Rails.logger.error "Instagram::SendOnInstagramService Error: #{error_message}"
    
    message.update!(
      status: :failed,
      external_error: "Instagram Error: #{error_message}"
    )
  end

  def instagram_select_message_params
    {
      recipient: { id: contact.get_source_id(inbox.id) },
      message: {
        attachment: {
          type: 'template',
          payload: {
            template_type: 'button',
            text: message.content,
            buttons: message.content_attributes['items'].map do |item|
              if item['value'].to_s.match?(/\A#{URI::DEFAULT_PARSER.make_regexp}\z/)
                {
                  type: 'web_url',
                  title: item['title'][0..19], # Instagram giới hạn 20 ký tự cho title
                  url: item['value']
                }
              else
                {
                  type: 'postback',
                  title: item['title'][0..19],
                  payload: item['value']
                }
              end
            end[0..2] # Instagram chỉ cho phép tối đa 3 buttons
          }
        }
      }
    }.merge(instagram_message_tag)
  end

  def instagram_card_message_params
    {
      recipient: { id: contact.get_source_id(inbox.id) },
      message: {
        attachment: {
          type: 'template',
          payload: {
            template_type: 'generic',
            elements: message.content_attributes['items'].map do |item|
              {
                title: item['title'].to_s[0..79], # Instagram giới hạn 80 ký tự cho title
                subtitle: item['description'].to_s[0..79], # Instagram giới hạn 80 ký tự cho subtitle
                image_url: item['media_url'],
                buttons: (item['actions'] || []).map do |action|
                  if action['type'] == 'link'
                    {
                      type: 'web_url',
                      title: action['text'].to_s[0..19],
                      url: action['uri']
                    }
                  elsif action['type'] == 'postback'
                    {
                      type: 'postback',
                      title: action['text'].to_s[0..19],
                      payload: action['payload']
                    }
                  end
                end.compact[0..2] # Instagram chỉ cho phép tối đa 3 buttons
              }
            end[0..9] # Instagram chỉ cho phép tối đa 10 elements
          }
        }
      }
    }.merge(instagram_message_tag)
  end

  def instagram_message_tag
    {
      messaging_type: 'MESSAGE_TAG',
      tag: 'HUMAN_AGENT'
    }
  end

  def contains_url?(text)
    return false if text.blank?
    URI.extract(text).any?
  end

  def url_message_params
    {
      recipient: { id: contact.get_source_id(inbox.id) },
      message: {
        attachment: {
          type: 'template',
          payload: {
            template_type: 'button',
            text: message.content.truncate(600), # Instagram giới hạn độ dài text
            buttons: [
              {
                type: 'web_url', 
                url: URI.extract(message.content).first,
                title: 'Mở liên kết'[0..19] # Instagram giới hạn 20 ký tự
              }
            ]
          }
        }
      }
    }.merge(instagram_message_tag)
  end

  def send_typing_status(status)
    return if @inbox.channel_type != 'Channel::Instagram'

    begin
      response = HTTParty.post(
        'https://graph.facebook.com/v11.0/me/messages',
        body: {
          recipient: { id: @contact_inbox.source_id },
          sender_action: status == 'on' ? 'typing_on' : 'typing_off'
        }.to_json,
        query: {
          access_token: @inbox.channel.page_access_token,
          appsecret_proof: calculate_app_secret_proof(
            GlobalConfigService.load('FB_APP_SECRET', ''), 
            @inbox.channel.page_access_token
          )
        },
        headers: { 'Content-Type' => 'application/json' }
      )

      handle_instagram_error(StandardError.new(response['error']['message'])) if response['error'].present?
    rescue StandardError => e
      handle_instagram_error(e)
    end
  end
end
