class AddOriginalNameToAttachments < ActiveRecord::Migration[5.0]
  def change
    add_column :attachments, :original_name, :string
  end
end
