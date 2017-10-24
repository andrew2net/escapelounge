class Game < ApplicationRecord
  before_save :generate_instructions

  has_many :user_games, dependent: :destroy
  has_many :users, through: :user_games

  has_many :game_steps, dependent: :destroy
  accepts_nested_attributes_for :game_steps, reject_if: :all_blank, allow_destroy: true

  has_and_belongs_to_many :grades

  enum difficulty: [:"1 (beginner)", :"2 (easy)", :"3 (medium)", :"4 (hard)", :"5 (difficult)"]
  # enum age_range: [:"ages 5-9", :"ages 10 - 14", :"ages 15-19"]

  # enum status: []  --  should status be an enumerated list?

  validates :time_length, presence: true

  has_attached_file :instructions_pdf
  validates_attachment :instructions_pdf, content_type: { content_type: "application/pdf" }

  background_opts = {
    styles:      { thumb: "260x260#" },
    default_url: ":style/default_game_background.jpg"
  }

  banner_opts = {
    styles:      { thumb: "260x260#" },
    default_url: ":style/default_game_banner.jpg"
  }

  if Rails.env.production?
    s3_opts = {
      storage:          :s3,
      s3_region:        'us-east-1', # TODO set your S3 region here
      s3_storage_class: { thumb: :REDUCED_REDUNDANCY },
      s3_credentials:   "#{Rails.root}/config/s3.yml"
    }

    background_opts.merge! s3_opts
    banner_opts.merge! s3_opts
  end

  has_attached_file :background, background_opts
  validates_attachment :background, content_type: { content_type: /\Aimage\/.*\z/ }

  has_attached_file :banner, banner_opts
  validates_attachment :banner, content_type: { content_type: /\Aimage\/.*\z/ }

  scope :visible, -> { where(visible: true) }

  # Return a game step with step_id if it's allowed for user with user_id.
  # Return nil if the step is not allowed.
  def allowed_step(step_id:, user_id:)
    # Find previous answered step.
    ps = game_steps.answered(user_id).where("game_steps.id < ?", step_id).last
    if ps
      GameStep.find step_id
    else
      nil
    end
  end

  private

  # Generate PDF instructions and attach to the game.
  def generate_instructions
    file = "#{Dir.mktmpdir}/#{name.parameterize.underscore}_instructions.pdf"
    html = ApplicationController.render partial: "admin/games/game_instructions", locals: { game: self }
    pdf = WickedPdf.new.pdf_from_string(html)
    File.open(file, "wb") { |f| f << pdf }
    self.instructions_pdf = File.open file
  end
end
