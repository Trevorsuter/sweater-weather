require 'rails_helper'

RSpec.describe SalariesFacade do

  describe 'happy path' do

    it 'can get the current weather data' do
      request = SalariesFacade.get_weather_data("denver")

      expect(request).to have_key('datetime')
      expect(request).to have_key('sunrise')
      expect(request).to have_key('sunset')
      expect(request).to have_key('temperature')
      expect(request).to have_key('feels_like')
      expect(request).to have_key('humidity')
      expect(request).to have_key('uvi')
      expect(request).to have_key('visibility')
      expect(request).to have_key('conditions')
      expect(request).to have_key('icon')
    end

    it 'can format the correct jobs' do
      output = SalariesFacade.format_jobs("denver")

      expect(output.length).to be <= 7

      output.each do |job|
        expect(job).to have_key('title')
        expect(job).to have_key('min')
        expect(job).to have_key('max')
      end
    end
  end
end