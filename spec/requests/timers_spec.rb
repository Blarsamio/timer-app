require 'rails_helper'

RSpec.describe 'Timers', type: :request do
  let!(:session_record) { create(:session, device_id: 'device-a') }
  let!(:timer) { create(:timer, session: session_record) }
  let!(:preset) { create(:session, preset: true) }
  let!(:preset_timer) { create(:timer, session: preset) }
  let(:session_id) { session_record.id }
  let(:timer_id) { timer.id }

  describe 'POST /sessions/:session_id/timers' do
    let(:valid_attributes) { { duration: 300, title: 'Meditation' } }

    context 'when request attributes are valid' do
      before { post "/sessions/#{session_id}/timers", params: { timer: valid_attributes, device_id: 'device-a' }, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/sessions/#{session_id}/timers", params: { timer: { duration: nil }, device_id: 'device-a' }, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end

    it 'forbids another device' do
      post "/sessions/#{session_id}/timers", params: { timer: valid_attributes, device_id: 'device-b' }, headers: headers
      expect(response).to have_http_status(403)
    end

    it 'forbids adding to a preset' do
      post "/sessions/#{preset.id}/timers", params: { timer: valid_attributes }, headers: headers
      expect(response).to have_http_status(403)
    end
  end

  describe 'DELETE /timers/:id' do
    it 'deletes the device\'s own timer' do
      delete "/timers/#{timer_id}", params: { device_id: 'device-a' }, headers: headers
      expect(response).to have_http_status(204)
    end

    it 'forbids another device' do
      delete "/timers/#{timer_id}", params: { device_id: 'device-b' }, headers: headers
      expect(response).to have_http_status(403)
      expect(Timer.exists?(timer_id)).to be true
    end

    it 'forbids deleting a preset timer' do
      delete "/timers/#{preset_timer.id}", headers: headers
      expect(response).to have_http_status(403)
      expect(Timer.exists?(preset_timer.id)).to be true
    end
  end
end
