class AddAttachmentImageToHints < ActiveRecord::Migration[5.1]
  def self.up
    change_table :hints do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :hints, :image
  end
end
