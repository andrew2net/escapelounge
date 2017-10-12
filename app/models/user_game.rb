class UserGame < ApplicationRecord
  after_find :check_started_game

  belongs_to :user
  belongs_to :game
  has_many :step_answers, dependent: :delete_all
  has_and_belongs_to_many :hints

  scope :running, -> { where(paused_at: nil, finished_at: nil) }
  scope :paused, -> { where.not(paused_at: nil).where(finished_at: nil) }

  def formated_result
    Time.at(result).utc.strftime("%H:%M:%S")
  end

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
