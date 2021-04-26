require 'rails_helper'

RSpec.describe 'User Create API' do
  describe 'happy path' do
    before :each do
      headers = { 'CONTENT_TYPE' => 'application/json'}
      body = {user: {email: "example@email.com",
              password: "testpassword",
              password_confirmation: "test_password"}}.as_json
      post api_v1_users_path(headers: headers, params: body)
    end

    it 'gives a 201 status code response back when user is created' do
      
      expect(response.status).to eq(201)
    end

    it 'will create a user if all requirements are met' do
      user = User.where(email: "example@email.com").first
    end
  end
end