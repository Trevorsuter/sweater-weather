require 'rails_helper'

RSpec.describe 'User Create API' do
  describe 'happy path' do
    before :each do
      headers = { 'CONTENT_TYPE' => 'application/json'}
      body = {email: "example@email.com",
              password: "testpassword",
              password_confirmation: "testpassword"}.as_json
      post api_v1_users_path(headers: headers, params: body, as: :json)

      @user = User.where(email: "example@email.com").first
    end

    it 'gives a 201 status code response back when user is created' do

      expect(response.status).to eq(201)
    end


    it 'will create a user if all requirements are met' do
      
      expect(@user.email).to eq('example@email.com')
      expect(@user.password).to_not eq("testpassword")
      expect(@user.authenticate("testpassword")).to_not be false
    end

    it 'should return the new user' do
      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:data]).to have_key(:id)
      expect(result[:data][:id].to_i).to eq(@user.id)

      expect(result[:data]).to have_key(:type)
      expect(result[:data][:type]).to eq("user")

      expect(result[:data]).to have_key(:attributes)
      expect(result[:data][:attributes]).to be_a(Hash)

      expect(result[:data][:attributes]).to have_key(:email)
      expect(result[:data][:attributes][:email]).to eq(@user.email)
      
      expect(result[:data][:attributes]).to have_key(:api_key)
      expect(result[:data][:attributes][:api_key]).to eq(@user.api_key)
    end
  end

  describe 'sad path' do
    it 'will not create a user if password and password confirmation do not match' do
      headers = { 'CONTENT_TYPE' => 'application/json'}
      body = {email: "example@email.com",
              password: "testpassword",
              password_confirmation: "test_password2"}.as_json
      post api_v1_users_path(headers: headers, params: body)
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(401)
      expect(body).to eq("Your passwords don't match.")
      expect(User.all).to be_empty
    end

    it 'will not create a user if email is already taken' do
      User.create!(email: "example@email.com", password: "password")
      
      expect(User.all.length).to eq(1)

      headers = { 'CONTENT_TYPE' => 'application/json'}
      body = {email: "example@email.com",
              password: "test_password2",
              password_confirmation: "test_password2"}.as_json

      post api_v1_users_path(headers: headers, params: body)
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(401)
      expect(body).to eq("User Exists.")
      expect(User.all.length).to eq(1)
    end

    it 'will not create a new user if email is missing' do
      headers = { 'CONTENT_TYPE' => 'application/json'}
      body = {password: "test_password2",
              password_confirmation: "test_password2"}.as_json

      post api_v1_users_path(headers: headers, params: body)
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(401)
      expect(body).to eq("You forgot some fields.")
      expect(User.all.length).to eq(0)
    end
    it 'will not create a new user if password is missing' do
      headers = { 'CONTENT_TYPE' => 'application/json'}
      body = {email: "example@email.com",
              password_confirmation: "test_password2"}.as_json

      post api_v1_users_path(headers: headers, params: body)
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(401)
      expect(body).to eq("You forgot some fields.")
      expect(User.all.length).to eq(0)
    end
    it 'will not create a new user if password confirmation is missing' do
      headers = { 'CONTENT_TYPE' => 'application/json'}
      body = {email: "example@email.com",
              password: "test_password2"}.as_json

      post api_v1_users_path(headers: headers, params: body)
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(401)
      expect(body).to eq("You forgot some fields.")
      expect(User.all.length).to eq(0)
    end

  end
end