class CreateRequestTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :request_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
