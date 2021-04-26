require 'rails_helper'

RSpec.describe BackgroundsFacade do

  describe 'happy path' do
    it 'can format the params' do
      expect(BackgroundsFacade.format_params("denver,co")).to eq("denver+co")
    end

    it 'can make a successful request' do
      VCR.use_cassette('backgrounds_facade') do
        request = BackgroundsFacade.get_backgrounds("denver,co")
  
        expect(request.status).to eq(200)
      end
    end
  end

end