class CreateVerticals < ActiveRecord::Migration[5.0]
  def change
    create_table :verticals do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
