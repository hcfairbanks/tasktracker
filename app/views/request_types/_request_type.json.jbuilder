json.extract! request_type, :id, :name, :description, :created_at, :updated_at
json.url request_type_url(request_type, format: :json)
