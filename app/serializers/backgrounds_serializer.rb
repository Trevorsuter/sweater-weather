class BackgroundsSerializer
  include FastJsonapi::ObjectSerializer
  set_id 'nil'
  set_type 'image'
  attributes :image
end
