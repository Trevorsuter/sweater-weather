require 'rails_helper'

RSpec.describe MapquestFacade do

  describe 'happy path' do

    it 'can get coordinates' do
      VCR.use_cassette('mapquest_facade') do
        response = MapquestFacade.get_coordinates("denver,co")

        expect(response.latitude).to eq(39.738453)
        expect(response.longitude).to eq(-104.984853)
      end
    end
  end
end