require 'rails_helper'

RSpec.describe MapquestService do

  describe 'happy path' do
    it 'can make a successful request' do
      VCR.use_cassette('mapquest_service') do
        request = MapquestService.request("denver,co")

        expect(request.status).to eq(200)
      end
    end

    it 'can parse data' do
      VCR.use_cassette('mapquest_service') do
        data = MapquestService.parse_data("denver,co")

        expect(data).to be_a(Hash)
      end
    end

    it 'can create an openstruct for the location' do
      VCR.use_cassette('mapquest_service') do
        data = MapquestService.coordinates("denver,co")

        expect(data).to be_an(OpenStruct)
        expect(data.latitude).to eq(39.738453)
        expect(data.longitude).to eq(-104.984853)
      end
    end
  end
end