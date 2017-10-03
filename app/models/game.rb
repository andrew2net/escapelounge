class Game < ApplicationRecord

  has_many :user_games, dependent: :destroy
  has_many :users, through: :user_games

  has_many :game_steps, dependent: :destroy
  accepts_nested_attributes_for :game_steps, reject_if: :all_blank, allow_destroy: true

  enum difficulty: [:"1 (beginner)", :"2 (easy)", :"3 (medium)", :"4 (hard)", :"5 (difficult)"]
  enum age_range: [:"ages 5-9", :"ages 10 - 14", :"ages 15-19"]

  # enum status: []  --  should status be an enumerated list?

  scope :visible, -> { where(visible: true) }
end
