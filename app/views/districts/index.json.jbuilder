json.array!(@districts) do |district|
  json.extract! district, :id, :en_name, :ar_name
  json.url district_url(district, format: :json)
end
