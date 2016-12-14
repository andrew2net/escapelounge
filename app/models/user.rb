class User < ApplicationRecord

  has_many :user_games, dependent: :destroy
  has_many :games, through: :user_games

end
