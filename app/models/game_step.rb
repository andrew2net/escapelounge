class GameStep < ApplicationRecord
  include Attachable

  belongs_to :game
  has_many :step_answers, dependent: :delete_all

  has_many :hints, dependent: :destroy
  accepts_nested_attributes_for :hints, reject_if: :all_blank, allow_destroy: true

  has_many :game_step_solutions, dependent: :destroy
  accepts_nested_attributes_for :game_step_solutions, reject_if: :all_blank, allow_destroy: true

  has_attached_file :image, attachment_opts(styles: { thumb: "260x260#" })
  validates_attachment :image, content_type: { content_type: /\Aimage\/.*\z/ }

  default_scope { order :game_id, :position }

  enum answer_input_type: [:text_field, :combo_lock]

  scope :answered, ->(user_id) { joins(step_answers: :user_game)
      .where(step_answers: { user_games: { user_id: user_id }})
  }

  # Return previous step
  def previous(user_id)
    self.class.answered(user_id).where("game_steps.position < ?", position)
      .where(game_id: game_id).last
  end

  # Return next allowed step.
  def next(user_game_id)
    # Check if the step is answered or has no solutions.
    allow_next = !game_step_solutions.any? ||
      !step_answers.find_by(user_game_id: user_game_id).nil?
    if allow_next
      # if it's answered then retirn next step.
      self.class.where(game_id: game_id).where('position > ?', position).first
    end
  end

  private

  def set_position
    unless position
      self.position = self.class.where(game_id: game_id).last.position + 1
    end
  end
end
