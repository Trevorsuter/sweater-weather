require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email}
    it { should validate_presence_of :password_digest }
    it { should have_secure_password }
  end

  describe 'after creation' do
    it 'will create a random string as an api key after successful creation' do
      @user = User.create(email: "example@email.com", password: "password")

      expect(@user.api_key).to_not be_nil
      expect(@user.api_key).to be_a(String)
    end
  end
end
