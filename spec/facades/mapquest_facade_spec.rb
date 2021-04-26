require 'rails_helper'

RSpec.describe MapquestFacade do

  describe 'happy path' do
    it 'can make a successful request' do
      VCR.use_cassette('mapquest_facade') do
        response = MapquestFacade.request_location("denver,co")
        result = JSON.parse(response.body, symbolize_names: true)
        location = result[:results].first[:providedLocation][:location]

        expect(response.status).to eq(200)
        expect(location).to eq("denver,co")
      end
    end

    it 'can get coordinates' do
      VCR.use_cassette('mapquest_facade') do
        response = MapquestFacade.get_coordinates("denver,co")

        expect(response.latitude).to eq(39.738453)
        expect(response.longitude).to eq(-104.984853)
      end
    end
  end
end