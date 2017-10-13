class Hint < ApplicationRecord
  belongs_to :game_step
  has_and_belongs_to_many :user_games

  default_scope { order :id }

  scope :covered, ->(user_game) { where.not(id: user_game.hints.ids) }
    # .where.not(user_games: { id: user_game_id }) }
  # scope :uncovered, -> { left_joins(:user_games).where.not(user_games: { id: nil }) }
end
