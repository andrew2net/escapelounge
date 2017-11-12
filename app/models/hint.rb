class Hint < ApplicationRecord
  include Attachable

  belongs_to :game_step
  has_and_belongs_to_many :user_games

  has_attached_file :image, attachment_opts(styles: { thumb: "260x260#" })
  validates_attachment :image, content_type: { content_type: /\Aimage\/.*\z/ }

  default_scope { order :id }

  scope :covered, ->(user_game) { where.not(id: user_game.hints.ids) }
end
