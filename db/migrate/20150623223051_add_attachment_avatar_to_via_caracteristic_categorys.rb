class AddAttachmentAvatarToViaCaracteristicCategorys < ActiveRecord::Migration
  def self.up
    change_table :via_caracteristic_categorys do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :via_caracteristic_categorys, :avatar
  end
end
