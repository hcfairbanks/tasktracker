class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.string :link
      t.date :required_by
      t.boolean :member_facing

      t.integer :reported_by_id
      t.integer :assigned_to_id

      t.references :request_type, foreign_key: true
      t.references :vertical, foreign_key: true
      t.references :priority, foreign_key: true
      t.references :status, foreign_key: true

      t.timestamps
    end
  end
end
