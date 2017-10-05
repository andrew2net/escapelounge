class User < ApplicationRecord
  after_find :check_started_game

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_games, dependent: :destroy
  has_many :games, through: :user_games
  belongs_to :game

  private

  def check_started_game
    if game_start_at && !pause_at
      time = DateTime.now #+ timezone_offset.minutes
      minutes = ((time - game_start_at.to_datetime) * 24 * 60).to_i
      if minutes >= game.time_length
        self.game_start_at = nil
        self.game_id = nil
        save
      end
    end
  end
end
