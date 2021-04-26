class SalariesSerializer
  include FastJsonapi::ObjectSerializer
  set_id 'nil'
  set_type "salaries"
  attributes :destination, :forecast, :salaries
end
