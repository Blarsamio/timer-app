require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let!(:sessions) { create_list(:session, 5) }
  let(:session_id) { sessions.first.id }

  describe 'GET /sessions' do
    before { get '/sessions', headers: headers }

    it 'returns sessions' do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /sessions/:id' do
    before { get "/sessions/#{session_id}", headers: headers }

    context 'when the record exists' do
      it 'returns the session' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(session_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:session_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /sessions' do
    let(:valid_attributes) { { name: 'Morning Flow', description: 'Good morning' } }

    context 'when the request is valid' do
      before { post '/sessions', params: { session: valid_attributes }, headers: headers }

      it 'creates a session' do
        expect(json['name']).to eq('Morning Flow')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/sessions', params: { session: { name: '' } }, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT /sessions/:id' do
    let(:valid_attributes) { { name: 'Evening Flow' } }

    context 'when the record exists' do
      before { put "/sessions/#{session_id}", params: { session: valid_attributes }, headers: headers }

      it 'updates the record' do
        expect(json['name']).to eq('Evening Flow')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE /sessions/:id' do
    before { delete "/sessions/#{session_id}", headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
