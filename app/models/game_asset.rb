class GameAsset < ApplicationRecord
  include Attachable

  belongs_to :game

  has_attached_file :file, attachment_opts
  validates_attachment :file, presence: true
  do_not_validate_attachment_file_type :file

  validates :name, presence: true
end
