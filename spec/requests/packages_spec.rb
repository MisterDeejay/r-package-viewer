require 'rails_helper'

RSpec.describe 'Packages Controller', type: :request do
  # initialize test data

  let!(:packages) { create_list(:package, 20) }

  # Test suite for GET /todos
  describe 'GET /packages' do
    # make HTTP get request before each example
    before { get '/packages' }

    it 'returns packages' do
      # Note `json` is a custom helper to parse JSON responses
      expect(assigns(:packages)).not_to be_empty
      expect(assigns(:packages).count).to eq(20)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
