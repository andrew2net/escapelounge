# frozen_string_literal: true

# Gamse modes.
class Game < ApplicationRecord
  include Attachable

  before_save :generate_instructions

  has_many :user_games, dependent: :destroy
  has_many :users, through: :user_games

  has_many :game_assets
  accepts_nested_attributes_for :game_assets, reject_if: :all_blank,
                                              allow_destroy: true

  has_many :game_steps, dependent: :destroy
  accepts_nested_attributes_for :game_steps, reject_if: :all_blank,
                                             allow_destroy: true

  has_and_belongs_to_many :grades

  enum difficulty: [:"1 (beginner)", :"2 (easy)", :"3 (medium)", :"4 (hard)",
                    :"5 (difficult)"]

  validates :time_length, presence: true

  has_attached_file :instructions_pdf, attachment_opts
  validates_attachment :instructions_pdf,
                       content_type: { content_type: 'application/pdf' }

  has_attached_file :background, attachment_opts(
    styles:      { thumb: '260x260#' },
    default_url: ':style/default_game_background.jpg'
  )
  validates_attachment :background,
                       content_type: { content_type: %r{\Aimage\/.*\z} }

  has_attached_file :banner, attachment_opts(
    styles:      { thumb: '260x260#' },
    default_url: ':style/default_game_banner.jpg'
  )
  validates_attachment :banner,
                       content_type: { content_type: %r{\Aimage\/.*\z} }

  has_attached_file :success_sound,
                    attachment_opts(default_url: '/sounds/success.mp3')
  validates_attachment :success_sound,
                       content_type: { content_type: %r{\Aaudio\/.*\z} }

  has_attached_file :fail_sound,
                    attachment_opts(default_url: '/sounds/fail.mp3')
  validates_attachment :success_sound,
                       content_type: { content_type: %r{\Aaudio\/.*\z} }

  has_attached_file :hint_sound,
                    attachment_opts(default_url: '/sounds/hint.mp3')
  validates_attachment :success_sound,
                       content_type: { content_type: %r{\Aaudio\/.*\z} }

  scope :visible, -> { where(visible: true) }

  scope :allowed, ->(user) do
    includes(grades: :subscription_plans)
      .where(subscription_plans: { id: user.subscription_plan_id })
  end

  # Return a game step with step_id if it's allowed for user with user_id.
  # Return nil if the step is not allowed.
  def allowed_step(step_id:, user_game_id:)
    step = game_steps.where(id: step_id).first
    # Find previous answered step.
    ps = game_steps.where('game_steps.position < ?', step && step.position).last
    if ps && (ps.game_step_solutions
        .joins(:step_answers)
        .where(step_answers: { user_game_id: user_game_id })
        .any? || ps.game_step_solutions.none?)
      step
    end
  end

  private

  # Generate PDF instructions and attach to the game.
  def generate_instructions
    file = "#{Dir.mktmpdir}/#{name.parameterize.underscore}_instructions.pdf"
    html = ApplicationController.render(
      partial: 'admin/games/game_instructions', locals: { game: self }
    )
    pdf = WickedPdf.new.pdf_from_string(html)
    File.open(file, 'wb') { |f| f << pdf }
    self.instructions_pdf = File.open file
  end
end
