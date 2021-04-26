require 'rails_helper'

RSpec.describe 'backgrounds API' do

  describe 'happy path' do
    before :each do
      VCR.use_cassette('background_spec') do
        get api_v1_backgrounds_path(location: "denver,co")
        
        @result = JSON.parse(response.body, symbolize_names: true)
      end
    end

    it 'has a successful response' do

      expect(response).to be_successful
    end

    it 'has the correct format' do
      expect(@result).to have_key(:data)

      expect(@result[:data]).to have_key(:id)
      expect(@result[:data]).to have_key(:type)
      expect(@result[:data]).to have_key(:attributes)

      expect(@result[:data][:attributes]).to have_key(:image)
      expect(@result[:data][:attributes][:image]).to have_key(:location)
      expect(@result[:data][:attributes][:image]).to have_key(:image_url)
      expect(@result[:data][:attributes][:image]).to have_key(:credit)

      expect(@result[:data][:attributes][:image][:credit]).to have_key(:source)
      expect(@result[:data][:attributes][:image][:credit]).to have_key(:author)
      expect(@result[:data][:attributes][:image][:credit]).to have_key(:logo)
    end
  end
end