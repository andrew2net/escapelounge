class GameStep < ApplicationRecord

  belongs_to :game

  has_many :hints, dependent: :destroy
  accepts_nested_attributes_for :hints, reject_if: :all_blank, allow_destroy: true

end
