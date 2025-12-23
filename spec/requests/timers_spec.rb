require 'rails_helper'

RSpec.describe 'Timers', type: :request do
  let!(:session_record) { create(:session) }
  let!(:timer) { create(:timer, session: session_record) }
  let(:session_id) { session_record.id }
  let(:timer_id) { timer.id }

  describe 'POST /sessions/:session_id/timers' do
    let(:valid_attributes) { { duration: 300, title: 'Meditation' } }

    context 'when request attributes are valid' do
      before { post "/sessions/#{session_id}/timers", params: { timer: valid_attributes }, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/sessions/#{session_id}/timers", params: { timer: { duration: nil } }, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE /timers/:id' do
    before { delete "/timers/#{timer_id}", headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
