class UserGame < ApplicationRecord
  after_find :check_started_game

  belongs_to :user
  belongs_to :game
  has_many :step_answers

  scope :running, -> { where(paused_at: nil, finished_at: nil) }
  scope :paused, -> { where.not(paused_at: nil).where(finished_at: nil) }

  private

  # Check if stared game is expired.
  def check_started_game
    if started_at && !paused_at
      time = DateTime.now
      minutes = ((time - started_at.to_datetime) * 24 * 60).to_i
      self.update finished_at: time if minutes >= game.time_length
    end
  end
end
