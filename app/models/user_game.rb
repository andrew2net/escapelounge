# frozen_string_literal: true

# If result 0 then game ended, if greater 0 then finished, if nil then timeouted
class UserGame < ApplicationRecord
  after_find :check_started_game

  belongs_to :user
  belongs_to :game
  has_many :step_answers, dependent: :delete_all
  has_and_belongs_to_many :hints
  has_many :passed_game_steps, dependent: :delete_all

  scope :running, -> { where(paused_at: nil, finished_at: nil) }
  scope :paused, -> { where.not(paused_at: nil).where(finished_at: nil) }
  scope :running_or_paused, -> { where(finished_at: nil) }
  scope :finished, -> { where.not(finished_at: nil) }

  # Return percent of answered steps and steps of total
  def progress
    total_steps = game.game_steps.count
    answered_steps = passed_game_steps.count
    percent = answered_steps.to_f / total_steps.to_f * 100
    ["#{percent}%", "#{answered_steps} of #{total_steps}"]
  end

  def progress_deg
    total_steps = game.game_steps.count
    answered_steps = passed_game_steps.count
    if total_steps.positive?
      (180 * answered_steps / total_steps).round
    else
      0
    end
  end

  # Return step next after last answered
  def last_allowed_step
    game.game_steps.where.not(id: passed_game_steps.map(&:game_step_id)).first
  end

  # Returen result in "hh:MM:ss" format.
  def formated_result
    if result&.zero?
      'Ended'
    elsif result
      Time.at(result).utc.strftime('%M:%S !')
    elsif paused_at.nil? && finished_at.nil?
      'Running'
    elsif !paused_at.nil? && finished_at.nil?
      'Paused'
    else
      'Time expired'
    end
  end

  # Mark the hint as used and reduce remaining time
  def use_hint(hint_id)
    # Don't add hint if the game is finished or the hint is already added
    return if finished_at || hints.exists?(hint_id)
    hint = Hint.find hint_id
    hints << hint
    self.started_at -= hint.value.seconds if hint.value
    save
  end

  # Finish the user game.
  def finish(reslt = nil)
    # return if finished_at
    self.finished_at ||= Time.now
    self.result = reslt || ((finished_at.to_datetime - started_at.to_datetime)\
                              * 24 * 3600).to_i
    save
  end

  private

  # Check if stared game is expired.
  def check_started_game
    return if finished_at || paused_at
    time = Time.zone.now
    minutes = ((time - started_at) / 1.minute).to_i
    update finished_at: time if minutes >= game.time_length
  end
end
