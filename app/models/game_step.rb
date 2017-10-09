class GameStep < ApplicationRecord

  belongs_to :game
  has_many :step_answers

  has_many :hints, dependent: :destroy
  accepts_nested_attributes_for :hints, reject_if: :all_blank, allow_destroy: true

  has_many :game_step_solutions, dependent: :destroy
  accepts_nested_attributes_for :game_step_solutions, reject_if: :all_blank, allow_destroy: true

  default_scope { order :id }

  scope :not_answered, -> { left_outer_joins(:step_answers)
    .where(step_answers: { game_step_id: nil })}
end
