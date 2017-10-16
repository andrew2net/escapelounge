class UserGame < ApplicationRecord
  after_find :check_started_game

  belongs_to :user
  belongs_to :game
  has_many :step_answers, dependent: :delete_all
  has_and_belongs_to_many :hints

  scope :running, -> { where(paused_at: nil, finished_at: nil) }
  scope :paused, -> { where.not(paused_at: nil).where(finished_at: nil) }

  # Retur percent of answered steps
  def progress
    total_steps = game.game_steps.count
    answered_steps = step_answers.count
    percent = answered_steps.to_f / total_steps.to_f * 100
    [ "#{percent}%", "#{answered_steps} of #{total_steps}"]
  end

  # Returen result in "hh:MM:ss" format.
  def formated_result
    Time.at(result).utc.strftime("%H:%M:%S") if result
  end

  # Mark the hint as used and reduce remaining time
  def use_hint(hint_id)
    unless self.finished_at
      hint = Hint.find hint_id
      self.hints << hint
      self.started_at -= hint.value.seconds
      save
    end
  end

  # Finish the user game.
  def finish
    unless finished_at
      self.finished_at = DateTime.now
      self.result = ((finished_at.to_datetime - started_at.to_datetime) * 24 * 3600).to_i
      save
    end
  end

  private

  # Check if stared game is expired.
  def check_started_game
    if !finished_at && !paused_at
      time = DateTime.now
      minutes = ((time - started_at.to_datetime) * 24 * 60).to_i
      self.update finished_at: time if minutes >= game.time_length
    end
  end
end
