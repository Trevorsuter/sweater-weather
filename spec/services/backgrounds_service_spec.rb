require 'rails_helper'

RSpec.describe BackgroundsService do
  describe 'happy path' do

    it 'can format the query correctly' do
      request = BackgroundsService.format_query("denver,co")

      expect(request).to eq("denver+co")
    end

    it 'can make a successful request' do
      VCR.use_cassette('backgrounds_service') do
        request = BackgroundsService.get_data("denver,co")

        expect(request.status).to eq(200)
      end
    end

    it 'can successfully get the first image' do
      VCR.use_cassette('backgrounds_service') do
        data = BackgroundsService.first_image("denver,co")

        expect(data).to be_a(Hash)

        expect(data).to have_key(:webSearchUrl)
        expect(data[:webSearchUrl]).to_not be_nil

        expect(data).to have_key(:contentUrl)
        expect(data[:contentUrl]).to_not be_nil

        expect(data).to have_key(:name)
        expect(data[:name]).to_not be_nil

        expect(data).to have_key(:hostPageUrl)
        expect(data[:hostPageUrl]).to_not be_nil

        expect(data).to have_key(:hostPageFavIconUrl)
        expect(data[:hostPageFavIconUrl]).to_not be_nil
      end
    end

    it 'can format the image for json output' do
      VCR.use_cassette('backgrounds_service') do
        image = BackgroundsService.image("denver,co")

        expect(image).to be_a(Hash)
        expect(image).to have_key('location')
        expect(image).to have_key('search_url')
        expect(image).to have_key('image_url')
        expect(image).to have_key('credit')

        expect(image['credit']).to have_key('name')
        expect(image['credit']).to have_key('source')
        expect(image['credit']).to have_key('logo')
      end
    end
  end
end