class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email
  attributes :api_key do |object|
    object.password_digest
  end
end
