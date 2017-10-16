class GameStep < ApplicationRecord

  belongs_to :game
  has_many :step_answers, dependent: :delete_all

  has_many :hints, dependent: :destroy
  accepts_nested_attributes_for :hints, reject_if: :all_blank, allow_destroy: true

  has_many :game_step_solutions, dependent: :destroy
  accepts_nested_attributes_for :game_step_solutions, reject_if: :all_blank, allow_destroy: true

  default_scope { order :id }

  scope :answered, ->(user_id) { joins(step_answers: :user_game)
      .where(step_answers: { user_games: { user_id: user_id }})
  }

  # Return previous step
  def previous(user_id)
    self.class.answered(user_id).where("game_steps.id < ?", id)
      .where(game_id: game_id).last
  end

  # Return next allowed step.
  def next(user_game_id)
    # Check if the step ia answered.
    step_answer = step_answers.find_by(user_game_id: user_game_id)
    if step_answer
      # if it's answered then retirn next step.
      self.class.where(game_id: game_id).where('id > ?', id).first
    end
  end
end
