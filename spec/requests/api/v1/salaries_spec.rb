require 'rails_helper'

RSpec.describe 'salaries API' do
  describe 'happy path' do
    before :each do
      get api_v1_salaries_path(destination: "denver")
      @result = JSON.parse(response.body, symbolize_names: true)
    end

    it 'has a successful response' do

      expect(response).to be_successful
    end

    it 'outputs the right format' do

      expect(@result).to have_key(:data)

      expect(@result[:data]).to have_key(:id)
      expect(@result[:data][:id]).to be_nil
      expect(@result[:data]).to have_key(:type)
      expect(@result[:data][:type]).to eq("salaries")
      expect(@result[:data]).to have_key(:attributes)
    end

    it 'outputs the right destination' do
      attributes = @result[:data][:attributes]

      expect(attributes).to have_key(:destination)
      expect(attributes[:destination]).to eq("denver")

      expect(attributes).to have_key(:forecast)
      expect(attributes[:forecast]).to have_key(:summary)
      expect(attributes[:forecast]).to have_key(:temperature)
    end

    it 'outputs the forecast for that destination' do
      attributes = @result[:data][:attributes]

      expect(attributes).to have_key(:forecast)
      expect(attributes[:forecast]).to have_key(:summary)
      expect(attributes[:forecast]).to have_key(:temperature)
    end

    it 'outputs the salaries of certain jobs' do
      attributes = @result[:data][:attributes]

      expect(attributes).to have_key(:salaries)
      expect(attributes[:salaries]).to be_an(Array)
    end

    it 'only outputs a total of 7 jobs' do
      salaries = @result[:data][:attributes][:salaries]

      expect(salaries.length).to be <= 7
    end

    xit 'only includes the correct jobs' do

    end
  end
end