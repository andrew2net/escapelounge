class ImageResponseOption < ApplicationRecord
  include Attachable

  attr_accessor :image_solution_id

  around_save :set_solution

  belongs_to :game_step, inverse_of: :image_response_options

  has_attached_file :image, attachment_opts(styles: { thumb: "200x200#" })
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  private

  def set_solution
    set = game_step.image_solution_id == image_solution_id
    yield
    if set
      game_step.update_image_solution id
    end
  end
end
