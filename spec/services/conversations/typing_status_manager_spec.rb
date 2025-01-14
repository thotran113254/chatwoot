require 'rails_helper'

RSpec.describe Conversations::TypingStatusManager do
  let(:conversation) { create(:conversation) }
  let(:user) { create(:user) }
  let(:params) { { typing_status: 'on' } }
  let(:typing_status) { described_class.new(conversation, user, params) }

  describe '#toggle_typing_status' do
    it 'triggers typing event with correct status' do
      expect(typing_status).to receive(:trigger_typing_event)
        .with('conversation.typing_on', nil)
      typing_status.toggle_typing_status
    end

    context 'when inbox is facebook' do
      let(:facebook_channel) { create(:channel_facebook_page) }
      let(:facebook_inbox) { create(:inbox, channel: facebook_channel) }
      let(:conversation) { create(:conversation, inbox: facebook_inbox) }

      it 'sends typing status to facebook' do
        expect_any_instance_of(Facebook::SendOnFacebookService)
          .to receive(:send_typing_status).with('on')
        typing_status.toggle_typing_status
      end
    end

    context 'when inbox is instagram' do
      let(:instagram_channel) { create(:channel_instagram) }
      let(:instagram_inbox) { create(:inbox, channel: instagram_channel) }
      let(:conversation) { create(:conversation, inbox: instagram_inbox) }

      it 'sends typing status to instagram' do
        expect_any_instance_of(Instagram::SendOnInstagramService)
          .to receive(:send_typing_status).with('on')
        typing_status.toggle_typing_status
      end
    end
  end
end 