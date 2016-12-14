json.extract! game, :id, :name, :description, :status, :difficulty, :age_range, :score, :created_at, :updated_at
json.url game_url(game, format: :json)