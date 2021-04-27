require 'rails_helper'

RSpec.describe ForecastFacade do
  
  describe 'happy path' do
    it 'can get coordinates from the mapquest service' do
      VCR.use_cassette('mapquest_service') do
        expected_latitude = 39.738453
        expected_longitude = -104.984853
  
        request = ForecastFacade.coordinates("denver,co")
  
        expect(request.latitude).to eq(expected_latitude)
        expect(request.longitude).to eq(expected_longitude)
      end
    end

    it 'can get all the weather data' do
      VCR.use_cassette('openweather') do
        data = ForecastFacade.weather("denver,co")

        expect(data.current_weather).to have_key('datetime')
        expect(data.current_weather).to have_key('sunrise')
        expect(data.current_weather).to have_key('sunset')
        expect(data.current_weather).to have_key('temperature')
        expect(data.current_weather).to have_key('feels_like')
        expect(data.current_weather).to have_key('humidity')
        expect(data.current_weather).to have_key('uvi')
        expect(data.current_weather).to have_key('visibility')
        expect(data.current_weather).to have_key('conditions')
        expect(data.current_weather).to have_key('icon')

        data.daily_weather.each do |day|
          expect(day).to have_key('date')
          expect(day).to have_key('sunrise')
          expect(day).to have_key('sunset')
          expect(day).to have_key('max_temp')
          expect(day).to have_key('min_temp')
          expect(day).to have_key('conditions')
          expect(day).to have_key('icon')
        end
        
        data.hourly_weather.each do |hour|
          expect(hour).to have_key('time')
          expect(hour).to have_key('temperature')
          expect(hour).to have_key('conditions')
          expect(hour).to have_key('icon')
        end
      end
    end
  end
end