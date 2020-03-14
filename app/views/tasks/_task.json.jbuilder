json.extract! task, :id, :title, :description, :reported_by, :request_type, :member_facing, :vertical, :title, :required_by, :link, :priority, :created_at, :updated_at
json.url task_url(task, format: :json)
