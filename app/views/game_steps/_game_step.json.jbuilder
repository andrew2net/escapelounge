json.extract! game_step, :id, :name, :description, :value, :game_id, :created_at, :updated_at
json.url game_step_url(game_step, format: :json)