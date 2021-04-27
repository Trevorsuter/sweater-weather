require 'rails_helper'

RSpec.describe RoadtripService do

  describe 'happy path' do
    it 'can make a successful request for data' do
      VCR.use_cassette('roadtrip_facade') do
        request = RoadtripService.get_data("Denver,CO", "Pueblo,CO")

        expect(request.status).to eq(200)
        expect(request).to be_a(Faraday::Response)
        expect(request.body).to be_a(String)
      end
    end

    it 'can parse the data' do
      VCR.use_cassette('roadtrip_facade') do
        data = RoadtripService.parsed_data("Denver,CO", "Pueblo,CO")
        
        expect(data).to be_a(Hash)
        expect(data).to have_key(:route)
        expect(data).to have_key(:info)
      end
    end

    it 'can create an openstruct for the necessary roadtrip information' do
      VCR.use_cassette('roadtrip_facade_combined') do
        parsed_data = RoadtripService.parsed_data("Denver,CO", "Pueblo,CO")
        data = RoadtripService.data("Denver,CO", "Pueblo,CO")

        expected_travel_time = parsed_data[:route][:formattedTime]
        expected_arrival_time = Time.now + parsed_data[:route][:time]
        expected_raw_travel_time = parsed_data[:route][:time]
        expected_latitude = parsed_data[:route][:locations].last[:displayLatLng][:lat]
        expected_longitude = parsed_data[:route][:locations].last[:displayLatLng][:lng]
        
        expect(data).to be_an(OpenStruct)
        expect(data.start_city).to eq("Denver,CO")
        expect(data.end_city).to eq("Pueblo,CO")
        expect(data.travel_time).to eq(expected_travel_time)
        expect(data.raw_travel_time).to eq(expected_raw_travel_time)

        expect(data.arrival_time.month).to eq(expected_arrival_time.month)
        expect(data.arrival_time.day).to eq(expected_arrival_time.day)
        expect(data.arrival_time.hour).to eq(expected_arrival_time.hour)
        expect(data.arrival_time.min).to eq(expected_arrival_time.min)
        
        expect(data.arrival_longitude).to eq(expected_longitude)
        expect(data.arrival_latitude).to eq(expected_latitude)
      end
    end
  end
end