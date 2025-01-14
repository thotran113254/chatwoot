require 'rails_helper'

describe Facebook::SendTypingStatusService do
  let!(:account) { create(:account) }
  let!(:facebook_channel) { create(:channel_facebook_page, account: account) }
  let!(:facebook_inbox) { create(:inbox, channel: facebook_channel, account: account) }
  let!(:contact) { create(:contact, account: account) }
  let!(:conversation) { create(:conversation, contact: contact, inbox: facebook_inbox) }
  let(:bot) { class_double(Facebook::Messenger::Bot).as_stubbed_const }

  before do
    allow(bot).to receive(:deliver).and_return(true)
  end

  describe '#perform' do
    context 'when typing status is sent' do
      it 'sends typing_on status to facebook' do
        described_class.new(
          conversation: conversation,
          status: 'typing_on'
        ).perform

        expect(bot).to have_received(:deliver).with(
          {
            recipient: { id: contact.get_source_id(facebook_inbox.id) },
            sender_action: 'typing_on',
            messaging_type: 'RESPONSE'
          },
          page_id: facebook_channel.page_id
        )
      end

      it 'handles facebook errors properly' do
        allow(bot).to receive(:deliver)
          .and_raise(Facebook::Messenger::FacebookError.new('message' => 'Error validating access token'))

        expect {
          described_class.new(
            conversation: conversation,
            status: 'typing_on'
          ).perform
        }.to change { facebook_channel.authorization_error_count }.by(1)
      end
    end
  end
end 