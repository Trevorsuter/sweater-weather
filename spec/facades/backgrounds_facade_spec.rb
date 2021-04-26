require 'rails_helper'

RSpec.describe BackgroundsFacade do

  describe 'happy path' do
    it 'can create an ostruct for the backgrounds serializer' do
      VCR.use_cassette('backgrounds_facade') do
        ostruct = BackgroundsFacade.formatted_image("denver,co")

        expect(ostruct).to be_an(OpenStruct)
        expect(ostruct['image']).to be_a(Hash)
        expect(ostruct['image']).to have_key('location')
        expect(ostruct['image']).to have_key('search_url')
        expect(ostruct['image']).to have_key('image_url')
        expect(ostruct['image']).to have_key('credit')

        expect(ostruct['image']['credit']).to have_key('name')
        expect(ostruct['image']['credit']).to have_key('source')
        expect(ostruct['image']['credit']).to have_key('logo')
      end
    end
  end

end