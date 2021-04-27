require 'rails_helper'

RSpec.describe RoadtripFacade do
  describe 'happy path' do

    it 'can get the correct weather info' do
      VCR.use_cassette('roadtrip_weather_data') do
        request = RoadtripFacade.weather_data("Denver,CO", "Pueblo,CO")
        trip_info = RoadtripService.data("Denver,CO", "Pueblo,CO")

        expect(request[:lat]).to eq(trip_info.arrival_latitude.round(4))
        expect(request[:lon]).to eq(trip_info.arrival_longitude.round(4))
      end
    end

    it 'can get the correct hourly forecast if travel time is less than 48 hours' do
      VCR.use_cassette('roadtrip_forecast_data') do
        data = RoadtripFacade.forecast_data("Denver,CO", "Pueblo,CO")
        trip_info = RoadtripService.data("Denver,CO", "Pueblo,CO")
        forecast_hour = Time.at(data[:dt]).hour
        forecast_day = Time.at(data[:dt]).day
        arrival_hour = trip_info.arrival_time.hour
        arrival_day = trip_info.arrival_time.day

        expect(forecast_hour).to eq(arrival_hour)
        expect(forecast_day).to eq(arrival_day)
      end
    end

    it 'can get the correct daily forecast if travel time is more than 48 hours' do
      VCR.use_cassette('48_hour_trip') do
        data = RoadtripFacade.forecast_data("Glenwood,ME", "Los Angeles,CA")
        trip_info = RoadtripService.data("Glenwood,ME", "Los Angeles,CA")
        forecast_day = Time.at(data[:dt]).day
        arrival_day = trip_info.arrival_time.day

        expect(data).to have_key(:sunrise)
        expect(data).to have_key(:sunset)
        expect(forecast_day).to eq(arrival_day)
      end
    end

    it 'can get the correct temperature for a daily forecast' do
      VCR.use_cassette('48_hour_trip') do
        data = RoadtripFacade.find_temp("Glenwood,ME", "Los Angeles,CA")

        expect(data).to be_a(Float)
        expect(data).to_not be_a(Hash)
      end
    end
    it 'can get the correct temperature for a hourly forecast' do
      VCR.use_cassette('forecast_trip_data') do
        data = RoadtripFacade.find_temp("Denver,CO", "Pueblo,CO")

        expect(data).to be_a(Float)
        expect(data).to_not be_a(Hash)
      end
    end

    it 'can format the weather at eta' do
      VCR.use_cassette('forecast_trip_data_final') do
        data = RoadtripFacade.weather_at_eta("Denver,CO", "Pueblo,CO")
        temp = RoadtripFacade.find_temp("Denver,CO", "Pueblo,CO")
        forecast = RoadtripFacade.forecast_data("Denver,CO", "Pueblo,CO")
        conditions = forecast[:weather].first[:description]

        expect(data).to be_an(OpenStruct)
        expect(data.temperature).to eq(temp)
        expect(data.conditions).to eq(conditions)
      end
    end

    it 'can format the roadtrip data' do
      VCR.use_cassette('roadtrip_data_final') do
        data = RoadtripFacade.data("Denver,CO", "Pueblo,CO")
        trip_info = RoadtripService.data("Denver,CO", "Pueblo,CO")
        weather_at_eta = RoadtripFacade.weather_at_eta("Denver,CO", "Pueblo,CO")

        expect(data).to be_an(OpenStruct)
        expect(data.start_city).to eq(trip_info.start_city)
        expect(data.end_city).to eq(trip_info.end_city)
        expect(data.travel_time).to eq(trip_info.travel_time)
        expect(data.weather_at_eta).to be_a(Hash)
        expect(data.weather_at_eta[:temperature]).to eq(weather_at_eta.temperature)
        expect(data.weather_at_eta[:conditions]).to eq(weather_at_eta.conditions)
      end
    end
  end

  describe 'sad path' do

    it 'forecast does not return a daily record if travel time is less than 48 hours' do
      VCR.use_cassette('roadtrip_forecast_data') do
        data = RoadtripFacade.forecast_data("Denver,CO", "Pueblo,CO")
        trip_info = RoadtripService.data("Denver,CO", "Pueblo,CO")

        two_days_in_seconds = 60 * 60 * 24 * 2
        # 60 seconds in a minute, times 60 minutes in an hour, times 24 hours in a day, times two days

        expect(trip_info.raw_travel_time).to be <= two_days_in_seconds

        expect(data).to_not have_key(:sunrise)
        expect(data).to_not have_key(:sunset)
      end
    end
  end
end