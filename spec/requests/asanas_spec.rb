require 'rails_helper'

RSpec.describe 'Asanas', type: :request do
  let!(:asanas) { create_list(:asana, 5) }
  let(:asana_id) { asanas.first.id }

  describe 'GET /asanas' do
    before { get '/asanas', headers: headers }

    it 'returns asanas' do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /asanas/:id' do
    before { get "/asanas/#{asana_id}", headers: headers }

    context 'when the record exists' do
      it 'returns the asana' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(asana_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:asana_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
