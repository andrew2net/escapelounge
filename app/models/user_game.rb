# If result 0 then game ended, if greater 0 then finished, if nil then timeouted.
class UserGame < ApplicationRecord
  after_find :check_started_game

  belongs_to :user
  belongs_to :game
  has_many :step_answers, dependent: :delete_all
  has_and_belongs_to_many :hints

  scope :running, -> { where(paused_at: nil, finished_at: nil) }
  scope :paused, -> { where.not(paused_at: nil).where(finished_at: nil) }

  # Return percent of answered steps and steps of total
  def progress
    total_steps = game.game_steps.joins(:game_step_solutions).distinct.count
    answered_steps = step_answers.count
    percent = answered_steps.to_f / total_steps.to_f * 100
    [ "#{percent}%", "#{answered_steps} of #{total_steps}"]
  end

  def progress_deg
    total_steps = game.game_steps.joins(:game_step_solutions).distinct.count
    answered_steps = step_answers.count
    if total_steps > 0
      (180 * answered_steps / total_steps).round
    else
      0
    end
  end

  # Return step next after last answered
  def last_allowed_step
    previous_step = nil
    game.game_steps.includes(:game_step_solutions).each do |step|
        has_answer = step.step_answers.where(user_game_id: id).any?
        if previous_step && !has_answer && !previous_step.game_step_solutions.any?
          return previous_step
        elsif !has_answer
          return step
        end
        previous_step = step
      end
      # .where("NOT step_answers.id IS NULL AND step_answers.user_game_id=? OR game_step_solutions.id IS NULL", id).last
  end

  # Returen result in "hh:MM:ss" format.
  def formated_result
    if result == 0
      "Ended"
    elsif result
      Time.at(result).utc.strftime("%H:%M:%S")
    else
      "Time expired"
    end
  end

  # Mark the hint as used and reduce remaining time
  def use_hint(hint_id)
    # Don't add hint if the game is finished or the hint is already added
    unless self.finished_at || hints.exists?(hint_id)
      hint = Hint.find hint_id
      self.hints << hint
      self.started_at -= hint.value.seconds if hint.value
      save
    end
  end

  # Finish the user game.
  def finish(result = nil)
    unless finished_at
      self.finished_at = DateTime.now
      self.result = result ||
        ((finished_at.to_datetime - started_at.to_datetime) * 24 * 3600).to_i
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
