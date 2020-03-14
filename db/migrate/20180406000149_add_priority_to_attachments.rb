class AddPriorityToAttachments < ActiveRecord::Migration[5.0]
  def change
    add_column :attachments, :priority, :integer
  end
end
