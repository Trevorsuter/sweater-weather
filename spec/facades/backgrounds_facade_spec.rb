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

    it 'can get the first image from the search' do
      VCR.use_cassette('backgrounds_facade') do
        image = BackgroundsFacade.first_image("denver,co")

        expect(image).to be_a(Hash)
        expect(image).to_not be_an(Array)

        expect(image).to have_key(:webSearchUrl)
        expect(image).to have_key(:contentUrl)
        expect(image).to have_key(:name)
        expect(image).to have_key(:hostPageFavIconUrl)
        expect(image).to have_key(:hostPageUrl)
      end
    end
  end

end