require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "should have attached pdf instructions" do
    game = games :one
    game.save
    assert game.instructions_pdf_file_name == "#{game.name.downcase}_instructions.pdf"
  end
end
