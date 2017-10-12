class Hint < ApplicationRecord
  belongs_to :game_step
  has_and_belongs_to_many :user_games

  default_scope { order :id }

  scope :covered, -> { left_joins(:user_games).where(user_games: { id: nil }) }
  scope :uncovered, -> { left_joins(:user_games).where.not(user_games: { id: nil }) }
end
